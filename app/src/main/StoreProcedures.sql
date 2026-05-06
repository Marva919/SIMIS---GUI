-- ---------------------------------------------------------------
-- 1. SP_LAGERBESTAND_PRUEFEN
--    Prüft, ob eine Menge einer Variante im angegebenen Lager
--    verfügbar ist.
--    OUT p_verfuegbar: 1 = ja, 0 = nein
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_LAGERBESTAND_PRUEFEN (
    p_variante_id  IN  NUMBER,
    p_lager_id     IN  NUMBER,
    p_menge        IN  NUMBER,
    p_verfuegbar   OUT NUMBER,
    p_aktuell      OUT NUMBER
) AS
    v_menge NUMBER := 0;
BEGIN
    SELECT NVL(MENGE, 0)
    INTO   v_menge
    FROM   LAGER_BESTAND
    WHERE  VARIANTE_ID = p_variante_id
      AND  LAGER_ID    = p_lager_id;

    p_aktuell    := v_menge;
    p_verfuegbar := CASE WHEN v_menge >= p_menge THEN 1 ELSE 0 END;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_aktuell    := 0;
        p_verfuegbar := 0;
END SP_LAGERBESTAND_PRUEFEN;
/

-- ---------------------------------------------------------------
-- 2. SP_LAGERBESTAND_AKTUALISIEREN
--    Bucht eine Menge auf einen Lagerbestand (negativ = Entnahme,
--    positiv = Einlagerung).
--    Wirft einen Fehler bei Unterschreitung von 0.
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_LAGERBESTAND_AKTUALISIEREN (
    p_variante_id IN NUMBER,
    p_lager_id    IN NUMBER,
    p_delta       IN NUMBER,   -- positiv = Eingang, negativ = Ausgang
    p_neue_menge  OUT NUMBER
) AS
    v_menge NUMBER;
BEGIN
    SELECT MENGE
    INTO   v_menge
    FROM   LAGER
    WHERE  VARIANTE_ID = p_variante_id
      AND  LAGER_ID    = p_lager_id
    FOR UPDATE;

    IF v_menge + p_delta < 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Lagerbestand unterschreitet 0 für Variante ' || p_variante_id);
    END IF;

    UPDATE LAGER
    SET    MENGE = MENGE + p_delta
    WHERE  VARIANTE_ID = p_variante_id
      AND  LAGER_ID    = p_lager_id;

    p_neue_menge := v_menge + p_delta;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF p_delta > 0 THEN
            INSERT INTO LAGER (LAGERID, VARIANTE_ID, MENGEN_VERFUEGBAR)
            VALUES (p_lager_id, p_variante_id, p_delta);
            p_neue_menge := p_delta;
        ELSE
            RAISE_APPLICATION_ERROR(-20002,
                'Kein Lagerbestand gefunden für Variante ' || p_variante_id);
        END IF;
END SP_LAGERBESTAND_AKTUALISIEREN;
/

-- ---------------------------------------------------------------
-- 3. SP_BESTELLUNG_ERSTELLEN
--    Erstellt eine komplette Bestellung inkl. Positionen und
--    bucht den Lagerbestand aus.
--    Alle Positionen werden als JSON-String übergeben.
--    Format: kommagetrennte Paare: VARIANTE_ID:MENGE:LAGER_ID
--    Beispiel: '5:2:1,12:1:1'
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_BESTELLUNG_ERSTELLEN (
    p_kunde_id        IN  NUMBER,
    p_angestellter_id IN  NUMBER,
    p_filiale_id      IN  NUMBER,
    p_lieferadresse   IN  VARCHAR2,
    p_notizen         IN  VARCHAR2,
    p_positionen      IN  VARCHAR2,   -- CSV: "variante_id:menge:lager_id,..."
    p_bestellung_id   OUT NUMBER,
    p_gesamt_betrag   OUT NUMBER
) AS
    v_bestellung_id  NUMBER;
    v_gesamt         NUMBER := 0;
    v_pos_str        VARCHAR2(4000);
    v_token          VARCHAR2(200);
    v_variante_id    NUMBER;
    v_menge          NUMBER;
    v_lager_id       NUMBER;
    v_preis          NUMBER;
    v_verfuegbar     NUMBER;
    v_aktuell        NUMBER;
    v_neue_menge     NUMBER;
    v_rest           VARCHAR2(4000);
    v_colon1         NUMBER;
    v_colon2         NUMBER;
    v_next_comma     NUMBER;
BEGIN
    -- Neue Bestellung anlegen
    SELECT SEQ_BESTELLUNG.NEXTVAL INTO v_bestellung_id FROM DUAL;

    INSERT INTO BESTELLUNG (
        BESTELLUNG_ID, KUNDE_ID, ANGESTELLTER_ID, FILIALE_ID,
        STATUS, GESAMT_BETRAG, LIEFERADRESSE, NOTIZEN
    ) VALUES (
        v_bestellung_id, p_kunde_id, p_angestellter_id, p_filiale_id,
        'NEU', 0, p_lieferadresse, p_notizen
    );

    -- Positionen parsen und verarbeiten
    v_rest := p_positionen || ',';

    LOOP
        v_next_comma := INSTR(v_rest, ',');
        EXIT WHEN v_next_comma = 0 OR LENGTH(TRIM(v_rest)) = 0;

        v_token  := TRIM(SUBSTR(v_rest, 1, v_next_comma - 1));
        v_rest   := SUBSTR(v_rest, v_next_comma + 1);

        EXIT WHEN LENGTH(v_token) = 0;

        -- Token aufteilen: VARIANTE_ID:MENGE:LAGER_ID
        v_colon1      := INSTR(v_token, ':');
        v_colon2      := INSTR(v_token, ':', v_colon1 + 1);
        v_variante_id := TO_NUMBER(SUBSTR(v_token, 1, v_colon1 - 1));
        v_menge       := TO_NUMBER(SUBSTR(v_token, v_colon1 + 1, v_colon2 - v_colon1 - 1));
        v_lager_id    := TO_NUMBER(SUBSTR(v_token, v_colon2 + 1));

        -- Verfügbarkeit prüfen
        SP_LAGERBESTAND_PRUEFEN(v_variante_id, v_lager_id, v_menge, v_verfuegbar, v_aktuell);

        IF v_verfuegbar = 0 THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20010,
                'Nicht ausreichend Lagerbestand für Variante ' || v_variante_id
                || '. Verfügbar: ' || v_aktuell || ', Benötigt: ' || v_menge);
        END IF;

        -- Aktuellen Preis ermitteln (Basispreis + Aufschlag)
        SELECT p.BASIS_PREIS + NVL(v.PREIS_AUFSCHLAG, 0)
        INTO   v_preis
        FROM   PRODUKTVARIANTE v
        JOIN   PRODUKT p ON p.PRODUKTID = v.PRODUKTID
        WHERE  v.VARIANTEID = v_variante_id;

        -- Bestellposition einfügen
        INSERT INTO BESTELLPOSITION (BESTELLUNGID, VARIANTEID, MENGE, EINZELPREIS)
        VALUES (v_bestellung_id, v_variante_id, v_menge, v_preis);

        v_gesamt := v_gesamt + (v_menge * v_preis);

        -- Lagerbestand buchen
        SP_LAGERBESTAND_AKTUALISIEREN(v_variante_id, v_lager_id, -v_menge, v_neue_menge);
    END LOOP;

    -- Gesamtbetrag aktualisieren
    UPDATE BESTELLUNG
    SET    GESAMT_BETRAG = v_gesamt,
           STATUS        = 'BESTAETIGT'
    WHERE  BESTELLUNGID = v_bestellung_id;

    COMMIT;

    p_bestellung_id := v_bestellung_id;
    p_gesamt_betrag := v_gesamt;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END SP_BESTELLUNG_ERSTELLEN;
/

-- ---------------------------------------------------------------
-- 4. SP_BESTELLUNG_STORNIEREN
--    Storniert eine Bestellung und bucht den Lagerbestand zurück.
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_BESTELLUNG_STORNIEREN (
    p_bestellung_id IN  NUMBER,
    p_lager_id      IN  NUMBER,    -- Lager für Rückbuchung
    p_erfolgreich   OUT NUMBER
) AS
    v_status       VARCHAR2(30);
    v_neue_menge   NUMBER;
BEGIN
    -- Status prüfen
    SELECT STATUS
    INTO   v_status
    FROM   BESTELLUNG
    WHERE  BESTELLUNGID = p_bestellung_id
    FOR UPDATE;

    IF v_status IN ('VERSANDT','GELIEFERT','STORNIERT') THEN
        RAISE_APPLICATION_ERROR(-20020,
            'Bestellung ' || p_bestellung_id ||
            ' kann nicht storniert werden. Status: ' || v_status);
    END IF;

    -- Lagerbestand zurückbuchen
    FOR pos IN (
        SELECT VARIANTEID, MENGE
        FROM   BESTELLPOSITION
        WHERE  BESTELLUNGID = p_bestellung_id
    ) LOOP
        SP_LAGERBESTAND_AKTUALISIEREN(
            pos.VARIANTEID, p_lager_id, pos.MENGE, v_neue_menge
        );
    END LOOP;

    -- Bestellung stornieren
    UPDATE BESTELLUNG
    SET    STATUS = 'STORNIERT'
    WHERE  BESTELLUNGID = p_bestellung_id;

    COMMIT;
    p_erfolgreich := 1;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_erfolgreich := 0;
        RAISE;
END SP_BESTELLUNG_STORNIEREN;
/

-- ---------------------------------------------------------------
-- 5. SP_PRODUKT_SUCHEN
--    Gibt ein REF CURSOR mit Produkten inkl. Bestand zurück.
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_PRODUKT_SUCHEN (
    p_suchbegriff IN  VARCHAR2,
    p_kategorie   IN  VARCHAR2,
    p_min_preis   IN  NUMBER,
    p_max_preis   IN  NUMBER,
    p_lager_id    IN  NUMBER,
    p_ergebnis    OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_ergebnis FOR
        SELECT
            p.PRODUKTID,
            p.NAME                AS PRODUKT_NAME,
            p.BESCHREIBUNG,
            p.BASIS_PREIS,
            p.KATEGORIE,
            p.BILD_URL,
            m.NAME                AS MATERIAL_NAME,
            v.VARIANTEID,
            v.SKU,
            v.FARBE,
            v.PREIS_AUFSCHLAG,
            (p.BASIS_PREIS + NVL(v.PREIS_AUFSCHLAG, 0)) AS GESAMT_PREIS,
            g.BEZEICHNUNG         AS GROESSE,
            NVL(lb.MENGE, 0)      AS LAGERBESTAND
        FROM   PRODUKT p
        JOIN   PRODUKTVARIANTE v  ON v.PRODUKTID  = p.PRODUKTID
        LEFT JOIN GROESSE g        ON g.GROESSEID  = v.GROESSEID
        LEFT JOIN MATERIAL m       ON m.MATERIALID = p.MATERIALID
        LEFT JOIN LAGER lb ON lb.VARIANTEID = v.VARIANTEID
                                  AND lb.LAGERID    = NVL(p_lager_id, lb.LAGERID)
        WHERE  p.AKTIV = 1
          AND  v.AKTIV = 1
          AND  (p_suchbegriff IS NULL
                OR UPPER(p.NAME) LIKE '%' || UPPER(p_suchbegriff) || '%'
                OR UPPER(p.BESCHREIBUNG) LIKE '%' || UPPER(p_suchbegriff) || '%')
          AND  (p_kategorie IS NULL OR p.KATEGORIE = p_kategorie)
          AND  (p_min_preis IS NULL OR p.BASIS_PREIS >= p_min_preis)
          AND  (p_max_preis IS NULL OR p.BASIS_PREIS <= p_max_preis)
        ORDER BY p.NAME, g.SORT_ORDER;
END SP_PRODUKT_SUCHEN;
/

-- ---------------------------------------------------------------
-- 6. SP_KUNDE_ANLEGEN_ODER_FINDEN
--    Legt einen neuen Kunden an oder gibt bestehenden zurück.
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_KUNDE_ANLEGEN_ODER_FINDEN (
    p_vorname   IN  VARCHAR2,
    p_nachname  IN  VARCHAR2,
    p_email     IN  VARCHAR2,
    p_telefon   IN  VARCHAR2,
    p_strasse   IN  VARCHAR2,
    p_plz       IN  VARCHAR2,
    p_ort       IN  VARCHAR2,
    p_kunde_id  OUT NUMBER,
    p_neu       OUT NUMBER    -- 1 = neu angelegt, 0 = gefunden
) AS
    v_kunde_id NUMBER;
BEGIN
    -- Vorhandenen Kunden per E-Mail suchen
    BEGIN
        SELECT KUNDEID
        INTO   v_kunde_id
        FROM   KUNDE
        WHERE  UPPER(EMAIL) = UPPER(p_email);

        p_kunde_id := v_kunde_id;
        p_neu      := 0;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Neuen Kunden anlegen
            SELECT SEQ_KUNDE.NEXTVAL INTO v_kunde_id FROM DUAL;

            INSERT INTO KUNDE (
                KUNDEID, VORNAME, NACHNAME, EMAIL,
                ADRESSE, PLZ, ORT, LAND, TELEFONNUMMER
            ) VALUES (
                v_kunde_id, p_vorname, p_nachname, p_email,
                p_telefon, p_strasse, p_plz, p_ort
            );

            COMMIT;
            p_kunde_id := v_kunde_id;
            p_neu      := 1;
    END;
END SP_KUNDE_ANLEGEN_ODER_FINDEN;
/
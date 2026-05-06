-- ============================================================
--  Stored Procedures  |  angepasst an das echte DB-Schema
-- ============================================================

-- ---------------------------------------------------------------
-- 1. SP_BESTAND_PRUEFEN
--    Prüft ob genug Bestand für eine Variante im Lager vorhanden.
--    Tabelle: BESTAND (BESTANDID, VARIANTEID, LAGERID, MENGE_VERFUEGBAR)
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_BESTAND_PRUEFEN (
    p_varianteid   IN  NUMBER,
    p_lagerid      IN  NUMBER,
    p_menge        IN  NUMBER,
    p_verfuegbar   OUT NUMBER,
    p_aktuell      OUT NUMBER
) AS
    v_menge NUMBER := 0;
BEGIN
    SELECT NVL(MENGE_VERFUEGBAR, 0)
    INTO   v_menge
    FROM   BESTAND
    WHERE  VARIANTEID = p_varianteid
      AND  LAGERID    = p_lagerid;

    p_aktuell    := v_menge;
    p_verfuegbar := CASE WHEN v_menge >= p_menge THEN 1 ELSE 0 END;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_aktuell    := 0;
        p_verfuegbar := 0;
END SP_BESTAND_PRUEFEN;
/

-- ---------------------------------------------------------------
-- 2. SP_BESTAND_AKTUALISIEREN
--    Bucht Menge auf BESTAND (positiv = Eingang, negativ = Ausgang).
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_BESTAND_AKTUALISIEREN (
    p_varianteid IN  NUMBER,
    p_lagerid    IN  NUMBER,
    p_delta      IN  NUMBER,
    p_neu        OUT NUMBER
) AS
    v_menge NUMBER;
BEGIN
    SELECT MENGE_VERFUEGBAR
    INTO   v_menge
    FROM   BESTAND
    WHERE  VARIANTEID = p_varianteid
      AND  LAGERID    = p_lagerid
        FOR UPDATE;

    IF v_menge + p_delta < 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
                                'Bestand unterschreitet 0 – Variante ' || p_varianteid
                                    || ' (verfügbar: ' || v_menge || ')');
    END IF;

    UPDATE BESTAND
    SET    MENGE_VERFUEGBAR = MENGE_VERFUEGBAR + p_delta
    WHERE  VARIANTEID = p_varianteid
      AND  LAGERID    = p_lagerid;

    p_neu := v_menge + p_delta;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF p_delta > 0 THEN
            INSERT INTO BESTAND (BESTANDID, VARIANTEID, LAGERID, MENGE_VERFUEGBAR)
            VALUES (SEQ_BESTAND.NEXTVAL, p_varianteid, p_lagerid, p_delta);
            p_neu := p_delta;
        ELSE
            RAISE_APPLICATION_ERROR(-20002,
                                    'Kein Bestand gefunden für Variante ' || p_varianteid);
        END IF;
END SP_BESTAND_AKTUALISIEREN;
/

-- ---------------------------------------------------------------
-- 3. SP_VERKAUF_ERSTELLEN
--    Legt Kundenverkauf an (VERKAUF + VERKAUFPOSITIONen),
--    bucht BESTAND aus und schreibt LAGERBEWEGUNG.
--    p_positionen: CSV "varianteid:menge,varianteid:menge,..."
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_VERKAUF_ERSTELLEN (
    p_kundeid        IN  NUMBER,
    p_filialeid      IN  NUMBER,
    p_zahlungsartid  IN  NUMBER,
    p_lagerid        IN  NUMBER,
    p_positionen     IN  VARCHAR2,
    p_verkaufid      OUT NUMBER,
    p_gesamtbetrag   OUT NUMBER
) AS
    v_verkaufid   NUMBER;
    v_gesamt      NUMBER := 0;
    v_rest        VARCHAR2(4000);
    v_token       VARCHAR2(200);
    v_varianteid  NUMBER;
    v_menge       NUMBER;
    v_preis       NUMBER;
    v_verfuegbar  NUMBER;
    v_aktuell     NUMBER;
    v_neu         NUMBER;
    v_colon       NUMBER;
    v_comma       NUMBER;
    v_bestandid   NUMBER;
BEGIN
    SELECT SEQ_VERKAUF.NEXTVAL INTO v_verkaufid FROM DUAL;

    INSERT INTO VERKAUF (
        VERKAUFID, KUNDEID, FILIALEID, ZAHLUNGSARTID,
        ANZAHL, ZAHLUNGSTATUS, VERKAUFSDATUM
    ) VALUES (
                 v_verkaufid, p_kundeid, p_filialeid, p_zahlungsartid,
                 0, 'N', SYSDATE
             );

    v_rest := p_positionen || ',';
    LOOP
        v_comma := INSTR(v_rest, ',');
        EXIT WHEN v_comma = 0 OR LENGTH(TRIM(v_rest)) = 0;

        v_token  := TRIM(SUBSTR(v_rest, 1, v_comma - 1));
        v_rest   := SUBSTR(v_rest, v_comma + 1);
        EXIT WHEN LENGTH(v_token) = 0;

        v_colon      := INSTR(v_token, ':');
        v_varianteid := TO_NUMBER(SUBSTR(v_token, 1, v_colon - 1));
        v_menge      := TO_NUMBER(SUBSTR(v_token, v_colon + 1));

        -- Bestand prüfen
        SP_BESTAND_PRUEFEN(v_varianteid, p_lagerid, v_menge, v_verfuegbar, v_aktuell);
        IF v_verfuegbar = 0 THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20010,
                                    'Nicht genug Bestand – Variante ' || v_varianteid
                                        || ' (verfügbar: ' || v_aktuell || ', benötigt: ' || v_menge || ')');
        END IF;

        -- Preis mit optionalem Rabatt ermitteln
        SELECT ROUND(pv.PREISVARIANTE * (1 - NVL(
                                                     CASE WHEN SYSDATE BETWEEN r.START_DATUM AND NVL(r.END_DATUM, SYSDATE)
                                                              THEN r.RABATT_PROZENT ELSE 0 END, 0) / 100), 2)
        INTO   v_preis
        FROM   PRODUKTVARIANTE pv
                   JOIN   PRODUKT p   ON p.PRODUKTID  = pv.PRODUKTID
                   LEFT JOIN RABATT r ON r.RABATTID   = p.RABATTID
        WHERE  pv.VARIANTEID = v_varianteid;

        INSERT INTO VERKAUFPOSITION (
            VERKAUFPOSITIONID, VARIANTEID, VERKAUFID, MENGE, EINZELPREIS
        ) VALUES (
                     SEQ_VERKAUFPOS.NEXTVAL, v_varianteid, v_verkaufid, v_menge, v_preis
                 );

        v_gesamt := v_gesamt + (v_menge * v_preis);

        -- Bestand ausbuchen
        SP_BESTAND_AKTUALISIEREN(v_varianteid, p_lagerid, -v_menge, v_neu);

        -- Lagerbewegung: K = Kauf (Ausgang)
        SELECT BESTANDID INTO v_bestandid
        FROM   BESTAND
        WHERE  VARIANTEID = v_varianteid AND LAGERID = p_lagerid;

        INSERT INTO LAGERBEWEGUNG
        (BEWEGUNGSID, BESTANDID, BES_BESTANDID, DATUM, BEWEGUNGSTYP, MENGE)
        VALUES
            (SEQ_LAGERBEWEGUNG.NEXTVAL, v_bestandid, v_bestandid, SYSDATE, 'K', v_menge);

    END LOOP;

    -- Anzahl Positionen eintragen, Zahlung bestätigen
    UPDATE VERKAUF
    SET    ANZAHL        = (SELECT COUNT(*) FROM VERKAUFPOSITION WHERE VERKAUFID = v_verkaufid),
           ZAHLUNGSTATUS = 'Y'
    WHERE  VERKAUFID = v_verkaufid;

    COMMIT;
    p_verkaufid    := v_verkaufid;
    p_gesamtbetrag := v_gesamt;

EXCEPTION
    WHEN OTHERS THEN ROLLBACK; RAISE;
END SP_VERKAUF_ERSTELLEN;
/

-- ---------------------------------------------------------------
-- 4. SP_VERKAUF_STORNIEREN
--    Storniert Verkauf (ZAHLUNGSTATUS → 'N') und bucht Bestand zurück.
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_VERKAUF_STORNIEREN (
    p_verkaufid IN  NUMBER,
    p_lagerid   IN  NUMBER,
    p_erfolg    OUT NUMBER
) AS
    v_status    CHAR(1);
    v_neu       NUMBER;
    v_bestandid NUMBER;
BEGIN
    SELECT ZAHLUNGSTATUS INTO v_status
    FROM   VERKAUF
    WHERE  VERKAUFID = p_verkaufid
        FOR UPDATE;

    IF v_status = 'N' THEN
        RAISE_APPLICATION_ERROR(-20020,
                                'Verkauf ' || p_verkaufid || ' ist bereits storniert.');
    END IF;

    FOR pos IN (
        SELECT VARIANTEID, MENGE FROM VERKAUFPOSITION WHERE VERKAUFID = p_verkaufid
        ) LOOP
            SP_BESTAND_AKTUALISIEREN(pos.VARIANTEID, p_lagerid, pos.MENGE, v_neu);

            SELECT BESTANDID INTO v_bestandid
            FROM   BESTAND
            WHERE  VARIANTEID = pos.VARIANTEID AND LAGERID = p_lagerid;

            -- I = Inventar-Rückkehr (Eingang)
            INSERT INTO LAGERBEWEGUNG
            (BEWEGUNGSID, BESTANDID, BES_BESTANDID, DATUM, BEWEGUNGSTYP, MENGE)
            VALUES
                (SEQ_LAGERBEWEGUNG.NEXTVAL, v_bestandid, v_bestandid, SYSDATE, 'I', pos.MENGE);
        END LOOP;

    UPDATE VERKAUF SET ZAHLUNGSTATUS = 'N' WHERE VERKAUFID = p_verkaufid;

    COMMIT;
    p_erfolg := 1;

EXCEPTION
    WHEN OTHERS THEN ROLLBACK; p_erfolg := 0; RAISE;
END SP_VERKAUF_STORNIEREN;
/

-- ---------------------------------------------------------------
-- 5. SP_PRODUKT_SUCHEN
--    REF CURSOR mit Produkten + Varianten + Bestand.
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_PRODUKT_SUCHEN (
    p_suchbegriff IN  VARCHAR2,
    p_kategorieid IN  NUMBER,
    p_min_preis   IN  NUMBER,
    p_max_preis   IN  NUMBER,
    p_lagerid     IN  NUMBER,
    p_ergebnis    OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_ergebnis FOR
        SELECT
            p.PRODUKTID,
            p.NAME                         AS PRODUKTNAME,
            p.BESCHREIBUNG,
            p.BASIS_PREIS,
            k.KATEGORIENAME,
            NVL(r.RABATT_PROZENT, 0)       AS RABATT_PROZENT,
            pv.VARIANTEID,
            pv.PREISVARIANTE,
            ROUND(pv.PREISVARIANTE * (1 - NVL(
                                                  CASE WHEN SYSDATE BETWEEN r.START_DATUM AND NVL(r.END_DATUM, SYSDATE)
                                                           THEN r.RABATT_PROZENT ELSE 0 END, 0) / 100), 2) AS ENDPREIS,
            f.FARBENID,
            f.FARBEBEZEICHNUNG,
            f.HEXCODE,
            m.BEZEICHNUNG                  AS MATERIAL,
            g.GROESSEID,
            g.BREITE_CM,
            g.HOEHE_CM,
            g.TIEFE_CM,
            g.BESCHREIBUNG                 AS GROESSE_BESCHREIBUNG,
            NVL(b.MENGE_VERFUEGBAR, 0)     AS BESTAND
        FROM   PRODUKT          p
                   JOIN   PRODUKTKATEGORIE k  ON k.KATEGORIEID = p.KATEGORIEID
                   LEFT JOIN RABATT        r  ON r.RABATTID    = p.RABATTID
                   JOIN   PRODUKTVARIANTE  pv ON pv.PRODUKTID  = p.PRODUKTID  AND pv.VERFUEGBAR = 'Y'
                   JOIN   FARBE            f  ON f.FARBENID    = pv.FARBENID
                   JOIN   MATERIAL         m  ON m.MATERIALID  = pv.MATERIALID
                   JOIN   GROESSE          g  ON g.GROESSEID   = pv.GROESSEID
                   LEFT JOIN BESTAND       b  ON b.VARIANTEID  = pv.VARIANTEID
            AND b.LAGERID     = NVL(p_lagerid, b.LAGERID)
        WHERE  p.VERFUEGBAR = 'Y'
          AND  (p_suchbegriff IS NULL
            OR UPPER(p.NAME)         LIKE '%' || UPPER(p_suchbegriff) || '%'
            OR UPPER(p.BESCHREIBUNG) LIKE '%' || UPPER(p_suchbegriff) || '%')
          AND  (p_kategorieid IS NULL OR p.KATEGORIEID = p_kategorieid)
          AND  (p_min_preis   IS NULL OR pv.PREISVARIANTE >= p_min_preis)
          AND  (p_max_preis   IS NULL OR pv.PREISVARIANTE <= p_max_preis)
        ORDER BY p.NAME, f.FARBEBEZEICHNUNG, g.BREITE_CM;
END SP_PRODUKT_SUCHEN;
/

-- ---------------------------------------------------------------
-- 6. SP_KUNDE_ANLEGEN_ODER_FINDEN
-- ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_KUNDE_ANLEGEN_ODER_FINDEN (
    p_vorname  IN  VARCHAR2,
    p_nachname IN  VARCHAR2,
    p_email    IN  VARCHAR2,
    p_telefon  IN  VARCHAR2,
    p_adresse  IN  VARCHAR2,
    p_plz      IN  VARCHAR2,
    p_ort      IN  VARCHAR2,
    p_land     IN  VARCHAR2,
    p_passwort IN  VARCHAR2,
    p_kundeid  OUT NUMBER,
    p_neu      OUT NUMBER
) AS
    v_id NUMBER;
BEGIN
    SELECT KUNDEID INTO v_id FROM KUNDE WHERE UPPER(EMAIL) = UPPER(p_email);
    p_kundeid := v_id;
    p_neu     := 0;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        SELECT SEQ_KUNDE.NEXTVAL INTO v_id FROM DUAL;
        INSERT INTO KUNDE (
            KUNDEID, VORNAME_, NACHNAME, EMAIL, ADRESSE,
            PLZ, ORT, LAND, REGESTRIERT, PASSWORT, TELEFONNUMMER
        ) VALUES (
                     v_id, p_vorname, p_nachname, p_email,
                     NVL(p_adresse,'-'), NVL(p_plz,'00000'),
                     NVL(p_ort,'-'), NVL(p_land,'Deutschland'),
                     'Y', NVL(p_passwort,'temp123'), p_telefon
                 );
        COMMIT;
        p_kundeid := v_id;
        p_neu     := 1;
END SP_KUNDE_ANLEGEN_ODER_FINDEN;
/
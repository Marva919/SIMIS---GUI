package service;

import java.sql.*;
import java.util.*;
import lombok.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class StoredProcedureService {

  private final JdbcTemplate jdbcTemplate;

  // ----------------------------------------------------------
  // Lagerbestand prüfen
  // ----------------------------------------------------------
  public LagerbestandErgebnis lagerbestandPruefen(Long varianteId, Long lagerId, int menge) {
    log.debug("Prüfe Lagerbestand: Variante={}, Lager={}, Menge={}", varianteId, lagerId, menge);

    return jdbcTemplate.execute(
        (Connection con) -> {
          try (CallableStatement cs =
              con.prepareCall("{CALL SP_LAGERBESTAND_PRUEFEN(?,?,?,?,?)}")) {

            cs.setLong(1, varianteId);
            cs.setLong(2, lagerId);
            cs.setInt(3, menge);
            cs.registerOutParameter(4, Types.NUMERIC); // p_verfuegbar
            cs.registerOutParameter(5, Types.NUMERIC); // p_aktuell

            cs.execute();

            return new LagerbestandErgebnis(cs.getInt(4) == 1, cs.getInt(5));
          }
        });
  }

  // ----------------------------------------------------------
  // Lagerbestand aktualisieren
  // ----------------------------------------------------------
  public int lagerbestandAktualisieren(Long varianteId, Long lagerId, int delta) {
    log.debug(
        "Aktualisiere Lagerbestand: Variante={}, Lager={}, Delta={}", varianteId, lagerId, delta);

    return jdbcTemplate.execute(
        (Connection con) -> {
          try (CallableStatement cs =
              con.prepareCall("{CALL SP_LAGERBESTAND_AKTUALISIEREN(?,?,?,?)}")) {

            cs.setLong(1, varianteId);
            cs.setLong(2, lagerId);
            cs.setInt(3, delta);
            cs.registerOutParameter(4, Types.NUMERIC); // p_neue_menge

            cs.execute();
            return cs.getInt(4);
          }
        });
  }

  // ----------------------------------------------------------
  // Bestellung erstellen
  // ----------------------------------------------------------
  /**
   * @param positionen CSV-String: "varianteId:menge:lagerId,..."
   */
  public BestellungErgebnis bestellungErstellen(
      Long kundeId,
      Long angestellterId,
      Long filialeId,
      String lieferadresse,
      String notizen,
      String positionen) {
    log.info("Erstelle Bestellung für Kunde={} durch Angestellter={}", kundeId, angestellterId);

    return jdbcTemplate.execute(
        (Connection con) -> {
          try (CallableStatement cs =
              con.prepareCall("{CALL SP_BESTELLUNG_ERSTELLEN(?,?,?,?,?,?,?,?)}")) {

            cs.setLong(1, kundeId);
            cs.setLong(2, angestellterId);
            cs.setLong(3, filialeId);
            cs.setString(4, lieferadresse);
            cs.setString(5, notizen);
            cs.setString(6, positionen);
            cs.registerOutParameter(7, Types.NUMERIC); // p_bestellung_id
            cs.registerOutParameter(8, Types.NUMERIC); // p_gesamt_betrag

            cs.execute();

            return new BestellungErgebnis(cs.getLong(7), cs.getBigDecimal(8));
          }
        });
  }

  // ----------------------------------------------------------
  // Bestellung stornieren
  // ----------------------------------------------------------
  public boolean bestellungStornieren(Long bestellungId, Long lagerId) {
    log.info("Storniere Bestellung={}", bestellungId);

    return jdbcTemplate.execute(
        (Connection con) -> {
          try (CallableStatement cs = con.prepareCall("{CALL SP_BESTELLUNG_STORNIEREN(?,?,?)}")) {

            cs.setLong(1, bestellungId);
            cs.setLong(2, lagerId);
            cs.registerOutParameter(3, Types.NUMERIC); // p_erfolgreich

            cs.execute();
            return cs.getInt(3) == 1;
          }
        });
  }

  // ----------------------------------------------------------
  // Produkte suchen (REF CURSOR)
  // ----------------------------------------------------------
  public List<Map<String, Object>> produkteSuchen(
      String suchbegriff, String kategorie, Double minPreis, Double maxPreis, Long lagerId) {
    return jdbcTemplate.execute(
        (Connection con) -> {
          try (CallableStatement cs = con.prepareCall("{CALL SP_PRODUKT_SUCHEN(?,?,?,?,?,?)}")) {

            cs.setString(1, suchbegriff);
            cs.setString(2, kategorie);
            if (minPreis != null) cs.setDouble(3, minPreis);
            else cs.setNull(3, Types.NUMERIC);
            if (maxPreis != null) cs.setDouble(4, maxPreis);
            else cs.setNull(4, Types.NUMERIC);
            if (lagerId != null) cs.setLong(5, lagerId);
            else cs.setNull(5, Types.NUMERIC);
            cs.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);

            cs.execute();

            List<Map<String, Object>> result = new ArrayList<>();
            try (ResultSet rs = (ResultSet) cs.getObject(6)) {
              ResultSetMetaData meta = rs.getMetaData();
              int cols = meta.getColumnCount();
              while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= cols; i++) {
                  row.put(meta.getColumnName(i).toLowerCase(), rs.getObject(i));
                }
                result.add(row);
              }
            }
            return result;
          }
        });
  }

  // ----------------------------------------------------------
  // Kunde anlegen oder finden
  // ----------------------------------------------------------
  public KundeErgebnis kundeAnlegenOderFinden(
      String vorname,
      String nachname,
      String email,
      String telefon,
      String strasse,
      String plz,
      String ort) {
    return jdbcTemplate.execute(
        (Connection con) -> {
          try (CallableStatement cs =
              con.prepareCall("{CALL SP_KUNDE_ANLEGEN_ODER_FINDEN(?,?,?,?,?,?,?,?,?)}")) {

            cs.setString(1, vorname);
            cs.setString(2, nachname);
            cs.setString(3, email);
            cs.setString(4, telefon);
            cs.setString(5, strasse);
            cs.setString(6, plz);
            cs.setString(7, ort);
            cs.registerOutParameter(8, Types.NUMERIC); // p_kunde_id
            cs.registerOutParameter(9, Types.NUMERIC); // p_neu

            cs.execute();

            return new KundeErgebnis(cs.getLong(8), cs.getInt(9) == 1);
          }
        });
  }

  // ----------------------------------------------------------
  // Inner records / DTOs
  // ----------------------------------------------------------
  public record LagerbestandErgebnis(boolean verfuegbar, int aktuelleMenge) {}

  public record BestellungErgebnis(Long bestellungId, java.math.BigDecimal gesamtBetrag) {}

  public record KundeErgebnis(Long kundeId, boolean neuAngelegt) {}
}

package service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.*;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class StoredProcedureService {

  private final JdbcTemplate jdbcTemplate;

  public BestandErgebnis bestandPruefen(Long varianteId, Long lagerId, int menge) {
    log.debug("SP_BESTAND_PRUEFEN varianteId={} lagerId={} menge={}", varianteId, lagerId, menge);
    return jdbcTemplate.execute((Connection con) -> {
      try (CallableStatement cs = con.prepareCall("{CALL SP_BESTAND_PRUEFEN(?,?,?,?,?)}")) {
        cs.setLong(1, varianteId);
        cs.setLong(2, lagerId);
        cs.setInt(3, menge);
        cs.registerOutParameter(4, Types.NUMERIC);
        cs.registerOutParameter(5, Types.NUMERIC);
        cs.execute();
        return new BestandErgebnis(cs.getInt(4) == 1, cs.getInt(5));
      }
    });
  }

  public int bestandAktualisieren(Long varianteId, Long lagerId, int delta) {
    return jdbcTemplate.execute((Connection con) -> {
      try (CallableStatement cs = con.prepareCall("{CALL SP_BESTAND_AKTUALISIEREN(?,?,?,?)}")) {
        cs.setLong(1, varianteId);
        cs.setLong(2, lagerId);
        cs.setInt(3, delta);
        cs.registerOutParameter(4, Types.NUMERIC);
        cs.execute();
        return cs.getInt(4);
      }
    });
  }

  public VerkaufErgebnis verkaufErstellen(Long kundeId, Long filialeId,
                                          Long zahlungsartId, Long lagerId,
                                          String positionen) {
    log.info("SP_VERKAUF_ERSTELLEN kundeId={} filialeId={}", kundeId, filialeId);
    return jdbcTemplate.execute((Connection con) -> {
      try (CallableStatement cs = con.prepareCall("{CALL SP_VERKAUF_ERSTELLEN(?,?,?,?,?,?,?)}")) {
        cs.setLong(1, kundeId);
        cs.setLong(2, filialeId);
        cs.setLong(3, zahlungsartId);
        cs.setLong(4, lagerId);
        cs.setString(5, positionen);
        cs.registerOutParameter(6, Types.NUMERIC);
        cs.registerOutParameter(7, Types.NUMERIC);
        cs.execute();
        return new VerkaufErgebnis(cs.getLong(6), cs.getBigDecimal(7));
      }
    });
  }

  public boolean verkaufStornieren(Long verkaufId, Long lagerId) {
    log.info("SP_VERKAUF_STORNIEREN verkaufId={}", verkaufId);
    return jdbcTemplate.execute((Connection con) -> {
      try (CallableStatement cs = con.prepareCall("{CALL SP_VERKAUF_STORNIEREN(?,?,?)}")) {
        cs.setLong(1, verkaufId);
        cs.setLong(2, lagerId);
        cs.registerOutParameter(3, Types.NUMERIC);
        cs.execute();
        return cs.getInt(3) == 1;
      }
    });
  }

  public List<Map<String, Object>> produkteSuchen(String suchbegriff, Long kategorieId,
                                                  Double minPreis, Double maxPreis,
                                                  Long lagerId) {
    return jdbcTemplate.execute((Connection con) -> {
      try (CallableStatement cs = con.prepareCall("{CALL SP_PRODUKT_SUCHEN(?,?,?,?,?,?)}")) {
        cs.setString(1, suchbegriff);
        if (kategorieId != null) cs.setLong(2, kategorieId);   else cs.setNull(2, Types.NUMERIC);
        if (minPreis    != null) cs.setDouble(3, minPreis);     else cs.setNull(3, Types.NUMERIC);
        if (maxPreis    != null) cs.setDouble(4, maxPreis);     else cs.setNull(4, Types.NUMERIC);
        if (lagerId     != null) cs.setLong(5, lagerId);        else cs.setNull(5, Types.NUMERIC);
        cs.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
        cs.execute();

        List<Map<String, Object>> rows = new ArrayList<>();
        try (ResultSet rs = (ResultSet) cs.getObject(6)) {
          ResultSetMetaData meta = rs.getMetaData();
          int cols = meta.getColumnCount();
          while (rs.next()) {
            Map<String, Object> row = new LinkedHashMap<>();
            for (int i = 1; i <= cols; i++) {
              row.put(meta.getColumnName(i).toLowerCase(), rs.getObject(i));
            }
            rows.add(row);
          }
        }
        return rows;
      }
    });
  }

  public KundeErgebnis kundeAnlegenOderFinden(String vorname, String nachname,
                                              String email, String telefon,
                                              String adresse, String plz,
                                              String ort, String land) {
    return jdbcTemplate.execute((Connection con) -> {
      try (CallableStatement cs = con.prepareCall("{CALL SP_KUNDE_ANLEGEN_ODER_FINDEN(?,?,?,?,?,?,?,?,?,?,?)}")) {
        cs.setString(1, vorname);
        cs.setString(2, nachname);
        cs.setString(3, email);
        cs.setString(4, telefon);
        cs.setString(5, adresse);
        cs.setString(6, plz);
        cs.setString(7, ort);
        cs.setString(8, land);
        cs.registerOutParameter(10, Types.NUMERIC);
        cs.registerOutParameter(11, Types.NUMERIC);
        cs.execute();
        return new KundeErgebnis(cs.getLong(10), cs.getInt(11) == 1);
      }
    });
  }

  public record BestandErgebnis(boolean verfuegbar, int aktuelleMenge) {}
  public record VerkaufErgebnis(Long verkaufId, java.math.BigDecimal gesamtBetrag) {}
  public record KundeErgebnis(Long kundeId, boolean neuAngelegt) {}
}
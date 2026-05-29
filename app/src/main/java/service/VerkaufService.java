package service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import model.Verkauf;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import repository.VerkaufRepository;

@Service
@RequiredArgsConstructor
@Slf4j
public class VerkaufService {

  private final VerkaufRepository repo;
  private final StoredProcedureService spService;
  private final JdbcTemplate jdbcTemplate;

  public List<Map<String, Object>> aktiveRabatte() {
    String sql =
        """
            SELECT RABATTID, BEZEICHNUNG, RABATT_PROZENT, START_DATUM, END_DATUM
            FROM RABATT
            WHERE START_DATUM <= SYSDATE
              AND (END_DATUM IS NULL OR END_DATUM >= SYSDATE)
            ORDER BY RABATT_PROZENT
            """;
    return jdbcTemplate.queryForList(sql).stream().map(this::lowercaseKeys).toList();
  }

  public StoredProcedureService.VerkaufErgebnis verkaufErstellen(
      VerkaufAnfrage anfrage, Long filialeId, Long lagerId) {
    log.info("Positionen erhalten: {}", anfrage.positionen());
    if (anfrage.positionen() == null || anfrage.positionen().isEmpty()) {
      throw new IllegalArgumentException("Keine Positionen angegeben");
    }
    for (PositionAnfrage p : anfrage.positionen()) {
      if (p.varianteId() == null) {
        throw new IllegalArgumentException("VarianteId fehlt in einer Position: " + p);
      }
    }
    String csv =
        anfrage.positionen().stream()
            .map(p -> p.varianteId() + ":" + p.menge())
            .collect(Collectors.joining(","));
    log.info("CSV an SP_VERKAUF_ERSTELLEN: [{}]", csv);

    StoredProcedureService.VerkaufErgebnis ergebnis =
        spService.verkaufErstellen(
            anfrage.kundeId(), filialeId, anfrage.zahlungsartId(), lagerId, csv);

    if (anfrage.rabattId() != null) {
      BigDecimal prozent =
          jdbcTemplate.queryForObject(
              "SELECT RABATT_PROZENT FROM RABATT WHERE RABATTID = ?",
              BigDecimal.class,
              anfrage.rabattId());
      if (prozent != null && prozent.compareTo(BigDecimal.ZERO) > 0) {
        BigDecimal faktor =
            BigDecimal.ONE.subtract(
                prozent.divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP));
        jdbcTemplate.update(
            "UPDATE VERKAUFPOSITION SET EINZELPREIS = ROUND(EINZELPREIS * ?, 2) WHERE VERKAUFID = ?",
            faktor,
            ergebnis.verkaufId());
        BigDecimal rabattierterGesamt =
            ergebnis.gesamtBetrag().multiply(faktor).setScale(2, RoundingMode.HALF_UP);
        return new StoredProcedureService.VerkaufErgebnis(ergebnis.verkaufId(), rabattierterGesamt);
      }
    }
    return ergebnis;
  }

  public boolean stornieren(Long verkaufId, Long lagerId) {
    String status =
        jdbcTemplate.queryForObject(
            "SELECT ZAHLUNGSTATUS FROM VERKAUF WHERE VERKAUFID = ?", String.class, verkaufId);
    if (status == null)
      throw new NoSuchElementException("Verkauf " + verkaufId + " nicht gefunden");
    if ("Y".equals(status))
      throw new IllegalStateException("Bereits bezahlte Verkäufe können nicht storniert werden");
    return spService.verkaufStornieren(verkaufId, lagerId);
  }

  public List<Verkauf> nachKunde(Long kundeId) {
    return repo.findByKundeIdOrderByVerkaufsDatumDesc(kundeId);
  }

  public List<Map<String, Object>> nachKundeMitGesamt(Long kundeId) {
    return verkaufsUebersicht("v.KUNDEID = ?", kundeId);
  }

  public List<Map<String, Object>> nachFilialeMitGesamt(Long filialeId) {
    return verkaufsUebersicht("v.FILIALEID = ?", filialeId);
  }

  public Map<String, Object> details(Long verkaufId) {
    String sql =
        """
            SELECT
                v.VERKAUFID,
                v.KUNDEID,
                k.VORNAME || ' ' || k.NACHNAME AS KUNDE,
                k.EMAIL,
                v.VERKAUFSDATUM,
                v.ZAHLUNGSTATUS,
                v.ANZAHL,
                v.ZAHLUNGSARTID,
                z.BEZEICHNUNG AS ZAHLUNGSART,
                NVL(SUM(vp.MENGE * vp.EINZELPREIS), 0) AS GESAMT
            FROM VERKAUF v
            LEFT JOIN KUNDE k ON k.KUNDEID = v.KUNDEID
            LEFT JOIN VERKAUFPOSITION vp ON vp.VERKAUFID = v.VERKAUFID
            LEFT JOIN ZAHLUNGSART z ON z.ZAHLUNGSARTID = v.ZAHLUNGSARTID
            WHERE v.VERKAUFID = ?
            GROUP BY
                v.VERKAUFID, v.KUNDEID, k.VORNAME, k.NACHNAME,
                k.EMAIL, v.VERKAUFSDATUM, v.ZAHLUNGSTATUS,
                v.ANZAHL, v.ZAHLUNGSARTID, z.BEZEICHNUNG
            """;

    List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, verkaufId);
    if (rows.isEmpty())
      throw new NoSuchElementException("Verkauf " + verkaufId + " nicht gefunden");

    Map<String, Object> header = lowercaseKeys(rows.get(0));

    String positionenSql =
        """
            SELECT
                vp.VERKAUFPOSITIONID,
                vp.VARIANTEID,
                vp.MENGE,
                vp.EINZELPREIS,
                p.NAME AS PRODUKTNAME,
                f.FARBEBEZEICHNUNG AS FARBE,
                g.BESCHREIBUNG AS GROESSE
            FROM VERKAUFPOSITION vp
            LEFT JOIN PRODUKTVARIANTE pv ON pv.VARIANTEID = vp.VARIANTEID
            LEFT JOIN PRODUKT p ON p.PRODUKTID = pv.PRODUKTID
            LEFT JOIN FARBE f ON f.FARBENID = pv.FARBENID
            LEFT JOIN GROESSE g ON g.GROESSEID = pv.GROESSEID
            WHERE vp.VERKAUFID = ?
            ORDER BY vp.VERKAUFPOSITIONID
            """;
    List<Map<String, Object>> positionen =
        jdbcTemplate.queryForList(positionenSql, verkaufId).stream()
            .map(this::lowercaseKeys)
            .toList();

    String rueckgabenSql =
        """
            SELECT
                r.RUECKGABEID,
                r.DATUM,
                r.GRUND,
                r.BETRAG_ERSTATTUNG
            FROM RUECKGABE r
            WHERE r.VERKAUFID = ?
            ORDER BY r.DATUM DESC
            """;
    List<Map<String, Object>> rueckgaben =
        jdbcTemplate.queryForList(rueckgabenSql, verkaufId).stream()
            .map(this::lowercaseKeys)
            .toList();

    header.put("positionen", positionen);
    header.put("rueckgaben", rueckgaben);
    return header;
  }

  public void zahlungsstatusAktualisieren(Long verkaufId, String status) {
    if (!status.equals("Y") && !status.equals("N"))
      throw new IllegalArgumentException("Status muss Y oder N sein");
    int updated =
        jdbcTemplate.update(
            "UPDATE VERKAUF SET ZAHLUNGSTATUS=? WHERE VERKAUFID=?", status, verkaufId);
    if (updated == 0) throw new NoSuchElementException("Verkauf " + verkaufId + " nicht gefunden");
  }

  public void rueckgabeErfassen(
      Long verkaufId, Long lagerId, Long kundeId, String grund, BigDecimal betrag) {
    Long nextId =
        jdbcTemplate.queryForObject(
            "SELECT NVL(MAX(RUECKGABEID), 0) + 1 FROM RUECKGABE", Long.class);
    jdbcTemplate.update(
        """
            INSERT INTO RUECKGABE (RUECKGABEID, VERKAUFID, LAGERID, KUNDEID, DATUM, GRUND, BETRAG_ERSTATTUNG)
            VALUES (?, ?, ?, ?, SYSDATE, ?, ?)
            """,
        nextId,
        verkaufId,
        lagerId,
        kundeId,
        grund,
        betrag);
  }

  private List<Map<String, Object>> verkaufsUebersicht(String whereClause, Long parameter) {
    String sql =
        """
            SELECT
                v.VERKAUFID,
                v.KUNDEID,
                k.NACHNAME || ', ' || k.VORNAME AS KUNDE,
                v.VERKAUFSDATUM,
                v.ZAHLUNGSTATUS,
                v.ANZAHL,
                NVL(SUM(vp.MENGE * vp.EINZELPREIS), 0) AS GESAMT
            FROM VERKAUF v
            LEFT JOIN KUNDE k ON k.KUNDEID = v.KUNDEID
            LEFT JOIN VERKAUFPOSITION vp ON vp.VERKAUFID = v.VERKAUFID
            WHERE %s
            GROUP BY
                v.VERKAUFID,
                v.KUNDEID,
                k.NACHNAME,
                k.VORNAME,
                v.VERKAUFSDATUM,
                v.ZAHLUNGSTATUS,
                v.ANZAHL
            ORDER BY v.VERKAUFSDATUM DESC, v.VERKAUFID DESC
            """
            .formatted(whereClause);
    return jdbcTemplate.queryForList(sql, parameter).stream().map(this::lowercaseKeys).toList();
  }

  private Map<String, Object> lowercaseKeys(Map<String, Object> row) {
    Map<String, Object> lower = new LinkedHashMap<>();
    row.forEach((key, value) -> lower.put(key.toLowerCase(), value));
    return lower;
  }

  public record VerkaufAnfrage(
      Long kundeId, Long zahlungsartId, Long rabattId, List<PositionAnfrage> positionen) {}

  public record PositionAnfrage(
      @com.fasterxml.jackson.annotation.JsonProperty("varianteId") Long varianteId,
      @com.fasterxml.jackson.annotation.JsonProperty("menge") int menge) {}

  public record ZahlungsstatusAnfrage(String status) {}

  public record RueckgabeAnfrage(String grund, java.math.BigDecimal betrag) {}
}

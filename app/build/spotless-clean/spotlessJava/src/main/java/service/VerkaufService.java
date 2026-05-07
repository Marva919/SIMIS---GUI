package service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import model.Verkauf;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import repository.VerkaufRepository;

@Service
@RequiredArgsConstructor
public class VerkaufService {

  private final VerkaufRepository repo;
  private final StoredProcedureService spService;
  private final JdbcTemplate jdbcTemplate;

  public StoredProcedureService.VerkaufErgebnis verkaufErstellen(
      VerkaufAnfrage anfrage, Long filialeId, Long lagerId) {
    String csv =
        anfrage.positionen().stream()
            .map(p -> p.varianteId() + ":" + p.menge())
            .collect(Collectors.joining(","));

    return spService.verkaufErstellen(
        anfrage.kundeId(), filialeId, anfrage.zahlungsartId(), lagerId, csv);
  }

  public boolean stornieren(Long verkaufId, Long lagerId) {
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
      Long kundeId, Long zahlungsartId, List<PositionAnfrage> positionen) {}

  public record PositionAnfrage(Long varianteId, int menge) {}
}

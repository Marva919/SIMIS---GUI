package service;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import model.Bestellung;
import org.springframework.stereotype.Service;
import repository.BestellungRepository;

@Service
@RequiredArgsConstructor
@Slf4j
public class BestellungService {

  private final BestellungRepository repo;
  private final StoredProcedureService spService;
  private final KundeService kundeService;

  public StoredProcedureService.BestellungErgebnis bestellungErstellen(
      BestellungAnfrage anfrage, Long angestellterId, Long filialeId) {

    // Positionen als CSV aufbauen: varianteId:menge:lagerId, ...
    String positionenCsv =
        anfrage.positionen().stream()
            .map(p -> p.varianteId() + ":" + p.menge() + ":" + anfrage.lagerId())
            .collect(Collectors.joining(","));

    return spService.bestellungErstellen(
        anfrage.kundeId(),
        angestellterId,
        filialeId,
        anfrage.lieferadresse(),
        anfrage.notizen(),
        positionenCsv);
  }

  public boolean stornieren(Long bestellungId, Long lagerId) {
    return spService.bestellungStornieren(bestellungId, lagerId);
  }

  public List<Bestellung> bestellungenNachKunde(Long kundeId) {
    return repo.findByKundeIdOrderByErstelltAmDesc(kundeId);
  }

  // DTO
  public record BestellungAnfrage(
      Long kundeId,
      Long lagerId,
      String lieferadresse,
      String notizen,
      List<PositionAnfrage> positionen) {}

  public record PositionAnfrage(Long varianteId, int menge) {}
}

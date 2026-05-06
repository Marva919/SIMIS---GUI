package controller;

import java.util.Map;
import lombok.RequiredArgsConstructor;
import model.Angestellter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import service.BestellungService;

@RestController
@RequestMapping("/api/bestellungen")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class BestellungController {

  private final BestellungService service;

  /** Neue Bestellung aufgeben. Ruft intern SP_BESTELLUNG_ERSTELLEN auf. */
  @PostMapping
  public ResponseEntity<?> bestellungErstellen(
      @RequestBody BestellungService.BestellungAnfrage anfrage,
      @AuthenticationPrincipal Angestellter angestellter) {
    var ergebnis =
        service.bestellungErstellen(
            anfrage, angestellter.getAngestellterId(), angestellter.getFilialeId());

    return ResponseEntity.status(HttpStatus.CREATED)
        .body(
            Map.of(
                "bestellungId",
                ergebnis.bestellungId(),
                "gesamtBetrag",
                ergebnis.gesamtBetrag(),
                "status",
                "BESTAETIGT",
                "message",
                "Bestellung erfolgreich erstellt"));
  }

  /** Bestellung stornieren. Ruft intern SP_BESTELLUNG_STORNIEREN auf. */
  @PutMapping("/{id}/stornieren")
  public ResponseEntity<?> stornieren(@PathVariable Long id, @RequestParam Long lagerId) {
    boolean ok = service.stornieren(id, lagerId);
    if (!ok) {
      return ResponseEntity.badRequest().body(Map.of("error", "Stornierung fehlgeschlagen"));
    }
    return ResponseEntity.ok(Map.of("message", "Bestellung " + id + " wurde storniert"));
  }

  /** Bestellungen eines Kunden abrufen. */
  @GetMapping("/kunde/{kundeId}")
  public ResponseEntity<?> nachKunde(@PathVariable Long kundeId) {
    return ResponseEntity.ok(service.bestellungenNachKunde(kundeId));
  }
}

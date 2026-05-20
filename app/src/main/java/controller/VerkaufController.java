package controller;

import java.util.Map;
import java.util.NoSuchElementException;
import lombok.RequiredArgsConstructor;
import model.Angestellter;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import service.VerkaufService;

@RestController
@RequestMapping("/api/verkauf")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class VerkaufController {

  private final VerkaufService service;

  @PostMapping
  public ResponseEntity<?> erstellen(
      @RequestBody VerkaufService.VerkaufAnfrage anfrage, @AuthenticationPrincipal Angestellter a) {
    var ergebnis = service.verkaufErstellen(anfrage, a.getFilialeId(), a.getLagerId());
    return ResponseEntity.status(HttpStatus.CREATED)
        .body(
            Map.of(
                "verkaufId", ergebnis.verkaufId(),
                "gesamtBetrag", ergebnis.gesamtBetrag(),
                "message", "Verkauf erfolgreich abgeschlossen"));
  }

  @GetMapping("/{id}")
  public ResponseEntity<?> details(@PathVariable Long id) {
    try {
      return ResponseEntity.ok(service.details(id));
    } catch (NoSuchElementException e) {
      return ResponseEntity.notFound().build();
    }
  }

  @PutMapping("/{id}/stornieren")
  public ResponseEntity<?> stornieren(
      @PathVariable Long id, @AuthenticationPrincipal Angestellter a) {
    boolean ok = service.stornieren(id, a.getLagerId());
    if (!ok) return ResponseEntity.badRequest().body(Map.of("error", "Stornierung fehlgeschlagen"));
    return ResponseEntity.ok(Map.of("message", "Verkauf " + id + " storniert"));
  }

  @PatchMapping("/{id}/zahlungstatus")
  public ResponseEntity<?> zahlungsstatusAktualisieren(
      @PathVariable Long id, @RequestBody VerkaufService.ZahlungsstatusAnfrage anfrage) {
    try {
      service.zahlungsstatusAktualisieren(id, anfrage.status());
      return ResponseEntity.ok(Map.of("message", "Zahlungsstatus aktualisiert"));
    } catch (NoSuchElementException e) {
      return ResponseEntity.notFound().build();
    } catch (IllegalArgumentException e) {
      return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
    }
  }

  @PostMapping("/{id}/rueckgabe")
  public ResponseEntity<?> rueckgabeErfassen(
      @PathVariable Long id,
      @RequestBody VerkaufService.RueckgabeAnfrage anfrage,
      @AuthenticationPrincipal Angestellter a) {
    try {
      var details = service.details(id);
      Long kundeId = ((Number) details.get("kundeid")).longValue();
      service.rueckgabeErfassen(id, a.getLagerId(), kundeId, anfrage.grund(), anfrage.betrag());
      return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("message", "Rückgabe erfasst"));
    } catch (NoSuchElementException e) {
      return ResponseEntity.notFound().build();
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
    }
  }

  @GetMapping
  public ResponseEntity<?> alleVerkauefe(@AuthenticationPrincipal Angestellter a) {
    return ResponseEntity.ok(service.nachFilialeMitGesamt(a.getFilialeId()));
  }

  @GetMapping("/kunde/{kundeId}")
  public ResponseEntity<?> nachKunde(@PathVariable Long kundeId) {
    return ResponseEntity.ok(service.nachKundeMitGesamt(kundeId));
  }
}

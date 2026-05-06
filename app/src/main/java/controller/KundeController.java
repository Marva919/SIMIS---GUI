package controller;

import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import model.Kunde;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import service.KundeService;

@RestController
@RequestMapping("/api/kunden")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class KundeController {

  private final KundeService service;

  @GetMapping
  public ResponseEntity<List<Kunde>> alle() {
    return ResponseEntity.ok(service.alleKunden());
  }

  @GetMapping("/suchen")
  public ResponseEntity<List<Kunde>> suchen(@RequestParam String name) {
    return ResponseEntity.ok(service.suchen(name));
  }

  @GetMapping("/{id}")
  public ResponseEntity<?> findById(@PathVariable Long id) {
    return service.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }

  /**
   * Neuen Kunden anlegen oder bestehenden zurückgeben. Ruft intern SP_KUNDE_ANLEGEN_ODER_FINDEN
   * auf.
   */
  @PostMapping
  public ResponseEntity<?> anlegen(@RequestBody Kunde kunde) {
    var ergebnis = service.anlegenOderFinden(kunde);
    return ResponseEntity.status(ergebnis.neuAngelegt() ? HttpStatus.CREATED : HttpStatus.OK)
        .body(
            Map.of(
                "kundeId", ergebnis.kundeId(),
                "neu", ergebnis.neuAngelegt()));
  }
}

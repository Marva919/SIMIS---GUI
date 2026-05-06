package controller;

import model.Kunde;
import service.KundeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/kunden")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class KundeController {

  private final KundeService service;

  @GetMapping
  public ResponseEntity<List<Kunde>> alle() {
    return ResponseEntity.ok(service.alle());
  }

  @GetMapping("/suchen")
  public ResponseEntity<List<Kunde>> suchen(@RequestParam String name) {
    return ResponseEntity.ok(service.suchen(name));
  }

  @GetMapping("/{id}")
  public ResponseEntity<?> findById(@PathVariable Long id) {
    return service.findById(id).map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
  }

  @PostMapping
  public ResponseEntity<?> anlegen(@RequestBody Kunde kunde) {
    var r = service.anlegenOderFinden(kunde);
    return ResponseEntity.status(r.neuAngelegt() ? HttpStatus.CREATED : HttpStatus.OK)
            .body(Map.of("kundeId", r.kundeId(), "neu", r.neuAngelegt()));
  }
}
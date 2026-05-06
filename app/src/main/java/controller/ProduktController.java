package controller;

import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import service.ProduktService;

@RestController
@RequestMapping("/api/produkte")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class ProduktController {

  private final ProduktService service;

  /** GET /api/produkte?suche=Bett&kategorie=Schlafzimmer&minPreis=200&maxPreis=1500&lagerId=1 */
  @GetMapping
  public ResponseEntity<List<Map<String, Object>>> suchen(
      @RequestParam(required = false) String suche,
      @RequestParam(required = false) String kategorie,
      @RequestParam(required = false) Double minPreis,
      @RequestParam(required = false) Double maxPreis,
      @RequestParam(required = false) Long lagerId) {
    return ResponseEntity.ok(service.suchen(suche, kategorie, minPreis, maxPreis, lagerId));
  }

  @GetMapping("/kategorien")
  public ResponseEntity<List<String>> kategorien() {
    return ResponseEntity.ok(service.alleKategorien());
  }

  @GetMapping("/{id}")
  public ResponseEntity<?> findById(@PathVariable Long id) {
    return service.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
}

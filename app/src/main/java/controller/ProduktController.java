package controller;

import service.ProduktService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/produkte")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class ProduktController {

  private final ProduktService service;

  @GetMapping
  public ResponseEntity<List<Map<String, Object>>> suchen(
          @RequestParam(required = false) String  suche,
          @RequestParam(required = false) Long    kategorieId,
          @RequestParam(required = false) Double  minPreis,
          @RequestParam(required = false) Double  maxPreis,
          @RequestParam(required = false) Long    lagerId
  ) {
    return ResponseEntity.ok(service.suchen(suche, kategorieId, minPreis, maxPreis, lagerId));
  }

  @GetMapping("/kategorien")
  public ResponseEntity<List<Map<String, Object>>> kategorien() {
    return ResponseEntity.ok(service.alleKategorien());
  }
}
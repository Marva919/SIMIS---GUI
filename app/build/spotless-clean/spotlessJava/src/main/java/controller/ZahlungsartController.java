package controller;

import java.util.List;
import lombok.RequiredArgsConstructor;
import model.Zahlungsart;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import repository.ZahlungsartRepository;

@RestController
@RequestMapping("/api/zahlungsarten")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class ZahlungsartController {

  private final ZahlungsartRepository repo;

  @GetMapping
  public ResponseEntity<List<Zahlungsart>> alle() {
    return ResponseEntity.ok(repo.findAll());
  }
}

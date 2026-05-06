package controller;

import model.Zahlungsart;
import repository.ZahlungsartRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

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
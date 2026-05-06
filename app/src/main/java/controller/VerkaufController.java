package controller;

import model.Angestellter;
import service.VerkaufService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/verkauf")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class VerkaufController {

    private final VerkaufService service;

    @PostMapping
    public ResponseEntity<?> erstellen(
            @RequestBody VerkaufService.VerkaufAnfrage anfrage,
            @AuthenticationPrincipal Angestellter a
    ) {
        var ergebnis = service.verkaufErstellen(anfrage, a.getFilialeId(), a.getLagerId());
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of(
                "verkaufId",    ergebnis.verkaufId(),
                "gesamtBetrag", ergebnis.gesamtBetrag(),
                "message",      "Verkauf erfolgreich abgeschlossen"
        ));
    }

    @PutMapping("/{id}/stornieren")
    public ResponseEntity<?> stornieren(
            @PathVariable Long id,
            @AuthenticationPrincipal Angestellter a
    ) {
        boolean ok = service.stornieren(id, a.getLagerId());
        if (!ok) return ResponseEntity.badRequest().body(Map.of("error", "Stornierung fehlgeschlagen"));
        return ResponseEntity.ok(Map.of("message", "Verkauf " + id + " storniert"));
    }

    @GetMapping
    public ResponseEntity<?> alleVerkauefe(@AuthenticationPrincipal Angestellter a) {
        return ResponseEntity.ok(service.nachFiliale(a.getFilialeId()));
    }

    @GetMapping("/kunde/{kundeId}")
    public ResponseEntity<?> nachKunde(@PathVariable Long kundeId) {
        return ResponseEntity.ok(service.nachKunde(kundeId));
    }
}
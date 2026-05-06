package controller;

import service.AngestellterService;
import model.Angestellter;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

  private final AngestellterService service;

  @PostMapping("/login")
  public ResponseEntity<?> login(@Valid @RequestBody LoginRequest req) {
    String token = service.login(req.email(), req.passwort());
    return ResponseEntity.ok(Map.of("token", token));
  }

  @GetMapping("/me")
  public ResponseEntity<?> me(@AuthenticationPrincipal Angestellter a) {
    return ResponseEntity.ok(Map.of(
            "angestellterId", a.getAngestellterId(),
            "vorname",        a.getVorname(),
            "nachname",       a.getNachname(),
            "rolle",          a.getRolle(),
            "filialeId",      a.getFilialeId(),
            "lagerId",        a.getLagerId()
    ));
  }

  public record LoginRequest(
          @jakarta.validation.constraints.NotBlank String email,
          @jakarta.validation.constraints.NotBlank String passwort
  ) {}
}
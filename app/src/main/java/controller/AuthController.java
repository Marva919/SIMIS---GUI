package controller;

import jakarta.validation.Valid;
import lombok.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import service.AngestellterService;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

  private final AngestellterService service;

  @PostMapping("/login")
  public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest req) {
    String token = service.login(req.email(), req.passwort());
    return ResponseEntity.ok(new LoginResponse(token));
  }

  public record LoginRequest(
      @jakarta.validation.constraints.NotBlank String email,
      @jakarta.validation.constraints.NotBlank String passwort) {}

  public record LoginResponse(String token) {}
}

package controller;

import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.http.*;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.annotation.*;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

  @ExceptionHandler(BadCredentialsException.class)
  public ResponseEntity<?> handleBadCredentials(BadCredentialsException ex) {
    return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
        .body(Map.of("error", "Ungültige Anmeldedaten"));
  }

  @ExceptionHandler(DataAccessException.class)
  public ResponseEntity<?> handleDb(DataAccessException ex) {
    log.error("DB-Fehler: {}", ex.getMessage());
    String msg = ex.getMostSpecificCause().getMessage();
    return ResponseEntity.badRequest().body(Map.of("error", msg != null ? msg : "Datenbankfehler"));
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<?> handleAll(Exception ex) {
    log.error("Fehler: {}", ex.getMessage(), ex);
    return ResponseEntity.internalServerError().body(Map.of("error", "Interner Serverfehler"));
  }
}

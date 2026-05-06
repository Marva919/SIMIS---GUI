package controller;

import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

  @ExceptionHandler(BadCredentialsException.class)
  public ResponseEntity<?> handleBadCredentials(BadCredentialsException ex) {
    return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
        .body(Map.of("error", "Ungültige Anmeldedaten"));
  }

  @ExceptionHandler(DataAccessException.class)
  public ResponseEntity<?> handleDataAccess(DataAccessException ex) {
    log.error("DB-Fehler: {}", ex.getMessage());
    // Oracle-Fehlermeldungen aus Stored Procedures weitergeben
    String msg = ex.getMostSpecificCause().getMessage();
    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
        .body(Map.of("error", msg != null ? msg : "Datenbankfehler"));
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<?> handleAll(Exception ex) {
    log.error("Unerwarteter Fehler: {}", ex.getMessage(), ex);
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .body(Map.of("error", "Interner Serverfehler"));
  }
}

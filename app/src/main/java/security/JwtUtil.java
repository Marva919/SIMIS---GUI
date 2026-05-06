package security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import javax.crypto.SecretKey;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component
public class JwtUtil {

  @Value("${jwt.secret}")
  private String secret;

  @Value("${jwt.expiration-ms}")
  private long expirationMs;

  private SecretKey key() {
    return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
  }

  public String generateToken(String email, String rolle, Long angestellterId) {
    return Jwts.builder()
        .subject(email)
        .claim("rolle", rolle)
        .claim("angestellterId", angestellterId)
        .issuedAt(new Date())
        .expiration(new Date(System.currentTimeMillis() + expirationMs))
        .signWith(key())
        .compact();
  }

  public String extractEmail(String token) {
    return Jwts.parser()
        .verifyWith(key())
        .build()
        .parseSignedClaims(token)
        .getPayload()
        .getSubject();
  }

  public boolean isTokenValid(String token, UserDetails userDetails) {
    try {
      Claims claims = Jwts.parser().verifyWith(key()).build().parseSignedClaims(token).getPayload();
      return claims.getSubject().equals(userDetails.getUsername())
          && claims.getExpiration().after(new Date());
    } catch (JwtException e) {
      return false;
    }
  }
}

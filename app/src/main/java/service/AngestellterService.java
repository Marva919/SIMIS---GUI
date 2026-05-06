package service;

import lombok.*;
import lombok.RequiredArgsConstructor;
import model.Angestellter;
import org.springframework.security.authentication.*;
import org.springframework.security.core.userdetails.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import repository.AngestellterRepository;
import security.JwtUtil;

@Service
@RequiredArgsConstructor
public class AngestellterService implements UserDetailsService {

  private final AngestellterRepository repo;
  private final AuthenticationManager authManager;
  private final JwtUtil jwtUtil;
  private final PasswordEncoder encoder;

  @Override
  public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
    return repo.findByEmail(email)
        .orElseThrow(() -> new UsernameNotFoundException("Mitarbeiter nicht gefunden: " + email));
  }

  public String login(String email, String passwort) {
    authManager.authenticate(new UsernamePasswordAuthenticationToken(email, passwort));
    Angestellter a = repo.findByEmail(email).orElseThrow();
    return jwtUtil.generateToken(a.getEmail(), a.getRolle(), a.getAngestellterId());
  }
}

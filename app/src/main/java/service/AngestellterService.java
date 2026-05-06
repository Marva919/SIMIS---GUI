package service;

import model.Angestellter;
import repository.AngestellterRepository;
import security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.*;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AngestellterService implements UserDetailsService {

  private final AngestellterRepository repo;
  private final AuthenticationManager  authManager;
  private final JwtUtil                jwtUtil;

  @Override
  public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
    return repo.findByEmail(email)
            .orElseThrow(() -> new UsernameNotFoundException("Nicht gefunden: " + email));
  }

  public String login(String email, String passwort) {
    authManager.authenticate(new UsernamePasswordAuthenticationToken(email, passwort));
    Angestellter a = repo.findByEmail(email).orElseThrow();
    return jwtUtil.generateToken(a.getEmail(), a.getRolle(), a.getAngestellterId());
  }
}
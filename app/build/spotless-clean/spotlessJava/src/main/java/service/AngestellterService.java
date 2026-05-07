package service;

import lombok.RequiredArgsConstructor;
import model.Angestellter;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import repository.AngestellterRepository;
import security.JwtUtil;

@Service
@RequiredArgsConstructor
public class AngestellterService implements UserDetailsService {

  private final AngestellterRepository repo;
  private final PasswordEncoder passwordEncoder;
  private final JwtUtil jwtUtil;

  @Override
  public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
    return repo.findByEmail(email)
        .orElseThrow(() -> new UsernameNotFoundException("Nicht gefunden: " + email));
  }

  public String login(String email, String passwort) {
    Angestellter a =
        repo.findByEmail(email)
            .orElseThrow(() -> new BadCredentialsException("Ungueltige Anmeldedaten"));
    if (!passwordEncoder.matches(passwort, a.getPassword())) {
      throw new BadCredentialsException("Ungueltige Anmeldedaten");
    }
    return jwtUtil.generateToken(a.getEmail(), a.getRolle(), a.getAngestellterId());
  }
}

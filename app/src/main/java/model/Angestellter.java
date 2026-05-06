package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

@Entity
@Table(name = "ANGESTELLTER")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Angestellter implements UserDetails {

  @Id
  @Column(name = "ANGESTELLTER_ID")
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_ang")
  @SequenceGenerator(name = "seq_ang", sequenceName = "SEQ_ANGESTELLTER", allocationSize = 1)
  private Long angestellterId;

  @Column(name = "FILIALE_ID", nullable = false)
  private Long filialeId;

  @Column(name = "VORNAME", nullable = false)
  private String vorname;

  @Column(name = "NACHNAME", nullable = false)
  private String nachname;

  @Column(name = "EMAIL", nullable = false, unique = true)
  private String email;

  @Column(name = "PASSWORT", nullable = false)
  private String passwort;

  @Column(name = "ROLLE", nullable = false)
  private String rolle;

  @Column(name = "AKTIV")
  private boolean aktiv = true;

  @Column(name = "ERSTELLT_AM")
  private LocalDateTime erstelltAm;

  // --- UserDetails ---
  @Override
  public String getUsername() {
    return email;
  }

  @Override
  public String getPassword() {
    return passwort;
  }

  @Override
  public boolean isEnabled() {
    return aktiv;
  }

  @Override
  public boolean isAccountNonExpired() {
    return true;
  }

  @Override
  public boolean isAccountNonLocked() {
    return true;
  }

  @Override
  public boolean isCredentialsNonExpired() {
    return true;
  }

  @Override
  public Collection<? extends GrantedAuthority> getAuthorities() {
    return List.of(new SimpleGrantedAuthority("ROLE_" + rolle));
  }
}

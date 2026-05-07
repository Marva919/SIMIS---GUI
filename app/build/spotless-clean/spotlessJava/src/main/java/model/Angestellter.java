package model;

import jakarta.persistence.*;
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
  @Column(name = "ANGESTELLTERID")
  private Long angestellterId;

  @Column(name = "FILIALEID")
  private Long filialeId;

  @Column(name = "LAGERID")
  private Long lagerId;

  @Column(name = "ANG_ANGESTELLTERID")
  private Long vorgesetzterAngestellterId;

  @Column(name = "VORNAME")
  private String vorname;

  @Column(name = "NACHNAME")
  private String nachname;

  @Column(name = "ROLLE")
  private String rolle;

  @Column(name = "EMAIL")
  private String email;

  @Column(name = "TELEFON")
  private String telefon;

  @Column(name = "PASSWORT")
  private String passwort;

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
    return true;
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

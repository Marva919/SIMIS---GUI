package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.*;

@Entity
@Table(name = "KUNDE")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Kunde {

  @Id
  @Column(name = "KUNDE_ID")
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_kd")
  @SequenceGenerator(name = "seq_kd", sequenceName = "SEQ_KUNDE", allocationSize = 1)
  private Long kundeId;

  @Column(name = "VORNAME", nullable = false)
  private String vorname;

  @Column(name = "NACHNAME", nullable = false)
  private String nachname;

  @Column(name = "EMAIL", unique = true)
  private String email;

  @Column(name = "TELEFON")
  private String telefon;

  @Column(name = "STRASSE")
  private String strasse;

  @Column(name = "PLZ")
  private String plz;

  @Column(name = "ORT")
  private String ort;

  @Column(name = "ERSTELLT_AM")
  private LocalDateTime erstelltAm;
}

package model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "KUNDE")
@Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
public class Kunde {
  @Id @Column(name = "KUNDEID")           private Long kundeId;
  @Column(name = "VORNAME")              private String vorname;
  @Column(name = "NACHNAME")              private String nachname;
  @Column(name = "EMAIL")                 private String email;
  @Column(name = "ADRESSE")               private String adresse;
  @Column(name = "PLZ")                   private String plz;
  @Column(name = "ORT")                   private String ort;
  @Column(name = "LAND")                  private String land;
  @Column(name = "TELEFONNUMMER")         private String telefonnummer;
}
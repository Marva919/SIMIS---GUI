package model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "FARBE")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Farbe {
  @Id
  @Column(name = "FARBENID")
  private Long farbenId;

  @Column(name = "HEXCODE")
  private String hexcode;

  @Column(name = "FARBEBEZEICHNUNG")
  private String farbeBezeichnung;

  @Column(name = "BESCHREIBUNG")
  private String beschreibung;
}

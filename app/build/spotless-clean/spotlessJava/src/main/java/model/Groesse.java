package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import lombok.*;

@Entity
@Table(name = "GROESSE")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Groesse {
  @Id
  @Column(name = "GROESSEID")
  private Long groesseId;

  @Column(name = "BREITE_CM")
  private BigDecimal breiteCm;

  @Column(name = "HOEHE_CM")
  private BigDecimal hoeheCm;

  @Column(name = "TIEFE_CM")
  private BigDecimal tiefeCm;

  @Column(name = "BESCHREIBUNG")
  private String beschreibung;
}

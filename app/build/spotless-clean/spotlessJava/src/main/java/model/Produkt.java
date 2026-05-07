package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import lombok.*;

@Entity
@Table(name = "PRODUKT")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Produkt {

  @Id
  @Column(name = "PRODUKTID")
  private Long produktId;

  @Column(name = "KATEGORIEID")
  private Long kategorieId;

  @Column(name = "RABATTID")
  private Long rabattId;

  @Column(name = "VERFUEGBAR")
  private String verfuegbar;

  @Column(name = "NAME")
  private String name;

  @Column(name = "BASIS_PREIS")
  private BigDecimal basisPreis;

  @Column(name = "BESCHREIBUNG")
  private String beschreibung;
}

package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
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
  @Column(name = "PRODUKT_ID")
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_prod")
  @SequenceGenerator(name = "seq_prod", sequenceName = "SEQ_PRODUKT", allocationSize = 1)
  private Long produktId;

  @Column(name = "NAME", nullable = false)
  private String name;

  @Column(name = "BESCHREIBUNG")
  private String beschreibung;

  @Column(name = "BASIS_PREIS", nullable = false)
  private BigDecimal basisPreis;

  @Column(name = "MATERIAL_ID")
  private Long materialId;

  @Column(name = "KATEGORIE")
  private String kategorie;

  @Column(name = "BILD_URL")
  private String bildUrl;

  @Column(name = "AKTIV")
  private boolean aktiv = true;

  @Column(name = "ERSTELLT_AM")
  private LocalDateTime erstelltAm;

  @OneToMany(fetch = FetchType.LAZY)
  @JoinColumn(name = "PRODUKT_ID")
  private List<ProduktVariante> varianten;
}

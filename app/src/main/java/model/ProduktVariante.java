package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import lombok.*;

@Entity
@Table(name = "PRODUKT_VARIANTE")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProduktVariante {

  @Id
  @Column(name = "VARIANTE_ID")
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_var")
  @SequenceGenerator(name = "seq_var", sequenceName = "SEQ_VARIANTE", allocationSize = 1)
  private Long varianteId;

  @Column(name = "PRODUKT_ID", nullable = false)
  private Long produktId;

  @Column(name = "GROESSE_ID")
  private Long groesseId;

  @Column(name = "FARBE")
  private String farbe;

  @Column(name = "SKU", nullable = false, unique = true)
  private String sku;

  @Column(name = "PREIS_AUFSCHLAG")
  private BigDecimal preisAufschlag = BigDecimal.ZERO;

  @Column(name = "AKTIV")
  private boolean aktiv = true;
}

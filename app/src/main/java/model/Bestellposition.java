package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import lombok.*;

@Entity
@Table(name = "BESTELLPOSITION")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Bestellposition {

  @Id
  @Column(name = "BESTELLPOSITIONID")
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_pos")
  @SequenceGenerator(name = "seq_pos", sequenceName = "SEQ_BESTELLPOS", allocationSize = 1)
  private Long positionId;

  @Column(name = "BESTELLUNGID", nullable = false)
  private Long bestellungId;

  @Column(name = "VARIANTEID", nullable = false)
  private Long varianteId;

  @Column(name = "MENGE", nullable = false)
  private int menge;

  @Column(name = "EINZELPREIS", nullable = false)
  private BigDecimal einzelpreis;
}

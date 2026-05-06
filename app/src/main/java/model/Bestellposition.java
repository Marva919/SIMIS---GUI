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
  @Column(name = "POSITION_ID")
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_pos")
  @SequenceGenerator(name = "seq_pos", sequenceName = "SEQ_BESTELLPOSITION", allocationSize = 1)
  private Long positionId;

  @Column(name = "BESTELLUNG_ID", nullable = false)
  private Long bestellungId;

  @Column(name = "VARIANTE_ID", nullable = false)
  private Long varianteId;

  @Column(name = "MENGE", nullable = false)
  private int menge;

  @Column(name = "EINZELPREIS", nullable = false)
  private BigDecimal einzelpreis;
}

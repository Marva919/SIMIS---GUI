package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import lombok.*;

@Entity
@Table(name = "VERKAUFPOSITION")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Verkaufposition {
  @Id
  @Column(name = "VERKAUFPOSITIONID")
  private Long verkaufPositionId;

  @Column(name = "VARIANTEID")
  private Long varianteId;

  @Column(name = "VERKAUFID")
  private Long verkaufId;

  @Column(name = "MENGE")
  private Integer menge;

  @Column(name = "EINZELPREIS")
  private BigDecimal einzelpreis;
}

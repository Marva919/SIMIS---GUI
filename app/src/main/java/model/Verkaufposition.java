package model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "VERKAUFPOSITION")
@Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
public class Verkaufposition {
    @Id @Column(name = "VERKAUFPOSITIONID") private Long verkaufPositionId;
    @Column(name = "VARIANTEID")            private Long varianteId;
    @Column(name = "VERKAUFID")             private Long verkaufId;
    @Column(name = "MENGE")                 private Integer menge;
    @Column(name = "EINZELPREIS")           private BigDecimal einzelpreis;
}
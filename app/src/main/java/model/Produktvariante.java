package model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "PRODUKTVARIANTE")
@Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
public class Produktvariante {

  @Id @Column(name = "VARIANTEID")     private Long varianteId;
  @Column(name = "FARBENID")           private Long farbenId;
  @Column(name = "MATERIALID")         private Long materialId;
  @Column(name = "PRODUKTID")          private Long produktId;
  @Column(name = "GROESSEID")          private Long groesseId;
  @Column(name = "PREISVARIANTE")      private BigDecimal preisVariante;
  @Column(name = "VERFUEGBAR")         private String verfuegbar;
}
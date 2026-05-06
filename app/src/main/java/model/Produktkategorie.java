package model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "PRODUKTKATEGORIE")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Produktkategorie {
    @Id @Column(name = "KATEGORIEID")       private Long kategorieId;
    @Column(name = "KATEGORIENAME")         private String kategorieName;
    @Column(name = "BESCHREIBUNG")          private String beschreibung;
}
package model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "BESTAND")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Bestand {
    @Id @Column(name = "BESTANDID")         private Long bestandId;
    @Column(name = "VARIANTEID")            private Long varianteId;
    @Column(name = "LAGERID")               private Long lagerId;
    @Column(name = "MENGE_VERFUEGBAR")      private Long mengeVerfuegbar;
}
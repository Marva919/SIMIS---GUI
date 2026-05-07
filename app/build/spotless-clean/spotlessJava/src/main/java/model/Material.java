package model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "MATERIAL")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Material {
  @Id
  @Column(name = "MATERIALID")
  private Long materialId;

  @Column(name = "BEZEICHNUNG")
  private String bezeichnung;

  @Column(name = "BESCHREIBUNG")
  private String beschreibung;
}

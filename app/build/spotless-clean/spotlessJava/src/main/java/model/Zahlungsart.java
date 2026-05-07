package model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ZAHLUNGSART")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Zahlungsart {
  @Id
  @Column(name = "ZAHLUNGSARTID")
  private Long zahlungsartId;

  @Column(name = "BEZEICHNUNG")
  private String bezeichnung;
}

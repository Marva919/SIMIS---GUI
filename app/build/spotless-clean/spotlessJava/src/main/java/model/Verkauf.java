package model;

import jakarta.persistence.*;
import java.util.Date;
import java.util.List;
import lombok.*;

@Entity
@Table(name = "VERKAUF")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Verkauf {
  @Id
  @Column(name = "VERKAUFID")
  private Long verkaufId;

  @Column(name = "KUNDEID")
  private Long kundeId;

  @Column(name = "FILIALEID")
  private Long filialeId;

  @Column(name = "ZAHLUNGSARTID")
  private Long zahlungsartId;

  @Column(name = "ANZAHL")
  private Integer anzahl;

  @Column(name = "ZAHLUNGSTATUS")
  private String zahlungStatus;

  @Column(name = "VERKAUFSDATUM")
  @Temporal(TemporalType.DATE)
  private Date verkaufsDatum;

  @OneToMany(fetch = FetchType.LAZY)
  @JoinColumn(name = "VERKAUFID")
  private List<Verkaufposition> positionen;
}

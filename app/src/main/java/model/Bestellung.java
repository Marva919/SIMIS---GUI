package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import lombok.*;

@Entity
@Table(name = "BESTELLUNG")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Bestellung {

  @Id
  @Column(name = "BESTELLUNG_ID")
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_bst")
  @SequenceGenerator(name = "seq_bst", sequenceName = "SEQ_BESTELLUNG", allocationSize = 1)
  private Long bestellungId;

  @Column(name = "KUNDE_ID", nullable = false)
  private Long kundeId;

  @Column(name = "ANGESTELLTER_ID", nullable = false)
  private Long angestellterId;

  @Column(name = "FILIALE_ID", nullable = false)
  private Long filialeId;

  @Column(name = "ERSTELLT_AM")
  private LocalDateTime erstelltAm;

  @Column(name = "STATUS", nullable = false)
  private String status;

  @Column(name = "GESAMT_BETRAG")
  private BigDecimal gesamtBetrag;

  @Column(name = "LIEFERADRESSE")
  private String lieferadresse;

  @Column(name = "NOTIZEN")
  private String notizen;

  @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
  @JoinColumn(name = "BESTELLUNG_ID")
  private List<Bestellposition> positionen;
}

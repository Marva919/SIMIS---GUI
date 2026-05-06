package repository;

import java.util.List;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

public interface BestellungRepository extends JpaRepository<model.Bestellung, Long> {

  List<model.Bestellung> findByKundeIdOrderByErstelltAmDesc(Long kundeId);

  @Query("SELECT b FROM Bestellung b WHERE b.angestellterId = :aid ORDER BY b.erstelltAm DESC")
  List<model.Bestellung> findByAngestellter(@Param("aid") Long angestellterId);
}

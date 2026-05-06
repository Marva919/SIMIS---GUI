package repository;

import model.Kunde;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface KundeRepository extends JpaRepository<Kunde, Long> {
  Optional<Kunde> findByEmailIgnoreCase(String email);

  @Query("SELECT k FROM Kunde k WHERE UPPER(k.nachname) LIKE UPPER(CONCAT('%',:n,'%')) " +
          "OR UPPER(k.vorname) LIKE UPPER(CONCAT('%',:n,'%'))")
  List<Kunde> sucheNachName(@Param("n") String name);
}
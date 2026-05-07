package repository;

import java.util.List;
import model.Produkt;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

public interface ProduktRepository extends JpaRepository<Produkt, Long> {

  @Query(
      "SELECT p FROM Produkt p WHERE p.verfuegbar = 'Y' "
          + "AND (:kat IS NULL OR p.kategorieId = :kat) "
          + "AND (:s IS NULL OR UPPER(p.name) LIKE UPPER(CONCAT('%',:s,'%')))")
  List<Produkt> findByFilter(@Param("s") String suche, @Param("kat") Long kategorieId);
}

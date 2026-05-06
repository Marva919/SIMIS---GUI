package repository;

import java.util.List;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

public interface ProduktRepository extends JpaRepository<model.Produkt, Long> {

  @Query(
      "SELECT p FROM Produkt p WHERE p.aktiv = true "
          + "AND (:kategorie IS NULL OR p.kategorie = :kategorie) "
          + "AND (:suche IS NULL OR UPPER(p.name) LIKE UPPER(CONCAT('%',:suche,'%')))")
  List<model.Produkt> findByFilter(
      @Param("suche") String suche, @Param("kategorie") String kategorie);

  @Query(
      "SELECT DISTINCT p.kategorie FROM Produkt p WHERE p.aktiv = true AND p.kategorie IS NOT NULL")
  List<String> findAlleKategorien();
}

package repository;

import java.util.List;
import model.Verkauf;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VerkaufRepository extends JpaRepository<Verkauf, Long> {
  List<Verkauf> findByKundeIdOrderByVerkaufsDatumDesc(Long kundeId);

  List<Verkauf> findByFilialeIdOrderByVerkaufsDatumDesc(Long filialeId);
}

package repository;

import model.Verkauf;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VerkaufRepository extends JpaRepository<Verkauf, Long> {
    List<Verkauf> findByKundeIdOrderByVerkaufsDatumDesc(Long kundeId);
    List<Verkauf> findByFilialeIdOrderByVerkaufsDatumDesc(Long filialeId);
}
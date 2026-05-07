package repository;

import java.util.List;
import model.Produktvariante;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProduktvarianteRepository extends JpaRepository<Produktvariante, Long> {
  List<Produktvariante> findByProduktIdAndVerfuegbar(Long produktId, String verfuegbar);
}

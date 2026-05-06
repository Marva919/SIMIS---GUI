package repository;

import model.Produktvariante;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProduktvarianteRepository extends JpaRepository<Produktvariante, Long> {
    List<Produktvariante> findByProduktIdAndVerfuegbar(Long produktId, String verfuegbar);
}
package repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AngestellterRepository extends JpaRepository<model.Angestellter, Long> {
  Optional<model.Angestellter> findByEmail(String email);
}

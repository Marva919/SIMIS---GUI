package repository;

import java.util.Optional;
import model.Angestellter;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AngestellterRepository extends JpaRepository<Angestellter, Long> {
  Optional<Angestellter> findByEmail(String email);
}

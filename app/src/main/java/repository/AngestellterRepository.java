package repository;

import model.Angestellter;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface AngestellterRepository extends JpaRepository<Angestellter, Long> {
  Optional<Angestellter> findByEmail(String email);
}
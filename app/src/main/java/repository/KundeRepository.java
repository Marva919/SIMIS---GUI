package repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface KundeRepository extends JpaRepository<model.Kunde, Long> {
  Optional<model.Kunde> findByEmailIgnoreCase(String email);

  List<model.Kunde> findByNachnameContainingIgnoreCaseOrVornameContainingIgnoreCase(
      String nachname, String vorname);
}

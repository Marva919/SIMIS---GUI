package repository;

import model.Zahlungsart;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ZahlungsartRepository extends JpaRepository<Zahlungsart, Long> {}
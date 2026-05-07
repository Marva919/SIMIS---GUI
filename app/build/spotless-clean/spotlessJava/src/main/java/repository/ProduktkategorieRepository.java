package repository;

import model.Produktkategorie;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProduktkategorieRepository extends JpaRepository<Produktkategorie, Long> {}

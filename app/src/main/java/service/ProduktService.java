package service;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import model.Produkt;
import org.springframework.stereotype.Service;
import repository.ProduktRepository;

@Service
@RequiredArgsConstructor
public class ProduktService {

  private final ProduktRepository repo;
  private final StoredProcedureService spService;

  public List<Map<String, Object>> suchen(
      String suchbegriff, String kategorie, Double minPreis, Double maxPreis, Long lagerId) {
    // Über Stored Procedure mit Lagerbestand
    return spService.produkteSuchen(suchbegriff, kategorie, minPreis, maxPreis, lagerId);
  }

  public List<String> alleKategorien() {
    return repo.findAlleKategorien();
  }

  public Optional<Produkt> findById(Long id) {
    return repo.findById(id);
  }
}

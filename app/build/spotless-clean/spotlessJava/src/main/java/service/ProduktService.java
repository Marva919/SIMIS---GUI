package service;

import java.util.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import repository.ProduktkategorieRepository;

@Service
@RequiredArgsConstructor
public class ProduktService {

  private final StoredProcedureService spService;
  private final ProduktkategorieRepository katRepo;

  public List<Map<String, Object>> suchen(
      String suchbegriff, Long kategorieId, Double minPreis, Double maxPreis, Long lagerId) {
    return spService.produkteSuchen(suchbegriff, kategorieId, minPreis, maxPreis, lagerId);
  }

  public List<Map<String, Object>> alleKategorien() {
    return katRepo.findAll().stream()
        .map(
            k ->
                Map.<String, Object>of(
                    "kategorieId", k.getKategorieId(),
                    "kategorieName", k.getKategorieName()))
        .toList();
  }
}

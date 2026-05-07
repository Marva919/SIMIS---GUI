package service;

import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import model.Kunde;
import org.springframework.stereotype.Service;
import repository.KundeRepository;

@Service
@RequiredArgsConstructor
public class KundeService {

  private final KundeRepository repo;
  private final StoredProcedureService spService;

  public StoredProcedureService.KundeErgebnis anlegenOderFinden(Kunde k) {
    return spService.kundeAnlegenOderFinden(
        k.getVorname(),
        k.getNachname(),
        k.getEmail(),
        k.getTelefonnummer(),
        k.getAdresse(),
        k.getPlz(),
        k.getOrt(),
        k.getLand());
  }

  public Optional<Kunde> findById(Long id) {
    return repo.findById(id);
  }

  public List<Kunde> suchen(String n) {
    return repo.sucheNachName(n);
  }

  public List<Kunde> alle() {
    return repo.findAll();
  }
}

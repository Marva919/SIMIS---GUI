package service;

import model.Verkauf;
import repository.VerkaufRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VerkaufService {

    private final VerkaufRepository      repo;
    private final StoredProcedureService spService;

    public StoredProcedureService.VerkaufErgebnis verkaufErstellen(VerkaufAnfrage anfrage,
                                                                   Long filialeId, Long lagerId) {
        String csv = anfrage.positionen().stream()
                .map(p -> p.varianteId() + ":" + p.menge())
                .collect(Collectors.joining(","));

        return spService.verkaufErstellen(
                anfrage.kundeId(), filialeId,
                anfrage.zahlungsartId(), lagerId, csv
        );
    }

    public boolean stornieren(Long verkaufId, Long lagerId) {
        return spService.verkaufStornieren(verkaufId, lagerId);
    }

    public List<Verkauf> nachKunde(Long kundeId) {
        return repo.findByKundeIdOrderByVerkaufsDatumDesc(kundeId);
    }

    public List<Verkauf> nachFiliale(Long filialeId) {
        return repo.findByFilialeIdOrderByVerkaufsDatumDesc(filialeId);
    }

    public record VerkaufAnfrage(
            Long   kundeId,
            Long   zahlungsartId,
            List<PositionAnfrage> positionen
    ) {}

    public record PositionAnfrage(Long varianteId, int menge) {}
}
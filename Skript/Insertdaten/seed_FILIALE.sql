-- Seed-Daten - Tabelle FILIALE (ASCII only)
-- WICHTIG: FILIALE.LAGERID hat einen FK auf LAGER(LAGERID).
-- Diese Inserts erwarten, dass es LAGERID 1..5 bereits gibt.
SET DEFINE OFF;

INSERT INTO FILIALE (FILIALEID, LAGERID, NAME, ADRESSE, PLZ, ORT, TELEFON) VALUES (1, 1, 'Simis Berlin Mitte', 'Friedrichstrasse 88', '10117', 'Berlin', '+493012345670');
INSERT INTO FILIALE (FILIALEID, LAGERID, NAME, ADRESSE, PLZ, ORT, TELEFON) VALUES (2, 2, 'Simis Hamburg Alster', 'Jungfernstieg 24', '20354', 'Hamburg', '+494012345671');
INSERT INTO FILIALE (FILIALEID, LAGERID, NAME, ADRESSE, PLZ, ORT, TELEFON) VALUES (3, 3, 'Simis Muenchen Maximilian', 'Maximilianstrasse 12', '80539', 'Muenchen', '+498912345672');
INSERT INTO FILIALE (FILIALEID, LAGERID, NAME, ADRESSE, PLZ, ORT, TELEFON) VALUES (4, 4, 'Simis Frankfurt Oper', 'Opernplatz 6', '60313', 'Frankfurt am Main', '+496912345673');
INSERT INTO FILIALE (FILIALEID, LAGERID, NAME, ADRESSE, PLZ, ORT, TELEFON) VALUES (5, 5, 'Simis Duesseldorf Koenigsallee', 'Koenigsallee 42', '40212', 'Duesseldorf', '+492112345674');
COMMIT;

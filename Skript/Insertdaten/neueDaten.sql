/* ============================================================
   STAMMDATEN
============================================================ */

INSERT INTO ZAHLUNGSART VALUES (1, 'Bar');
INSERT INTO ZAHLUNGSART VALUES (2, 'EC-Karte');
INSERT INTO ZAHLUNGSART VALUES (3, 'Kreditkarte');
INSERT INTO ZAHLUNGSART VALUES (4, 'PayPal');

INSERT INTO RABATT VALUES (1, 10, DATE '2026-01-01', DATE '2026-03-31', 'Frühlingsrabatt');
INSERT INTO RABATT VALUES (2, 15, DATE '2026-06-01', DATE '2026-08-31', 'Sommeraktion');
INSERT INTO RABATT VALUES (3, 20, DATE '2026-11-01', DATE '2026-12-31', 'Winter Sale');

INSERT INTO PRODUKTKATEGORIE VALUES (1, 'Sofas', 'Wohnzimmer Sofas');
INSERT INTO PRODUKTKATEGORIE VALUES (2, 'Tische', 'Esstische und Couchtische');
INSERT INTO PRODUKTKATEGORIE VALUES (3, 'Stühle', 'Esszimmer- und Bürostühle');
INSERT INTO PRODUKTKATEGORIE VALUES (4, 'Betten', 'Schlafzimmerbetten');
INSERT INTO PRODUKTKATEGORIE VALUES (5, 'Schränke', 'Kleiderschränke und Regale');
INSERT INTO PRODUKTKATEGORIE VALUES (6, 'Lampen', 'Steh- und Tischlampen');

INSERT INTO MATERIAL VALUES (1, 'Eiche', 'Massives Eichenholz');
INSERT INTO MATERIAL VALUES (2, 'Kiefer', 'Hochwertiges Kiefernholz');
INSERT INTO MATERIAL VALUES (3, 'Metall', 'Pulverbeschichtetes Metall');
INSERT INTO MATERIAL VALUES (4, 'Leder', 'Echtes Rindsleder');
INSERT INTO MATERIAL VALUES (5, 'Stoff', 'Weicher Möbelstoff');
INSERT INTO MATERIAL VALUES (6, 'Glas', 'Sicherheitsglas');
INSERT INTO MATERIAL VALUES (7, 'Velours', 'Premium Veloursstoff');
INSERT INTO MATERIAL VALUES (8, 'Kunstleder', 'Pflegeleichtes Kunstleder');

INSERT INTO FARBE VALUES (1, 'FFFFFF', 'Weiß matt', 'Weiß');
INSERT INTO FARBE VALUES (2, '000000', 'Schwarz matt', 'Schwarz');
INSERT INTO FARBE VALUES (3, '8B4513', 'Braun Holz', 'Braun');
INSERT INTO FARBE VALUES (4, '808080', 'Modernes Grau', 'Grau');
INSERT INTO FARBE VALUES (5, 'D2B48C', 'Helles Holz', 'Beige');
INSERT INTO FARBE VALUES (6, '1E3A5F', 'Dunkelblau', 'Blau');
INSERT INTO FARBE VALUES (7, '556B2F', 'Olivgrün', 'Grün');
INSERT INTO FARBE VALUES (8, 'B22222', 'Dunkelrot', 'Rot');

INSERT INTO GROESSE VALUES (1, 200, 90, 85, '2-Sitzer Sofa');
INSERT INTO GROESSE VALUES (2, 260, 90, 85, '3-Sitzer Sofa');
INSERT INTO GROESSE VALUES (3, 120, 75, 80, 'Kleiner Tisch');
INSERT INTO GROESSE VALUES (4, 180, 75, 90, 'Großer Esstisch');
INSERT INTO GROESSE VALUES (5, 45, 95, 45, 'Esszimmerstuhl');
INSERT INTO GROESSE VALUES (6, 180, 60, 200, 'Kleiderschrank');
INSERT INTO GROESSE VALUES (7, 160, 50, 210, 'Regal');
INSERT INTO GROESSE VALUES (8, 180, 120, 200, 'Doppelbett');
INSERT INTO GROESSE VALUES (9, 90, 45, 90, 'Couchtisch');
INSERT INTO GROESSE VALUES (10, 30, 170, 30, 'Stehlampe');

/* ============================================================
   LAGER & FILIALEN
============================================================ */

INSERT INTO LAGER VALUES (1, NULL, 500, 'Hauptlager');
INSERT INTO LAGER VALUES (2, NULL, 250, 'Filiallager');
INSERT INTO LAGER VALUES (3, NULL, 180, 'Filiallager');

INSERT INTO FILIALE VALUES (1, 1, 'Möbelwelt Bielefeld', 'Bahnhofstraße 10', '33602', 'Bielefeld', '0521123456');
INSERT INTO FILIALE VALUES (2, 2, 'Möbelwelt Herford', 'Mindener Straße 22', '32049', 'Herford', '0522111122');
INSERT INTO FILIALE VALUES (3, 3, 'Möbelwelt Gütersloh', 'Kaiserstraße 15', '33330', 'Gütersloh', '0524112345');

INSERT INTO OEFFNUNGSZEITEN VALUES (1, 1, 1, TO_DATE('08:00','HH24:MI'), TO_DATE('18:00','HH24:MI'));
INSERT INTO OEFFNUNGSZEITEN VALUES (2, 1, 2, TO_DATE('08:00','HH24:MI'), TO_DATE('18:00','HH24:MI'));
INSERT INTO OEFFNUNGSZEITEN VALUES (3, 1, 3, TO_DATE('08:00','HH24:MI'), TO_DATE('18:00','HH24:MI'));
INSERT INTO OEFFNUNGSZEITEN VALUES (4, 1, 4, TO_DATE('08:00','HH24:MI'), TO_DATE('18:00','HH24:MI'));
INSERT INTO OEFFNUNGSZEITEN VALUES (5, 1, 5, TO_DATE('08:00','HH24:MI'), TO_DATE('20:00','HH24:MI'));
INSERT INTO OEFFNUNGSZEITEN VALUES (6, 1, 6, TO_DATE('09:00','HH24:MI'), TO_DATE('16:00','HH24:MI'));

/* ============================================================
   MITARBEITER
============================================================ */

INSERT INTO ANGESTELLTER VALUES (1, 1, NULL, 1, 'Anna', 'Schmidt', 'Filialleiterin', 'anna.schmidt@moebelwelt.de', 'admin123', '0151111111');
INSERT INTO ANGESTELLTER VALUES (2, 1, 1, 1, 'Lukas', 'Meyer', 'Verkäufer', 'lukas.meyer@moebelwelt.de', 'admin123', '0151111112');
INSERT INTO ANGESTELLTER VALUES (3, 1, 1, 1, 'Sophie', 'Weber', 'Kassiererin', 'sophie.weber@moebelwelt.de', 'admin123', '0151111113');
INSERT INTO ANGESTELLTER VALUES (4, 2, NULL, 2, 'Jonas', 'Fischer', 'Filialleiter', 'jonas.fischer@moebelwelt.de', 'admin123', '0151111114');
INSERT INTO ANGESTELLTER VALUES (5, 2, 4, 2, 'Emma', 'Becker', 'Verkäuferin', 'emma.becker@moebelwelt.de', 'admin123', '0151111115');
INSERT INTO ANGESTELLTER VALUES (6, 2, 4, 2, 'Leon', 'Wagner', 'Lagerist', 'leon.wagner@moebelwelt.de', 'admin123', '0151111116');
INSERT INTO ANGESTELLTER VALUES (7, 3, NULL, 3, 'Mia', 'Hoffmann', 'Filialleiterin', 'mia.hoffmann@moebelwelt.de', 'admin123', '0151111117');
INSERT INTO ANGESTELLTER VALUES (8, 3, 7, 3, 'Paul', 'Koch', 'Verkäufer', 'paul.koch@moebelwelt.de', 'admin123', '0151111118');
INSERT INTO ANGESTELLTER VALUES (9, 3, 7, 3, 'Clara', 'Richter', 'Dekorateurin', 'clara.richter@moebelwelt.de', 'admin123', '0151111119');
INSERT INTO ANGESTELLTER VALUES (10, 1, 1, 1, 'Noah', 'Klein', 'Lagerist', 'noah.klein@moebelwelt.de', 'admin123', '0151111120');

/* ============================================================
   KUNDEN
============================================================ */

INSERT INTO KUNDE VALUES (1, 'Max', 'Mustermann', 'max@mail.de', 'Musterweg 1', '33602', 'Bielefeld', 'Deutschland', '017111111');
INSERT INTO KUNDE VALUES (2, 'Laura', 'Neumann', 'laura@mail.de', 'Ringstraße 12', '32049', 'Herford', 'Deutschland', '017122222');
INSERT INTO KUNDE VALUES (3, 'Tim', 'Schulz', 'tim@mail.de', 'Gartenweg 4', '33330', 'Gütersloh', 'Deutschland', '017133333');
INSERT INTO KUNDE VALUES (4, 'Julia', 'Hartmann', 'julia@mail.de', 'Bergstraße 8', '33615', 'Bielefeld', 'Deutschland', '017144444');
INSERT INTO KUNDE VALUES (5, 'Felix', 'Zimmer', 'felix@mail.de', 'Parkallee 9', '33739', 'Bielefeld', 'Deutschland', '017155555');

/* ============================================================
   30 PRODUKTE
============================================================ */

INSERT INTO PRODUKT VALUES (1, 1, 1, 'Y', 'Nordic Sofa', 899.99, 'Modernes Sofa im skandinavischen Stil');
INSERT INTO PRODUKT VALUES (2, 1, NULL, 'Y', 'Comfort Lounge', 1199.99, 'Großes Familien Sofa');
INSERT INTO PRODUKT VALUES (3, 1, 2, 'Y', 'Urban Couch', 799.99, 'Kompakte Stadtcouch');
INSERT INTO PRODUKT VALUES (4, 1, NULL, 'Y', 'Velvet Dream', 1399.99, 'Luxus Velours Sofa');
INSERT INTO PRODUKT VALUES (5, 1, NULL, 'Y', 'Relax Corner', 1599.99, 'Ecksofa mit Ottomane');

INSERT INTO PRODUKT VALUES (6, 2, NULL, 'Y', 'Oak Dining', 699.99, 'Massiver Esstisch aus Eiche');
INSERT INTO PRODUKT VALUES (7, 2, 1, 'Y', 'Glass Table', 499.99, 'Moderner Glastisch');
INSERT INTO PRODUKT VALUES (8, 2, NULL, 'Y', 'Coffee Cube', 249.99, 'Kleiner Couchtisch');
INSERT INTO PRODUKT VALUES (9, 2, NULL, 'Y', 'Industrial Desk', 599.99, 'Schreibtisch im Industrial Stil');
INSERT INTO PRODUKT VALUES (10, 2, 2, 'Y', 'Family Table XL', 999.99, 'Großer Familientisch');

INSERT INTO PRODUKT VALUES (11, 3, NULL, 'Y', 'Dining Chair Soft', 149.99, 'Polsterstuhl');
INSERT INTO PRODUKT VALUES (12, 3, NULL, 'Y', 'Office Comfort', 249.99, 'Ergonomischer Bürostuhl');
INSERT INTO PRODUKT VALUES (13, 3, NULL, 'Y', 'Wood Chair', 129.99, 'Holzstuhl klassisch');
INSERT INTO PRODUKT VALUES (14, 3, 1, 'Y', 'Bar Stool', 179.99, 'Moderner Barhocker');
INSERT INTO PRODUKT VALUES (15, 3, NULL, 'Y', 'Lounge Chair', 349.99, 'Designer Sessel');

INSERT INTO PRODUKT VALUES (16, 4, 3, 'Y', 'Sleep Comfort', 1199.99, 'Boxspringbett');
INSERT INTO PRODUKT VALUES (17, 4, NULL, 'Y', 'Wood Dream', 899.99, 'Massivholzbett');
INSERT INTO PRODUKT VALUES (18, 4, NULL, 'Y', 'Modern Bed', 999.99, 'Modernes Doppelbett');
INSERT INTO PRODUKT VALUES (19, 4, 2, 'Y', 'Kids Bed', 499.99, 'Kinderbett');
INSERT INTO PRODUKT VALUES (20, 4, NULL, 'Y', 'Luxury Sleep', 1899.99, 'Premium Bett');

INSERT INTO PRODUKT VALUES (21, 5, NULL, 'Y', 'Classic Wardrobe', 999.99, 'Großer Kleiderschrank');
INSERT INTO PRODUKT VALUES (22, 5, NULL, 'Y', 'Open Shelf', 299.99, 'Modernes Regal');
INSERT INTO PRODUKT VALUES (23, 5, 1, 'Y', 'TV Cabinet', 449.99, 'TV Schrank');
INSERT INTO PRODUKT VALUES (24, 5, NULL, 'Y', 'Office Shelf', 399.99, 'Büroregal');
INSERT INTO PRODUKT VALUES (25, 5, NULL, 'Y', 'Sliding Closet', 1499.99, 'Schwebetürenschrank');

INSERT INTO PRODUKT VALUES (26, 6, NULL, 'Y', 'Floor Light', 149.99, 'Stehlampe');
INSERT INTO PRODUKT VALUES (27, 6, NULL, 'Y', 'Desk Light', 89.99, 'Tischlampe');
INSERT INTO PRODUKT VALUES (28, 6, 2, 'Y', 'Reading Lamp', 119.99, 'Leselampe');
INSERT INTO PRODUKT VALUES (29, 6, NULL, 'Y', 'LED Modern', 199.99, 'LED Designerlampe');
INSERT INTO PRODUKT VALUES (30, 6, NULL, 'Y', 'Wood Light', 159.99, 'Holzlampe');

/* ============================================================
   PRODUKTVARIANTEN (Beispielhaft 4 Varianten je Produkt)
============================================================ */

INSERT INTO PRODUKTVARIANTE VALUES (1, 4, 5, 1, 1, 899.99, 'Y');
INSERT INTO PRODUKTVARIANTE VALUES (2, 2, 4, 1, 2, 999.99, 'Y');
INSERT INTO PRODUKTVARIANTE VALUES (3, 5, 5, 1, 1, 879.99, 'Y');
INSERT INTO PRODUKTVARIANTE VALUES (4, 6, 7, 1, 2, 1099.99, 'Y');

INSERT INTO PRODUKTVARIANTE VALUES (5, 3, 1, 6, 3, 699.99, 'Y');
INSERT INTO PRODUKTVARIANTE VALUES (6, 2, 3, 6, 4, 749.99, 'Y');
INSERT INTO PRODUKTVARIANTE VALUES (7, 1, 1, 6, 4, 729.99, 'Y');
INSERT INTO PRODUKTVARIANTE VALUES (8, 5, 2, 6, 3, 679.99, 'Y');

INSERT INTO PRODUKTVARIANTE VALUES (9, 4, 5, 11, 5, 149.99, 'Y');
INSERT INTO PRODUKTVARIANTE VALUES (10, 2, 8, 11, 5, 159.99, 'Y');
INSERT INTO PRODUKTVARIANTE VALUES (11, 6, 5, 11, 5, 154.99, 'Y');
INSERT INTO PRODUKTVARIANTE VALUES (12, 7, 5, 11, 5, 149.99, 'Y');


/* ============================================================
   BESTAND
============================================================ */

INSERT INTO BESTAND VALUES (1, 1, 1, 15);
INSERT INTO BESTAND VALUES (2, 2, 1, 10);
INSERT INTO BESTAND VALUES (3, 3, 2, 8);
INSERT INTO BESTAND VALUES (4, 4, 3, 6);
INSERT INTO BESTAND VALUES (5, 5, 1, 20);
INSERT INTO BESTAND VALUES (6, 6, 2, 12);
INSERT INTO BESTAND VALUES (7, 7, 3, 5);
INSERT INTO BESTAND VALUES (8, 8, 1, 11);
INSERT INTO BESTAND VALUES (9, 9, 2, 18);
INSERT INTO BESTAND VALUES (10, 10, 3, 7);

/* ============================================================
   BESTELLUNGEN
============================================================ */

INSERT INTO BESTELLUNG VALUES (1, 1, DATE '2026-01-15', 10, 'Y');
INSERT INTO BESTELLUNG VALUES (2, 2, DATE '2026-02-10', 5, 'Y');
INSERT INTO BESTELLUNG VALUES (3, 3, DATE '2026-03-05', 8, 'N');

INSERT INTO BESTELLPOSITION VALUES (1, 1, 1, 2, 899.99);
INSERT INTO BESTELLPOSITION VALUES (2, 1, 5, 1, 699.99);
INSERT INTO BESTELLPOSITION VALUES (3, 2, 9, 4, 149.99);
INSERT INTO BESTELLPOSITION VALUES (4, 3, 2, 2, 999.99);

/* ============================================================
   LIEFERANTEN
============================================================ */

INSERT INTO LIEFERANT VALUES (1, 'HolzDesign GmbH', 'kontakt@holzdesign.de', 'Industriestr. 1', '10115', 'Berlin', '030111111', 'Peter Hansen');
INSERT INTO LIEFERANT VALUES (2, 'MetalWorks AG', 'service@metalworks.de', 'Werkstr. 5', '20095', 'Hamburg', '040222222', 'Sabine Keller');
INSERT INTO LIEFERANT VALUES (3, 'Comfort Fabrics', 'info@comfortfabrics.de', 'Textilweg 9', '50667', 'Köln', '022133333', 'Julia Frank');

INSERT INTO LIEFERANT_PRODUKT VALUES (1, 1);
INSERT INTO LIEFERANT_PRODUKT VALUES (1, 6);
INSERT INTO LIEFERANT_PRODUKT VALUES (2, 7);
INSERT INTO LIEFERANT_PRODUKT VALUES (2, 9);
INSERT INTO LIEFERANT_PRODUKT VALUES (3, 4);
INSERT INTO LIEFERANT_PRODUKT VALUES (3, 11);

/* ============================================================
   VERKÄUFE
============================================================ */

INSERT INTO VERKAUF VALUES (1, 1, 1, 2, 2, 'Y', DATE '2026-01-10');
INSERT INTO VERKAUF VALUES (2, 2, 2, 3, 1, 'Y', DATE '2026-01-18');
INSERT INTO VERKAUF VALUES (3, 3, 3, 1, 3, 'N', DATE '2026-02-02');

INSERT INTO VERKAUFPOSITION VALUES (1, 1, 1, 1, 899.99);
INSERT INTO VERKAUFPOSITION VALUES (2, 5, 1, 1, 699.99);
INSERT INTO VERKAUFPOSITION VALUES (3, 9, 2, 1, 149.99);
INSERT INTO VERKAUFPOSITION VALUES (4, 2, 3, 2, 999.99);

/* ============================================================
   RÜCKGABEN
============================================================ */

INSERT INTO RUECKGABE VALUES (1, 1, 1, 1, DATE '2026-01-20', 'Kleine Beschädigung', 899.99);
INSERT INTO RUECKGABE VALUES (2, 2, 2, 2, DATE '2026-01-28', 'Falsche Farbe geliefert', 149.99);

/* ============================================================
   BEWERTUNGEN
============================================================ */

INSERT INTO BEWERTUNG VALUES (1, 1, 1, DATE '2026-01-15', 5, 'Sehr bequemes Sofa');
INSERT INTO BEWERTUNG VALUES (2, 6, 2, DATE '2026-01-18', 4, 'Schöner Tisch, gute Qualität');
INSERT INTO BEWERTUNG VALUES (3, 11, 3, DATE '2026-02-10', 5, 'Sehr komfortabler Stuhl');
INSERT INTO BEWERTUNG VALUES (4, 16, 4, DATE '2026-02-12', 4, 'Tolles Bett');

/* ============================================================
   PREISHISTORIE
============================================================ */

INSERT INTO PREIS_HISTORIE VALUES (1, 1, 949.99, 899.99, DATE '2026-01-01');
INSERT INTO PREIS_HISTORIE VALUES (2, 6, 749.99, 699.99, DATE '2026-01-01');
INSERT INTO PREIS_HISTORIE VALUES (3, 16, 1299.99, 1199.99, DATE '2026-02-01');

/* ============================================================
   LAGERBEWEGUNGEN
============================================================ */

INSERT INTO LAGERBEWEGUNG VALUES (1, 1, 2, DATE '2026-01-05', 'T', 2);
INSERT INTO LAGERBEWEGUNG VALUES (2, 3, 4, DATE '2026-01-12', 'K', 1);
INSERT INTO LAGERBEWEGUNG VALUES (3, 5, 6, DATE '2026-01-20', 'I', 5);

COMMIT;

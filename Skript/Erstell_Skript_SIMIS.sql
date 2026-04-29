/*==============================================================*/
/* DBMS name:      ORACLE Version 19c                           */
/* Created on:     05.02.2026 15:58:39                          */
/*==============================================================*/


alter table ANGESTELLTER
   drop constraint FK_ANGESTEL_ANGESTELL_ANGESTEL;

alter table ANGESTELLTER
   drop constraint FK_ANGESTEL_LAGER_MIT_LAGER;

alter table ANGESTELLTER
   drop constraint FK_ANGESTEL_RELATIONS_FILIALE;

alter table BESTAND
   drop constraint FK_BESTAND_BESTAND_L_LAGER;

alter table BESTAND
   drop constraint FK_BESTAND_BESTAND_P_PRODUKTV;

alter table BESTELLPOSITION
   drop constraint FK_BESTELLP_BESTELLUN_BESTELLU;

alter table BESTELLPOSITION
   drop constraint FK_BESTELLP_PRODUKTVA_PRODUKTV;

alter table BESTELLUNG
   drop constraint FK_BESTELLU_FILIALE_B_FILIALE;

alter table BEWERTUNG
   drop constraint FK_BEWERTUN_BEWERUNG__PRODUKT;

alter table BEWERTUNG
   drop constraint FK_BEWERTUN_KUNDE_BEW_KUNDE;

alter table FILIALE
   drop constraint "FK_FILIALE_GEHOERT Z_LAGER";

alter table LAGER
   drop constraint FK_LAGER_BESTELLUN_BESTELLU;

alter table LAGERBEWEGUNG
   drop constraint FK_LAGERBEW_BESTAND_Q_BESTAND;

alter table LAGERBEWEGUNG
   drop constraint FK_LAGERBEW_BESTAND_Z_BESTAND;

alter table LAGER_PRODUKT
   drop constraint "FK_LAGER_PR_BEFINDET _LAGER";

alter table LAGER_PRODUKT
   drop constraint FK_LAGER_PR_BEINHALTE_PRODUKT;

alter table LIEFERANT_PRODUKT
   drop constraint FK_LIEFERAN_LIEFERT_LIEFERAN;

alter table LIEFERANT_PRODUKT
   drop constraint "FK_LIEFERAN_WIRD GELI_PRODUKT";

alter table OEFFNUNGSZEITEN
   drop constraint FK_OEFFNUNG_FILIALE_O_FILIALE;

alter table PREIS_HISTORIE
   drop constraint FK_PREIS_HI_PRODUKT_P_PRODUKT;

alter table PRODUKT
   drop constraint FK_PRODUKT_PRODUKTKA_PRODUKTK;

alter table PRODUKT
   drop constraint FK_PRODUKT_RABATT_PR_RABATT;

alter table PRODUKTVARIANTE
   drop constraint FK_PRODUKTV_FARBE_PRO_FARBE;

alter table PRODUKTVARIANTE
   drop constraint FK_PRODUKTV_GROESSE_P_GROESSE;

alter table PRODUKTVARIANTE
   drop constraint FK_PRODUKTV_MATERIAL__MATERIAL;

alter table PRODUKTVARIANTE
   drop constraint FK_PRODUKTV_PRODUKT_P_PRODUKT;

alter table RUECKGABE
   drop constraint FK_RUECKGAB_KUNDE_RUE_KUNDE;

alter table RUECKGABE
   drop constraint FK_RUECKGAB_LAGER_RUE_LAGER;

alter table RUECKGABE
   drop constraint FK_RUECKGAB_VERKAUF_R_VERKAUF;

alter table VERKAUF
   drop constraint FK_VERKAUF_FILIALE_V_FILIALE;

alter table VERKAUF
   drop constraint FK_VERKAUF_VERKAUF_K_KUNDE;

alter table VERKAUF
   drop constraint FK_VERKAUF_ZAHLUNGSA_ZAHLUNGS;

alter table VERKAUFPOSITION
   drop constraint FK_VERKAUFP_PRODUKTVA_PRODUKTV;

alter table VERKAUFPOSITION
   drop constraint FK_VERKAUFP_VERKAUFPO_VERKAUF;

drop index ANGESTELLTER_ANGESTELLTER_FK;

drop index LAGER_MITARBEITER_FK;

drop index RELATIONSHIP_10_FK;

drop table ANGESTELLTER cascade constraints;

drop index BESTAND_PRODUKTVARIANTE_FK;

drop index BESTAND_LAGER_FK;

drop table BESTAND cascade constraints;

drop index PVARIANTE_BESTELLPOSITION_FK;

drop index BESTELLUNG_BESTELLPOSITION_FK;

drop table BESTELLPOSITION cascade constraints;

drop index FILIALE_BESTELLUNG_FK;

drop table BESTELLUNG cascade constraints;

drop index BEWERUNG_PRODUKT_FK;

drop index KUNDE_BEWERTUNG_FK;

drop table BEWERTUNG cascade constraints;

drop table FARBE cascade constraints;

drop index GEHOERT_ZU_FILIALE_FK;

drop table FILIALE cascade constraints;

drop table GROESSE cascade constraints;

drop table KUNDE cascade constraints;

drop index BESTELLUNG_LAGER_FK;

drop table LAGER cascade constraints;

drop index B_QUELLE_LBEWEGUNG_FK;

drop index BESTAND_ZIEL_LAGERBEWEGUNG_FK;

drop table LAGERBEWEGUNG cascade constraints;

drop index BEINHALTET_FK;

drop index BEFINDET_SICH_FK;

drop table LAGER_PRODUKT cascade constraints;

drop table LIEFERANT cascade constraints;

drop index WIRD_GELIEFERT_VON_FK;

drop index LIEFERT_FK;

drop table LIEFERANT_PRODUKT cascade constraints;

drop table MATERIAL cascade constraints;

drop index FILIALE_OEFFNNUNGSZEITEN_FK;

drop table OEFFNUNGSZEITEN cascade constraints;

drop index PRODUKT_PREIS_HISTORIE_FK;

drop table PREIS_HISTORIE cascade constraints;

drop index RABATT_PRODUKT_FK;

drop index PRODUKTKATGORIE_PRODUKT_FK;

drop table PRODUKT cascade constraints;

drop table PRODUKTKATEGORIE cascade constraints;

drop index PRODUKT_PRODUKTVARIANTE_FK;

drop index MATERIAL_PRODUKTVARIANTE_FK;

drop index FARBE_PRODUKTVARIANTE_FK;

drop index GROESSE_PRODUKTVARIANTE_FK;

drop table PRODUKTVARIANTE cascade constraints;

drop table RABATT cascade constraints;

drop index VERKAUF_RUECKGABE_FK;

drop index LAGER_RUECKGABE_FK;

drop index KUNDE_RUECKGABE_FK;

drop table RUECKGABE cascade constraints;

drop index FILIALE_VERKAUF_FK;

drop index ZAHLUNGSART_VERKAUF_FK;

drop index VERKAUF_KUNDE_FK;

drop table VERKAUF cascade constraints;

drop index PVARIANTE_VERKAUFPOSION_FK;

drop index VERKAUFPOSITION_VERKAUF_FK;

drop table VERKAUFPOSITION cascade constraints;

drop table ZAHLUNGSART cascade constraints;

/*==============================================================*/
/* Table: ANGESTELLTER                                          */
/*==============================================================*/
create table ANGESTELLTER (
   ANGESTELLTERID       NUMBER(20,0)          not null,
   FILIALEID            NUMBER(20,0),
   ANG_ANGESTELLTERID   NUMBER(20,0),
   LAGERID              NUMBER(20,0),
   VORNAME              VARCHAR2(50)          not null,
   NACHNAME             VARCHAR2(50)          not null,
   ROLLE                VARCHAR2(50)          not null,
   EMAIL                VARCHAR2(50)          not null,
   TELEFON              VARCHAR2(50),
   constraint PK_ANGESTELLTER primary key (ANGESTELLTERID)
);

/*==============================================================*/
/* Index: RELATIONSHIP_10_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_10_FK on ANGESTELLTER (
   FILIALEID ASC
);

/*==============================================================*/
/* Index: LAGER_MITARBEITER_FK                                  */
/*==============================================================*/
create index LAGER_MITARBEITER_FK on ANGESTELLTER (
   LAGERID ASC
);

/*==============================================================*/
/* Index: ANGESTELLTER_ANGESTELLTER_FK                          */
/*==============================================================*/
create index ANGESTELLTER_ANGESTELLTER_FK on ANGESTELLTER (
   ANG_ANGESTELLTERID ASC
);

/*==============================================================*/
/* Table: BESTAND                                               */
/*==============================================================*/
create table BESTAND (
   BESTANDID            NUMBER(20,0)          not null,
   VARIANTEID           NUMBER(20,0)          not null,
   LAGERID              NUMBER(20,0)          not null,
   MENGE_VERFUEGBAR     NUMBER(20,0)          not null,
   constraint PK_BESTAND primary key (BESTANDID)
);

/*==============================================================*/
/* Index: BESTAND_LAGER_FK                                      */
/*==============================================================*/
create index BESTAND_LAGER_FK on BESTAND (
   LAGERID ASC
);

/*==============================================================*/
/* Index: BESTAND_PRODUKTVARIANTE_FK                            */
/*==============================================================*/
create index BESTAND_PRODUKTVARIANTE_FK on BESTAND (
   VARIANTEID ASC
);

/*==============================================================*/
/* Table: BESTELLPOSITION                                       */
/*==============================================================*/
create table BESTELLPOSITION (
   BESTELLPOSITIONID    NUMBER(20,0)          not null,
   BESTELLUNGID         NUMBER(20,0)          not null,
   VARIANTEID           NUMBER(20,0)          not null,
   MENGE                NUMBER(20,0)          not null,
   EINZELPREIS          NUMBER(10,2)          not null,
   constraint PK_BESTELLPOSITION primary key (BESTELLPOSITIONID)
);

/*==============================================================*/
/* Index: BESTELLUNG_BESTELLPOSITION_FK                         */
/*==============================================================*/
create index BESTELLUNG_BESTELLPOSITION_FK on BESTELLPOSITION (
   BESTELLUNGID ASC
);

/*==============================================================*/
/* Index: PVARIANTE_BESTELLPOSITION_FK                          */
/*==============================================================*/
create index PVARIANTE_BESTELLPOSITION_FK on BESTELLPOSITION (
   VARIANTEID ASC
);

/*==============================================================*/
/* Table: BESTELLUNG                                            */
/*==============================================================*/
create table BESTELLUNG (
   BESTELLUNGID         NUMBER(20,0)          not null,
   FILIALEID            NUMBER(20,0),
   DATUM_BESTELLUNG     DATE,
   MENGE                NUMBER(20,0),
   STATUS               CHAR(1)              default 'N'
      constraint CKC_STATUS_BESTELLU check (STATUS is null or (STATUS in ('Y','N'))),
   constraint PK_BESTELLUNG primary key (BESTELLUNGID)
);

/*==============================================================*/
/* Index: FILIALE_BESTELLUNG_FK                                 */
/*==============================================================*/
create index FILIALE_BESTELLUNG_FK on BESTELLUNG (
   FILIALEID ASC
);

/*==============================================================*/
/* Table: BEWERTUNG                                             */
/*==============================================================*/
create table BEWERTUNG (
   BEWERTUNGSID         NUMBER(20,0)          not null,
   PRODUKTID            NUMBER(20,0)          not null,
   KUNDEID              NUMBER(20,0)          not null,
   DATUM                DATE                  not null,
   STERNE               NUMBER(1,0)           not null
      constraint CKC_STERNE_BEWERTUN check (STERNE between 1 and 5 and STERNE in (1,2,3,4,5)),
   KOMMENTAR            VARCHAR2(1000),
   constraint PK_BEWERTUNG primary key (BEWERTUNGSID)
);

/*==============================================================*/
/* Index: KUNDE_BEWERTUNG_FK                                    */
/*==============================================================*/
create index KUNDE_BEWERTUNG_FK on BEWERTUNG (
   KUNDEID ASC
);

/*==============================================================*/
/* Index: BEWERUNG_PRODUKT_FK                                   */
/*==============================================================*/
create index BEWERUNG_PRODUKT_FK on BEWERTUNG (
   PRODUKTID ASC
);

/*==============================================================*/
/* Table: FARBE                                                 */
/*==============================================================*/
create table FARBE (
   FARBENID             NUMBER(20,0)          not null,
   HEXCODE              CHAR(6)               not null,
   BESCHREIBUNG         VARCHAR2(1000),
   FARBEBEZEICHNUNG     VARCHAR2(100),
   constraint PK_FARBE primary key (FARBENID)
);

/*==============================================================*/
/* Table: FILIALE                                               */
/*==============================================================*/
create table FILIALE (
   FILIALEID            NUMBER(20,0)          not null,
   LAGERID              NUMBER(20,0)          not null,
   NAME                 VARCHAR2(50)          not null,
   ADRESSE              VARCHAR2(50)          not null,
   PLZ                  VARCHAR2(20)          not null,
   ORT                  VARCHAR2(50)          not null,
   TELEFON              VARCHAR2(20)          not null,
   constraint PK_FILIALE primary key (FILIALEID)
);

/*==============================================================*/
/* Index: GEHOERT_ZU_FILIALE_FK                                 */
/*==============================================================*/
create index GEHOERT_ZU_FILIALE_FK on FILIALE (
   LAGERID ASC
);

/*==============================================================*/
/* Table: GROESSE                                               */
/*==============================================================*/
create table GROESSE (
   GROESSEID            NUMBER(20,0)          not null,
   BREITE_CM            NUMBER(10,2)          not null,
   HOEHE_CM             NUMBER(10,2)          not null,
   TIEFE_CM             NUMBER(10,2)          not null,
   BESCHREIBUNG         VARCHAR2(1000),
   constraint PK_GROESSE primary key (GROESSEID)
);

/*==============================================================*/
/* Table: KUNDE                                                 */
/*==============================================================*/
create table KUNDE (
   KUNDEID              NUMBER(20,0)          not null,
   VORNAME_             VARCHAR2(50)          not null,
   NACHNAME             VARCHAR2(50)          not null,
   EMAIL                VARCHAR2(50)          not null,
   ADRESSE              VARCHAR2(100)         not null,
   PLZ                  VARCHAR2(20)          not null,
   ORT                  VARCHAR2(50)          not null,
   LAND                 VARCHAR2(50)          not null,
   REGESTRIERT          CHAR(1)              default 'N'  not null
      constraint CKC_REGESTRIERT_KUNDE check (REGESTRIERT in ('Y','N')),
   PASSWORT             VARCHAR2(20)          not null,
   TELEFONNUMMER        VARCHAR2(20),
   constraint PK_KUNDE primary key (KUNDEID)
);

/*==============================================================*/
/* Table: LAGER                                                 */
/*==============================================================*/
create table LAGER (
   LAGERID              NUMBER(20,0)          not null,
   BESTELLUNGID         NUMBER(20,0),
   MENGEN_VERFUEGBAR    NUMBER(20,0)          not null,
   LAGERTYP             VARCHAR2(50)          not null,
   constraint PK_LAGER primary key (LAGERID)
);

/*==============================================================*/
/* Index: BESTELLUNG_LAGER_FK                                   */
/*==============================================================*/
create index BESTELLUNG_LAGER_FK on LAGER (
   BESTELLUNGID ASC
);

/*==============================================================*/
/* Table: LAGERBEWEGUNG                                         */
/*==============================================================*/
create table LAGERBEWEGUNG (
   BEWEGUNGSID          NUMBER(20,0)          not null,
   BESTANDID            NUMBER(20,0)          not null,
   BES_BESTANDID        NUMBER(20,0)          not null,
   DATUM                DATE                  not null,
   BEWEGUNGSTYP         CHAR(1)               not null
      constraint CKC_BEWEGUNGSTYP_LAGERBEW check (BEWEGUNGSTYP in ('T','K','I') and BEWEGUNGSTYP = upper(BEWEGUNGSTYP)),
   MENGE                NUMBER(20,0)          not null
      constraint CKC_MENGE_LAGERBEW check (MENGE >= 1),
   constraint PK_LAGERBEWEGUNG primary key (BEWEGUNGSID)
);

/*==============================================================*/
/* Index: BESTAND_ZIEL_LAGERBEWEGUNG_FK                         */
/*==============================================================*/
create index BESTAND_ZIEL_LAGERBEWEGUNG_FK on LAGERBEWEGUNG (
   BES_BESTANDID ASC
);

/*==============================================================*/
/* Index: B_QUELLE_LBEWEGUNG_FK                                 */
/*==============================================================*/
create index B_QUELLE_LBEWEGUNG_FK on LAGERBEWEGUNG (
   BESTANDID ASC
);

/*==============================================================*/
/* Table: LAGER_PRODUKT                                         */
/*==============================================================*/
create table LAGER_PRODUKT (
   LAGERID              NUMBER(20,0)          not null,
   PRODUKTID            NUMBER(20,0)          not null,
   constraint PK_LAGER_PRODUKT primary key (LAGERID, PRODUKTID)
);

/*==============================================================*/
/* Index: BEFINDET_SICH_FK                                      */
/*==============================================================*/
create index BEFINDET_SICH_FK on LAGER_PRODUKT (
   LAGERID ASC
);

/*==============================================================*/
/* Index: BEINHALTET_FK                                         */
/*==============================================================*/
create index BEINHALTET_FK on LAGER_PRODUKT (
   PRODUKTID ASC
);

/*==============================================================*/
/* Table: LIEFERANT                                             */
/*==============================================================*/
create table LIEFERANT (
   LIEFERANTID          NUMBER(20,0)          not null,
   NAME                 VARCHAR2(50)          not null,
   EMAIL                VARCHAR2(50)          not null,
   ADRESSE              VARCHAR2(50)          not null,
   PLZ                  VARCHAR2(20)          not null,
   ORT                  VARCHAR2(50)          not null,
   TELEFON              VARCHAR2(20),
   KONTAKTPERSON        VARCHAR2(50),
   constraint PK_LIEFERANT primary key (LIEFERANTID)
);

/*==============================================================*/
/* Table: LIEFERANT_PRODUKT                                     */
/*==============================================================*/
create table LIEFERANT_PRODUKT (
   LIEFERANTID          NUMBER(20,0)          not null,
   PRODUKTID            NUMBER(20,0)          not null,
   constraint PK_LIEFERANT_PRODUKT primary key (LIEFERANTID, PRODUKTID)
);

/*==============================================================*/
/* Index: LIEFERT_FK                                            */
/*==============================================================*/
create index LIEFERT_FK on LIEFERANT_PRODUKT (
   LIEFERANTID ASC
);

/*==============================================================*/
/* Index: WIRD_GELIEFERT_VON_FK                                 */
/*==============================================================*/
create index WIRD_GELIEFERT_VON_FK on LIEFERANT_PRODUKT (
   PRODUKTID ASC
);

/*==============================================================*/
/* Table: MATERIAL                                              */
/*==============================================================*/
create table MATERIAL (
   MATERIALID           NUMBER(20,0)          not null,
   BEZEICHNUNG          VARCHAR2(50)          not null,
   BESCHREIBUNG         VARCHAR2(1000),
   constraint PK_MATERIAL primary key (MATERIALID)
);

/*==============================================================*/
/* Table: OEFFNUNGSZEITEN                                       */
/*==============================================================*/
create table OEFFNUNGSZEITEN (
   OEFFNUNGSZEITID      NUMBER(20,0)          not null,
   FILIALEID            NUMBER(20,0)          not null,
   WOCHENTAGE           NUMBER(1)             not null
      constraint CKC_WOCHENTAGE_OEFFNUNG check (WOCHENTAGE between 1 and 7 and WOCHENTAGE in (1,2,3,4,5,6,7)),
   VONUHRZEIT           DATE                  not null,
   BISUHRZEIT           DATE                  not null,
   constraint PK_OEFFNUNGSZEITEN primary key (OEFFNUNGSZEITID)
);

/*==============================================================*/
/* Index: FILIALE_OEFFNNUNGSZEITEN_FK                           */
/*==============================================================*/
create index FILIALE_OEFFNNUNGSZEITEN_FK on OEFFNUNGSZEITEN (
   FILIALEID ASC
);

/*==============================================================*/
/* Table: PREIS_HISTORIE                                        */
/*==============================================================*/
create table PREIS_HISTORIE (
   PREISID              NUMBER(20,0)          not null,
   PRODUKTID            NUMBER(20,0)          not null,
   ALTER_PREIS          NUMBER(10,2)          not null,
   NEUER_PREIS          NUMBER(10,2),
   DATUM                DATE,
   constraint PK_PREIS_HISTORIE primary key (PREISID)
);

/*==============================================================*/
/* Index: PRODUKT_PREIS_HISTORIE_FK                             */
/*==============================================================*/
create index PRODUKT_PREIS_HISTORIE_FK on PREIS_HISTORIE (
   PRODUKTID ASC
);

/*==============================================================*/
/* Table: PRODUKT                                               */
/*==============================================================*/
create table PRODUKT (
   PRODUKTID            NUMBER(20,0)          not null,
   KATEGORIEID          NUMBER(20,0)          not null,
   RABATTID             NUMBER(20,0),
   VERFUEGBAR           CHAR(1)              default 'N'  not null
      constraint CKC_VERFUEGBAR_PRODUKT check (VERFUEGBAR in ('Y','N')),
   NAME                 VARCHAR2(50),
   BASIS_PREIS          NUMBER(10,2),
   BESCHREIBUNG         VARCHAR2(1000),
   constraint PK_PRODUKT primary key (PRODUKTID)
);

/*==============================================================*/
/* Index: PRODUKTKATGORIE_PRODUKT_FK                            */
/*==============================================================*/
create index PRODUKTKATGORIE_PRODUKT_FK on PRODUKT (
   KATEGORIEID ASC
);

/*==============================================================*/
/* Index: RABATT_PRODUKT_FK                                     */
/*==============================================================*/
create index RABATT_PRODUKT_FK on PRODUKT (
   RABATTID ASC
);

/*==============================================================*/
/* Table: PRODUKTKATEGORIE                                      */
/*==============================================================*/
create table PRODUKTKATEGORIE (
   KATEGORIEID          NUMBER(20,0)          not null,
   KATEGORIENAME        VARCHAR2(50)          not null,
   BESCHREIBUNG         VARCHAR2(1000),
   constraint PK_PRODUKTKATEGORIE primary key (KATEGORIEID)
);

/*==============================================================*/
/* Table: PRODUKTVARIANTE                                       */
/*==============================================================*/
create table PRODUKTVARIANTE (
   VARIANTEID           NUMBER(20,0)          not null,
   FARBENID             NUMBER(20,0)          not null,
   MATERIALID           NUMBER(20,0)          not null,
   PRODUKTID            NUMBER(20,0)          not null,
   GROESSEID            NUMBER(20,0)          not null,
   PREISVARIANTE        NUMBER(10,2)          not null,
   VERFUEGBAR           CHAR(1)              default 'N'  not null
      constraint CKC_VERFUEGBAR_PRODUKTV check (VERFUEGBAR in ('Y','N')),
   constraint PK_PRODUKTVARIANTE primary key (VARIANTEID)
);

/*==============================================================*/
/* Index: GROESSE_PRODUKTVARIANTE_FK                            */
/*==============================================================*/
create index GROESSE_PRODUKTVARIANTE_FK on PRODUKTVARIANTE (
   GROESSEID ASC
);

/*==============================================================*/
/* Index: FARBE_PRODUKTVARIANTE_FK                              */
/*==============================================================*/
create index FARBE_PRODUKTVARIANTE_FK on PRODUKTVARIANTE (
   FARBENID ASC
);

/*==============================================================*/
/* Index: MATERIAL_PRODUKTVARIANTE_FK                           */
/*==============================================================*/
create index MATERIAL_PRODUKTVARIANTE_FK on PRODUKTVARIANTE (
   MATERIALID ASC
);

/*==============================================================*/
/* Index: PRODUKT_PRODUKTVARIANTE_FK                            */
/*==============================================================*/
create index PRODUKT_PRODUKTVARIANTE_FK on PRODUKTVARIANTE (
   PRODUKTID ASC
);

/*==============================================================*/
/* Table: RABATT                                                */
/*==============================================================*/
create table RABATT (
   RABATTID             NUMBER(20,0)          not null,
   RABATT_PROZENT       NUMBER(5,2)           not null
      constraint CKC_RABATT_PROZENT_RABATT check (RABATT_PROZENT between 0 and 100),
   START_DATUM          DATE                  not null,
   END_DATUM            DATE,
   BEZEICHNUNG          VARCHAR2(50),
   constraint PK_RABATT primary key (RABATTID)
);

/*==============================================================*/
/* Table: RUECKGABE                                             */
/*==============================================================*/
create table RUECKGABE (
   REUCKGABEID          NUMBER(20,0)          not null,
   VERKAUFID            NUMBER(20,0),
   LAGERID              NUMBER(20,0),
   KUNDEID              NUMBER(20,0),
   DATUM                DATE                  not null,
   GRUND                VARCHAR2(1000)        not null,
   BETRAG_ERSTATTUNG    NUMBER(10,2)          not null,
   constraint PK_RUECKGABE primary key (REUCKGABEID)
);

/*==============================================================*/
/* Index: KUNDE_RUECKGABE_FK                                    */
/*==============================================================*/
create index KUNDE_RUECKGABE_FK on RUECKGABE (
   KUNDEID ASC
);

/*==============================================================*/
/* Index: LAGER_RUECKGABE_FK                                    */
/*==============================================================*/
create index LAGER_RUECKGABE_FK on RUECKGABE (
   LAGERID ASC
);

/*==============================================================*/
/* Index: VERKAUF_RUECKGABE_FK                                  */
/*==============================================================*/
create index VERKAUF_RUECKGABE_FK on RUECKGABE (
   VERKAUFID ASC
);

/*==============================================================*/
/* Table: VERKAUF                                               */
/*==============================================================*/
create table VERKAUF (
   VERKAUFID            NUMBER(20,0)          not null,
   KUNDEID              NUMBER(20,0),
   FILIALEID            NUMBER(20,0),
   ZAHLUNGSARTID        NUMBER(20,0)          not null,
   ANZAHL               NUMBER(20,0)          not null,
   ZAHLUNGSTATUS        CHAR(1)              default 'N'  not null
      constraint CKC_ZAHLUNGSTATUS_VERKAUF check (ZAHLUNGSTATUS in ('Y','N')),
   VERKAUFSDATUM        DATE                  not null,
   constraint PK_VERKAUF primary key (VERKAUFID)
);

/*==============================================================*/
/* Index: VERKAUF_KUNDE_FK                                      */
/*==============================================================*/
create index VERKAUF_KUNDE_FK on VERKAUF (
   KUNDEID ASC
);

/*==============================================================*/
/* Index: ZAHLUNGSART_VERKAUF_FK                                */
/*==============================================================*/
create index ZAHLUNGSART_VERKAUF_FK on VERKAUF (
   ZAHLUNGSARTID ASC
);

/*==============================================================*/
/* Index: FILIALE_VERKAUF_FK                                    */
/*==============================================================*/
create index FILIALE_VERKAUF_FK on VERKAUF (
   FILIALEID ASC
);

/*==============================================================*/
/* Table: VERKAUFPOSITION                                       */
/*==============================================================*/
create table VERKAUFPOSITION (
   VERKAUFPOSITIONID    NUMBER(20,0)          not null,
   VARIANTEID           NUMBER(20,0)          not null,
   VERKAUFID            NUMBER(20,0)          not null,
   MENGE                NUMBER(10,0)          not null,
   EINZELPREIS          NUMBER(10,2)          not null,
   constraint PK_VERKAUFPOSITION primary key (VERKAUFPOSITIONID)
);

/*==============================================================*/
/* Index: VERKAUFPOSITION_VERKAUF_FK                            */
/*==============================================================*/
create index VERKAUFPOSITION_VERKAUF_FK on VERKAUFPOSITION (
   VERKAUFID ASC
);

/*==============================================================*/
/* Index: PVARIANTE_VERKAUFPOSION_FK                            */
/*==============================================================*/
create index PVARIANTE_VERKAUFPOSION_FK on VERKAUFPOSITION (
   VARIANTEID ASC
);

/*==============================================================*/
/* Table: ZAHLUNGSART                                           */
/*==============================================================*/
create table ZAHLUNGSART (
   ZAHLUNGSARTID        NUMBER(20,0)          not null,
   BEZEICHNUNG          VARCHAR2(50)          not null,
   constraint PK_ZAHLUNGSART primary key (ZAHLUNGSARTID)
);

alter table ANGESTELLTER
   add constraint FK_ANGESTEL_ANGESTELL_ANGESTEL foreign key (ANG_ANGESTELLTERID)
      references ANGESTELLTER (ANGESTELLTERID);

alter table ANGESTELLTER
   add constraint FK_ANGESTEL_LAGER_MIT_LAGER foreign key (LAGERID)
      references LAGER (LAGERID);

alter table ANGESTELLTER
   add constraint FK_ANGESTEL_RELATIONS_FILIALE foreign key (FILIALEID)
      references FILIALE (FILIALEID);

alter table BESTAND
   add constraint FK_BESTAND_BESTAND_L_LAGER foreign key (LAGERID)
      references LAGER (LAGERID);

alter table BESTAND
   add constraint FK_BESTAND_BESTAND_P_PRODUKTV foreign key (VARIANTEID)
      references PRODUKTVARIANTE (VARIANTEID);

alter table BESTELLPOSITION
   add constraint FK_BESTELLP_BESTELLUN_BESTELLU foreign key (BESTELLUNGID)
      references BESTELLUNG (BESTELLUNGID);

alter table BESTELLPOSITION
   add constraint FK_BESTELLP_PRODUKTVA_PRODUKTV foreign key (VARIANTEID)
      references PRODUKTVARIANTE (VARIANTEID);

alter table BESTELLUNG
   add constraint FK_BESTELLU_FILIALE_B_FILIALE foreign key (FILIALEID)
      references FILIALE (FILIALEID);

alter table BEWERTUNG
   add constraint FK_BEWERTUN_BEWERUNG__PRODUKT foreign key (PRODUKTID)
      references PRODUKT (PRODUKTID);

alter table BEWERTUNG
   add constraint FK_BEWERTUN_KUNDE_BEW_KUNDE foreign key (KUNDEID)
      references KUNDE (KUNDEID);

alter table FILIALE
   add constraint "FK_FILIALE_GEHOERT Z_LAGER" foreign key (LAGERID)
      references LAGER (LAGERID);

alter table LAGER
   add constraint FK_LAGER_BESTELLUN_BESTELLU foreign key (BESTELLUNGID)
      references BESTELLUNG (BESTELLUNGID);

alter table LAGERBEWEGUNG
   add constraint FK_LAGERBEW_BESTAND_Q_BESTAND foreign key (BESTANDID)
      references BESTAND (BESTANDID);

alter table LAGERBEWEGUNG
   add constraint FK_LAGERBEW_BESTAND_Z_BESTAND foreign key (BES_BESTANDID)
      references BESTAND (BESTANDID);

alter table LAGER_PRODUKT
   add constraint "FK_LAGER_PR_BEFINDET _LAGER" foreign key (LAGERID)
      references LAGER (LAGERID);

alter table LAGER_PRODUKT
   add constraint FK_LAGER_PR_BEINHALTE_PRODUKT foreign key (PRODUKTID)
      references PRODUKT (PRODUKTID);

alter table LIEFERANT_PRODUKT
   add constraint FK_LIEFERAN_LIEFERT_LIEFERAN foreign key (LIEFERANTID)
      references LIEFERANT (LIEFERANTID);

alter table LIEFERANT_PRODUKT
   add constraint "FK_LIEFERAN_WIRD GELI_PRODUKT" foreign key (PRODUKTID)
      references PRODUKT (PRODUKTID);

alter table OEFFNUNGSZEITEN
   add constraint FK_OEFFNUNG_FILIALE_O_FILIALE foreign key (FILIALEID)
      references FILIALE (FILIALEID);

alter table PREIS_HISTORIE
   add constraint FK_PREIS_HI_PRODUKT_P_PRODUKT foreign key (PRODUKTID)
      references PRODUKT (PRODUKTID);

alter table PRODUKT
   add constraint FK_PRODUKT_PRODUKTKA_PRODUKTK foreign key (KATEGORIEID)
      references PRODUKTKATEGORIE (KATEGORIEID);

alter table PRODUKT
   add constraint FK_PRODUKT_RABATT_PR_RABATT foreign key (RABATTID)
      references RABATT (RABATTID);

alter table PRODUKTVARIANTE
   add constraint FK_PRODUKTV_FARBE_PRO_FARBE foreign key (FARBENID)
      references FARBE (FARBENID);

alter table PRODUKTVARIANTE
   add constraint FK_PRODUKTV_GROESSE_P_GROESSE foreign key (GROESSEID)
      references GROESSE (GROESSEID);

alter table PRODUKTVARIANTE
   add constraint FK_PRODUKTV_MATERIAL__MATERIAL foreign key (MATERIALID)
      references MATERIAL (MATERIALID);

alter table PRODUKTVARIANTE
   add constraint FK_PRODUKTV_PRODUKT_P_PRODUKT foreign key (PRODUKTID)
      references PRODUKT (PRODUKTID);

alter table RUECKGABE
   add constraint FK_RUECKGAB_KUNDE_RUE_KUNDE foreign key (KUNDEID)
      references KUNDE (KUNDEID);

alter table RUECKGABE
   add constraint FK_RUECKGAB_LAGER_RUE_LAGER foreign key (LAGERID)
      references LAGER (LAGERID);

alter table RUECKGABE
   add constraint FK_RUECKGAB_VERKAUF_R_VERKAUF foreign key (VERKAUFID)
      references VERKAUF (VERKAUFID);

alter table VERKAUF
   add constraint FK_VERKAUF_FILIALE_V_FILIALE foreign key (FILIALEID)
      references FILIALE (FILIALEID);

alter table VERKAUF
   add constraint FK_VERKAUF_VERKAUF_K_KUNDE foreign key (KUNDEID)
      references KUNDE (KUNDEID);

alter table VERKAUF
   add constraint FK_VERKAUF_ZAHLUNGSA_ZAHLUNGS foreign key (ZAHLUNGSARTID)
      references ZAHLUNGSART (ZAHLUNGSARTID);

alter table VERKAUFPOSITION
   add constraint FK_VERKAUFP_PRODUKTVA_PRODUKTV foreign key (VARIANTEID)
      references PRODUKTVARIANTE (VARIANTEID);

alter table VERKAUFPOSITION
   add constraint FK_VERKAUFP_VERKAUFPO_VERKAUF foreign key (VERKAUFID)
      references VERKAUF (VERKAUFID);


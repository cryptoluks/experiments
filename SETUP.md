# Anlagenspiegel Dashboard - Power BI

Dashboard zur Visualisierung des Anlagengitters aus SAP Business One, angelehnt an das "Fixed Assets" Design von Global Data 365.

## Projektstruktur

```
├── FixedAssetsDashboard.pbip              # Power BI Project Hauptdatei
├── FixedAssetsDashboard.SemanticModel/    # Datenmodell (Tabellen, Beziehungen, Measures)
│   ├── definition.pbism
│   └── definition/
│       └── model.bim                      # Tabellarisches Modell (TOM)
├── FixedAssetsDashboard.Report/           # Report-Definition (Seiten, Visuals)
│   ├── definition.pbir
│   └── definition/
│       ├── report.json                    # Visuals und Layout
│       └── pages/                         # Seitendefinitionen
├── data/
│   └── sap_b1_anlagengitter.csv           # Demo-Daten (SAP B1 Anlagengitter-Format)
├── queries/
│   ├── SAP_B1_Anlagengitter_Query.m       # Power Query M-Skript (HANA/SQL/CSV)
│   └── DAX_Measures.dax                   # Alle DAX-Measures
└── SETUP.md
```

## Schnellstart

### Option 1: PBIP-Projekt öffnen (empfohlen)

1. **Power BI Desktop** öffnen (Version März 2023 oder neuer)
2. Unter **Datei > Optionen > Vorschaufeatures** die Option **Power BI Project (.pbip)** aktivieren
3. **Datei > Öffnen > Durchsuchen** → `FixedAssetsDashboard.pbip` öffnen
4. Datenquelle anpassen (siehe unten)
5. **Daten aktualisieren**

### Option 2: Manueller Import

1. Neue Power BI Desktop Datei erstellen
2. **Daten abrufen > Text/CSV** → `data/sap_b1_anlagengitter.csv` importieren
3. DAX-Measures aus `queries/DAX_Measures.dax` übernehmen
4. Visuals gemäß `report.json` anlegen

## SAP Business One Anbindung

### Voraussetzungen

- SAP Business One 9.3 oder höher
- SAP HANA Client oder SQL Server Native Client
- Berechtigungen auf die Tabellen `OITM` und `OACS`

### Verbindung konfigurieren

Die Datei `queries/SAP_B1_Anlagengitter_Query.m` enthält fertige Power Query Abfragen für:

| Option | Verbindung | Anwendungsfall |
|--------|-----------|----------------|
| **Option 1** | SAP HANA | SAP B1 on HANA |
| **Option 2** | SQL Server | SAP B1 on SQL Server |
| **Option 3** | CSV-Import | Demo / Offline |

**Schritte:**

1. In Power BI Desktop: **Start > Daten transformieren > Erweiterter Editor**
2. Den passenden Query-Block aus `SAP_B1_Anlagengitter_Query.m` einfügen
3. Parameter `SAP_B1_Server` und `SAP_B1_Database` anlegen:
   - **Verwalten > Parameter verwalten > Neu**
   - `SAP_B1_Server`: z.B. `sap-hana-server:30015`
   - `SAP_B1_Database`: z.B. `SBO_MeineFirma`

### SAP B1 Tabellen-Referenz

| SAP Tabelle | Beschreibung | Verwendete Felder |
|-------------|--------------|-------------------|
| `OITM` | Artikel/Anlagen (ItemType='F') | ItemCode, ItemName, AcqValue, DepValue, NetBookVal, ... |
| `OACS` | Anlagenklassen | Code, Name |

## Dashboard-Seiten

### Seite 1: Übersicht
- **5 KPI-Karten**: Anfangsbestand, Zugänge, Abschreibungen, Abgänge, Restbuchwert
- **Balkendiagramm**: Zugänge nach Monat
- **Horizontales Balkendiagramm**: Zugänge nach Anlagenklasse

### Seite 2: Details
- **Tabelle**: Anlagengitter mit Einzelpositionen
- **Donut-Diagramm**: Restbuchwert nach Standort
- **Treemap**: Abschreibungen nach Anlagenklasse

## DAX-Measures

Alle Measures sind in `queries/DAX_Measures.dax` dokumentiert:

- Grundkennzahlen: Anfangsbestand, Zugänge, Abschreibungen, Abgänge, Restbuchwert
- Delta-Vergleiche: Vormonat (VM), Vorjahr (VJ) - absolut und prozentual
- Abschreibungskennzahlen: Quote, Buchwert-Intensität, Durchschnittsalter
- Kumulierte Werte: Kum. Zugänge, Kum. Abschreibungen

## Anlagenklassen (SAP B1)

| Code | Bezeichnung |
|------|-------------|
| 100 | Gebäude und Bauten |
| 200 | Maschinen und Anlagen |
| 300 | Fuhrpark |
| 400 | Grundstücke |
| 500 | Büroausstattung |
| 600 | EDV-Anlagen |
| 700 | Betriebsanlagen |
| 800 | Betriebs- und Geschäftsausstattung |
| 900 | Firmenwagen |
| 1000 | Geringwertige WG |
| 1100 | Immaterielle VG |

// Power Query M-Skript: SAP Business One Anlagengitter
// Verbindung über SAP HANA oder SQL Server (je nach SAP B1 Installation)
//
// Option 1: SAP HANA Direktverbindung
// Option 2: SQL Server (SAP B1 on SQL)
// Option 3: CSV-Import (Demo-Daten)
//
// Anpassen: ServerName, Datenbankname und Credentials in den Parametern

// === PARAMETER ===
// Diese Parameter werden in Power BI unter "Parameter verwalten" konfiguriert
// SAP_B1_Server = "your-sap-server:30015"  // HANA Port
// SAP_B1_Database = "SBO_YourCompany"

// === OPTION 1: SAP HANA Verbindung ===
let
    // SAP HANA Verbindung zum Anlagengitter
    Quelle_HANA = SapHana.Database(SAP_B1_Server, SAP_B1_Database, [Implementation="2.0"]),

    // SQL-Abfrage für das Anlagengitter aus SAP B1
    AnlagengitterQuery = "
        SELECT
            T0.""ItemCode"",
            T0.""ItemName"",
            T1.""AssetClass"",
            T1.""AssetClsNm""     AS ""AssetClassName"",
            T0.""CapDate""        AS ""CapDate"",
            T0.""AcqValue""       AS ""AHK_Vortrag"",
            T0.""AcqCurVal""      AS ""Zugang"",
            T0.""RetValue""       AS ""Abgang"",
            (T0.""AcqValue"" + T0.""AcqCurVal"" - T0.""RetValue"") AS ""AHK_Endstand"",
            T0.""DepValue""       AS ""AfA_Vortrag"",
            T0.""DepCurVal""      AS ""AfA_Zugang"",
            T0.""RetDepVal""      AS ""AfA_Abgang"",
            (T0.""DepValue"" + T0.""DepCurVal"" - T0.""RetDepVal"") AS ""AfA_Endstand"",
            (T0.""AcqValue"" - T0.""DepValue"") AS ""Buchwert_Anfang"",
            T0.""NetBookVal""     AS ""Buchwert_Ende"",
            T0.""UsefulLife""     AS ""Nutzungsdauer"",
            CASE T0.""DepMethod""
                WHEN 'S' THEN 'Linear'
                WHEN 'D' THEN 'Degressiv'
                WHEN 'N' THEN 'Keine'
                ELSE T0.""DepMethod""
            END                   AS ""AfA_Methode"",
            T0.""CostCenter""     AS ""Kostenstelle"",
            T0.""Location""       AS ""Standort"",
            CASE T0.""Status""
                WHEN 'A' THEN 'Aktiv'
                WHEN 'R' THEN 'Abgang'
                WHEN 'I' THEN 'Inaktiv'
                ELSE T0.""Status""
            END                   AS ""Status"",
            TO_VARCHAR(T0.""CapDate"", 'YYYY-MM') AS ""BuchungsMonat""
        FROM ""OITM"" T0
        INNER JOIN ""OACS"" T1 ON T0.""AssetClass"" = T1.""Code""
        WHERE T0.""ItemType"" = 'F'
        ORDER BY T0.""ItemCode""
    ",

    Ergebnis = Value.NativeQuery(Quelle_HANA, AnlagengitterQuery)
in
    Ergebnis


// === OPTION 2: SQL Server Verbindung ===
/*
let
    Quelle_SQL = Sql.Database(SAP_B1_Server, SAP_B1_Database),

    AnlagengitterQuery = "
        SELECT
            T0.ItemCode,
            T0.ItemName,
            T1.Code         AS AssetClass,
            T1.Name         AS AssetClassName,
            T0.CapDate,
            T0.AcqValue     AS AHK_Vortrag,
            T0.AcqCurVal    AS Zugang,
            T0.RetValue     AS Abgang,
            (T0.AcqValue + T0.AcqCurVal - T0.RetValue) AS AHK_Endstand,
            T0.DepValue     AS AfA_Vortrag,
            T0.DepCurVal    AS AfA_Zugang,
            T0.RetDepVal    AS AfA_Abgang,
            (T0.DepValue + T0.DepCurVal - T0.RetDepVal) AS AfA_Endstand,
            (T0.AcqValue - T0.DepValue) AS Buchwert_Anfang,
            T0.NetBookVal   AS Buchwert_Ende,
            T0.UsefulLife   AS Nutzungsdauer,
            CASE T0.DepMethod
                WHEN 'S' THEN 'Linear'
                WHEN 'D' THEN 'Degressiv'
                WHEN 'N' THEN 'Keine'
                ELSE T0.DepMethod
            END             AS AfA_Methode,
            T0.CostCenter   AS Kostenstelle,
            T0.Location     AS Standort,
            CASE T0.Status
                WHEN 'A' THEN 'Aktiv'
                WHEN 'R' THEN 'Abgang'
                WHEN 'I' THEN 'Inaktiv'
                ELSE T0.Status
            END             AS Status,
            FORMAT(T0.CapDate, 'yyyy-MM') AS BuchungsMonat
        FROM OITM T0
        INNER JOIN OACS T1 ON T0.AssetClass = T1.Code
        WHERE T0.ItemType = 'F'
        ORDER BY T0.ItemCode
    ",

    Ergebnis = Value.NativeQuery(Quelle_SQL, AnlagengitterQuery)
in
    Ergebnis
*/


// === OPTION 3: CSV-Import (Demo-Daten) ===
/*
let
    Quelle = Csv.Document(
        File.Contents("data/sap_b1_anlagengitter.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    Header = Table.PromoteHeaders(Quelle, [PromoteAllScalars=true]),
    Typen = Table.TransformColumnTypes(Header, {
        {"ItemCode", type text}, {"ItemName", type text}, {"AssetClass", Int64.Type},
        {"AssetClassName", type text}, {"CapDate", type date},
        {"AHK_Vortrag", type number}, {"Zugang", type number}, {"Abgang", type number},
        {"AHK_Endstand", type number}, {"AfA_Vortrag", type number},
        {"AfA_Zugang", type number}, {"AfA_Abgang", type number},
        {"AfA_Endstand", type number}, {"Buchwert_Anfang", type number},
        {"Buchwert_Ende", type number}, {"Nutzungsdauer", Int64.Type},
        {"AfA_Methode", type text}, {"Kostenstelle", type text},
        {"Standort", type text}, {"Status", type text}, {"BuchungsMonat", type text}
    })
in
    Typen
*/

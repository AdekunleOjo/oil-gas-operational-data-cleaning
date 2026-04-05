
---Data Cleaning

-- Standardize ID and Name
-- Format: PREFIX0X

ALTER TABLE OilandGas_Raw
ADD WellID VARCHAR(10);

UPDATE OilandGas_Raw
SET WellID =
    'W' + RIGHT('0' + 
        CAST(
            CAST(
                SUBSTRING(Well_ID, PATINDEX('%[0-9]%', Well_ID), LEN(Well_ID))
            AS INT)
        AS VARCHAR), 4);

ALTER TABLE OilandGas_Raw
ADD WellName VARCHAR(10);

UPDATE OilandGas_Raw
SET WellName =
    'Well' + RIGHT('0' + 
        CAST(
            CAST(
                SUBSTRING(Well_ID, PATINDEX('%[0-9]%', Well_ID), LEN(Well_ID))
            AS INT)
        AS VARCHAR), 4);

alter table oilandgas_raw
drop column well_id, well_name

-- Clean WellID format
UPDATE OilandGas_Raw
SET WellID = 'W' + RIGHT('0' + 
    CAST(CAST(REPLACE(WellName, 'Well', '') AS INT) AS VARCHAR), 3)
WHERE WellID IS NULL
AND WellName IS NOT NULL;

-- Clean WellName format
UPDATE OilandGas_Raw
SET WellName = 'Well' + RIGHT('0' + 
    CAST(
        CAST(
            REPLACE(REPLACE(REPLACE(UPPER(WellID), 'WELL', ''), 'W', ''), '-', '') 
        AS INT) 
    AS VARCHAR), 3)
WHERE WellName IS NULL
AND WellID IS NOT NULL;

-- Standardizing and formatting Date column
UPDATE OilandGas_Raw
SET [Date] = TRY_CONVERT(DATE, [Date]);

-- Handling Missing Production Data with Domain-Driven Imputation Strategy
UPDATE OilandGas_raw
SET Oil_Production_BBL = 0
WHERE Oil_Production_BBL IS NULL
AND (
    Downtime_Hours > 0 
    OR Equipment_Status LIKE '%Fail%'
);

UPDATE OilandGas_raw
SET Gas_Production_MSCF = 0
WHERE Gas_Production_MSCF IS NULL
AND (
    Downtime_Hours > 0 
    OR Equipment_Status LIKE '%Fail%'
);

UPDATE tgt
SET Oil_Production_BBL = src.AvgOil
FROM OilandGas_raw tgt
JOIN (
    SELECT WellID, AVG(CAST(Oil_Production_BBL AS FLOAT)) AS AvgOil
    FROM OilandGas_raw
    WHERE Oil_Production_BBL IS NOT NULL
    GROUP BY WellID
) src
ON tgt.WellID = src.WellID
WHERE tgt.Oil_Production_BBL IS NULL
AND tgt.Equipment_Status = 'Maintenance';

UPDATE tgt
SET Oil_Production_BBL = src.AvgOil
FROM OilandGas_raw tgt
JOIN (
    SELECT WellID, AVG(CAST(Oil_Production_BBL AS FLOAT)) AS AvgOil
    FROM OilandGas_raw
    WHERE Oil_Production_BBL IS NOT NULL
    GROUP BY WellID
) src
ON tgt.WellID = src.WellID
WHERE tgt.Oil_Production_BBL IS NULL
AND tgt.Equipment_Status = 'Active';

-- Set Water Cut to 0 for Non-Producing Wells (Downtime/Failure)
UPDATE OilandGas_raw
SET [Water_Cut (%)] = 0
WHERE [Water_Cut (%)] IS NULL
AND (
    Downtime_Hours > 0 
    OR Equipment_Status LIKE '%Fail%'
);

-- Estimate Missing Water Cut Using Average per Well
UPDATE tgt
SET [Water_Cut (%)] = src.AvgWaterCut
FROM OilandGas_raw tgt
JOIN (
    SELECT WellID, AVG(CAST([Water_Cut (%)] AS FLOAT)) AS AvgWaterCut
    FROM OilandGas_raw
    WHERE [Water_Cut (%)] IS NOT NULL
    GROUP BY WellID
) src
ON tgt.WellID = src.WellID
WHERE tgt.[Water_Cut (%)] IS NULL
AND tgt.Equipment_Status = 'Active';

-- Set Downtime to 0 for Active Wells
UPDATE OilandGas_raw
SET Downtime_Hours = 0
WHERE Downtime_Hours IS NULL
AND Equipment_Status = 'Active';

UPDATE tgt
SET Downtime_Hours = src.AvgDowntime
FROM OilandGas_raw tgt
JOIN (
    SELECT Equipment_Status, AVG(CAST(Downtime_Hours AS FLOAT)) AS AvgDowntime
    FROM OilandGas_raw
    WHERE Downtime_Hours IS NOT NULL
    GROUP BY Equipment_Status
) src
ON tgt.Equipment_Status = src.Equipment_Status
WHERE tgt.Downtime_Hours IS NULL
AND tgt.Equipment_Status LIKE '%Maint%';


select equipment_status, downtime_hours from OilandGas_raw
where downtime_hours is null

UPDATE OilandGas_raw
SET Downtime_Hours =
    CASE 
        WHEN Downtime_Hours is null THEN 0
      
        ELSE Downtime_Hours
    END 

-- Replace Remaining NULL WellID, WellName, location
UPDATE OilandGas_raw
SET WellID = 'UNKNOWN'
WHERE WellID IS NULL;

UPDATE OilandGas_raw
SET WellName = 'UNKNOWN'
WHERE WellName IS NULL;

UPDATE OilandGas_raw
SET location = 'UNKNOWN'
WHERE location IS NULL;





































































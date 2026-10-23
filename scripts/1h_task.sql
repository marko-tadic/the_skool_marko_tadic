SET PAGESIZE 100

DESC system.tabell;

SELECT 
    UTBILDNINGSOMRÅDE,
ROUND(
    (SUM(CASE WHEN STUDIEFORM = 'Distans' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),1
) AS andel_distans_procent,
ROUND(
    (SUM(CASE WHEN STUDIEFORM = 'Bunden' THEN 1 ELSE 0 END) * 100.0) / COUNT (*),1
) AS andel_bunden_procent
FROM 
    tabell
GROUP BY 
    UTBILDNINGSOMRÅDE;

EXIT

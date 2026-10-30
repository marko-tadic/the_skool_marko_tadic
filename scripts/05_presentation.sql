SET PAGESIZE 100
-- split version, a)
SELECT uo.utbildningsområde_name AS utbildningsområde,
    COUNT(*) AS antal_ansökningar
FROM
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
GROUP BY 
    uo.utbildningsområde_name
ORDER BY antal_ansökningar DESC;
-- ursprung version, a)
SELECT
    UTBILDNINGSOMRÅDE,
    COUNT(*) AS antal_ansökningar
FROM
    tabell
GROUP BY
    UTBILDNINGSOMRÅDE
ORDER BY
    antal_ansökningar DESC;

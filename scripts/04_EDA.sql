SET PAGESIZE 100
DESC tabell;
-- a) Antal ansökningar per utbildningsområde, sorterat på flest ansökningar
SELECT 
    uo.utbildningsområde_name AS utbildningsområde, 
    COUNT(*) AS antal_ansökningar
FROM
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
GROUP BY
    uo.utbildningsområde_name
ORDER BY antal_ansökningar DESC;

-- b) Antal BEVILJADE ansökningar per utbildningsområde
SELECT
    uo.utbildningsområde_name AS utbildningsområde,
    COUNT(*) AS antal_beviljade_ansökningar
FROM 
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
WHERE
    a.beslut = 'Beviljad'
GROUP BY uo.utbildningsområde_name
ORDER BY antal_beviljade_ansökningar DESC;
-- c) Antal AVSLAGNA ansökningar per utbildningsområde
SELECT 
    uo.utbildningsområde_name AS utbildningsområde,
    COUNT(*) AS antal_avslagna_ansökningar
FROM
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
WHERE
    a.beslut = 'Avslag'
GROUP BY uo.utbildningsområde_name
ORDER BY antal_avslagna_ansökningar DESC;
-- d) Antal BEVILJADE ansökningar per utbildningsnamn inom Data/IT
SELECT 
    a.utbildningsnamn,
    uo.utbildningsområde_name AS utbildningsområde,
    COUNT(*) AS antal_beviljade_ansökningar
FROM
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
WHERE 
    uo.utbildningsområde_name = 'Data/IT'
    AND a.beslut = 'Beviljad'
GROUP BY
    uo.utbildningsområde_name,
    a.utbildningsnamn
ORDER BY antal_beviljade_ansökningar DESC;
-- e) Antal AVSLAGNA ansökningar per utbildningsnamn inom Data/IT
SELECT
    a.utbildningsnamn,
    uo.utbildningsområde_name AS utbildningsområde,
    COUNT(*) AS antal_avslagna_ansökningar
FROM
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
WHERE
    uo.utbildningsområde_name = 'Data/IT'
    AND a.beslut = 'Avslag'
GROUP BY 
    uo.utbildningsområde_name,
    a.utbildningsnamn
ORDER BY antal_avslagna_ansökningar DESC;
-- f) Antal BEVILJADE ansökningar per utbildningsanordnare administrativ enhet & utbildningsnamn, inom Data/IT
SELECT
    uo.utbildningsområde_name AS utbildningsområde,
    a.utbildningsnamn,
    ua.name AS anordnare,
    COUNT(*) AS antal_beviljade_ansökningar
FROM
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
JOIN utbildningsanordnare ua ON a.anordnare_id = ua.anordnare_id
WHERE uo.utbildningsområde_name = 'Data/IT'
    AND a.beslut = 'Beviljad'
GROUP BY 
    uo.utbildningsområde_name,
    ua.name, 
    a.utbildningsnamn
ORDER BY 
    ua.name, 
    antal_beviljade_ansökningar DESC;
-- g) Topp 5 län efter antal beviljade ansökningar
SELECT
    l.lan_name,
    COUNT(DISTINCT a.diarienummer) AS antal_beviljade_ansökningar
FROM
    ansökan a
JOIN ansökan_kommun ak ON a.diarienummer = ak.diarienummer
JOIN kommun k ON ak.kommun_id = k.kommun_id
JOIN lan l ON k.lan_id = l.lan_id
WHERE
    a.beslut = 'Beviljad'
    AND k.kommun_name != 'Flera kommuner'
GROUP BY l.lan_name
ORDER BY antal_beviljade_ansökningar DESC
FETCH FIRST 5 ROWS ONLY;
-- h) Andel distans och andel bundna utbildningar inom respektive utbildningsområde
SELECT
    uo.utbildningsområde_name,
    ROUND(
        (SUM(CASE WHEN a.studieform = 'Distans' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 1) AS andel_distans_procent,
    ROUND(
        (SUM(CASE WHEN a.studieform = 'Bunden' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 1) AS andel_bunden_procent
FROM
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
GROUP BY uo.utbildningsområde_name;
-- i) Antal utbildningar som innehåller ordet AI
SELECT 
    COUNT(*) AS antal_utbildningar_med_AI
FROM
    ansökan
WHERE utbildningsnamn LIKE '%AI%';

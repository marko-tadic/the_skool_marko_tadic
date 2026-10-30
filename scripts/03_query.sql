SET PAGESIZE 100

-- Beviljande per utbildningsområde. Antal ansökningar tillagd så det inte blir missvisande.
SELECT
    uo.utbildningsområde_name AS utbildningsområde,
    COUNT(*) AS antal_ansökningar,
    SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) AS antal_beviljade,
    ROUND(
        (SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 1) AS beviljandegrad_procent
FROM
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
GROUP BY
    uo.utbildningsområde_name
ORDER BY
    beviljandegrad_procent DESC;

-- Geografisk spridning. Antal beviljade och beviljandegrad per län.
SELECT
    l.lan_name AS län,
    COUNT(DISTINCT CASE WHEN a.beslut = 'Beviljad' THEN a.diarienummer END) AS antal_beviljade,
    ROUND(
        (COUNT(DISTINCT CASE WHEN a.beslut = 'Beviljad' THEN a.diarienummer END) * 100.0) 
        / COUNT(DISTINCT a.diarienummer), 1) AS beviljandegrad_procent
FROM
    ansökan a
JOIN ansökan_kommun ak ON a.diarienummer = ak.diarienummer
JOIN kommun k ON ak.kommun_id = k.kommun_id
JOIN lan l ON k.lan_id = l.lan_id
WHERE
    k.kommun_name != 'Flera kommuner'
GROUP BY 
    l.lan_name
ORDER BY
    beviljandegrad_procent DESC;

-- Distans vs. platsbunden. Antal sökningar, antal beviljade och beviljandegrad.
SELECT 
    a.studieform,
    COUNT(*) AS antal_ansökningar,
    SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) as antal_beviljade,
    ROUND(
        (SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(*), 1) AS beviljandegrad_procent
FROM
    ansökan a
GROUP BY
    a.studieform
ORDER BY
    beviljandegrad_procent DESC;

-- Konkurrentanalys (med fler eller lika med 5 ansökningar)
SELECT
    ua.name AS anordnare,
    COUNT(*) AS antal_ansökningar,
    SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) as antal_beviljande,
    ROUND(
        (SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(*), 1) AS beviljandegrad_procent
FROM
    ansökan a
JOIN utbildningsanordnare ua ON a.anordnare_id = ua.anordnare_id
GROUP BY ua.name
HAVING COUNT(*) >= 5
ORDER BY antal_beviljande DESC;

-- Konkurrentanalys (utan restriktioner om antal ansökningar) sorterat efter beviljandegrad.
SELECT
    ua.name AS anordnare,
    COUNT(*) AS antal_ansökningar,
    SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) as antal_beviljande,
    ROUND(
        (SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(*), 1) AS beviljandegrad_procent
FROM
    ansökan a
JOIN utbildningsanordnare ua ON a.anordnare_id = ua.anordnare_id
GROUP BY ua.name
ORDER BY beviljandegrad_procent DESC;

-- Huvudmannatyp per område
SELECT
    uo.utbildningsområde_name,
    ua.huvudmannatyp,
    COUNT(*) AS antal_ansökningar,
    SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) as antal_beviljande,
    ROUND(
        (SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(*), 1) AS beviljandegrad_procent
FROM
    ansökan a
JOIN sun5_inriktning s ON a.sun5_kod = s.sun5_kod
JOIN utbildningsområde uo ON s.utbildningsområde_id = uo.utbildningsområde_id
JOIN utbildningsanordnare ua ON a.anordnare_id = ua.anordnare_id
WHERE
    a.beslut In ('Beviljad', 'Avslag')
GROUP BY uo.utbildningsområde_name, ua.huvudmannatyp
HAVING COUNT(*) >= 5
ORDER BY uo.utbildningsområde_name, beviljandegrad_procent DESC;

-- Antal starter och beviljandegrad
SELECT
    a.sökta_utbildningsomgångar AS antal_starter,
    COUNT(*) AS antal_ansökningar,
    SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) AS antal_beviljade,
    ROUND(
        (SUM(CASE WHEN a.beslut = 'Beviljad' THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(*), 1) AS beviljandegrad_procent
FROM 
    ansökan a
WHERE
    a.beslut IN ('Beviljad', 'Avslag')
GROUP BY a.sökta_utbildningsomgångar
ORDER BY a.sökta_utbildningsomgångar;


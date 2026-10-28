INSERT INTO utbildningsområde (utbildningsområde_id, utbildningsområde_name)
SELECT 
    ROW_NUMBER() OVER (ORDER BY utbildningsområde), utbildningsområde
FROM 
    (SELECT DISTINCT utbildningsområde 
    FROM tabell); 

INSERT INTO seqf (seqf_kod, examenstyp)
SELECT DISTINCT
    seqf_nivå, examenstyp
FROM
    tabell
WHERE seqf_nivå IS NOT NULL;

INSERT INTO seqf (seqf_kod, examenstyp) VALUES (0, 'Ingen');

INSERT INTO utbildningsanordnare (anordnare_id, name, huvudmannatyp)
SELECT
    ROW_NUMBER() OVER (ORDER BY namn), namn, huvudmannatyp
FROM
    (SELECT DISTINCT TRIM(utbildningsanordnare_administr) AS namn, huvudmannatyp
    FROM tabell);

INSERT INTO lan (lan_id, lan_name)
SELECT
    ROW_NUMBER() OVER (ORDER BY län), län
FROM    
    (SELECT DISTINCT län 
    FROM tabell);

INSERT INTO sun5_inriktning (sun5_kod, utbildningsområde_id, sun5_namn)
SELECT DISTINCT
    t.sun5_inriktning, u.utbildningsområde_id, t.sun5_inriktning_namn
FROM
    tabell t
JOIN utbildningsområde u ON u.utbildningsområde_name = t.utbildningsområde;

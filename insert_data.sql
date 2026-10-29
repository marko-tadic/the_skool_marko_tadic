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

INSERT INTO kommun (kommun_id, kommun_name, lan_id)
SELECT
    ROW_NUMBER() OVER (ORDER BY k.kommun), k.kommun, l.lan_id
FROM
    (SELECT DISTINCT kommun, län 
    FROM tabell) k
JOIN lan l ON l.lan_name = k.län;

-- NVL for oracle only, COALESCE for broader use
INSERT INTO ansökan (diarienummer, sun5_kod, seqf_kod, anordnare_id, utbildningsnamn, beslut, yh_poäng, studieform, studietakt_procent, sökta_yrkesområde, sökta_utbildningsomgångar, beviljade_utbildningsomgångar, sökta_platser_totalt, beviljade_platser_totalt)
SELECT
    t.diarienummer, t.sun5_inriktning, COALESCE(t.seqf_nivå, 0), a.anordnare_id, t.utbildningsnamn, t.beslut, t.yh_poäng, t.studieform, t.studietakt_#, t.smalt_yrkesområde, t.sökta_utbildningsomgångar, t.beviljade_utbildningsomgångar, t.sökta_platser_totalt, t.beviljade_platser_totalt
FROM
    tabell t
JOIN utbildningsanordnare a ON a.name = TRIM(t.utbildningsanordnare_administr);

INSERT INTO ansökan_kommun (diarienummer, kommun_id)
SELECT
    t.diarienummer, k.kommun_id
FROM
    tabell t
JOIN kommun k ON k.kommun_name = t.kommun;

COMMIT;

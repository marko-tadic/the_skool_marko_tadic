INSERT INTO utbildningsområde (utbildningsområde_id, utbildningsområde_name)
SELECT 
    ROW_NUMBER() OVER (ORDER BY utbildningsområde), utbildningsområde
FROM 
    (SELECT DISTINCT utbildningsområde FROM tabell); 



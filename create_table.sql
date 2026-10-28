DROP TABLE ansökan_kommun CASCADE CONSTRAINTS PURGE;
DROP TABLE ansökan CASCADE CONSTRAINTS PURGE;
DROP TABLE kommun CASCADE CONSTRAINTS PURGE;
DROP TABLE sun5_inriktning CASCADE CONSTRAINTS PURGE;
DROP TABLE lan CASCADE CONSTRAINTS PURGE;
DROP TABLE utbildningsanordnare CASCADE CONSTRAINTS PURGE;
DROP TABLE seqf CASCADE CONSTRAINTS PURGE;
DROP TABLE utbildningsområde CASCADE CONSTRAINTS PURGE;

CREATE TABLE IF NOT EXISTS utbildningsområde (
    utbildningsområde_id INT PRIMARY KEY,
    utbildningsområde_name VARCHAR2(200)
);

CREATE TABLE IF NOT EXISTS seqf (
    seqf_kod INT PRIMARY KEY,
    examenstyp VARCHAR2(200)
);

CREATE TABLE IF NOT EXISTS utbildningsanordnare (
    anordnare_id INT PRIMARY KEY,
    name VARCHAR2(200),
    huvudmannatyp VARCHAR2(200)
);

CREATE TABLE IF NOT EXISTS lan (
    lan_id INT PRIMARY KEY,
    lan_name VARCHAR2(200)
);

CREATE TABLE IF NOT EXISTS sun5_inriktning (
    sun5_kod VARCHAR2(100) PRIMARY KEY,
    utbildningsområde_id INT,
    sun5_namn VARCHAR2(200),    
    CONSTRAINT fk_sun5_utbildningsområde
        FOREIGN KEY (utbildningsområde_id) 
        REFERENCES utbildningsområde(utbildningsområde_id)
);

CREATE TABLE IF NOT EXISTS kommun (
    kommun_id INT PRIMARY KEY,
    kommun_name VARCHAR2(200),
    lan_id INT,
    CONSTRAINT fk_kommun_lan
        FOREIGN KEY (lan_id)
        REFERENCES lan(lan_id)
);

CREATE TABLE ansökan (
    diarienummer VARCHAR2(100) PRIMARY KEY,
    sun5_kod VARCHAR2(100),
    seqf_kod INT,
    anordnare_id INT,
    utbildningsnamn VARCHAR2(200),
    beslut VARCHAR2(50),
    yh_poäng INT,
    studieform VARCHAR2(50),
    studietakt_procent INT,
    sökta_yrkesområde VARCHAR2(200),
    beviljade_utbildningsomgångar INT,
    sökta_platser_totalt INT,
    beviljade_platser_totalt INT,
    CONSTRAINT fk_ansökan_sun5
        FOREIGN KEY (sun5_kod)
        REFERENCES sun5_inriktning(sun5_kod),
    CONSTRAINT fk_ansökan_seqf
        FOREIGN KEY (seqf_kod)
        REFERENCES seqf(seqf_kod),
    CONSTRAINT fk_ansökan_anordnare
        FOREIGN KEY (anordnare_id)
        REFERENCES utbildningsanordnare(anordnare_id)
);

CREATE TABLE IF NOT EXISTS ansökan_kommun (
    ansökan_kommun_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diarienummer VARCHAR2(100),
    kommun_id INT,
    CONSTRAINT fk_ansökan_kommun_ansökan
        FOREIGN KEY (diarienummer)
        REFERENCES ansökan(diarienummer),
    CONSTRAINT fk_ansökan_kommun_kommun
        FOREIGN KEY (kommun_id)
        REFERENCES kommun(kommun_id)
);

EXIT

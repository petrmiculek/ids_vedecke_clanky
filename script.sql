DROP TABLE Person CASCADE CONSTRAINTS; -- osoba
DROP TABLE Institution CASCADE CONSTRAINTS; -- instituce
DROP TABLE Publisher; -- vydavatel
DROP TABLE Article; -- clanek
DROP TABLE Contribution; -- prispevek
DROP TABLE TechnicalReport; -- technicka zprava
DROP TABLE Magazine; -- casopis
DROP TABLE MagazineIssue; -- vydani casopisu
DROP TABLE ArticleShare; -- podil na clanku
DROP TABLE ImpactFactorHistory; -- historie impakt faktoru (casopisu)

CREATE TABLE Person(
    id INT DEFAULT Person_seq.NEXTVAL NOT NULL PRIMARY KEY,
    name_first VARCHAR(31),
    name_last VARCHAR(31),
    email VARCHAR(63),
    research_topic VARCHAR(1023),
    research_keywords VARCHAR(255)
    );

CREATE TABLE ImpactFactorHistory(
    value NUMBER,
    year INT CHECK(year >= 1900),
    magazine_id NUMBER NOT NULL,
    -- foreign key -> magazine
    CONSTRAINT ImpactFactorHistory_Magazine_fk
        FOREIGN KEY (magazine_id) REFERENCES Magazine (id) ON DELETE CASCADE

);

CREATE TABLE Contribution(

);

CREATE TABLE TechnicalReport(

);


CREATE TABLE ArticleShare(
    percentage NUMBER CHECK(percentage > 0 and percentage <= 100) -- non-zero
    -- poradi autoru?
);


CREATE TABLE Magazine(
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(63)
    -- impact factor history (separate table)
);


CREATE TABLE MagazineIssue(

);


CREATE TABLE Article(
    id INT NOT NULL PRIMARY KEY, -- document object identifier
    name VARCHAR(63)


);

CREATE TABLE Publisher(
    name_company VARCHAR(31) NOT NULL PRIMARY KEY,
    name_owner VARCHAR(63)

);



CREATE TABLE Institution (
  id INT NOT NULL PRIMARY KEY,
  person_id INT NOT NULL,
  CONSTRAINT institution_person_fk
    FOREIGN KEY (person_id) REFERENCES Person (id) ON DELETE CASCADE
);

INSERT INTO Institution
--VALUES(2300, 'Peter', 'mailik@a.com', 'vyskum o nicom', 'nicota, nic, hh');

SELECT *
FROM Institution;
DROP TABLE Person CASCADE CONSTRAINTS; -- osoba
DROP TABLE Institution CASCADE CONSTRAINTS; -- instituce
DROP TABLE Publisher; -- vydavatel
DROP TABLE Article; -- clanek
DROP TABLE Magazine; -- casopis
DROP TABLE MagazineIssue; -- vydani casopisu
DROP TABLE Share; -- podil
DROP TABLE Contribution; -- prispevek
DROP TABLE ImpactFactorHistory; -- historie impakt faktoru

CREATE TABLE Person(
    id INT DEFAULT Person_seq.NEXTVAL NOT NULL PRIMARY KEY,
    name_first VARCHAR(31),
    name_last VARCHAR(31),
    email VARCHAR(63),
    research_topic VARCHAR(1023),
    research_keywords VARCHAR(255)
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
DROP TABLE Person CASCADE CONSTRAINTS;
DROP TABLE Institution CASCADE CONSTRAINTS;

CREATE TABLE Person(
    ID INTEGER,

    PRIMARY KEY (ID)
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
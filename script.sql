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

DROP SEQUENCE Person_seq;

CREATE SEQUENCE Person_seq
    START WITH 100000
    INCREMENT BY 1;


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
    id INT NOT NULL PRIMARY KEY,
    institution_id INT NOT NULL,

    CONSTRAINT techRep_id_fk
        FOREIGN KEY (id) REFERENCES Article (id) ON DELETE CASCADE,

    CONSTRAINT techRep_institution_fk
        FOREIGN KEY (institution_id) REFERENCES Institution (code) ON DELETE CASCADE
);


CREATE TABLE ArticleShare(
    author_id INT NOT NULL,
    article_id INT NOT NULL,
    author_order INT NOT NULL, -- poradi autora, najit vhodnejsi oznaceni
    percentage NUMBER CHECK(percentage > 0 and percentage <= 100), -- non-zero
    -- ma smysl na urovni SQL hlidat Suma(percentage) == 100?

    CONSTRAINT ArticleShare_Person_fk
        FOREIGN KEY (author_id) REFERENCES Person (id) ON DELETE CASCADE,
        -- on delete nemusi byt cascade?

    CONSTRAINT ArticleShare_Article_fk
        FOREIGN KEY (article_id) REFERENCES Article (id) ON DELETE CASCADE


);


CREATE TABLE Magazine(
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(63),
    publisher_id INT NOT NULL,
    CONSTRAINT ImpactFactorHistory_Magazine_fk
        FOREIGN KEY (publisher_id) REFERENCES Publisher (id) ON DELETE CASCADE

    -- (Magazine is referenced by impact factor history)
);


CREATE TABLE MagazineIssue(
    id INT NOT NULL PRIMARY KEY,
    date_published DATE,
    impact_factor_value NUMBER -- decimal value?
    -- also, does the attribute make sense together with table ImpactFactorHistory?
);


CREATE TABLE Article(
    id INT NOT NULL PRIMARY KEY, -- document object identifier
    name VARCHAR(63)


);

CREATE TABLE Publisher(
    id INT NOT NULL PRIMARY KEY,
    name_company VARCHAR(31) NOT NULL,
    name_owner VARCHAR(63)

);



CREATE TABLE Institution (
  code INT NOT NULL PRIMARY KEY,
  person_id INT NOT NULL,
  CONSTRAINT institution_person_fk
    FOREIGN KEY (person_id) REFERENCES Person (id) ON DELETE CASCADE
);

INSERT INTO Person
    VALUES(DEFAULT, 'Tibor', 'Kubik', 'tiborkubik1@gmail.com', 'Machine learning for computational haplotype analysis', 'AI, bioinformatics, genes, machine learning');
INSERT INTO Institution
    VALUES (432, 105);

SELECT *
FROM Person;

SELECT *
FROM Institution;

-- TODO
-- NOT NULL constraints - check existing, add further?
-- SEQUENCE for primary keys generation
-- ON DELETE .___. - check existing, discuss

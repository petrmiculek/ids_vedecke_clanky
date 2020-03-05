DROP SEQUENCE Person_seq;
DROP SEQUENCE Author_order_seq;

DROP TABLE Institution CASCADE CONSTRAINTS;                         -- instituce
DROP TABLE Person CASCADE CONSTRAINTS;                              -- osoba
DROP TABLE Article CASCADE CONSTRAINTS;                             -- clanek
DROP TABLE ArticleShare CASCADE CONSTRAINTS;                        -- podil na clanku
DROP TABLE Publisher CASCADE CONSTRAINTS;                           -- vydavatel
DROP TABLE Magazine CASCADE CONSTRAINTS;                            -- casopis
DROP TABLE ImpactFactorHistory CASCADE CONSTRAINTS;                 -- historie impakt faktoru (casopisu)
DROP TABLE TechnicalReport CASCADE CONSTRAINTS;                     -- technicka zprava
DROP TABLE MagazineIssue CASCADE CONSTRAINTS;                       -- vydani casopisu
DROP TABLE Contribution CASCADE CONSTRAINTS;                        -- prispevek
DROP TABLE Citation CASCADE CONSTRAINTS;                            -- citace (clanku)


CREATE SEQUENCE Person_seq
    START WITH 100000
    INCREMENT BY 1;

CREATE SEQUENCE Author_order_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE Institution (
    code INT NOT NULL PRIMARY KEY,
    name VARCHAR(63)
);

CREATE TABLE Person(
    id INT DEFAULT Person_seq.NEXTVAL NOT NULL PRIMARY KEY,
    name_first VARCHAR(31),
    name_last VARCHAR(31),
    email VARCHAR(63),
    research_topic VARCHAR(1023),
    research_keywords VARCHAR(255),

    institution_id INT NOT NULL,

    CONSTRAINT Institution_Person_fk
        FOREIGN KEY (institution_id) REFERENCES Institution (code) ON DELETE CASCADE
);



CREATE TABLE Article(
    id INT NOT NULL PRIMARY KEY, -- document object identifier
    article_name VARCHAR(63)
    --- missing author???
);

CREATE TABLE ArticleShare(
    author_id INT NOT NULL,
    article_id INT NOT NULL,
    author_order INT DEFAULT Author_order_seq.NEXTVAL, -- poradi autora, najit vhodnejsi oznaceni
                                                       -- treba domysliet, order treba byt vzdy od 1 pre kazdy clanok zvlast
    percentage NUMBER CHECK(percentage > 0 and percentage <= 100), -- non-zero
    -- ma smysl na urovni SQL hlidat Suma(percentage) == 100?

    CONSTRAINT ArticleShare_Person_fk
        FOREIGN KEY (author_id) REFERENCES Person (id) ON DELETE CASCADE,
        -- on delete nemusi byt cascade?

    CONSTRAINT ArticleShare_Article_fk
        FOREIGN KEY (article_id) REFERENCES Article (id) ON DELETE CASCADE
);


CREATE TABLE Publisher(
    id INT NOT NULL PRIMARY KEY,
    name_company VARCHAR(31) UNIQUE NOT NULL, -- vydavatel je identifikovan jmenem
    name_owner VARCHAR(63)

);

CREATE TABLE Magazine(
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(63), -- not unique on purpose
    publisher_id INT NOT NULL UNIQUE,
    CONSTRAINT Magazine_Publisher_fk
        FOREIGN KEY (publisher_id) REFERENCES Publisher (id) ON DELETE CASCADE

    -- (Magazine is referenced by impact factor history)
);

CREATE TABLE ImpactFactorHistory(
    value NUMBER,
    year INT CHECK(year >= 1900),
    magazine_id NUMBER NOT NULL,
    -- foreign key -> magazine
    CONSTRAINT ImpactFactorHistory_Magazine_fk
        FOREIGN KEY (magazine_id) REFERENCES Magazine (id) ON DELETE CASCADE

);

CREATE TABLE TechnicalReport(
    id INT NOT NULL PRIMARY KEY,
    institution_id INT NOT NULL,

    CONSTRAINT TechRep_Article_fk -- generalization relationship
        FOREIGN KEY (id) REFERENCES Article (id) ON DELETE CASCADE,

    CONSTRAINT TechRep_Institution_fk
        FOREIGN KEY (institution_id) REFERENCES Institution (code) ON DELETE CASCADE
);

CREATE TABLE MagazineIssue(
    id INT NOT NULL ,
    date_published DATE,
    magazine_id INT NOT NULL,
    year INT CHECK (year >= 1900), -- possible trigger, currently is a duplicate value
    issue_number INT CHECK (issue_number > 0), -- within a year

    impact_factor_value NUMBER, -- decimal value?
    -- also, does the attribute make sense together with table ImpactFactorHistory?

    PRIMARY KEY (year, issue_number),

    CONSTRAINT Issue_Magazine_fk
        FOREIGN KEY (magazine_id) REFERENCES Magazine (id) ON DELETE CASCADE
);

CREATE TABLE Contribution(
    id INT NOT NULL PRIMARY KEY,
    magazine_id INT NOT NULL,       -- added magazine id. When it was primary, it wasnt possible to
                                    -- add more contributions referencing 1 magazine
    magazine_issue_year INT NOT NULL,
    magazine_issue_number INT NOT NULL,

    CONSTRAINT Contribution_Article_fk -- generalization relationship
        FOREIGN KEY (magazine_id) REFERENCES Article (id) ON DELETE CASCADE,

    CONSTRAINT Contribution_MagazineIssue_fk
        FOREIGN KEY (magazine_issue_year, magazine_issue_number) REFERENCES MagazineIssue (year, issue_number) ON DELETE CASCADE
);

CREATE TABLE Citation(
    id INT NOT NULL PRIMARY KEY, -- musi mit tabulka primarni klic?
    id_citing_contribution INT NOT NULL,
    id_cited_article INT NOT NULL,

    CONSTRAINT Citation_Contribution_citing_fk
        FOREIGN KEY (id_citing_contribution) REFERENCES Contribution (id) ON DELETE CASCADE,

    CONSTRAINT Citation_Article_cited_fk
        FOREIGN KEY (id_cited_article) REFERENCES Article (id) ON DELETE CASCADE
);

----------------------------------------------------------------------------------------------
INSERT INTO Institution
    VALUES(105, 'Institution of Bioinformatics in Prague');
INSERT INTO Institution
    VALUES(106, 'European Institute of Absurd Articles');

INSERT INTO Person
    VALUES(DEFAULT, 'Emma', 'Clarkson', 'emma@gclarkson.com', 'Machine learning for computational haplotype analysis', 'AI, bioinformatics, genes, machine learning', 105);
INSERT INTO Person
    VALUES(DEFAULT, 'Patrick', 'Chimney', 'pchimney@google.com', 'Measurement of absurdity of European articles', 'EU, articles, absurd articles', 106);

INSERT INTO Article
    VALUES(567, 'Locus classification in chromosome');
INSERT INTO Article
    VALUES(672, 'Blah-blah article');

INSERT INTO ArticleShare
    VALUES(100000, 567, DEFAULT, 40);
INSERT INTO ArticleShare
    VALUES(100001, 567, DEFAULT, 60);
INSERT INTO ArticleShare
    VALUES(100001, 672, DEFAULT, 100);

INSERT INTO TechnicalReport
    VALUES(567, 105);

INSERT INTO Publisher
    VALUES(300, 'Best Publishers Ever (BPE)', 'Mark Fitch');
INSERT INTO Publisher
    VALUES(301, 'Independent European Publishers', 'Emily Aldrin');

INSERT INTO Magazine
    VALUES(555, 'First Magazine', 300);
INSERT INTO Magazine
    VALUES(556, 'Tech Mag', 301);

INSERT INTO MagazineIssue
    VALUES(1, '30-November-2019', 555, 2019, 1, 4.5);
INSERT INTO MagazineIssue
    VALUES(2, '11-December-2019', 555, 2019, 2, 1.3);

-- INSERT ImpactFactorHistory


INSERT INTO Contribution
    VALUES(1, 567, 2019, 1);
INSERT INTO Contribution
    VALUES(2, 567, 2019, 1);

INSERT INTO Citation
    VALUES(1, 2, 567);
INSERT INTO Citation
    VALUES(2, 1, 672);
-- invalid insert - institution does not exist
--INSERT INTO Person
--    VALUES(DEFAULT, 'AAA', 'BBB', 'tiborkubik1@gmail.com', 'Machine learning for computational haplotype analysis', 'AI, bioinformatics, genes, machine learning', 104);


SELECT *
FROM Institution;

SELECT *
FROM Person;

SELECT *
FROM Article;

SELECT *
FROM ArticleShare;

SELECT *
FROM TechnicalReport;

SELECT *
FROM Publisher;

SELECT *
FROM Magazine;

SELECT *
FROM MagazineIssue;

SELECT *
FROM Contribution;

SELECT *
FROM Citation;


-- TODO
-- SEQUENCE for primary keys generation

-- NOT NULL constraints - check existing, add further?
-- ON DELETE .___. - check existing, discuss

-- zjistit, co dělá CASCADE CONSTRAINTS u DROPů

-- composite foreign key

-- otestovat vkládání příspěvku, technické zprávy a samotného článku (bez specializace)

-- year + number je primary key, ale year by se dal vytáhnout z atributu 'date'

DROP DATABASE IF EXISTS mananTest;
SHOW DATABASES;
CREATE DATABASE mananTest;
USE mananTest;

CREATE TABLE friends(
	roll_no INT PRIMARY KEY,
	name varchar(20) NOT NULL,
	emailid varchar(50) UNIQUE,
	rating INT
	);

SHOW TABLES;

DESCRIBE friends;

INSERT INTO friends VALUES 
(170101035,'Manan Gupta','manan170101035@iitg.ac.in',2008),
(170101009,'Anubhav Tyagi','tyagi170101009@iitg.ac.in',1805),
(170101038,'Mayank Wadhwani','mayan170101038@iitg.ac.in',1605),
(170101053,'Ravi Shankar',NULL,1805);

INSERT INTO friends VALUES  (170101037,'Manan Gupta','',2009);
INSERT INTO friends VALUES  (170101036,'Manan Gupta',NULL,2009);

SELECT * FROM friends WHERE name = 'Manan Gupta' && rating = 2009;

DELETE FROM friends WHERE rating = 2009;

SELECT * FROM friends;

UPDATE friends SET rating = 1203 where name = 'Anubhav Tyagi';

SELECT * FROM friends;

ALTER TABLE friends drop emailid;

SELECT * FROM friends;

DROP TABLE friends;

DROP DATABASE mananTest;
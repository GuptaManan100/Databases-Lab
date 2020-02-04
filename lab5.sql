DROP DATABASE IF EXISTS Lab5;
CREATE DATABASE Lab5;
USE Lab5;

CREATE TABLE Department(
	dept_id  int,
	depat_name varchar(50) NOT NULL,
	PRIMARY KEY (dept_id)
);
LOAD DATA LOCAL INFILE  'department.csv'
INTO TABLE Department
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Course(
	course_id int, 
	intake INT NOT NULL,
	couse_name varchar(50) NOT NULL UNIQUE,
	course_type ENUM('LAB','CLASS') NOT NULL,
	room varchar(20) NOT NULL,
	offered_by int NOT NULL,
	since int NOT NULL,
	FOREIGN KEY (offered_by) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (course_id)
);
LOAD DATA LOCAL INFILE  'Course_Offered.csv'
INTO TABLE Course
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Professor(
	prof_id int,
	prof_name varchar(50) NOT NULL,
	sex ENUM('M','F') NOT NULL,
	worksIn int NOT NULL,
	researchArea varchar(20),
	course_taught int,
	PRIMARY KEY (prof_id),
	FOREIGN KEY (worksIn) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (course_taught) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
LOAD DATA LOCAL INFILE  'Prof_Dept_Course.csv'
INTO TABLE Professor
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Dependant(
	prof_id int,
	dependant_name varchar(20),
	age INT,
	PRIMARY KEY(dependant_name,prof_id),
	FOREIGN KEY(prof_id) REFERENCES Professor(prof_id) ON DELETE CASCADE ON UPDATE CASCADE
);
LOAD DATA LOCAL INFILE  'dependent.csv'
INTO TABLE Dependant
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- CREATE TABLE researchArea(
-- 	areaName varchar(20),
-- 	prof_id int,
-- 	PRIMARY KEY(areaName, prof_id),
-- 	FOREIGN KEY(prof_id) REFERENCES Professor(prof_id) ON DELETE CASCADE ON UPDATE CASCADE
-- );

-- CREATE TABLE Schedule(
-- 	day varchar(20),
-- 	stTime TIME(0),
-- 	enTime TIME(0),
-- 	PRIMARY KEY (day,stTime,enTime)
-- );


CREATE TABLE ScheduledOn(
	course_id int, 
	day varchar(20),
	stTime TIME(0),
	enTime TIME(0),
	PRIMARY KEY (day,stTime,enTime,course_id),
	FOREIGN KEY(course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);

LOAD DATA LOCAL INFILE  'Scheduled_On.csv'
INTO TABLE Dependant
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Student(
	stud_id int,
	Name varchar(50),
	belongs_to int NOT NULL,
	FOREIGN KEY (belongs_to) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(stud_id)
);
LOAD DATA LOCAL INFILE  'Student_Record.csv'
INTO TABLE Student
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Attends(
	stud_id int NOT NULL,
	course_id int NOT NULL,
	grade int NOT NULL,
	FOREIGN KEY(course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(stud_id) REFERENCES Student(stud_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(stud_id,course_id)
);
LOAD DATA LOCAL INFILE  'Stud_Course.csv'
INTO TABLE Attends
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Queries
-- 1
CREATE VIEW MaxScores(course_id, grade) AS SELECT course_id, MAX(grade) FROM Attends GROUP BY course_id;
CREATE VIEW Toppers AS SELECT course_id, stud_id FROM Attends NATURAL JOIN MaxScores;
SELECT course_id, Name FROM Student NATURAL JOIN Toppers;

-- 2
CREATE VIEW TotalGP(stud_id, grade) AS SELECT stud_id, SUM(grade) FROM Attends GROUP BY stud_id;
CREATE VIEW TEM1 AS SELECT * FROM TotalGP WHERE grade>=20 AND grade<=30;
SELECT Name FROM Student NATURAL JOIN TEM1;

-- 3
CREATE VIEW CsMnc AS SELECT dept_id FROM Department WHERE depat_name = 'CSE' OR depat_name = 'MATHS';
CREATE VIEW CsMncProfs AS SELECT prof_id, dept_id FROM Professor JOIN CsMnc ON Professor.worksIn = CsMnc.dept_id;
SELECT dependant_name, prof_id FROM Dependant NATURAL JOIN CsMncProfs;

-- 4
CREATE VIEW Prof AS SELECT prof_id, prof_name, researchArea FROM Professor;
-- a
SELECT * FROM Prof WHERE researchArea = 'ML';
-- b
SELECT researchArea, COUNT(*) AS 'Number of Professors' FROM Prof GROUP BY researchArea;
-- c
UPDATE Prof SET researchArea = 'DS' WHERE researchArea = 'ML';
-- d
SELECT prof_id, prof_name FROM Professor WHERE researchArea = 'ML';

-- 5
CREATE VIEW DepProf AS SELECT prof_id, prof_name, dept_id, depat_name FROM Department JOIN Professor ON Department.dept_id = Professor.worksIn;
CREATE VIEW DepProfWith AS SELECT prof_id, prof_name, dept_id, depat_name FROM Department JOIN Professor ON Department.dept_id = Professor.worksIn WITH CHECK OPTION;

UPDATE DepProfWith SET depat_name = 'CSE' WHERE prof_name = 'SAMBIT PATRA';
UPDATE DepProf SET depat_name = 'CSE' WHERE prof_name = 'SAMBIT PATRA';

DROP DATABASE IF EXISTS Lab6;
CREATE DATABASE Lab6;
USE Lab6;

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
DELIMITER $$

DROP PROCEDURE IF EXISTS getProfessorsByDept $$
CREATE PROCEDURE getProfessorsByDept(IN deptname varchar(50) )
BEGIN
	SELECT prof_id, prof_name FROM Professor WHERE worksIn IN (SELECT dept_id FROM Department WHERE depat_name = deptname);
END $$

DROP PROCEDURE IF EXISTS getCPI $$
CREATE PROCEDURE getCPI(IN studid INT, OUT cpi REAL)
BEGIN
	SELECT AVG(grade) INTO cpi FROM Attends WHERE stud_id = studid;
END $$

DROP PROCEDURE IF EXISTS getGrade $$
CREATE PROCEDURE getGrade(IN studid INT, IN courseid INT, OUT grad varchar(30))
BEGIN
	DECLARE g INT DEFAULT 10;
	SELECT grade INTO g FROM Attends WHERE stud_id = studid AND course_id = courseid;
	CASE g
		WHEN 1 THEN 
			SET grad = 'Fail';
		WHEN 2 THEN 
			SET grad = 'Fail';
		WHEN 3 THEN 
			SET grad = 'Fail';
		WHEN 4 THEN 
			SET grad = 'Fail';
		WHEN 5 THEN 
			SET grad = 'CD';
		WHEN 6 THEN 
			SET grad = 'CC';
		WHEN 7 THEN 
			SET grad = 'BC';
		WHEN 8 THEN 
			SET grad = 'BB';
		WHEN 5 THEN 
			SET grad = 'AB';
		ELSE
			set grad = 'AA';
	END CASE;
END $$

DROP PROCEDURE IF EXISTS getCount $$
CREATE PROCEDURE getCount(IN coursename varchar(50), OUT coun INT)
BEGIN
	DECLARE count INT DEFAULT 0;
	SELECT COUNT(DISTINCT stud_id) INTO count FROM Attends WHERE course_id IN (SELECT course_id FROM Course WHERE couse_name = coursename);

	SET coun = count;
END $$

DELIMITER ;
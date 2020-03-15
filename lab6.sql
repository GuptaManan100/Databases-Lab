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
		WHEN 9 THEN 
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

DROP PROCEDURE IF EXISTS getProfessorsBySex $$
CREATE PROCEDURE getProfessorsBySex(IN value INT )
BEGIN
	IF value = 0 THEN
		SELECT * FROM Professor WHERE sex = 'F';
	ELSEIF value = 1 THEN
		SELECT * FROM Professor WHERE sex = 'M';
	ELSE
		SELECT 'invalid input';
	END IF;
END $$

DROP PROCEDURE IF EXISTS factorial $$
CREATE PROCEDURE factorial(IN value INT , OUT fact INT)
BEGIN
	IF value < 0 THEN
		SELECT 'invalid input';
	END IF;

	SET fact = 1;
	
	l1 : LOOP
		IF value = 0 THEN
			LEAVE l1;
		END IF;
		SET fact = fact * value;
		SET value = value - 1;
	END LOOP;
END $$

DROP PROCEDURE IF EXISTS getGiftAmount $$
CREATE PROCEDURE getGiftAmount(IN profid INT , OUT gift INT)
BEGIN
	DECLARE x INT DEFAULT 0;
	SELECT COUNT(*) INTO x FROM Dependant WHERE prof_id = profid;
	IF x>5 THEN
		SET x = 6;
	END IF;
	SET gift = x*1000 + 1000;
	IF x =0 THEN
		SET gift = 0;
	END IF;
END $$

DROP PROCEDURE IF EXISTS q41 $$
CREATE PROCEDURE q41(IN temp INT , IN step INT)
BEGIN
	SET temp = temp + step;
END $$

DROP PROCEDURE IF EXISTS q42 $$
CREATE PROCEDURE q42(OUT temp INT , IN step INT)
BEGIN
	SET temp = temp + step;
END $$

DROP PROCEDURE IF EXISTS q43 $$
CREATE PROCEDURE q43(INOUT temp INT , IN step INT)
BEGIN
	SET temp = temp + step;
END $$

DROP PROCEDURE IF EXISTS q51 $$
CREATE PROCEDURE q51(IN temp INT , IN step INT)
BEGIN
	DECLARE x INT;
	SET x = temp + step;
	SELECT COUNT(*) FROM Attends WHERE grade = temp;
	SELECT temp,x;

	UPDATE Attends Set grade = x WHERE grade = temp;
	SELECT COUNT(*) FROM Attends WHERE grade = temp;
	SELECT temp,x;
END $$

DROP PROCEDURE IF EXISTS q52 $$
CREATE PROCEDURE q52(OUT temp INT , IN step INT)
BEGIN
	DECLARE x INT;
	SET x = temp + step;
	SELECT COUNT(*) FROM Attends WHERE grade = temp;
	SELECT temp,x;

	UPDATE Attends Set grade = x WHERE grade = temp;
	SELECT COUNT(*) FROM Attends WHERE grade = temp;
	SELECT temp,x;
END $$

DROP PROCEDURE IF EXISTS q53 $$
CREATE PROCEDURE q53(INOUT temp INT , IN step INT)
BEGIN
	DECLARE x INT;
	SET x = temp + step;
	SELECT COUNT(*) FROM Attends WHERE grade = temp;
	SELECT temp,x;

	UPDATE Attends Set grade = x WHERE grade = temp;
	SELECT COUNT(*) FROM Attends WHERE grade = temp;
	SELECT temp,x;
END $$

DROP PROCEDURE IF EXISTS getNoProfInRA $$
CREATE PROCEDURE getNoProfInRA(IN ra varchar(20) , OUT count INT)
BEGIN
	SELECT COUNT(*) INTO count FROM Professor WHERE researchArea = ra; 
END $$
DELIMITER ;


CALL getProfessorsBySex(0);
CALL getProfessorsBySex(1);
CALL getProfessorsBySex(2);

CALL factorial(5, @fact);
SELECT @fact;
CALL factorial(7, @fact);
SELECT @fact;

CALL getGiftAmount(1207, @gift);
SELECT @gift;
CALL getGiftAmount(1, @gift);
SELECT @gift;
CALL getGiftAmount(1206, @gift);
SELECT @gift;

SET @temp = 7;
SET @step = 1;
CALL q41(@temp,@step);
SELECT @temp;

SET @temp = 7;
SET @step = 1;
CALL q42(@temp,@step);
SELECT @temp;

SET @temp = 7;
SET @step = 1;
CALL q43(@temp,@step);
SELECT @temp;

SET @temp = 4;
SET @step = 1;
CALL q51(@temp,@step);

SET @temp = 7;
SET @step = 1;
CALL q52(@temp,@step);

SET @temp = 9;
SET @step = 1;
CALL q53(@temp,@step);

SET @count = 0;
CALL getNoProfInRA('SPEECH',@count);
SELECT @count;
CALL getNoProfInRA('DS',@count);
SELECT @count;

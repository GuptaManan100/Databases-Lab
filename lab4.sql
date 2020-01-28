DROP DATABASE IF EXISTS Lab4;
CREATE DATABASE Lab4;
USE Lab4;

CREATE TABLE Department(
	dept_id  varchar(20),
	depat_name varchar(50) NOT NULL UNIQUE,
	PRIMARY KEY (dept_id)
);

INSERT INTO Department VALUES
('CSE','Computer Science and Engineering'),
('MnC','Maths And Computing'),
('EP','Engineering Physics');

CREATE TABLE Course(
	course_id varchar(20), 
	intake INT NOT NULL,
	couse_name varchar(50) NOT NULL UNIQUE,
	course_type ENUM('lab','theory') NOT NULL,
	room varchar(20) NOT NULL,
	since DATE NOT NULL,
	offered_by varchar(20) NOT NULL,
	FOREIGN KEY (offered_by) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (course_id)
);

INSERT INTO Course VALUES
('CS345',88,'Data Structures','theory','L1','00:01:01','CSE'),
('CS346',88,'Data Structures Lab','lab','Lab 1','01:01:01','CSE'),
('CS347',168,'Discrete Mathematics','theory','L1','06:11:12','CSE'),
('CS101',240,'Introduction to Computing','theory','L2','01:01:01','CSE'),
('CS102',240,'Programming Lab','lab','Lab 3','01:01:01','CSE'),
('MA101',240,'Real Analysis','theory','L3','00:01:01','MnC'),
('MA201',168,'Calculus','theory','5001','00:01:01','MnC'),
('MA326',88,'Finance','theory','5002','01:01:01','MnC');

CREATE TABLE Professor(
	prof_id varchar(20),
	prof_name varchar(50) NOT NULL,
	sex ENUM('male','female') NOT NULL,
	worksIn varchar(20) NOT NULL,
	PRIMARY KEY (prof_id),
	FOREIGN KEY (worksIn) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Professor VALUES
('AWA','Amit Awekar','male','CSE'),
('MPA','Moumita Patra','female','CSE'),
('CKF','Chandan Karfa','male','CSE'),
('ASA','Ashish Anand','male','CSE'),
('SMS','Subhamay Saha','male','MnC'),
('AKC','Anjan K C','male','MnC'),
('APS','Anumpam Saikia','male','MnC'),
('SCK','Sovan Chakraborty','male','EP'),
('UDR','Udit Raha','male','EP');

CREATE TABLE Dependant(
	age INT,
	dependant_name varchar(20),
	prof_id varchar(20) NOT NULL,
	PRIMARY KEY(dependant_name,prof_id),
	FOREIGN KEY(prof_id) REFERENCES Professor(prof_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Dependant VALUES
(64,'Rakesh Jana','AWA'),
(68,'Ramesh Srivastava','AWA'),
(64,'Nehal Deep','AWA'),
(41,'Aman Sharma','MPA'),
(12,'Parth Chawla','CKF'),
(4,'Shreyansh Sinha','MPA');

CREATE TABLE researchArea(
	areaName varchar(20),
	prof_id varchar(20),
	PRIMARY KEY(areaName, prof_id),
	FOREIGN KEY(prof_id) REFERENCES Professor(prof_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO researchArea VALUES
('VLSI','AWA'),
('VLSI','MPA'),
('VLSI','SMS'),
('System Design','AKC'),
('System Design','APS'),
('System Design','SCK'),
('ML','AWA'),
('ML','UDR'),
('ML','ASA'),
('Data Mining','ASA'),
('Data Mining','MPA'),
('AI','SMS'),
('AI','ASA'),
('AI','CKF');

CREATE TABLE Schedule(
	day varchar(20),
	stTime TIME(0),
	enTime TIME(0),
	PRIMARY KEY (day,stTime,enTime)
);

INSERT INTO Schedule VALUES
('Monday','14:00:00','17:00:00'),
('Tuesday','09:00:00','10:00:00'),
('Monday','09:00:00','10:00:00'),
('Wednesday','14:00:00','15:00:00'),
('Thursday','14:00:00','17:00:00'),
('Friday','14:00:00','17:00:00');

CREATE TABLE ScheduledOn(
	course_id varchar(20), 
	day varchar(20),
	stTime TIME(0),
	enTime TIME(0),
	PRIMARY KEY (day,stTime,enTime,course_id),
	FOREIGN KEY(course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (day,stTime,enTime) REFERENCES Schedule(day,stTime,enTime) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO ScheduledOn VALUES
('CS345','Tuesday','09:00:00','10:00:00'),
('CS345','Monday','09:00:00','10:00:00'),
('CS347','Tuesday','09:00:00','10:00:00'),
('CS346','Monday','14:00:00','17:00:00'),
('CS346','Thursday','14:00:00','17:00:00'),
('CS101','Wednesday','14:00:00','15:00:00'),
('CS102','Thursday','14:00:00','17:00:00'),
('CS102','Friday','14:00:00','17:00:00'),
('MA101','Monday','09:00:00','10:00:00'),
('MA201','Wednesday','14:00:00','15:00:00'),
('MA326','Wednesday','14:00:00','15:00:00');

CREATE TABLE Teaches(
	course_id varchar(20),
	prof_id varchar(20),
	PRIMARY KEY(course_id,prof_id),
	FOREIGN KEY(course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(prof_id) REFERENCES Professor(prof_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Teaches VALUES
('CS345','AWA'),
('CS345','ASA'),
('CS347','MPA'),
('CS346','CKF'),
('CS346','ASA'),
('CS101','AWA'),
('CS102','ASA'),
('CS102','CKF'),
('MA101','SMS'),
('MA201','AKC'),
('MA326','APS');

CREATE TABLE Student(
	stud_id int,
	Name varchar(50),
	belongs_to varchar(20) NOT NULL,
	FOREIGN KEY (belongs_to) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(stud_id)
);

INSERT INTO Student VALUES
(170101035,'Manan Gupta','CSE'),
(170101009,'Anubhav Tyagi','CSE'),
(170101038,'Mayank Wadhwani','CSE'),
(170101053,'Ravi Shankar','CSE'),
(170123039,'Mriganka Basu Roy Chaudhary','MnC');

CREATE TABLE Attends(
	stud_id int NOT NULL,
	course_id varchar(20) NOT NULL,
	grade int NOT NULL,
	FOREIGN KEY(course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(stud_id) REFERENCES Student(stud_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(stud_id,course_id)
);

INSERT INTO Attends VALUES
(170101035,'CS101',10),
(170101035,'CS102',9),
(170101035,'CS347',10),
(170101035,'CS346',10),
(170101038,'CS345',8),
(170101038,'CS346',9),
(170101038,'CS347',7),
(170101009,'CS345',7),
(170101009,'CS102',9),
(170101009,'CS347',6),
(170101009,'CS101',8),
(170123039,'MA326',10),
(170123039,'MA101',10),
(170123039,'MA201',10);


#Queries

SELECT worksIn AS 'Department ID', COUNT(*) AS 'Number of Professors' FROM Professor GROUP BY worksIn;

SELECT course_id FROM Course WHERE intake = (SELECT MAX(intake) FROM Course);

SELECT worksIn AS 'Department ID', COUNT(*) AS 'Number of Professors' FROM Professor GROUP BY worksIn ORDER BY COUNT(*) DESC;

SELECT day, COUNT(*) AS 'Number of Courses' FROM ScheduledOn GROUP BY day ORDER BY COUNT(*) DESC;

SELECT stud_id, AVG(grade) FROM Attends GROUP BY stud_id;

##Extra Query
SELECT A.Name, B.CPI FROM Student A JOIN (SELECT stud_id, AVG(grade) AS 'CPI' FROM Attends GROUP BY stud_id) AS B USING(stud_id) ORDER BY CPI DESC;
#OR
SELECT stud_id,A.Name, B.CPI FROM Student A NATURAL JOIN (SELECT stud_id, AVG(grade) AS 'CPI' FROM Attends GROUP BY stud_id) AS B ORDER BY CPI DESC;

SELECT DISTINCT depat_name FROM Department JOIN (SELECT * FROM Course WHERE room = 'L1' OR room ='L2' OR room='L3') AS A ON Department.dept_id = A.offered_by;

SELECT prof_name FROM Professor JOIN Department ON Department.dept_id = Professor.worksIn WHERE depat_name = 'Computer Science and Engineering';

SELECT prof_id, prof_name FROM Professor NATURAL JOIN (SELECT * FROM Teaches WHERE course_id = 'CS345') AS A;

SELECT DISTINCT depat_name FROM Department NATURAL JOIN (SELECT offered_by AS 'dept_id' FROM Course NATURAL JOIN (SELECT * FROM ScheduledOn WHERE stTime = '14:00:00' AND enTime = '15:00:00') AS A)AS B;


#EVALUATION QUERIES

SELECT day AS 'Day', offered_by AS 'Department', COUNT(*) AS 'Number of Courses Scheduled' FROM Course NATURAL JOIN (SELECT course_id, day FROM ScheduledOn) AS A GROUP BY offered_by, day;

SELECT age, COUNT(*) AS 'Dependants with this age' FROM Dependant GROUP BY age HAVING age>40;

SELECT stud_id, Name, A.T AS 'Total Grade' FROM Student NATURAL JOIN (SELECT stud_id, SUM(grade) AS T FROM Attends GROUP BY stud_id HAVING SUM(grade)>=20 AND SUM(grade)<=30) AS A; 

SELECT course_id FROM Course WHERE since = (SELECT MIN(since) FROM Course);

SELECT stud_id, Name, B.course_id FROM Student NATURAL JOIN (SELECT stud_id, A.course_id FROM Attends INNER JOIN (SELECT course_id, MAX(grade) AS T FROM Attends GROUP BY course_id) AS A ON A.course_id = Attends.course_id AND A.T = Attends.grade) AS B;

SELECT Name, course_id FROM Student LEFT JOIN Attends ON Attends.stud_id = Student.stud_id;

SELECT dependant_name, age FROM Dependant NATURAL JOIN (SELECT * FROM Professor) AS A WHERE prof_name = 'Amit Awekar';

SELECT prof_id, prof_name FROM Professor NATURAL JOIN (SELECT DISTINCT prof_id FROM researchArea WHERE areaName = 'Data Mining' OR areaName = 'ML') AS A;


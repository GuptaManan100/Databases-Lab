DROP DATABASE IF EXISTS Lab3;
CREATE DATABASE Lab3;
USE Lab3;

CREATE TABLE Department(
    dept_id  varchar(20),
    depat_name varchar(50),
    PRIMARY KEY (dept_id)
);

INSERT INTO Department VALUES
('CSE','Computer Science and Engineering'),
('MNC', 'Maths And Computing');

CREATE TABLE Professor(
    prof_id varchar(20),
    prof_name varchar(20),
    sex ENUM('Male','Female'),
    worksIn varchar(20),
    PRIMARY KEY (prof_id),
    FOREIGN KEY (worksIn) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Professor VALUES
('MPA','Moumita','Female','CSE'),
('AWA','Amit','Male','CSE'),
('AMA','Aman','Male','MNC'),
('MAY','Mayank','Male','MNC'),
('ANU','Anubhav','Male','MNC');

CREATE TABLE Dependents(
    age INT,
    dependent_name varchar(20),
    prof_id varchar(20),
    PRIMARY KEY(dependent_name,prof_id),
    FOREIGN KEY(prof_id) REFERENCES Professor(prof_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Dependents VALUES
(34,'Rajesh','MPA'),
(35,'Aman','AMA'),
(38,'Rajesh','MAY');

CREATE TABLE ResearchArea(
    areaName varchar(20),
    prof_id varchar(20),
    PRIMARY KEY(areaName, prof_id),
    FOREIGN KEY(prof_id) REFERENCES Professor(prof_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO ResearchArea VALUES
('VLSI','AWA'),
('VLSI','MPA'),
('VLSI','ANU'),
('Signal processing','AWA'),
('Signal processing','MPA'),
('Signal processing','MAY');

CREATE TABLE Schedule(
    day varchar(20),
    stTime TIME(0),
    enTime TIME(0),
    PRIMARY KEY (day,stTime,enTime)
);

INSERT INTO Schedule VALUES
('Monday','14:00:00','17:00:00'),
('Tuesday','9:00:00','12:00:00'),
('Wednesday','14:00:00','17:00:00'),
('Monday','8:00:00','9:00:00'),
('Friday','9:00:00','10:00:00');

CREATE TABLE Course(
    course_id varchar(20), 
    intake INT,
    couse_name varchar(20),
    course_type varchar(20),
    room varchar(20),
    since DATE,
    dept_id varchar(20),
    taughtBy varchar(20),
    day varchar(20),
    stTime TIME(0),
    enTime TIME(0),
    FOREIGN KEY (taughtBy) REFERENCES Professor(prof_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (day,stTime,enTime) REFERENCES Schedule(day,stTime,enTime) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (course_id)
);

INSERT INTO Course VALUES
('CS345',28,'Networks','Lab','L1','13:01:01','CSE','AWA','Monday','14:00:00','17:00:00'),
('CS428',98,'Data Struc','Theory','L2','13:01:01','CSE','MPA','Friday','9:00:00','10:00:00'),
('CS215',58,'Algo','Theory','L3','13:01:01','CSE','AWA','Friday','9:00:00','10:00:00'),
('CS212',58,'Hardware','Lab','5001','13:01:01','CSE','AWA','Tuesday','9:00:00','12:00:00'),
('MA345',28,'Optim','Lab','5002','13:01:01','MNC','ANU','Monday','14:00:00','17:00:00'),
('MA315',28,'Real Analysis','Theory','5003','13:01:01','MNC','AMA','Friday','9:00:00','10:00:00'),
('MA335',28,'Calculus','Theory','5004','13:01:01','MNC','AMA','Monday','8:00:00','9:00:00');


SELECT prof_name FROM Professor WHERE prof_id IN (SELECT prof_id FROM Dependents WHERE dependent_name = 'Rajesh');

SELECT prof_name FROM Professor WHERE prof_id IN (SELECT prof_id FROM ResearchArea WHERE areaName = 'VLSI') AND prof_id IN (SELECT prof_id FROM ResearchArea WHERE areaName = 'Signal processing');

SELECT prof_name FROM Professor WHERE prof_id IN (SELECT taughtBy FROM Course WHERE  intake<=30);

SELECT prof_id FROM Professor WHERE prof_id  NOT IN (SELECT taughtBy FROM Course WHERE course_id = 'CS428') AND prof_id IN (SELECT taughtBy FROM Course WHERE course_id = 'CS345') ;

SELECT course_id FROM Course WHERE  day = 'Monday' AND stTime = '14:00:00' AND enTime = '17:00:00' AND course_type = 'Lab';


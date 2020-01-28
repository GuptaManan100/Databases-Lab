DROP DATABASE IF EXISTS Lab2;
SHOW DATABASES;
CREATE DATABASE Lab2;
USE Lab2;

#Q1
CREATE TABLE Employees1(
	ssn char(11) PRIMARY KEY,
	name varchar(20) NOT NULL,
	lot INT NOT NULL
);


INSERT INTO Employees1 VALUES
('123-22-3666','Attishoo',48),
('231-31-5368','Smiley',22),
('131-24-3650','Smethurst',35);

#Q2
CREATE TABLE Departments1(
	did INT PRIMARY KEY,
	dname varchar(20) NOT NULL,
	budget INT UNSIGNED NOT NULL
);


INSERT INTO Departments1 VALUES
('100','HR',48000),
('201','CS',22000),
('304','Retail',35000);

CREATE TABLE Works_In2(
	ssn char(11),
	did INT,
	since DATE NOT NULL,
	FOREIGN KEY (ssn) REFERENCES Employees1(ssn) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (did) REFERENCES Departments1(did)  ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (ssn,did)
);

INSERT INTO Works_In2 VALUES
('123-22-3666',100,'01-09-01'),
('231-31-5368',201,'80-11-02'),
('231-31-5368',100,'00-11-02'),
('131-24-3650',304,'10-12-30');

#Q3
CREATE TABLE Manager2(
	M_id INT PRIMARY KEY,
	Name varchar(20) NOT NULL,
	Location varchar(20) NOT NULL
);


INSERT INTO Manager2 VALUES
(35,'Manan','Gurgaon'),
(9,'Anubhav','Delhi'),
(38,'Mayank','Delhi');

CREATE TABLE Employees2(
	Emp_id char(11) PRIMARY KEY,
	Name varchar(20) NOT NULL,
	Expertise varchar(20),
	ManagerID INT ,
	FOREIGN KEY (ManagerID) REFERENCES Manager2(M_id) ON UPDATE CASCADE ON DELETE SET NULL
);

INSERT INTO Employees2 VALUES
('123-22-3666','Attishoo','',9),
('231-31-5368','Smiley','Salesman',35),
('131-24-3650','Smethurst','Networks',35);


#Q4
CREATE TABLE HOD3(
	Emp_id INT PRIMARY KEY,
	Fname varchar(20) NOT NULL,
	Lname varchar(20),
	Email varchar(40) NOT NULL
);

INSERT INTO HOD3 VALUES
(123,'Attishoo','Shankar','a@gmail.com'),
(41,'Smiley','Srivastav','s@gmail.com');

CREATE TABLE Departments3(
	Dept_id INT PRIMARY KEY,
	Dept_name varchar(20) NOT NULL,
	Hod_Id INT UNIQUE,
	FOREIGN KEY (Hod_Id) REFERENCES HOD3(Emp_id) ON UPDATE CASCADE ON DELETE SET NULL
);

INSERT INTO Departments3 VALUES
(100,'MnC',123),
(201,'CS',41);

#Q5
CREATE TABLE Student4(
	Stud_id INT PRIMARY KEY,
	Name varchar(20) NOT NULL
);

INSERT INTO Student4 VALUES
(35,'Manan'),
(9,'Anubhav'),
(38,'Mayank');

CREATE TABLE Phones(
	Phn_no BIGINT NOT NULL UNIQUE,
	Stud_id INT, 
	FOREIGN KEY(Stud_id) REFERENCES Student4(Stud_id) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY(Stud_id,Phn_no)
);

INSERT INTO Phones VALUES
(9873968796,35),
(9818185777,35),
(9898988998,9);

#Q6
CREATE TABLE Employees5(
	ssn INT PRIMARY KEY,
	name varchar(20) NOT NULL,
	slot INT NOT NULL
);


INSERT INTO Employees5 VALUES
(123,'Attishoo',48),
(231,'Smiley',22),
(131,'Smethurst',35);

CREATE TABLE Reports_To(
	ssn_emp INT,
	ssn_sub INT,
	FOREIGN KEY (ssn_emp) REFERENCES Employees5(ssn) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (ssn_sub) REFERENCES Employees5(ssn) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY(ssn_sub,ssn_emp)
);

INSERT INTO Reports_To VALUES
(123,231),
(131,231);

#Q7
CREATE TABLE Employees6(
	ssn INT PRIMARY KEY,
	name varchar(20) NOT NULL,
	lot INT NOT NULL
);


INSERT INTO Employees6 VALUES
(123,'Attishoo',48),
(231,'Smiley',22),
(131,'Smethurst',35);

CREATE TABLE Dep_Policy(
	pname varchar(20) NOT NULL,
	age INT NOT NULL,
	cost INT NOT NULL,
	ssn INT NOT NULL,
	FOREIGN KEY (ssn) REFERENCES Employees6(ssn) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (ssn,pname)
);

INSERT INTO Dep_Policy VALUES
('Manan',20,20000,123),
('Aman',20,1000,123),
('Ashish',30,2000,231);


#Q8
CREATE TABLE Employees8(
	ssn char(11) PRIMARY KEY,
	name varchar(20) NOT NULL,
	lot INT NOT NULL
);


INSERT INTO Employees8 VALUES
('123-22-3666','Attishoo',48),
('231-31-5368','Smiley',22),
('131-24-3650','Smethurst',35);

CREATE TABLE Departments8(
	did INT PRIMARY KEY,
	dname varchar(20) NOT NULL,
	budget INT UNSIGNED NOT NULL,
	managerID char(11) NOT NULL,
	since Date NOT NULL,
	FOREIGN KEY(managerID) REFERENCES Employees8(ssn) ON UPDATE CASCADE ON DELETE RESTRICT
);


INSERT INTO Departments8 VALUES
('100','HR',48000,'123-22-3666','01-09-01'),
('201','CS',22000,'231-31-5368','00-11-02');

CREATE TABLE Works_In8(
	ssn char(11),
	did INT,
	since DATE NOT NULL,
	FOREIGN KEY (ssn) REFERENCES Employees1(ssn) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (did) REFERENCES Departments1(did)  ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (ssn,did)
);

INSERT INTO Works_In8 VALUES
('123-22-3666',100,'01-09-01'),
('231-31-5368',201,'80-11-02'),
('231-31-5368',100,'00-11-02'),
('131-24-3650',304,'10-12-30');


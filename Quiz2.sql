#CREATE DATABASE IF NOT EXISTS BIS638_24; 

#you start from here since I already have database created for you
USE BIS638_24;

#If you would like to rerun your commands, you can use the following DROP commands, remember the order matters.
DROP TABLE IF EXISTS ClassRegistration;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Instructors;

CREATE TABLE IF NOT EXISTS Courses(
CourseID VARCHAR(10) NOT NULL,
CourseName VARCHAR(50) NOT NULL,
CreditHours INT NOT NULL,
Duration INT NOT NULL,
CONSTRAINT CoursesPK PRIMARY KEY Course(CourseID));
SELECT * FROM Courses;

CREATE TABLE IF NOT EXISTS Instructors(
InstructorID INT NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Department VARCHAR(50) NOT NULL,
CONSTRAINT InstructorsPK PRIMARY KEY Instructor(InstructorID));
SELECT * FROM Instructors;

CREATE TABLE IF NOT EXISTS ClassRegistration(
CourseID VARCHAR(10) NOT NULL,
InstructorID INT NOT NULL,
Semester VARCHAR(15) NOT NULL,
Years INT NOT NULL,
CONSTRAINT ClassRegistrationPK PRIMARY KEY ClassRegistration(CourseID,InstructorID),
CONSTRAINT ClassRegistrationCourseFK FOREIGN KEY  ClassRegistration(CourseID) REFERENCES Courses(CourseID),
CONSTRAINT ClassRegistrationInstructorFK FOREIGN KEY ClassRegistration(InstructorID) REFERENCES Instructors(InstructorID));
SELECT * FROM ClassRegistration;

Alter TABLE Courses DROP COLUMN Duration;
SELECT * FROM Courses;

ALTER TABLE ClassRegistration ADD Modality VARCHAR(15) NOT NULL;
SELECT * FROM ClassRegistration;

INSERT INTO Courses (CourseID,CourseName,CreditHours) VALUES
('BIS101','Intro to Information System',1),('BIS201','Database Fundamentals',3),
('BIS305','Data Analytics',3);
SELECT * FROM Courses;

INSERT INTO Instructors ( InstructorID , FirstName,LastName, Department) VALUES
(1001,'Emma','Smith','BIS'),(1002,'Olivia','Chen','BIS'),(1003,'Vincent','Brown','Accounting'),
(1004,'Liam','Patel','BIS');
SELECT * FROM Instructors;

INSERT INTO ClassRegistration(CourseID , InstructorID,Semester,Years,Modality)VALUES
('BIS101',1001,'Fall',2024,'Face-to-Face'),('BIS201',1002,'Spring',2026,'Online'),
('BIS101',1004,'Fall',2025,'Hybrid');
SELECT * FROM ClassRegistration;

UPDATE Instructors SET Department='BIS' WHERE InstructorID=1003;
SELECT * FROM Instructors;

UPDATE ClassRegistration SET Semester='Spring' WHERE InstructorID=1004;
SELECT * FROM ClassRegistration;

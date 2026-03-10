DROP TABLE IF EXISTS ProjectAssignment;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Employee;



CREATE TABLE IF NOT EXISTS Employee(
EmployeeID INT NOT NULL,
FirstName VARCHAR(10) NOT NULL,
LastName VARCHAR(10) NOT NULL,
Department VARCHAR(50) NOT NULL,
CONSTRAINT EmployeePK PRIMARY KEY Employee(EmployeeID));
SELECT * FROM Employee;

CREATE TABLE IF NOT EXISTS Project(
ProjectID VARCHAR(10) NOT NULL,
ProjectName VARCHAR(30) NOT NULL,
StartDate VARCHAR(10) NOT NULL,
Budget INT  NOT NULL,
CONSTRAINT ProjectPK PRIMARY KEY Project(ProjectID));
SELECT * FROM Project;

CREATE TABLE IF NOT EXISTS ProjectAssignment(
ProjectID VARCHAR(10) NOT NULL,
EmployeeID INT NOT NULL,
AssignDate VARCHAR(10) NOT NULL,
HoursPerWeek INT  NOT NULL,
CONSTRAINT ProjectAssignmentPK PRIMARY KEY ProjectAssignment(ProjectID,EmployeeID),
CONSTRAINT ProjectAssignmentFK1 FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID),
CONSTRAINT ProjectAssignmentFK2 FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID));
SELECT * FROM ProjectAssignment;

ALTER TABLE Project DROP COLUMN Budget;
SELECT * FROM Project;

ALTER TABLE ProjectAssignment ADD COLUMN ProjectStatus VARCHAR(10) NOT NULL;
SELECT * FROM ProjectAssignment;

INSERT INTO  Employee  (EmployeeID,FirstName, LastName, Department) 
VALUES ( 501, 'Emma', 'Smith', 'InformationTechnology'),
 ( 502, 'Emily', 'Chen', 'Business Analyst'),
  ( 503, 'Mike', 'Brown', 'Accounting'),
   ( 504, 'Jack', 'Lee', 'Marketing');
   
   INSERT INTO  Project    (ProjectID,ProjectName,StartDate) 
VALUES ( 'P100', 'Mobile App Redisgn', '2026-01-10' ),
( 'P200', ' Data Warehouse Upgrade', '2026-02-10' ),
( 'P300', 'CRM Cleanup', '2026-02-15' );

  INSERT INTO  ProjectAssignment(ProjectID,EmployeeID,AssignDate, HoursPerWeek, ProjectStatus ) 
VALUES ( 'P100', 501, '2026-01-10',10, 'Active' ),
( 'P200', 502, '2026-02-03',15, 'On-Hold' ),
( 'P100', 504, '2026-01-20',8, 'Completed' );

UPDATE  Employee SET Department= 'Marketing' WHERE EmployeeID= 503;
SELECT * FROM Employee;
UPDATE  ProjectAssignment SET ProjectStatus= 'Active' WHERE ProjectID= 'P100';
SELECT * FROM ProjectAssignment;







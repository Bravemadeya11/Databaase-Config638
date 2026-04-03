
DROP TABLE IF EXISTS PatientTreatment;
DROP TABLE IF EXISTS TreatmentItem;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Treatment;
DROP TABLE IF EXISTS LaboratoryAssignment;
DROP TABLE IF EXISTS Laboratory;
DROP TABLE IF EXISTS NurseAssignment;
DROP TABLE IF EXISTS Resident;
DROP TABLE IF EXISTS OutPatient;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Bed;
DROP TABLE IF EXISTS CareCenter;
DROP TABLE IF EXISTS Volunteer;
DROP TABLE IF EXISTS Physician;
DROP TABLE IF EXISTS Technician;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Nurse;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Person;

CREATE TABLE Person(
     	PersonID  		INT 		NOT NULL,
     	FirstName     		VARCHAR(50),
    	LastName      		VARCHAR(50),
     	Address       		VARCHAR(40),
     	City          		VARCHAR(50),
     	State         		CHAR(2),
     	ZipCode        		INT,
     	PhoneNbr      		VARCHAR(12),
     	DateOfBirth    		DATE,
     	EmployeeYN          	CHAR(1),
     	PatientYN           	CHAR(1),
     	PhysicianYN         	CHAR(1),
     	VolunteerYN       	CHAR(1),
	CONSTRAINT PersonPK PRIMARY KEY (PersonID),
	CONSTRAINT PersonEmployeeYNValues CHECK (EmployeeYN IN ('Y', 'N')),
	CONSTRAINT PersonPatientYNValues CHECK (PatientYN IN ('Y', 'N')),
	CONSTRAINT PersonPhysicianYNValues CHECK (PhysicianYN IN ('Y', 'N')),
	CONSTRAINT PersonVolunteerYNValues CHECK (VolunteerYN IN ('Y', 'N')));
/* YOU CAN ALSO REMOVE "CONSTRAINT PersonPK PRIMARY KEY (PersonID)," 
TO JUST USE "PersonID  	INT PRIMARY KEY," SINCE PK IS ALWAYS NOT NULL AND THIS IS A SINGLE COLUMN PK 
OR YOU CAN USE PRIMARY KEY (PersonID), AFTER THE "VolunteerYN       	CHAR(1)," SINCE PK FOR A TEBAL IS NAMED AS PRIMARY KEY BY DEFAULT IN SQL, YOU DO NOT HAVE TO NAME IT */

CREATE TABLE Employee(
   	EmployeeID          	INT 		NOT NULL,
     	DateHired           	DATE,
     	EmployeeType		CHAR(1),
	CONSTRAINT EmployeePK PRIMARY KEY (EmployeeID),
	CONSTRAINT EmployeeFK1 FOREIGN KEY (EmployeeID) REFERENCES Person(PersonID),
	CONSTRAINT EmployeeTypeValues CHECK (EmployeeType IN ('N', 'S', 'T')));

CREATE TABLE Nurse(
   	NurseID             	INT            	NOT NULL,
     	Certificate 		VARCHAR(25)    	NOT NULL,
	CONSTRAINT NursePK PRIMARY KEY (NurseID),
	CONSTRAINT NurseFK1 FOREIGN KEY (NurseID) REFERENCES Employee(EmployeeID));

CREATE TABLE Staff(
     	StaffID  		INT            	NOT NULL,
     	JobClass            	VARCHAR(25),
	CONSTRAINT StaffPK PRIMARY KEY (StaffID),
	CONSTRAINT StaffFK1 FOREIGN KEY (StaffID) REFERENCES Employee(EmployeeID));

CREATE TABLE Technician(
   	TechnicianID      	INT      	NOT NULL,
     	Skills               	VARCHAR(50),
	CONSTRAINT TechnicianPK PRIMARY KEY (TechnicianID),
	CONSTRAINT TechnicianFK1 FOREIGN KEY (TechnicianID) REFERENCES Employee(EmployeeID));

CREATE TABLE Physician(
     	PhysicianID		INT        	NOT NULL,
     	Specialty           	VARCHAR(50),
     	PagerNbr            	VARCHAR(50),
	CONSTRAINT PhysicianPK PRIMARY KEY (PhysicianID),
	CONSTRAINT PhysicianFK1 FOREIGN KEY (PhysicianID) REFERENCES Person(PersonID));

CREATE TABLE Volunteer(
     	VolunteerID         	INT            	NOT NULL,
     	Skill               	VARCHAR(25),
	CONSTRAINT VolunteerPK PRIMARY KEY (VolunteerID),
	CONSTRAINT VolunteerFK1 FOREIGN KEY (VolunteerID) REFERENCES Person(PersonID));

CREATE TABLE CareCenter(
     	CareCenterID        	VARCHAR(10)	NOT NULL,
     	Location	  	VARCHAR(50),
     	CareCenterName      	VARCHAR(50),
     	CareCenterType	      	VARCHAR(50),
     	InChargeNurseID        	INT,
	CONSTRAINT CareCenterPK PRIMARY KEY (CareCenterID),
	CONSTRAINT CareCenterFK1 FOREIGN KEY (InChargeNurseID) REFERENCES Nurse(NurseID));

CREATE TABLE Bed(
     	BedID               	VARCHAR(12)    	NOT NULL,
     	CareCenterID        	VARCHAR(10),
     	RoomID              	INT,
	CONSTRAINT BedPK PRIMARY KEY (BedID),
	CONSTRAINT BedFK1 FOREIGN KEY (CareCenterID) REFERENCES	CareCenter(CareCenterID));

CREATE TABLE Patient(
     	PatientID           	INT            	NOT NULL,
     	PhysicianID         	INT,
     	ReferringPhysicianID    INT,
     	ContactDate         	DATE,
     	OutPatientYN        	CHAR(1),
     	ResidentYN          	CHAR(1),
	CONSTRAINT PatientPK PRIMARY KEY (PatientID),
	CONSTRAINT PatientFK1 FOREIGN KEY (PatientID) REFERENCES Person(PersonID),
	CONSTRAINT PatientFK2 FOREIGN KEY (PhysicianID) REFERENCES Physician(PhysicianID),
	CONSTRAINT PatientFK3 FOREIGN KEY (ReferringPhysicianID) REFERENCES Physician(PhysicianID),
	CONSTRAINT PatientOutPatientYNValues CHECK (OutPatientYN IN ('Y', 'N')),
	CONSTRAINT PatientResidentYNValues CHECK (ResidentYN IN ('Y', 'N')));

CREATE TABLE OutPatient(
     	OutPatientID		INT            	NOT NULL,
     	VisitDate           	DATE           	NOT NULL,
     	Comments            	VARCHAR(250),
	CONSTRAINT OutPatientPK PRIMARY KEY (OutPatientID, VisitDate),
	CONSTRAINT OutPatientFK1 FOREIGN KEY (OutPatientID) REFERENCES Patient(PatientID));

CREATE TABLE Resident(
     	ResPatientID        	INT            	NOT NULL,
    	BedID               	VARCHAR(12)    	NOT NULL,
     	DateAdmitted        	DATE           	NOT NULL,
	CONSTRAINT ResidentPK PRIMARY KEY (ResPatientID, BedID, DateAdmitted),
	CONSTRAINT ResidentFK1 FOREIGN KEY (ResPatientID) REFERENCES Patient(PatientID),
	CONSTRAINT ResidentFK2 FOREIGN KEY (BedID) REFERENCES Bed(BedID));

CREATE TABLE NurseAssignment(
    	CareCenterID        	VARCHAR(10)    	NOT NULL,
     	NurseID          	INT            	NOT NULL,
     	Year                	INT            	NOT NULL,
     	Week                	INT            	NOT NULL,
     	Hours               	INT,
	CONSTRAINT AssignmentPK PRIMARY KEY (CareCenterID, NurseID, Year, Week),
	CONSTRAINT AssignmentFK1 FOREIGN KEY (CareCenterID) REFERENCES CareCenter(CareCenterID),
	CONSTRAINT AssignmentFK2 FOREIGN KEY (NurseID) REFERENCES Nurse(NurseID));

CREATE TABLE Laboratory(
     	LaboratoryID        	VARCHAR(50)    	NOT NULL,
     	Location	  	VARCHAR(50)   	NOT NULL,
	CONSTRAINT LaboratoryPK PRIMARY KEY (LaboratoryID));

CREATE TABLE LaboratoryAssignment(
     	LaboratoryID        	VARCHAR(50)    	NOT NULL,
     	TechnicianID        	INT            	NOT NULL,
	CONSTRAINT LaboratoryAssignmentPK PRIMARY KEY (LaboratoryID, TechnicianID),
	CONSTRAINT LaboratoryAssignmentFK1 FOREIGN KEY (LaboratoryID) REFERENCES Laboratory(LaboratoryID),
	CONSTRAINT LaboratoryAssignmentFK2 FOREIGN KEY (TechnicianID) REFERENCES Technician(TechnicianID));

CREATE TABLE Treatment(
     	TreatmentID         	INT            	NOT NULL,
     	TreatmentName       	VARCHAR(50),
	CONSTRAINT TreatmentPK PRIMARY KEY (TreatmentID));

CREATE TABLE Item(
     	ItemID              	INT            	NOT NULL,
     	Description     	VARCHAR(125),
     	Cost            	DECIMAL(5,2),
	CONSTRAINT ItemPK PRIMARY KEY (ItemID));

CREATE TABLE TreatmentItem(
     	TreatmentID 		INT            	NOT NULL,
     	ItemID              	INT            	NOT NULL,
	CONSTRAINT TreatmentItemPK PRIMARY KEY (TreatmentID, ItemID),
	CONSTRAINT TreatmentItemFK1 FOREIGN KEY (TreatmentID) REFERENCES Treatment(TreatmentID),
	CONSTRAINT TreatmentItemFK2 FOREIGN KEY (ItemID) REFERENCES Item(ItemID));

CREATE TABLE PatientTreatment(
     	PatientID           	INT            	NOT NULL,
     	PhysicianID         	INT            	NOT NULL,
     	TreatmentID         	INT            	NOT NULL,
     	TreatmentDate       	DATE           	NOT NULL,
     	Results             	VARCHAR(250),
	CONSTRAINT PatientTreatmentPK PRIMARY KEY (PatientID, PhysicianID, TreatmentID, TreatmentDate),
	CONSTRAINT PatientTreatmentFK1 FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
	CONSTRAINT PatientTreatmentFK2 FOREIGN KEY (TreatmentID) REFERENCES Treatment(TreatmentID),
	CONSTRAINT PatientTreatmentFK3 FOREIGN KEY (PhysicianID) REFERENCES Physician(PhysicianID));

INSERT INTO Person (PersonID, FirstName, LastName, Address, City, State, ZipCode, PhoneNbr, DateOfBirth, EmployeeYN, PatientYN, PhysicianYN, VolunteerYN)VALUES
(1, 'Annette', 'Larreau', '127 Sandhill', 'Grant', 'CO', '80448', '', '1942-01-25', 'Y', 'N', 'N', 'N'),
(2, 'Thomas', 'Shiffman', '818 River Run', 'Conifer', 'CO', 80433, '', '1962-05-13', 'Y', 'Y', 'N', 'N'),
(3, 'Brian', 'Wiggins', '431 Walnut', 'Sheridan', 'CO', 80110, '', '1972-07-03', 'Y', 'N', 'N', 'N'),
(4, 'Wendell', 'Thomas', '928 Logan', 'Evergreen', 'CO', 80437, '', '1985-02-14', 'Y', 'N', 'N', 'N'),
(5, 'Salena', 'Dimas', '617 Valley Vista', 'Sheridan', 'CO', 80110, '', '1947-03-15', 'Y', 'N', 'N', 'N'),
(6, 'Terri', 'Smith', '5566 Point Loma Drive', 'Lakewood', 'CO', 80033, '', '1955-07-18', 'Y', 'N', 'N', 'N'),
(7, 'Larry', 'Moxly', '3421 Hillcrest Ave', 'Evergreen', 'CO', 80439, '', '1963-08-15', 'Y', 'Y', 'N', 'N'),
(8, 'Jim', 'Jones', '1432 Tied Knot Rd', 'Evergreen', 'CO', 80439, '', '1958-08-31', 'Y', 'Y', 'N', 'N'),
(9, 'Chris', 'Bailey', '6749 Clifton Rd', 'Lakewood', 'CO', 80033, '', '1994-01-16', 'Y', 'N', 'N', 'N'),
(10, 'Robert', 'Sprangler', '2929 Lipton Lane', 'Evergreen', 'CO', 80437, '', '1980-02-05', 'Y', 'N', 'N', 'N'),
(11, 'Chuck', 'Bronson', '343 Knuckels Street', 'Lakewood', 'CO', 80214, '', '1974-04-30', 'N', 'N', 'Y', 'N'),
(12, 'Rita', 'Freeman', '634 Valley Vista', 'Evergreen', 'CO', 80439, '', '1967-08-26', 'Y', 'N', 'N', 'N'),
(13, 'Anita', 'Grost', '1900 Smith Ave', 'Sheridan', 'CO', 80110, '', '1981-11-25', 'Y', 'N', 'N', 'Y'),
(14, 'Joanne', 'Danger', '101 Hazard Rd', 'Lakewood', 'CO', 80215, '', '1972-01-24', 'N', 'N', 'Y', 'N'),
(15, 'Steven', 'Nickolsen', '3234 Garrison Rd', 'Evergreen', 'CO', 80439, '', '1978-06-08', 'N', 'N', 'Y', 'N'),
(16, 'Scott', 'Caudle', '1211 Westminister Dr', 'Lakewood', 'CO', 80033, '', '1973-01-18', 'N', 'N', 'Y', 'N'),
(17, 'Joy', 'Yun', '8734 Fluffy Lane', 'Conifer', 'CO', 80433, '', '1952-05-18', 'Y', 'Y', 'N', 'Y'),
(18, 'Ralph', 'Hamilton', '710 Lamp Post Lane', 'Conifer', 'CO', 80433, '', '1944-05-15', 'Y', 'N', 'N', 'N'),
(19, 'Nathaniel', 'Tyre', '4455 Adrian Court', 'Lakewood', 'CO', 80033, '', '1982-07-07', 'Y', 'Y', 'N', 'N'),
(20, 'Cheryl', 'Lawson', '1045 Marcum', 'Evergreen', 'CO', 80439, '', '1966-04-23', 'Y', 'N', 'N', 'N'),
(21, 'Michelle', 'Smith', '813 Ranger Blvd.', 'Evergreen', 'CO', 80439, '', '1984-02-14', 'Y', 'Y', 'N', 'N'),
(22, 'Darlene', 'McLendon', '15337 Old Boulder Road', 'Sheridan', 'CO', 80110, '', '1977-09-29', 'Y', 'N', 'N', 'N');

-- ANOTHER WAY TO INSERT VALUES WHEN YOU INSERT VALUES FOR ALL COLUMNS IN A TABLE
INSERT INTO Employee VALUES (1, '2015-01-30', 'N');
INSERT INTO Employee VALUES (2, '2015-01-30', 'S');
INSERT INTO Employee VALUES (3, '2016-01-27', 'N');
INSERT INTO Employee VALUES (4, '2016-01-30', 'T');
INSERT INTO Employee VALUES (5, '2016-02-04', 'N');
INSERT INTO Employee VALUES (6, '2016-02-14', 'N');
INSERT INTO Employee VALUES (7, '2016-02-14', 'N');
INSERT INTO Employee VALUES (8, '2017-02-01', 'T');
INSERT INTO Employee VALUES (9, '2017-02-03', 'T');
INSERT INTO Employee VALUES (10, '2017-02-05', 'T');
INSERT INTO Employee VALUES (12, '2017-02-20', 'N');
INSERT INTO Employee VALUES (13, '2018-01-15', 'N');
INSERT INTO Employee VALUES (17, '2018-05-18', 'N');
INSERT INTO Employee VALUES (18, '2018-05-30', 'N');
INSERT INTO Employee VALUES (19, '2018-08-15', 'N');
INSERT INTO Employee VALUES (20, '2019-08-15', 'N');
INSERT INTO Employee VALUES (21, '2019-11-04', 'N');
INSERT INTO Employee VALUES (22, '2020-01-05', 'N');


INSERT INTO Nurse (NurseID, Certificate) VALUES
(1, 'RN'),
(3, 'RN'),
(5, 'RN'),
(6, 'RN'),
(7, 'LPN'),
(12, 'RN'),
(13, 'RN'),
(17, 'LPN'),
(18, 'LPN'),
(19, 'LPN'),
(20, 'RN'),
(21, 'LPN'),
(22, 'RN');

INSERT INTO Staff (StaffID, JobClass) VALUES (2, 'Full Time');

INSERT INTO Technician (TechnicianID, Skills) VALUES
(4, 'CT, MRI, Xray'),
(8, 'Hematology'),
(9, 'Anesthesia'),
(10, 'CT, MRI');

INSERT INTO Physician (PhysicianID, Specialty, PagerNbr) VALUES
(14, 'Hematology', '8089995454'),
(15, 'General', '8089991212'),
(11, 'OB\\GYN', '8089991524'),
(16, 'Exercise Physiologist', '8089992451');

INSERT INTO Volunteer (VolunteerID, Skill) VALUES
(13, 'Walking Partner'),
(17, 'Group Reading');

INSERT INTO CareCenter (CareCenterID, Location, CareCenterName, CareCenterType, InChargeNurseID) VALUES
('AE', 'Emergency Care Center', 'Emergency', 'Complex 1', 1),
('CA', 'Cardiology Care Center', 'Cardiology', 'Complex 3', 3),
('CC', 'Cancer Care Center', 'Cancer', 'Complex 3', 12),
('GC', 'General Care Center', 'General', 'Complex 2', 13),
('MA', 'Maternity Care Center', 'Maternity', 'Complex 2', 5),
('SG', 'Surgery Care center', 'Surgeon', 'Complex 2', 6);

INSERT INTO Bed (BedID, CareCenterID, RoomID) VALUES
('AE-100-1', 'AE', 100),
('AE-101-1', 'AE', 101),
('AE-102-1', 'AE', 102),
('AE-103-1', 'AE', 103),
('GC-100-1', 'GC', 100),
('GC-100-2', 'GC', 100),
('GC-102-1', 'GC', 102),
('GC-102-2', 'GC', 102),
('GC-103-1', 'GC', 103),
('GC-103-2', 'GC', 103),
('GC-104-1', 'GC', 104),
('GC-104-2', 'GC', 104),
('GC-105-1', 'GC', 105),
('GC-105-2', 'GC', 105),
('GC-200-1', 'GC', 200),
('GC-201-1', 'GC', 201),
('GC-202-1', 'GC', 202),
('GC-203-1', 'GC', 203),
('GC-204-1', 'GC', 204),
('GC-205-1', 'GC', 205),
('MA-100-1', 'MA', 100),
('MA-101-1', 'MA', 101),
('MA-102-1', 'MA', 102);

INSERT INTO Patient (PatientID, PhysicianID, ReferringPhysicianID, ContactDate, OutPatientYN, ResidentYN) VALUES
(2, 15, 16, '2020-05-15', 'Y', 'N'),
(7, 15, 14, '2020-05-22', 'Y', 'N'),
(8, 11, 16, '2020-04-22', 'N', 'Y'),
(17, 16, 11, '2020-06-17', 'N', 'Y'),
(19, 14, 16, '2020-06-17', 'Y', 'Y'),
(21, 15, 11, '2020-07-16', 'N', 'Y');

INSERT INTO OutPatient (OutPatientID, VisitDate, Comments) VALUES
(2, '2020-05-15', 'Broken Leg'),
(7, '2020-05-22', 'Asthma'),
(19, '2020-06-17', 'Unconscious upon arrival');

INSERT INTO Resident (ResPatientID, BedID, DateAdmitted) VALUES
(8, 'MA-100-1', '2020-08-13'),
(17, 'GC-100-2', '2020-06-17'),
(19, 'GC-100-1', '2020-06-17'),
(21, 'GC-201-1', '2020-07-16');

INSERT INTO NurseAssignment (CareCenterID, NurseID, Year, Week, Hours) VALUES
('AE', 1, 2020, 1, 40),
('AE', 1, 2020, 2, 40),
('AE', 1, 2020, 3, 40),
('AE', 1, 2020, 4, 40),
('AE', 18, 2020, 1, 32),
('AE', 18, 2020, 2, 32),
('AE', 18, 2020, 3, 32),
('AE', 18, 2020, 4, 32),
('CA', 3, 2020, 1, 38),
('CA', 3, 2020, 2, 39),
('CA', 3, 2020, 3, 40),
('CA', 3, 2020, 4, 40),
('CA', 19, 2020, 1, 30),
('CA', 19, 2020, 2, 32),
('CA', 19, 2020, 3, 28),
('CA', 19, 2020, 4, 0),
('CC', 12, 2020, 1, 42),
('CC', 12, 2020, 2, 41),
('CC', 12, 2020, 3, 44),
('CC', 12, 2020, 4, 40),
('CC', 22, 2020, 1, 35),
('CC', 22, 2020, 2, 35),
('CC', 22, 2020, 3, 38),
('CC', 22, 2020, 4, 38),
('GC', 7, 2020, 1, 24),
('GC', 7, 2020, 2, 24),
('GC', 7, 2020, 3, 24),
('GC', 7, 2020, 4, 24),
('GC', 13, 2020, 1, 40),
('GC', 13, 2020, 2, 40),
('GC', 13, 2020, 3, 40),
('GC', 13, 2020, 4, 40),
('MA', 5, 2020, 1, 42),
('MA', 5, 2020, 2, 40),
('MA', 5, 2020, 3, 35),
('MA', 5, 2020, 4, 36),
('MA', 20, 2020, 1, 40),
('MA', 20, 2020, 2, 40),
('MA', 20, 2020, 3, 40),
('MA', 20, 2020, 4, 40),
('SG', 6, 2020, 1, 42),
('SG', 6, 2020, 2, 39),
('SG', 6, 2020, 3, 45),
('SG', 6, 2020, 4, 40),
('SG', 21, 2020, 1, 28),
('SG', 21, 2020, 2, 28),
('SG', 21, 2020, 3, 28),
('SG', 21, 2020, 4, 28);

INSERT INTO Laboratory (LaboratoryID, Location) VALUES
('Arterial blood gases', 'Complex 2'),
('Blood alcohol level', 'Complex 2'),
('CMV', 'Complex 2'),
('Complete blood count', 'Complex 2'),
('Digitalis', 'Complex 2'),
('Drug screening', 'Complex 2'),
('Electrodiagnosis', 'Complex 2'),
('Hematology', 'Complex 2'),
('Pregnancy test', 'Complex 2'),
('PT/PT', 'Complex 2'),
('Radiology', 'Complex 3'),
('RSV', 'Complex 3'),
('SED rate', 'Complex 2'),
('SMAC', 'Complex 2'),
('STD screening', 'Complex 2'),
('Troponin', 'Complex 2');

INSERT INTO LaboratoryAssignment (LaboratoryID, TechnicianID) VALUES
('Arterial blood gases', 9),
('Electrodiagnosis', 10),
('Complete blood count', 8),
('Hematology', 8),
('Radiology', 4);

INSERT INTO Treatment (TreatmentID, TreatmentName) VALUES
(1, 'Laboratory'),
(2, 'Surgery'),
(3, 'Rehabilitation'),
(4, 'Physical'),
(5, 'Mental'),
(6, 'Cardiac'),
(7, 'Pulmonary'),
(8, 'Neurologic'),
(9, 'Pediatric'),
(10, 'Natal');

INSERT INTO Item (ItemID, Description, Cost) VALUES
(501, 'Inflatable Air Splint Leg 32"', 60),
(502, 'Inflatable Air Splint Leg 25"', 55),
(503, 'Inflatable Air Splint Arm 32"', 45),
(504, 'Inflatable Air Splint Arm 25"', 40),
(505, 'Inflatable Air Splint Hand and Wrist', 45),
(506, 'Inflatable Air Splint Ankle and Foot', 45),
(507, 'Cast Boot Large', 95),
(508, 'Cast Boot Small', 90),
(509, 'Stifneck Collar', 150),
(600, 'Ultrasound Lotion', 6.25),
(601, 'UltraSound Gel', 5),
(602, 'Ammonia Inhalant', 15),
(604, 'Burn Relief Spray', 60),
(605, 'Burn sheets 60"x96"', 40),
(606, 'Oxygen face Mask w/valve', 135),
(607, 'Micro face Mask', 30),
(608, 'Eyewash Bottle', 40),
(609, 'Sooth-A-Sting swab', 15),
(610, 'Insect Sting Wipe', 12.5),
(611, 'Poison Antidote Kit', 60),
(612, 'OB Kit', 30),
(613, 'Resuscitator Bag Mask Adult', 150),
(614, 'Resuscitator Bag Mask Child', 145),
(615, 'Tracheotomy Kit', 200),
(616, 'IV Sodium Clorine', 15),
(617, 'IV Sterile Water', 10),
(701, 'Chemical Strips #135 Luc.,Gluc.,Prot,Bld', 5),
(702, 'Chemical Strips #145 Luc.,Gluc.,Prot,Bld.,N, Urin.', 7.5),
(703, 'LabStix-urinary blood, ketones, glucose, protein and pH', 6.25),
(704, 'Multi Stix-pH, protein, glucose, ketones, bilirubin, blood and urobilinogen in urine', 10),
(705, 'Multi Stix glucose, bilirubin, ketones, specific gravity, glood, pH, protein, nitrate and leukocytes in urine', 15),
(706, 'Uristix', 7.5),
(801, 'Insta-Glucose tube 31 gram', 30),
(802, 'Insulin Syringe bx/100 monojet 29 gauge', 110),
(803, 'Insulin Syringe bx/100 monojet 27 gauge', 85),
(804, 'Insulin Travel Kit', 130),
(805, 'Lancets bx/100', 35),
(806, 'Diabetis Socks', 25),
(807, 'Diabetic Gloves', 35),
(901, 'Bed Pan diposable', 35),
(902, 'Bed Tray', 85),
(903, 'Emesis Basin Disposable', 5),
(904, 'Hair Comb', 15),
(905, 'Hair Brush', 25),
(906, 'Toothbrush', 15),
(907, 'Nail Clippers', 25),
(908, 'Sitz Bath Disposable', 35),
(909, 'Female Urinal Disposable', 30),
(910, 'Male Urinal Disposable', 10),
(911, 'Wash Basin Disposable', 10),
(912, 'Hand bulb syringe', 35),
(913, 'Wool Blanket', 120),
(914, 'Emergency Foam Blanket', 70),
(915, 'Bite Stick', 20),
(916, 'Tourniquet Velcro', 40),
(917, 'Tourniquet Latex Disposable', 10),
(918, 'Male Briefs Disposable', 5),
(919, 'Female Briefs Disposable', 5),
(920, 'Telephone', 100),
(921, 'Television', 100),
(922, 'Computer', 100);

INSERT INTO TreatmentItem (TreatmentID, ItemID) VALUES
(1, 701),
(1, 801),
(2, 615),
(2, 616),
(2, 617),
(4, 502),
(6, 613),
(7, 606),
(7, 613),
(8, 501),
(9, 614),
(10, 612);

INSERT INTO PatientTreatment (PatientID, PhysicianID, TreatmentID, TreatmentDate, Results) VALUES
(2, 15, 4, '2020-05-15', 'Immobilized leg'),
(19, 14, 1, '2020-06-17', 'High blood sugar'),
(21, 14, 1, '2020-07-16', 'Lab blood test for heart function'),
(2, 16, 4, '2020-05-15', 'Consultation'),
(2, 15, 4, '2020-03-15', 'Consultation'),
(21, 15, 6, '2020-07-16', 'Heart attack treated'),
(21, 15, 4, '2020-07-17', 'Monitoring'),
(7, 15, 7, '2020-05-22', 'Restored breathing ability'),
(8, 11, 10, '2020-08-14', 'Delivered baby');

#QUESTION 1
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientFullName,
    CONCAT(ph.FirstName, ' ', ph.LastName) AS PhysicianFullName,
    pat.ContactDate
FROM 
    Patient pat
    INNER JOIN Person p ON pat.PatientID = p.PersonID
    INNER JOIN Physician phys ON pat.PhysicianID = phys.PhysicianID
    INNER JOIN Person ph ON phys.PhysicianID = ph.PersonID;
 
 #QUESTION 2 
 SELECT 
    CONCAT(P.FirstName, ' ', P.LastName) AS PatientFullName,
    CONCAT(RP.FirstName, ' ', RP.LastName) AS ReferringPhysicianFullName,
    PA.ContactDate
FROM 
    Patient PA,
    Person P,
    Physician PH,
    Person RP
WHERE 
    PA.PatientID = P.PersonID
    AND PA.ReferringPhysicianID = PH.PhysicianID
    AND PH.PhysicianID = RP.PersonID
ORDER BY 
    PA.ContactDate;
 
#question 3

SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientFullName,
    t.TreatmentName,
    pt.TreatmentDate,
    CONCAT(phys.FirstName, ' ', phys.LastName) AS PhysicianFullName,
    pt.Results
FROM 
    PatientTreatment pt,
    Patient pat,
    Person p,
    Treatment t,
    Physician ph,
    Person phys
WHERE 
    pt.PatientID = pat.PatientID
    AND pat.PatientID = p.PersonID
    AND pt.TreatmentID = t.TreatmentID
    AND pt.PhysicianID = ph.PhysicianID
    AND ph.PhysicianID = phys.PersonID
ORDER BY 
    pt.TreatmentDate DESC;    
    
  #QUESTION 4
  SELECT 
    P.PersonID,
    P.FirstName,
    P.LastName,
    COUNT(PT.TreatmentID) AS TotalTreatments
FROM 
    Person P
    INNER JOIN Patient PA ON P.PersonID = PA.PatientID
    INNER JOIN PatientTreatment PT ON PA.PatientID = PT.PatientID
GROUP BY 
    P.PersonID,
    P.FirstName,
    P.LastName
ORDER BY 
    TotalTreatments DESC;
    

    
#QUESTION 5
SELECT 
    CONCAT(P.FirstName, ' ', P.LastName) AS PatientFullName,
    T.TreatmentName,
    I.ItemDescription,
    I.Cost AS ItemCost
FROM 
    PatientTreatment PT,
    Patient PA,
    Person P,
    Treatment T,
    TreatmentItem TI,
    Item I
WHERE 
    PT.PatientID = PA.PatientID
    AND PA.PatientID = P.PersonID
    AND PT.TreatmentID = T.TreatmentID
    AND T.TreatmentID = TI.TreatmentID
    AND TI.ItemID = I.ItemID
    AND I.Cost > 300
ORDER BY 
    I.Cost DESC;    
    
#QUESTION 6
SELECT 
    I.ItemID,
    I.Description,
    I.Cost,
    T.TreatmentID,
    T.TreatmentName
FROM 
    Item I,
    TreatmentItem TI,
    Treatment T
WHERE 
    I.ItemID = TI.ItemID
    AND TI.TreatmentID = T.TreatmentID
    AND I.Cost > 500
ORDER BY 
    I.Cost DESC, 
    I.ItemID;    
    
#QUESTION 7
SELECT 
    p.FirstName,
    p.LastName,
    e.DateHired,
    ROUND(DATEDIFF(CURDATE(), e.DateHired) / 365.25, 1) AS YearsOfService
FROM 
    Employee e
    INNER JOIN Person p ON e.EmployeeID = p.PersonID
ORDER BY 
    YearsOfService DESC; 
    
#QUESTION 8
SELECT 
    C.CareCenterID,
    C.CareCenterName,
    C.Location,
    CONCAT(P.FirstName, ' ', P.LastName) AS InChargeNurseName,
    SUM(NA.Hours) AS TotalNursingHours
FROM 
    CareCenter C,
    NurseAssignment NA,
    Nurse N,
    Person P
WHERE 
    C.CareCenterID = NA.CareCenterID
    AND NA.NurseID = N.NurseID
    AND N.NurseID = P.PersonID
    AND C.InChargeNurseID = N.NurseID
    AND NA.Year = 2020
    AND NA.Week = 1
GROUP BY 
    C.CareCenterID,
    C.CareCenterName,
    C.Location,
    P.FirstName,
    P.LastName
ORDER BY 
    C.CareCenterID;    
    
 #QUESTION 9
 SELECT 
    C.CareCenterID,
    C.CareCenterName,
    C.Location,
    CONCAT(P.FirstName, ' ', P.LastName) AS InChargeNurseName,
    SUM(NA.Hours) AS TotalNursingHours
FROM 
    CareCenter C,
    NurseAssignment NA,
    Nurse N,
    Person P
WHERE 
    C.CareCenterID = NA.CareCenterID
    AND NA.NurseID = N.NurseID
    AND N.NurseID = P.PersonID
    AND C.InChargeNurseID = N.NurseID
    AND NA.Year = 2020
    AND NA.Week = 1
GROUP BY 
    C.CareCenterID,
    C.CareCenterName,
    C.Location,
    P.FirstName,
    P.LastName
ORDER BY 
    C.CareCenterID;
    
#QUESTION 10
SELECT 
    P.FirstName,
    P.LastName,
    R.DateAdmitted,
    R.BedID,
    B.RoomID,
    CC.CareCenterName,
    CC.Location
FROM 
    Resident R
    JOIN Patient PT ON R.ResPatientID = PT.PatientID
    JOIN Person P ON PT.PatientID = P.PersonID
    JOIN Bed B ON R.BedID = B.BedID
    JOIN CareCenter CC ON B.CareCenterID = CC.CareCenterID
ORDER BY 
    R.DateAdmitted ASC;    
    
    
    




--UC1 Creating Database
CREATE DATABASE PAYROLL_SERVICES
USE PAYROLL_SERVICES;

--UC2-Creating Table 
CREATE TABLE Employee_Payroll(
Id int PRIMARY KEY IDENTITY(1,1),
Name varchar(30) NOT NULL,
Salary BIGINT NOT NULL,
Start DATE NOT NULL
);

--UC3-Inserting values into Table
INSERT INTO Employee_Payroll(
Name,Salary,Start)VALUES('Shubham',45000,'2023-03-02'),('Tejas',55000,'2017-04-21'),('Akshay',20000,'2020-06-17');

--UC4-Retrieve All Data from table
SELECT * FROM Employee_Payroll

--UC5-Retrieve salary data for particular employee as well as all employees who joined particular data range
SELECT Salary FROM Employee_Payroll WHERE Name='Shubham';
SELECT * FROM Employee_Payroll WHERE START BETWEEN CAST('2020-06-17' As DATE) AND GETDATE();

--UC6-Add Gender Column and Update the Rows to reflect the correct Employee Gender
ALTER TABLE Employee_Payroll ADD Gender varchar(10);
UPDATE Employee_Payroll SET Gender='M' WHERE Name='Shubham';
UPDATE Employee_Payroll SET Gender='M' WHERE Name='Tejas';
UPDATE Employee_Payroll SET Gender='M' WHERE Name='Akshay';
UPDATE Employee_Payroll SET Salary=45000 WHERE Name='Akshay';

--UC7-Find sum,average, min, max and number of male and female employees
SELECT AVG(Salary) FROM Employee_Payroll WHERE Gender='M' GROUP BY Gender;
SELECT SUM(Salary) FROM Employee_Payroll WHERE Gender='M' GROUP BY Gender;
SELECT MAX(Salary) FROM Employee_Payroll WHERE Gender='M' GROUP BY Gender;
SELECT MIN(Salary) FROM Employee_Payroll WHERE Gender='M' GROUP BY Gender;
SELECT COUNT(Salary) FROM Employee_Payroll WHERE Gender='M' GROUP BY Gender;
SELECT COUNT(Salary) FROM Employee_Payroll WHERE Gender='F' GROUP BY Gender;

--UC8 Adding Employee Additional Information
USE PAYROLL_SERVICES;
ALTER TABLE Employee_Payroll ADD PhoneNo BIGINT;
ALTER TABLE Employee_Payroll ADD EmpAddress VARCHAR(100) NOT NULL DEFAULT 'INDIA';
ALTER TABLE Employee_Payroll ADD Department VARCHAR(20) NOT NULL DEFAULT 'Research';
UPDATE Employee_Payroll SET PhoneNo=7853646345 WHERE Id=1;
UPDATE Employee_Payroll SET PhoneNo=8674554534 WHERE Id=2;
UPDATE Employee_Payroll SET PhoneNo=9833425367 WHERE Id=3;
SELECT * FROM Employee_Payroll

--UC9 Adding Pays Columns further to te table
--ALTER TABLE Employee_Payroll RENAME COLUMN 'Salary' TO 'Basic_Pay';
EXEC SP_RENAME 'Employee_Payroll.Salary', 'BasicPay', 'COLUMN';
ALTER TABLE Employee_Payroll ADD Deductions FLOAT NOT NULL DEFAULT 0.00;
ALTER TABLE Employee_Payroll ADD TaxablePay FLOAT NOT NULL DEFAULT 0.00;
ALTER TABLE Employee_Payroll ADD IncomeTax FLOAT NOT NULL DEFAULT 0.00;
ALTER TABLE Employee_Payroll ADD NetPay FLOAT NOT NULL DEFAULT 0.00;

UPDATE Employee_Payroll SET NetPay = (BasicPay - Deductions - TaxablePay - IncomeTax);
UPDATE Employee_Payroll SET Deductions=4000 WHERE Id IN (1,3);
UPDATE Employee_Payroll SET Deductions=6000 WHERE Id=2;
UPDATE Employee_Payroll SET Deductions=2000 WHERE Id=4;

--UC10- Adding Department of Tejas as Sales & Marketing Both
UPDATE Employee_Payroll SET Department='Sales' WHERE Name='Tejas';
INSERT INTO Employee_Payroll VALUES('Tejas',30000,'2019-06-07','M',7864646455,'SRE','Marketing',0.0,0.0,0.0,30000)
SELECT * FROM Employee_Payroll

--UC11-Creating ER Diagrams
--Employee Table, Company Table, Payroll Table, Department Table(For Joining many to many Relationship), Employee Department Table will be the entities For Normalization
DROP TABLE Employee_Payroll; --deleting the existing table(Employee_Payroll)

--Create new table(Company)
CREATE TABLE Company(
CompanyID INT PRIMARY KEY IDENTITY(1,1),
CompanyName VARCHAR(30)
);
SELECT * FROM Company
INSERT INTO Company VALUES('HCL'),('INFOSYS');
INSERT INTO Company VALUES('TCS');

--Create new table(Employee)
CREATE TABLE Employee(
EmployeeID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
EmployeeName VARCHAR(30) NOT NULL,
Gender CHAR(1) NOT NULL,
PhoneNo BIGINT,
EmployeeAddress VARCHAR(100),
CompanyID INT,
StartDate DATE NOT NULL
FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

SELECT * FROM Employee
INSERT INTO Employee VALUES
('Shubham','M',7206594149,'Rampuri Colony',1,'2017-09-15'),
('Rahul','M',7015906297,'Royal Garden',2,'2017-09-15'),
('Abhishek','M',8950595579,'Delhi Road',1,'2019-05-12'),
('Komal','F',9466365917,'Patel Nagar',2,'2017-05-09');

--create new table(PayRoll)
CREATE TABLE PayRoll(
BasicPay FLOAT NOT NULL DEFAULT 0.00,
Deductions FLOAT NOT NULL DEFAULT 0.00,
TaxablePay FLOAT,
IncomeTax FLOAT NOT NULL DEFAULT 0.00,
NetPay FLOAT,
EmployeeID INT,
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
SELECT * FROM PayRoll
INSERT INTO PayRoll(BasicPay,Deductions,IncomeTax,EmployeeID)VALUES
(2000000,20000,10000,1),
(2500000,18000,9000,2),
(1500000,25000,12500,3),
(3000000,30000,15000,4);

UPDATE PayRoll SET TaxablePay = (BasicPay - Deductions);
UPDATE PayRoll SET NetPay = (TaxablePay - IncomeTax);

--create new table(Department)
CREATE TABLE Department(
DepartmentID INT PRIMARY KEY IDENTITY(1,1),
DepartmentName VARCHAR(30)
);
SELECT * FROM Department
INSERT INTO Department VALUES
('Sales'),('Marketing'),('HR'),('Research');

--create new table(EmployeeDepartment)
CREATE TABLE EmployeeDepartment(
EmployeeID INT,
DepartmentID INT,
FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
FOREIGN KEY(DepartmentID) REFERENCES Department(DepartmentID)
);
SELECT * FROM EmployeeDepartment
INSERT INTO EmployeeDepartment VALUES
(1,1),(1,3),(2,4),(3,2),(4,1),(4,4);

--UC12- Retrieving data for Previous UC's

--Retrieving All data of All Employees
SELECT * FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyID
INNER JOIN PayRoll ON PayRoll.EmployeeID = Employee.EmployeeID
INNER JOIN EmployeeDepartment ON EmployeeDepartment.EmployeeID = Employee.EmployeeID
INNER JOIN Department ON Department.DepartmentID = EmployeeDepartment.DepartmentID

--Retrieving Payroll Data with Specific Employee Name
SELECT EmployeeName,CompanyName,Gender,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,StartDate,DepartmentName
FROM Company
INNER JOIN Employee ON Employee.CompanyID = Company.CompanyID AND Employee.EmployeeName = 'Shubham'
INNER JOIN PayRoll ON PayRoll.EmployeeID = Employee.EmployeeID
INNER JOIN EmployeeDepartment ON EmployeeDepartment.EmployeeID = Employee.EmployeeID
INNER JOIN Department ON Department.DepartmentID = EmployeeDepartment.DepartmentID

--Retrieving Data from a range of Date
SELECT EmployeeName,CompanyName,Gender,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,StartDate,DepartmentName
FROM Company
INNER JOIN Employee ON Employee.CompanyID = Company.CompanyID AND StartDate BETWEEN CAST('2017-09-15' AS DATE) AND GETDATE()
INNER JOIN PayRoll ON PayRoll.EmployeeID = Employee.EmployeeID
INNER JOIN EmployeeDepartment ON EmployeeDepartment.EmployeeID = Employee.EmployeeID
INNER JOIN Department ON Department.DepartmentID = EmployeeDepartment.DepartmentID

--Using Aggregate and grouping by gender
SELECT Gender,AVG(BasicPay) AS AvgSal FROM Employee 
INNER JOIN PayRoll on PayRoll.EmployeeID=Employee.EmployeeID GROUP BY Gender

SELECT Gender,SUM(BasicPay) AS TotalPay FROM Employee 
INNER JOIN PayRoll on PayRoll.EmployeeID=Employee.EmployeeID GROUP BY Gender

SELECT SUM(BasicPay) AS TotalPay FROM Employee 
INNER JOIN PayRoll on PayRoll.EmployeeID=Employee.EmployeeID WHERE Gender='M'

SELECT Gender,MAX(BasicPay) AS MaximumSalary FROM Employee 
INNER JOIN PayRoll on PayRoll.EmployeeID=Employee.EmployeeID GROUP BY Gender

SELECT Gender,MIN(BasicPay) AS MinimumSalary FROM Employee 
INNER JOIN PayRoll on PayRoll.EmployeeID=Employee.EmployeeID GROUP BY Gender

SELECT Gender,COUNT(BasicPay) AS NoOfPays FROM Employee 
INNER JOIN PayRoll on PayRoll.EmployeeID=Employee.EmployeeID GROUP BY Gender
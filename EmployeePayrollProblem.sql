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
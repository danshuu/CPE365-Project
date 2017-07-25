-- Create Database

DROP DATABASE IF EXISTS Job;
CREATE DATABASE Job;
USE Job;

CREATE TABLE City (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(25) NOT NULL,
   state CHAR(2) NOT NULL
);

CREATE TABLE Company (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(40) NOT NULL,
   cityID INT NOT NULL,
   CONSTRAINT FKCompany_cityId FOREIGN KEY (cityId)
    REFERENCES City(id)
    ON UPDATE CASCADE
);

CREATE TABLE Department (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(50) NOT NULL,
   companyId INT NOT NULL,
   CONSTRAINT FKDepartment_companyId FOREIGN KEY (companyId)
    REFERENCES Company(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   UNIQUE KEY UKname_companyId(name, companyId)
);

CREATE TABLE HometownAddress (
   id INT PRIMARY KEY AUTO_INCREMENT,
   addressNumber CHAR(5) NOT NULL,
   street VARCHAR(40) NOT NULL,
   zipcode CHAR(5) NOT NULL,
   cityId INT NOT NULL,
   CONSTRAINT FKHometownAddress_cityId FOREIGN KEY (cityId)
    REFERENCES City(id)
    ON UPDATE CASCADE,
   UNIQUE KEY UKaddressNumber_street_zipcode_cityId (addressNumber, street, zipcode, cityId)
);

CREATE TABLE Person (
   id INT PRIMARY KEY AUTO_INCREMENT,
   firstName VARCHAR(30) NOT NULL,
   lastName VARCHAR(30) NOT NULL,
   age TINYINT UNSIGNED,
   gender ENUM('M', 'F', 'Other'),
   hometownAddressId INT,
   INDEX INage (age),
   CONSTRAINT FKPerson_hometownAddressId FOREIGN KEY (hometownAddressId)
    REFERENCES HometownAddress(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE Profession (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(30) NOT NULL,
   division ENUM('Upper', 'Lower') NOT NULL
);

CREATE TABLE Rating (
   ratedId INT,
   score TINYINT UNSIGNED NOT NULL,
   raterId INT,
   CONSTRAINT FKRating_ratedId FOREIGN KEY (ratedId)
    REFERENCES Person(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKRating_raterId FOREIGN KEY (raterId)
    REFERENCES Person(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE CompanyXProfession (
   companyId INT NOT NULL,
   professionId INT NOT NULL, 
   CONSTRAINT FKCompanyXProfession_professionId FOREIGN KEY (professionId)
    REFERENCES Profession(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKCompanyXProfession_companyId FOREIGN KEY (companyId)
    REFERENCES Company(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   UNIQUE KEY UKcompanyId_professionalId(companyId, professionId)
);

CREATE TABLE Employee (
   personId INT NOT NULL,
   professionId INT NOT NULL,
   hiredDate DATE NOT NULL,
   salary DECIMAL(8, 2) UNSIGNED NOT NULL,
   deptId INT NOT NULL,
   companyId INT NOT NULL,
   INDEX INsalary (salary),
   INDEX INhiredDate (hiredDate),
   CONSTRAINT FKEmployee_personId FOREIGN KEY (personId)
    REFERENCES Person(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKEmployee_professionId FOREIGN KEY (professionId)
    REFERENCES Profession(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKEmployee_deptId FOREIGN KEY (deptId)
    REFERENCES Department(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKEmployee_companyId FOREIGN KEY (companyId)
    REFERENCES Company(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   UNIQUE KEY UKpersonId (personId)
);
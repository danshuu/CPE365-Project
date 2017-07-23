-- Create Database

DROP DATABASE IF EXISTS Job;
CREATE DATABASE Job;
USE Job;

CREATE TABLE City (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(25) NOT NULL,
   state CHAR(2) NOT NULL
);

CREATE TABLE Address (
   id INT PRIMARY KEY AUTO_INCREMENT,
   addressNumber CHAR(5) NOT NULL,
   street VARCHAR(40) NOT NULL,
   zipcode CHAR(5) NOT NULL,
   zipcodeExt CHAR(4),
   cityId INT NOT NULL,
   CONSTRAINT FKAddress_cityId FOREIGN KEY (cityId)
    REFERENCES City(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE Profession (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(30) NOT NULL
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

CREATE TABLE Person (
   id INT PRIMARY KEY AUTO_INCREMENT,
   firstName VARCHAR(30) NOT NULL,
   lastName VARCHAR(30) NOT NULL,
   age TINYINT UNSIGNED,
   gender ENUM('M', 'F', 'Other'),
   addressId INT,
   CONSTRAINT FKPerson_addressId FOREIGN KEY (addressId)
    REFERENCES Address(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
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
   companyId INT,
   professionId INT,
   CONSTRAINT FKCompanyXProfession_companyId FOREIGN KEY (companyId)
    REFERENCES Company(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKCompanyXProfession_professionId FOREIGN KEY (professionId)
    REFERENCES Profession(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   UNIQUE KEY UKcompanyId_professionId(companyId, professionId)
);

CREATE TABLE Employee (
   personId INT,
   professionId INT,
   deptId INT,
   salary DECIMAL(8, 2) UNSIGNED NOT NULL,
   hiredDate DATE NOT NULL,
   division ENUM('Upper', 'Lower'),
   CONSTRAINT FKEmployee_personId FOREIGN KEY (personId)
    REFERENCES Person(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKEmployee_professionId FOREIGN KEY (professionId)
    REFERENCES Profession(id)
    ON UPDATE CASCADE,
   CONSTRAINT FKEmployee_deptId FOREIGN KEY (deptId)
    REFERENCES Department(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
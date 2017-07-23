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

CREATE TABLE Profession (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(30) NOT NULL
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
   hiredDate DATE NOT NULL,
   division ENUM('Upper', 'Lower') NOT NULL,
   salary DECIMAL(8, 2) UNSIGNED NOT NULL,
   deptId INT NOT NULL,
   CONSTRAINT FKPersonXProfession_personId FOREIGN KEY (personId)
    REFERENCES Person(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKPersonXProfession_professionId FOREIGN KEY (professionId)
    REFERENCES Profession(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKPersonXProfession_deptId FOREIGN KEY (deptId)
    REFERENCES Department(id)
    ON UPDATE CASCADE
);

INSERT INTO Person (firstName, lastName, age, gender) VALUES 
   ('Bob', 'Smith', 21, 'M'), 
   ('Mary', 'James', 29, 'F'),
   ('Jane', 'Smith', 45, 'F'),
   ('Bob', 'James', 18, 'M'),
   ('Janice', 'Tan', 34, 'Other'),
   ('Bob', 'Smith', 24, 'M'),
   ('Red', 'Fire', 29, 'F');

INSERT INTO Profession VALUES
   (1, "Software Engineer"),
   (2, "Retail Specialist"),
   (3, "Manager"),
   (4, "Phone Operator");

INSERT INTO City VALUES
   (1, "Los Angeles", 'CA'),
   (2, "Mountain View", 'CA'),
   (3, "Sunnyvale", 'CA'),
   (4, "Miami", 'FL'),
   (5, "Seattle", 'WA'),
   (6, "Austin", 'TX'),
   (7, "Cupertino", 'CA'),
   (8, "Palo Alto", 'CA');

INSERT INTO Company VALUES
   (1, "Google", 1),
   (2, "Google", 2),
   (3, "Google", 3),
   (4, "Google", 4),
   (5, "Google", 5),
   (6, "Google", 6),
   (7, "Apple", 3),
   (8, "Apple", 6),
   (9, "Apple", 7),
   (10, "Microsoft", 8);

INSERT INTO Department VALUES
   (1, "Mobile Development", 1),
   (2, "Mobile Development", 2),
   (3, "Mobile Development", 3),
   (4, "Mobile Development", 4),
   (5, "Mobile Development", 7),
   (6, "Mobile Development", 8),
   (7, "Mobile Development", 9),
   (8, "Mobile Development", 10),
   (9, "Customer Support", 1),
   (10, "Customer Support", 2),
   (11, "Customer Support", 5),
   (12, "Customer Support", 6),
   (13, "Customer Support", 7),
   (14, "Customer Support", 8),
   (15, "Customer Support", 10),
   (16, "Window Cleaning", 10);

INSERT INTO CompanyXProfession VALUES
   (1, 1), (1, 2), (1, 3), (1, 4),
   (2, 1), (2, 2), (2, 3), (2, 4),
   (3, 1), (3, 2), (3, 3),
   (4, 3), (4, 4),
   (5, 1),
   (6, 2), (6, 3),
   (7, 1), (7, 2), (7, 3), (7, 4),
   (8, 3), (8, 4),
   (9, 4),
   (10, 1), (10, 2), (10, 3), (10, 4);

INSERT INTO Employee VALUES
   (1, 1, '2014-04-04', 'Upper', 15.50, 1),
   (2, 2, '2015-06-07', 'Upper', 20.00, 1),
   (3, 3, '2015-06-07', 'Upper', 30.00, 2),
   (4, 4, '2016-01-24', 'Lower', 18.00, 1),
   (5, 1, '2012-01-24', 'Lower', 14.00, 10),
   (6, 3, '2012-01-24', 'Upper', 18.00, 8);

INSERT INTO Rating VALUES
   (1, 4, 4),
   (2, 8, 4);

INSERT INTO Address VALUES
   (1, '1111', 'Happy Lane', '93410', NULL, 4);
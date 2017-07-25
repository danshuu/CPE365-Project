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
   professionId INT NOT NULL,
   companyId INT NOT NULL, 
   CONSTRAINT FKPersonXCompany_professionId FOREIGN KEY (professionId)
    REFERENCES Profession(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   CONSTRAINT FKPersonXCompany_companyId FOREIGN KEY (companyId)
    REFERENCES Company(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
   UNIQUE KEY UKprofessionId_companyId(professionId, companyId)
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

INSERT INTO City VALUES
   (1, "Los Angeles", 'CA'),
   (2, "Mountain View", 'CA'),
   (3, "Sunnyvale", 'CA'),
   (4, "Miami", 'FL'),
   (5, "Seattle", 'WA'),
   (6, "Austin", 'TX'),
   (7, "Cupertino", 'CA'),
   (8, "Palo Alto", 'CA'),
   (9, "San Diego", 'CA'),
   (10, "Portland", 'OR');

INSERT INTO HometownAddress VALUES
   (1, '1111', 'Happy Lane', '93410', 4),
   (2, '1121', 'Happy Lane2', '93420', 9),
   (3, '1131', 'Happy Lane3', '93430', 1);

INSERT INTO Person (firstName, lastName, age, gender, hometownAddressId) VALUES 
   ('Bob', 'Smith', 21, 'M', 1), 
   ('Mary', 'James', 29, 'F', 1),
   ('Jane', 'Smith', 45, 'F', 3),
   ('Bob', 'James', 18, 'M', 1),
   ('Janice', 'Tan', 34, 'Other', 2),
   ('Bob', 'Smith', 24, 'M', 1),
   ('Red', 'Fire', 29, 'F', 2), 
   ('Kobe', 'Bryant', 38, 'M', 2),
   ('Janice', 'White', 32, 'F', 2),
   ('Michael', 'Jordan', 54, 'M', 2),
   ('Lebron', 'James', 32, 'M', 1),
   ('Jerry', 'West', 64, 'M', 1),
   ('Random', 'Smith', 24, 'Other', 3),
   ('Boss', 'Big', 30, 'F', 3);

INSERT INTO Profession VALUES
   (1, "Software Engineer", "Lower"),
   (2, "Retail Specialist", "Lower"),
   (3, "Manager", "Upper"),
   (4, "Phone Operator", "Lower");

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

INSERT INTO Employee VALUES
   (1, 1, '2014-04-04', 15.50, 1, 3),
   (2, 1, '2015-06-07', 20.00, 1, 9),
   (3, 3, '2015-06-07', 30.00, 2, 6),
   (4, 4, '2016-01-24', 18.00, 1, 2),
   (5, 1, '2012-01-24', 14.00, 10, 2),
   (6, 3, '2012-01-24', 18.00, 8, 9),
   
   (7, 1, '2015-06-07', 30.00, 2, 3),
   (8, 4, '2016-01-24', 18.00, 1, 10),
   (9, 1, '2012-01-24', 14.00, 10, 1),
   (10, 3, '2012-01-24', 18.00, 8, 10),
   (11, 3, '2015-06-07', 30.00, 2, 3),
   (12, 4, '2016-01-24', 18.00, 1, 10),
   (13, 1, '2012-01-24', 14.00, 10, 7),
   (14, 3, '2015-02-12', 25.30, 10, 7);

INSERT INTO CompanyXProfession (professionId, companyId) 
(select distinct e.professionId, e.companyId from Employee e order by companyId);
   
INSERT INTO Rating VALUES
   (1, 4, 4),
   (2, 8, 4),
   (13, 5, 14),
   (9, 9, 14),
   (2, 8, 5);
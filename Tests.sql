-- Test Suite

-- List a count of all employees at every company
select c.name Company, count(p.id) numEmployees from Person p join Employee e on p.id = personId join Company c on c.id = companyId group by c.name;

-- List 'x' profession in each department of 'y' company

-- List a count of employees who live in each city at 'x' company

-- List the top five companies with the highest average salary of lower division workers

-- List every city ordered by the highest average salary to the lowest average salary

-- List the count of 'x' profession at all companies ordered by count of 'x' profession
SELECT Co.name "Company", COUNT(*) "Managers"
FROM Company Co JOIN Department D
ON Co.id = companyId JOIN Employee E
ON D.id = deptId JOIN Profession P
ON E.professionId = P.id
WHERE P.name = "Manager"
GROUP BY Co.name;

-- List the top five companies with the lowest employee ratings on average
-- POSSIBLY WORKS
SELECT C.name "Company", AVG(score) "score"
FROM Rating R JOIN Employee E
ON R.ratedId = E.personId JOIN Department D
ON E.deptId = D.id JOIN Company C
ON D.companyId = C.id
GROUP BY C.name
ORDER BY AVG(score) DESC
LIMIT 5;

-- List all employees who were hired before 'x' date and have a rating of 'y' or greater

-- List company and city where the company has at least 5 employees hired before 'y' date
-- WORKING
SELECT Co.name "Company", C.name "City", COUNT(*) "Employee Count"
FROM Employee E JOIN Department D
ON deptId = D.id JOIN Company Co
ON D.companyId = Co.id JOIN City C
ON cityId = C.id
WHERE hiredDate < '2016-01-01'
GROUP BY Co.name, C.name
HAVING COUNT(*) >= 5;

-- List each department in 'x' company that has at least 3 employees with a rating of 'y' or greater

-- List each person and score rated by 'x' rater

-- List each employee with a lower division profession who has not received a rating
SELECT firstName "First Name", lastName "Last Name", Pro.name "Profession"
FROM Profession Pro JOIN Employee E 
ON Pro.id = E.professionId LEFT JOIN Rating R
ON E.personId = R.ratedId JOIN Person P
ON E.personId = P.id
WHERE R.ratedId IS NULL
 AND Pro.division = 'Lower';

-- List each address and the employees where at least 2 employees from 'x' company have the same address
SELECT CONCAT(H.addressNumber, " ", H.street, ", ", C.name) "Address", 
 CONCAT(P1.firstName, " ", P1.lastName) "Employee 1", 
 CONCAT(P2.firstName, " ", P2.lastName) "Empolyee 2"
FROM Company Co JOIN Department D
ON Co.id = companyId JOIN Employee E1
ON D.id = E1.deptId JOIN Employee E2
ON D.id = E2.deptId
 AND E1.personId < E2.personId JOIN Person P1
ON E1.personId = P1.id JOIN Person P2
ON E2.personId = P2.id
 AND P1.hometownAddressId = P2.hometownAddressId JOIN HometownAddress H
ON P1.hometownAddressId = H.id JOIN City C
ON H.cityId = C.id
WHERE Co.name = "Google";

-- List each company, city, and profession where the company offers the profession but has no employees in the profession
SELECT DISTINCT Co.name "Comapny", C.name "City", P.name "Profession"
FROM Profession P JOIN CompanyXProfession CXP 
ON P.id = CXP.professionId JOIN Company Co
ON CXP.companyId = Co.id JOIN City C
ON Co.cityId = C.id JOIN Department D
ON Co.id = D.companyId LEFT JOIN Employee E
ON D.id = deptId
 AND CXP.professionId = E.professionId
WHERE E.professionId IS NULL;

-------

-- How many software engineers are at Google?
select c.name Company, count(e.personId) numSE from Profession prof join Employee e on e.professionId = prof.id join Company c on companyId = c.id where prof.name = "Software Engineer" group by Company;

-- How many software engineers at Google are females under the age of 26 hired before June 1, 1998?
select c.name Company, p.firstName, count(e.personId) numSE from Profession prof join Employee e on e.professionId = prof.id join Person p on p.id = e.personId join Company c on companyId = c.id where prof.name = "Software Engineer" and p.gender = 'F' and p.age > 26 and c.name = "Google" and e.hiredDate < "1998-06-01";

-- list the departments at Apple.
select d.name Dept from Department d join Company c on companyId = c.id where c.name = "Apple";

-- How many female software engineers are making above the average salary at Google?
select count(p.id) Count from Person p join Employee e on personId = p.id join Profession pf on pf.id = e.professionId where gender = 'F' and pf.name = "Software Engineer" and salary > (select avg(salary) from Employee join Company on companyId = Company.id where name = "Google");

-- How many software engineers are there in San Diego, CA?
select count(p.id) Count from City cty join HometownAddress ha on cty.id = ha.cityId join Person p on hometownAddressId = ha.id join Employee e on personId = p.id join Profession pf on pf.id = e.professionId where pf.name = "Software Engineer" and cty.name = "San Diego";

-- How many software engineers are there in San Diego, CA working at Google?
select count(p.id) Count from City cty join HometownAddress ha on cty.id = ha.cityId join Person p on hometownAddressId = ha.id join Employee e on personId = p.id join Profession pf on pf.id = e.professionId join Company c on c.id = e.companyId where pf.name = "Software Engineer" and cty.name = "San Diego" and c.name = "Google";



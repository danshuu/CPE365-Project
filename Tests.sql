-- Test Suite
-- Daniel Shu, Esteban Ramos, and Calvin Nguyen

-- 1. List a count of all employees at every company
select c.name Company, count(p.id) numEmployees 
from Person p join Employee e on p.id = personId join Company c on c.id = companyId 
group by c.name;

-- 2. List 'x' profession in each department of 'y' company
-- ex) list all the departments that software engineers work in at Google.
select distinct d.name
from Company c join CompanyXProfession cxp on c.id = cxp.companyId
     join Profession p on p.id = cxp.professionId
     join Department d on d.companyId = c.id
WHERE (p.name = "Software Engineer" and c.name = "Google");

-- 3. List a count of employees who live in each city at 'x' company
-- re-word: list the total number of employees from their homewtowns who work at google
-- i.e a count of 4 employees from Los Angeles that work at Google. and 3 from SD that work at Google.. etc.

select count(*) as "Num Employees from:", c.name as "City:", co.name "Working at:"
from Employee e, Person p, HometownAddress h, City c, Company co 
WHERE p.id = e.personId and h.id = p.hometownAddressId and c.id = h.cityId and e.companyId = co.id
      and co.name = "Google"
group by c.name;

-- 4. List every hometown city ordered by the highest average salary to the lowest average salary
select c.name as "Hometown", avg(e.salary) as "Avg Salary"
from Employee e, Person p, HometownAddress h, City c
where p.id = e.personId and h.id = p.hometownAddressId and c.id = h.cityId
group by c.name
order by "Avg Salary" desc;

-- 5. List the profession name and the count of 'x' profession at all companies ordered by count of 'x' profession
-- (x = software engineers)
select p.name as "Profession", count(*) as "Employee Count", c.name as "Company"
from Profession p, Company c, Employee e
WHERE p.id = e.professionId 
 and c.id = e.companyId
 and p.name = "Software Engineer"
group by c.name
order by "Employee Count";

-- 6. List the top five companies with the lowest employee ratings on average
-- POSSIBLY WORKS
SELECT C.name "Company", AVG(score) "score"
FROM Rating R JOIN Employee E
ON R.ratedId = E.personId JOIN Department D
ON E.deptId = D.id JOIN Company C
ON D.companyId = C.id
GROUP BY C.name
ORDER BY AVG(score) DESC
LIMIT 5;

-- 7. List all employees who were hired before 'x' date and have a rating of 'y' or greater
-- (x = June 20th 2015)
-- (y = 6)
select firstName, lastName
from Person p, Employee e, Rating r
WHERE p.id = e.personId and r.ratedId = e.personId and (hiredDate < "2015-06-20" and score >= 6);

-- 8. List company and city where the company has at least 5 employees hired before 'y' date
-- WORKING
SELECT Co.name "Company", C.name "City", COUNT(*) "Employee Count"
FROM Employee E JOIN Department D
ON deptId = D.id JOIN Company Co
ON D.companyId = Co.id JOIN City C
ON cityId = C.id
WHERE hiredDate < '2016-01-01'
GROUP BY Co.name, C.name
HAVING COUNT(*) >= 5;

-- 9. List each employee and score rated by 'x' rater
SELECT firstName, lastName, score
FROM Person P JOIN Employee E 
ON P.id = E.personId JOIN Rating R
ON E.personId = R.ratedId
WHERE R.raterId = 14;

-- 10. List each employee with a lower division profession who has not received a rating
SELECT firstName "First Name", lastName "Last Name", Pro.name "Profession"
FROM Profession Pro JOIN Employee E 
ON Pro.id = E.professionId LEFT JOIN Rating R
ON E.personId = R.ratedId JOIN Person P
ON E.personId = P.id
WHERE R.ratedId IS NULL
 AND Pro.division = 'Lower';

-- 11. List each address and the employees where at least 2 employees from 'x' company have the same address
SELECT CONCAT(H.addressNumber, " ", H.street, ", ", C.name) "Address", 
 CONCAT(P1.firstName, " ", P1.lastName) "Employee 1", 
 CONCAT(P2.firstName, " ", P2.lastName) "Employee 2"
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

-- 12. List each company, city, and profession where the company offers the profession but has no employees in the profession
SELECT DISTINCT Co.name "Company", C.name "City", P.name "Profession"
FROM Profession P JOIN CompanyXProfession CXP 
ON P.id = CXP.professionId JOIN Company Co
ON CXP.companyId = Co.id JOIN City C
ON Co.cityId = C.id JOIN Department D
ON Co.id = D.companyId LEFT JOIN Employee E
ON D.id = deptId
 AND CXP.professionId = E.professionId
WHERE E.professionId IS NULL;

-- 13. List every manager who has not rated an employee
SELECT P.id, firstName, lastName
FROM Profession Pro JOIN Employee E
ON Pro.id = E.professionId JOIN Person P
ON E.personId = P.id
WHERE NOT EXISTS (
   SELECT *
   FROM Rating R
   WHERE E.personId = R.raterId
)
 AND Pro.name = "Manager";

-- 14. List all lower division employees with a salary greater than or equal to 15.00
SELECT P.id, firstName, lastName, salary
FROM Person P JOIN Employee E
ON P.id = E.personId JOIN Profession Pro
ON E.professionId = Pro.id
WHERE Pro.division = "Lower"
 AND salary >= 15;

-- 15. How many software engineers are at Google?
select c.name Company, count(e.personId) numSE 
from Profession prof join Employee e on e.professionId = prof.id 
join Company c on companyId = c.id 
where prof.name = "Software Engineer" 
group by Company;

-- 16. How many software engineers at Google are females under the age of 26 hired before June 1, 1998?
select  c.name Company, p.firstName, count(e.personId) numSE 
from Profession prof join Employee e on e.professionId = prof.id join Person p on p.id = e.personId join Company c on companyId = c.id 
where prof.name = "Software Engineer" and p.gender = 'F' and p.age > 26 and c.name = "Google" and e.hiredDate < "1998-06-01";

-- 17. list the departments at Apple.
select d.name Dept 
from Department d join Company c on companyId = c.id 
where c.name = "Apple";

-- 18. How many female software engineers are making above the average salary at Google?
select count(p.id) Count 
from Person p join Employee e on personId = p.id join Profession pf on pf.id = e.professionId 
where gender = 'F' and pf.name = "Software Engineer" 
      and salary > (select avg(salary) from Employee join Company on companyId = Company.id where name = "Google");

-- 19. How many software engineers are there in San Diego, CA?
select count(p.id) Count 
from City cty join HometownAddress ha on cty.id = ha.cityId join Person p on hometownAddressId = ha.id 
     join Employee e on personId = p.id join Profession pf on pf.id = e.professionId 
where pf.name = "Software Engineer" and cty.name = "San Diego";

-- 20 How many software engineers are there in San Diego, CA working at Google?
select count(p.id) Count 
from City cty join HometownAddress ha on cty.id = ha.cityId join Person p on hometownAddressId = ha.id 
     join Employee e on personId = p.id join Profession pf on pf.id = e.professionId join Company c on c.id = e.companyId 
where pf.name = "Software Engineer" and cty.name = "San Diego" and c.name = "Google";

-- 21. List of employees who are not living in the same city as their company
SELECT E.personId, firstName, lastName, Co.name "Company"
FROM HometownAddress H JOIN Person P
ON H.id = P.hometownAddressId JOIN Employee E
ON P.id = E.personId JOIN Department D
ON E.deptId = D.id JOIN Company Co
ON D.companyId = Co.id
 AND H.cityId != Co.cityId;


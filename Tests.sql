-- Test Suite

-- List a count of all employees at every company
select c.name Company, count(p.id) numEmployees from Person p join Employee e on p.id = personId join Company c on c.id = companyId group by c.name;

-- List 'x' profession in each department of 'y' company

-- List a count of employees who live in each city at 'x' company

-- List the top five companies with the highest average salary of lower division workers
-- NOT WORKING
SELECT C.name, AVG(salary)
FROM Employee E JOIN Department D
ON E.deptId = D.id JOIN Company C
ON D.companyId = C.id
GROUP BY C.id
HAVING E.division = "Lower"
ORDER BY AVG(salary)
LIMIT 5;

-- List every city ordered by the highest average salary to the lowest average salary

-- List the count of 'x' profession at all companies ordered by count of 'x' profession

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

-- List each company and city where the company has at least 5 employees hired before 'y' date
-- NOT WORKING
SELECT *
FROM City C JOIN Company Co
ON C.id = cityId JOIN Department D
ON Co.id = D.companyId JOIN Employee E
ON D.id = deptId
WHERE hiredDate < '2016-01-01'
 AND Co.name = "Google";

SELECT *
FROM City C JOIN Company Co
ON C.id = cityId JOIN Department D
ON Co.id = D.companyId
WHERE EXISTS (
   SELECT *
   FROM Employee E
   WHERe hiredDate < '2016-01-01'
    AND D.id = deptId
)
 AND Co.name = "Google";
GROUP BY C.name, Co.name
HAVING Co.name = "Google";

-- List each department in 'x' company that has at least 3 employees with a rating of 'y' or greater
-- NOT WORKING
SELECT D.name
FROM Company C JOIN Department D 
ON C.id = companyId JOIN Employee E 
ON D.id = deptId JOIN Rating R
ON E.personId = R.ratedId
WHERE C.name = "Google"

-- List each person and score rated by 'x' rater


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



-- Test Suite

-- List a count of all employees at every company

-- List 'x' profession in each department of 'y' company

-- List a count of employees who live in each city at 'x' company

-- List the top five companies with the highest average salary of lower division workers
-- NOT WORKING
SELECT C.name, AVG(salary)
FROM Employee E JOIN Department D
ON deptId = D.id JOIN Company C
ON companyId = C.id
GROUP BY C.id
HAVING E.division = "Lower"
ORDER BY AVG(salary)
LIMIT 5;

-- List every city ordered by the highest average salary to the lowest average salary

-- List the count of 'x' profession at all companies ordered by count of 'x' profession

-- List the top five companies with the lowest employee ratings on average
-- NOT TESTED
SELECT C.name, AVG(score)
FROM Rating R JOIN Employee E
ON R.ratedId = E.personId JOIN Department D
ON deptId = D.id JOIN Company C
ON companyId = C.id
GROUP BY C.id
ORDER BY AVG(score) DESC
LIMIT 5;

-- List all employees who were hired before 'x' date and have a rating of 'y' or greater

-- List each department in 'x' company that has at least 5 employees hired before 'y' date
-- NOT WORKING
SELECT D.name
FROM Company C JOIN Department D
ON C.id = companyId JOIN Employee E
ON D.id = deptId
WHERE C.name = "Google"
 AND (
    SELECT *
    FROM Department D JOIN Employee E
    ON D.id = deptId
    GROUP BY D.id
    HAVING 
)
ORDER BY D.name;

-- List each department in 'x' company that has at least 5 employees with a rating of 'y' or greater
-- NOT WORKING
SELECT D.name
FROM Company C JOIN Department D 
ON C.id = companyId JOIN Employee E 
ON D.id = deptId JOIN Rating R
ON E.personId = R.ratedId
WHERE C.name = "Google"
GROUP BY D.id
HAVING COUNT(DISTINCT ratedId) >= 5
 AND R.score >= 7;

-------

-- How many software engineers are at Google?

-- How many software engineers at Google are females under the age of 26 hired before
-- hired before June 1, 1998?

-- list the departments at Amazon.

-- How many female software engineers are making above the average salary at Google?

-- How many software engineers are there in San Diego, CA?

-- How many software engineers are there in San Diego, CA working at Google?




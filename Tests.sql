-- Test Suite

-- List a count of all employees at every company

-- List 'x' profession in each department of 'y' company

-- List a count of employees who live in each city at 'x' company

-- List the top five companies with the highest average salary of lower division workers
SELECT C.name, AVG(salary)
FROM Employee E JOIN Department D
ON deptId = D.id JOIN Company C
ON companyId = C.id
GROUP BY C.id
HAVING Employee.division = "Lower"
ORDER BY AVG(salary)
LIMIT 5;

-- List every city ordered by the highest average salary to the lowest average salary

-- List the count of 'x' profession at all companies ordered by count of 'x' profession

-- List the top five companies with the lowest employee ratings on average


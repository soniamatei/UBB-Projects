   -- Show all the adoptions with the name of the animals and people instead of ips. (a
-- point d, g; join 3 tables; 

SELECT P2.name, Animals.name
FROM
	(SELECT People.name, Adoptions.aid
	FROM (Adoptions 
	INNER JOIN People ON Adoptions.pid = People.pid)) P2
INNER JOIN Animals ON Animals.aid = P2.aid;

-- Find the budget necessary to increase the salary of each employee with 20%.
-- point g; 1 X arithmetic op. in SELECT

SELECT sum(S2.new_salary) new_salary
FROM 
	(SELECT salary*0.2 new_salary
	 FROM Employees) S2;

-- Show the oldest's animal id and name that is adopted.
-- point e; where->where->where

SELECT Animals.aid, Animals.name
FROM Animals
WHERE Animals.date_of_birth = 
	(SELECT min(Animals.date_of_birth) Older
	 FROM Animals
	 WHERE Animals.aid IN
		(SELECT Adoptions.aid
		 FROM Adoptions))
AND Animals.aid IN 
	(SELECT Adoptions.aid
	 FROM Adoptions);


-- Show all the breeds that don't correspont to an animal from shelters (and are cat breeds) in alphabetical order.
-- point i; 1 X ALL modified with IN; 1 X AND; 1 X ORDER BY

SELECT Breeds.name
FROM Breeds
WHERE Breeds.bid <> ALL 
	(SELECT Animals.breed
	FROM Animals)
ORDER BY Breeds.name;

SELECT Breeds.name
FROM Breeds
WHERE Breeds.bid <> ALL 
	(SELECT Animals.breed
	FROM Animals) 
AND Breeds.cid IN 
	(SELECT Category.cid
	FROM Category
	WHERE Category.name = 'cat')
ORDER BY Breeds.name;

-- Show the data of all the animals that are adopted (and that are not dogs) ordered by date of birth.
-- point i; 1 X ANY modified with NOT IN; 1 X AND; 1 X ORDER BY

SELECT *
FROM Animals
wHERE Animals.aid = ANY
	(SELECT Adoptions.aid
	FROM Adoptions)
ORDER BY Animals.date_of_birth ASC;

SELECT *
FROM Animals
wHERE Animals.aid = ANY
	(SELECT Adoptions.aid
	FROM Adoptions)
AND Animals.category NOT IN 
	(SELECT Category.cid
	FROM Category
	WHERE Category.name = 'dog')
ORDER BY Animals.date_of_birth ASC;

-- Show all the employees' names that have animals at home.
-- point e, f

SELECT People.name
FROM People
WHERE People.pid IN
	(SELECT Employees.pid
	FROM Employees
	WHERE EXISTS 
		(SELECT Adoptions.pid
		FROM Adoptions
		WHERE Adoptions.pid = Employees.pid));

-- Show which animal had medical treatments after it was adopted.
-- To clearly see which animal had medical treatments between the others.
-- point b, d; AND for contidion

SELECT * 
FROM Medical_Treatments 
LEFT JOIN Animals ON Medical_Treatments.aid = Animals.aid 		   
					 AND Animals.aid IN 
						(SELECT Adoptions.aid
						 FROM Adoptions)
					 AND Medical_Treatments.begin_date < 
						(SELECT Adoptions.date
						 FROM Adoptions
						 WHERE Adoptions.aid = Animals.aid);

-- Show a list with all the people that don't work at a shelter.
-- point c; 1 X EXCEPT

SELECT * 
FROM People
WHERE People.pid = ANY
			(SELECT People.pid
			FROM People
			EXCEPT 
			SELECT Employees.pid
			FROM Employees)

-- Count how many animals, females and males, are younger than 6 months.
-- point h

SELECT Animals.sex, count(Animals.date_of_birth)
FROM Animals
WHERE DATEDIFF(MONTH, Animals.date_of_birth, (SELECT CAST( GETDATE() AS Date )) ) <= 6
GROUP BY Animals.sex;

-- Calculate which medical treatments have an average of cost bigger than 100.
-- point h

SELECT  Medical_Treatments.treatment, avg(Medical_Treatments.cost) average
FROM Medical_Treatments
GROUP BY Medical_Treatments.treatment
HAVING avg(Medical_Treatments.cost) > 100

-- Show the average age of animals, gouped by females and males, which is bigger than the age of the youngest animal.
-- point h

SELECT t.sex, avg(t.years)
FROM 
	(select Animals.sex, DATEDIFF(year, Animals.date_of_birth, (SELECT CAST( GETDATE() AS Date))) years
	 from Animals) t
GROUP BY t.sex
HAVING  avg(t.years) >= 
	(SELECT min(t1.years) average
	 FROM
		 (SELECT DATEDIFF(year, Animals.date_of_birth, (SELECT CAST( GETDATE() AS Date))) years
		  FROM Animals) t1);

-- Show the info of all animals that don't have medical records (and count how many there are).
-- point i; 1X ALL modified with aggr. op.

SELECT *
	FROM Animals
	WHERE Animals.aid <> ALL 
		(SELECT Medical_Treatments.aid
		 FROM Medical_Treatments
		 GROUP BY Medical_Treatments.aid)

SELECT count(*) count
FROM 
	(SELECT *
	FROM Animals
	WHERE Animals.aid <> ALL 
		(SELECT Medical_Treatments.aid
		 FROM Medical_Treatments
		 GROUP BY Medical_Treatments.aid)) t;

-- Show the info of animals adopted NOT from 'Arca lui Noe' (and count them).
-- point i; 1X ANY modified with aggr. op.

SELECT *
FROM Animals
WHERE Animals.sid <> ANY
	(SELECT Shelters.sid
	 FROM Shelters
	 WHERE Shelters.name = 'Arca lui Noe')
AND Animals.aid IN
	(SELECT Adoptions.aid
	 FROM Adoptions);

SELECT count(*) count
FROM 
	(SELECT *
	 FROM Animals
	 WHERE Animals.sid <> ANY
		(SELECT Shelters.sid
		 FROM Shelters
		 WHERE Shelters.name = 'Arca lui Noe')
	 AND Animals.aid IN
		(SELECT Adoptions.aid
		 FROM Adoptions)) t;

-- Show top 3 most expensive medical records.
-- 1 X TOP

SELECT TOP(3)*
FROM Medical_Treatments
ORDER BY Medical_Treatments.cost DESC;

-- Show the info of all people that made at least an adoption.
-- point f

SELECT * 
FROM People
WHERE EXISTS
	(SELECT Adoptions.pid
	 FROM Adoptions
	 WHERE Adoptions.pid = People.pid);

-- Show a list with all the breeds of the animals in the database.
-- 2 x DISTINCT

SELECT DISTINCT Breeds.name
FROM Breeds
WHERE Breeds.bid IN
	(SELECT DISTINCT Animals.breed
	 FROM Animals);

-- Show all the people domiciliated in Cluj-Napoca and Brasov.
-- point a; 1 x UNION

SELECT *
FROM People
WHERE People.domicile LIKE '%Cluj-Napoca%'
UNION 
SELECT *
FROM People
WHERE People.domicile LIKE '%Brasov%';

-- Calculate the sum of all the medical treatments for each animal in database.
-- half point h

SELECT Medical_Treatments.aid, sum(Medical_Treatments.cost)
FROM Medical_Treatments
GROUP BY Medical_Treatments.aid

-- Show all animals born in 2021 and 2022.
-- point a; 1 X OR 

SELECT * 
FROM Animals
WHERE YEAR(Animals.date_of_birth) = 2021 OR YEAR(Animals.date_of_birth) = 2022;

-- Show top 3 OLDEST animals.
-- 1 X TOP; 1 X NOT for condition

SELECT TOP 3 * 
FROM Animals
WHERE Animals.date_of_birth IS NOT NULL
ORDER BY Animals.date_of_birth ASC;

-- Show the name of each association with each shelter with which has a colabration.
-- point d; 2 X FULL JOIN

SELECT T.name Assoc, Shelters.name Shlt
FROM 
	(SELECT Colaborations.sid, Animal_Associations.name
	 FROM Animal_Associations 
	 FULL JOIN Colaborations ON Animal_Associations.aaid = Colaborations.aaid) T
FULL JOIN Shelters ON T.sid = Shelters.sid;
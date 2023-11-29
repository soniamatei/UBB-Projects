-- INSERT --

-- Animals:

INSERT INTO Animals (name, sid, sex, category, breed, color)
VALUES ('Sori' , 1809, 'M', 1, 11, 'Brown');
INSERT INTO Animals 
VALUES ('MAX' , 1809, 'M', 1, 7, 'White and Black', '2013-02-09');
-- delete max		%%%%
INSERT INTO Animals 
VALUES ('Selena' , 2076, 'F', 2, 1, 'Chocolate', '2002-06-22');
INSERT INTO Animals 
VALUES ('Ursulica' , 2076, 'M', 2, 4, 'Grey and Brown', '2022-04-22');
INSERT INTO Animals 
VALUES ('Dori' , 2076, 'F', 2, 5, 'Tricolor', '2021-07-01');
INSERT INTO Animals 
VALUES ('Pantera' , 1809, 'F', 2, 5, 'Black', '2022-04-22');
INSERT INTO Animals 
VALUES ('Lache' , 1809, 'M', 1, 6, 'Golden', '2015-12-30');

-- Shelters:

INSERT INTO Shelters
VALUES ('Arca lui Noe', 'Jud. Cluj, Mun. Cluj-Napoca, Str. Vidului, Nr. 229');
INSERT INTO Shelters
VALUES ('Pisici pe Creier', 'Jud. Brasov, Mun. Rasnov, Str. Pomilor, Nr. 65');

-- Category:

INSERT INTO Category
VALUES ('dog');
INSERT INTO Category
VALUES ('cat');

-- Breeds:

INSERT INTO Breeds
VALUES (2, 'Siamese', 'Short', '12-15', 'Chocolate point', 'Medium (8-15)');
INSERT INTO Breeds
VALUES (2, 'Lykoi', 'Short', '12-15', 'Black', 'Small (6-12)');
INSERT INTO Breeds
VALUES (2, 'Angora', 'Long', '15-18', 'White', 'Small (6-12)');
INSERT INTO Breeds
VALUES (2, 'Ocicat', 'Short', '12-14', 'Fawn', 'Large (10-15)');
INSERT INTO Breeds (cid, name)
VALUES (2, 'European');
INSERT INTO Breeds
VALUES (1, 'Golden Retriever', 'long', '10-12', 'Golden', 'Large (55-80)');
INSERT INTO Breeds
VALUES (1, 'Beagle', 'Short', '12-15', 'Tricolor', 'Small (20-25)');
INSERT INTO Breeds
VALUES (1, 'Collie', 'Long', '14-16', 'Tricolor', 'Large (55-75)');
INSERT INTO Breeds
VALUES (1, 'St. Bernard', 'Medium', '8-10', 'Brown', 'Large (110-200)');
INSERT INTO Breeds
VALUES (1, 'Poodle', 'Long', '12-15', 'Various', 'Medium (45-70)');
-- delete poodle			 %%%%
INSERT INTO Breeds (cid, name)
VALUES (1, 'European');

-- People:

INSERT INTO People
VALUES ('Matei Sonia', 'F', 'Jud. Brasov, Mun. Brasov, Str. Sitarului, Nr. 7', '0740821359', 'sonia@gmail.com');
INSERT INTO People
VALUES ('Mothe Andrei', 'M', 'Jud. Cluj, Mun. Cluj-Napoca, Str. Bobalnei, Nr. 54', '0746861279', 'mothe@gmail.com');
INSERT INTO People
VALUES ('Valentina Mihalescu', 'M', 'Jud. Suceava, Mun. Radauti, Str. Iernuteni, Nr. 89', '0746861279', 'vale@gmail.com');
-- update vale to F and number		****
INSERT INTO People
VALUES ('Claudia Moisiuc', 'F', 'Jud. Cluj, Mun. Cluj-Napoca, Str. Daciei, Nr. 3', '0746668300', 'didi@gmail.com');
INSERT INTO People
VALUES ('David Andrei', 'M', 'Jud. Mures, Mun. Reghin, Str. Pomilor, Nr. 20', '0746753450', 'david@gmail.com');

-- Adoptions:

-- !! VIOLATION !!
INSERT INTO Adoptions
VALUES (17569, 3678, '2016-02-01');
-- !!

INSERT INTO Adoptions
VALUES (17169, 3678, '2016-02-01');
INSERT INTO Adoptions
VALUES (15935, 2877, '2022-05-30');
INSERT INTO Adoptions
VALUES (15935, 3411, '2022-05-30');
INSERT INTO Adoptions
VALUES (18403, 3144, '2022-05-30');
-- update dates for last one		****

-- Employees:

INSERT INTO Employees
VALUES (19637, 2076, 'Cooking', 2223, '2021-01-01');
INSERT INTO Employees
VALUES (20871, 1809, 'Cleaning', 1200, '2018-10-22');
INSERT INTO Employees
VALUES (15935, 2076, 'Cleaning', 900, '2020-09-20');

-- Animal Associations

INSERT INTO Animal_Associations
VALUES ('Veterinarius', 'Jud. Cluj, Mun. Cluj-Napoca, Str. Campina, Nr. 70');
INSERT INTO Animal_Associations
VALUES ('Happy Pets', 'Jud. Brasov, Mun. Brasov, Str. Carierei, Nr. 30');
INSERT INTO Animal_Associations
VALUES ('Veterra', 'Jud. Mures, Mun. Reghin, Str. Zorilor, Nr. 8');

-- Colaborations:

INSERT INTO Colaborations
VALUES (136, 1809, '2021-01-01', '2025-01-01');
INSERT INTO Colaborations
VALUES (220, 2076, '2020-06-01', '2030-06-01');

-- Medical Treatments:

INSERT INTO Medical_Treatments
VALUES (2076, 136, 'Vaccination', 50, '2021-10-10', '2021-10-10');
-- delete				%%%%
INSERT INTO Medical_Treatments
VALUES (3678, 136, 'Parasite Medicamentation', 50, '2012-09-10', '2012-09-15');
-- update date after 2016 for 3678 and price    ****
INSERT INTO Medical_Treatments
VALUES (2610, 136, 'Antibiotics', 900, '2020-02-02', '2020-02-28');
INSERT INTO Medical_Treatments
VALUES (3144, 136, 'Vaccination', 50, '2021-01-10', '2021-01-10');
INSERT INTO Medical_Treatments
VALUES (3411, 136, 'Vaccination', 70, '2022-07-10', '2022-07-10');
INSERT INTO Medical_Treatments
VALUES (2877, 220, 'Vaccination', 70, '2022-08-10', '2022-08-10');
INSERT INTO Medical_Treatments
VALUES (2610, 220, 'Parasite Medicamentation', 500, '2015-09-01', '2015-09-15');

delete from Medical_Treatments
where aid = 2877 and aaid= 136;
-- UPDATE --

-- People:

UPDATE People
SET sex = 'F', phone_number='0742865252', date_of_birth = '2002.12.11'
WHERE pid = 18403;
UPDATE People
SET date_of_birth = '2002.06.26'
WHERE pid = 15935;
UPDATE People
SET date_of_birth = '2006.07.13'
WHERE pid = 17169;
UPDATE People
SET date_of_birth = '2005.01.31'
WHERE pid = 19637;
UPDATE People
SET date_of_birth = '2001.09.27'
WHERE pid = 20871;

-- Adoptions:

UPDATE Adoptions
SET date = '2022-04-10'
WHERE pid = 18403 and aid = 3144;

-- Medical Treatments:

UPDATE Medical_Treatments
SET begin_date = '2016-09-01', end_date = '2016-09-10', cost = 400
WHERE aaid= 136 and aid = 3678;

-- DELETE --

DELETE FROM Animals 
WHERE name = 'MAX' and date_of_birth IS NOT NULL;
DELETE FROM Breeds
WHERE name LIKE '%Poodle%';
DELETE FROM Medical_Treatments
WHERE cost BETWEEN 40 and 100;

 

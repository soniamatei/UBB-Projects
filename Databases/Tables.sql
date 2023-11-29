CREATE TABLE Shelters(
	sid INT IDENTITY(146, 37) PRIMARY KEY,
	name VARCHAR(100),
	address VARCHAR(150)
)

CREATE TABLE People(
	pid INT IDENTITY(13467, 1234) PRIMARY KEY,
	name VARCHAR(100),
	sex VARCHAR CHECK(sex in ('M', 'F')),
	domicile VARCHAR(150),
	phone_number VARCHAR(10), --CHECK(phone_number like '%^[0-9]$%'),
	email VARCHAR(50)
)
ALTER TABLE People
DROP CONSTRAINT CK__People__phone_nu__4F7CD00D;
ALTER TABLE People 
ADD date_of_birth DATE;

CREATE TABLE Animals(
	aid INT IDENTITY(1275, 267) PRIMARY KEY,
	name VARCHAR(50),
	sid INT FOREIGN KEY REFERENCES Shelters(sid),
	sex VARCHAR CHECK(sex in ('M', 'F')),
	category INT FOREIGN KEY REFERENCES Category(cid),
	breed INT FOREIGN KEY REFERENCES Breeds(bid),
	color VARCHAR(30),
	date_of_birth DATE --DEFAULT 'Unknown'
)
select name from sys.default_constraints where parent_object_id=OBJECT_ID('dbo.Animals');
alter table Animals
drop constraint DF__Animals__date_of__75A278F5;

CREATE TABLE Adoptions(
	pid INT FOREIGN KEY REFERENCES People(pid),
	aid INT FOREIGN KEY REFERENCES Animals(aid) UNIQUE, 
	date DATE,
	PRIMARY KEY (pid, aid)
)

CREATE TABLE Employees(
	pid INT FOREIGN KEY REFERENCES People(pid),
	sid INT FOREIGN KEY REFERENCES Shelters(sid),
	occupation VARCHAR(100),
	salary INT,
	date_of_employmenet DATE,
	PRIMARY KEY (pid, sid),
)

CREATE TABLE Animal_Associations(
	aaid INT IDENTITY(136, 84) PRIMARY KEY,
	name VARCHAR(100),
	address VARCHAR(150),
)

CREATE TABLE Colaborations(
	aaid INT FOREIGN KEY REFERENCES Animal_Associations(aaid),
	sid INT FOREIGN KEY REFERENCES Shelters(sid),
	begin_date DATE,
	end_date DATE,
	PRIMARY KEY (aaid, sid)
)

CREATE TABLE Medical_Treatments(
	aid INT FOREIGN KEY REFERENCES Animals(aid),
	aaid INT FOREIGN KEY REFERENCES Animal_Associations(aaid),
	treatment VARCHAR(200),
	cost INT,
	begin_date DATE,
	end_date DATE,
	PRIMARY KEY (aid, aaid)
)

CREATE TABLE Breeds(
	bid INT IDENTITY(1, 1) PRIMARY KEY,
	cid INT FOREIGN KEY REFERENCES Category(cid),
	name VARCHAR(100),
	-- coat VARCHAR(10),
	-- life span (in years) VARCHAR(10),
	-- color VARCHAR(10),
	-- size VARCHAR(10)
)
ALTER TABLE Breeds
ADD UNIQUE(cid, name);
ALTER TABLE Breeds
ADD coat VARCHAR(10);
ALTER TABLE Breeds
ADD life_span_in_years VARCHAR(10);
ALTER TABLE Breeds
ADD color VARCHAR(20);
ALTER TABLE Breeds
ADD size_in_pounds VARCHAR(20);

CREATE TABLE Category(
	cid INT IDENTITY(1, 1) PRIMARY KEY,
	name VARCHAR(100)
)
ALTER TABLE Category
ADD UNIQUE(name);
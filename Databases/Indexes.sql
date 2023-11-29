CREATE TABLE Ta(
	aid INT PRIMARY KEY IDENTITY,
	a2 INT UNIQUE,
	a3 INT 
)

CREATE TABLE Tb(
	bid INT PRIMARY KEY IDENTITY,
	b2 INT
)

CREATE TABLE Tc(
	cid INT PRIMARY KEY IDENTITY,
	aid INT FOREIGN KEY REFERENCES Ta(aid),
	bid INT FOREIGN KEY REFERENCES Tb(bid)
)

INSERT INTO Ta VALUES 
	(1, 1), (2, 7), (3, 7), (4, 3), (5, 6), (6, 6), (89, 7), (79, 9);
INSERT INTO Tb VALUES 
	(1), (2), (3), (4), (5), (6), (89), (79);

-- CLUSTERED INDEX CREATED THROUGH PRIMARY KEY CONSTRAINT
-- NON-CLUSTERED INDEX CREATED THROUGH UNIQUE CONSTRAINT

-- CLUSTERED INDEX SCAN ON Ta (we can't use the non-clustered index because we need to evaluate by the clustered one)
SELECT *
FROM Ta
ORDER BY aid;

-- CLUSTERED INDEX SEEK ON Ta
SELECT * 
FROM Ta
WHERE aid = 7;

-- NON-CLUSTERED INDEX SCAN ON Ta (chooses non-clustered because it is at maximum equal in values with the clustered one)
SELECT a2
FROM Ta;

--	NON-CLUSTERED INDEX SEEK ON Ta
SELECT *
FROM Ta
WHERE aid < 7 and a2 = 6;

-- KEY LOOKUP (key lookup operator occurs when the query optimizer performs an index seek against a specific table and 
-- that index does not have all of the columns needed to fulfill the result set)
SELECT *
FROM Ta
WHERE a2 = 6;

-- NON-CLUSTERED INDEX FOR Tb
CREATE INDEX idx_Tb_b2 ON Tb(b2);
DROP INDEX idx_Tb_b2 ON Tb;

-- NUMBER OF ROWS READ : ACTUAL NUMBER OF ROWS FOR ALL EXECUTIONS : ORDERED : ESTIMATED OPERATOR COST : PHYSICAL OPERATION 
-- WITHOUT 8:1:False:0.0032908:Clustered index scan
-- WITH 1:1:True:0.0032831:Index seek
SELECT *
FROM Tb
WHERE b2 = 6;

-- IF WE REMOVE THE NON-CLUSTERED INDEX FOR Tb(b2) WE HAVE AN CLUSTERED INDEX SCAN FOR b2 = 6
-- OTHERWISE WE OBTAIN NON-CLUSTERED INDEX SEEK BECAUSE WE HAVE THE EXACT ID FOR THE EXACT VALUE FOR b2
-- AND WE DON'T NEED TO SEARCH FOR EVERY ID WHICH ONE OF IT HAS THIS VALUE
GO
CREATE VIEW [Joins] AS
	SELECT * FROM
	Ta INNER JOIN Tb ON aid = 7 AND b2 = 6;
GO
DROP VIEW [Joins];

SELECT * FROM [Joins];
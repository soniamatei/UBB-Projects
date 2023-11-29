--TABLES----------------------------------------------------------
CREATE TABLE Users(
	id INT PRIMARY KEY,
	name VARCHAR(50)
)

CREATE TABLE Posts(
	id INT PRIMARY KEY,
	userid INT FOREIGN KEY REFERENCES Users(id),
	likes INT
)
ALTER TABLE Posts ADD descr VARCHAR(200);

CREATE TABLE Friends( 
	user2 INT FOREIGN KEY REFERENCES Users(id),
	user1 INT FOREIGN KEY REFERENCES Users(id)
	PRIMARY KEY(user1, user2)
)

--VIEWS-----------------------------------------------------------
GO
CREATE VIEW [Top posts] AS
	SELECT TOP 10 * FROM Posts
	ORDER BY Posts.likes DESC
GO

CREATE VIEW [Posts of Users] AS
	SELECT Users.name, Posts.descr FROM 
	Users INNER JOIN Posts
	ON Posts.userid = Users.id
GO
CREATE VIEW [Likes per User] AS
	SELECT Users.name, T.Likes FROM 
	Users INNER JOIN
		(SELECT Posts.userid, sum(Posts.likes) Likes FROM Posts
		GROUP BY Posts.userid) T
	ON Users.id = T.userid
GO

--INSERT DATA---------------------------------------------------
INSERT INTO Users VALUES
	(1, 'Sonia'),
	(2, 'Andrei');

INSERT INTO Posts VALUES
	(1, 1, 100, 'funny story'),
	(2, 2, 20, 'weird experience'),
	(3, 2, 90, 'lazy day');

--INSERT TABLES---------------------------------------------------
INSERT INTO Tables VALUES 
	('Users'),
	('Posts'),
	('Friends');

--INSERT TESTS----------------------------------------------------
INSERT INTO Tests VALUES 
	('Test1');

--INSERT TEST TABLES-----------------------------------------------
INSERT INTO TestTables VALUES 
	(1, 1, 4, 1);

--INSERT TEST VIEWS-----------------------------------------------
INSERT INTO TestViews VALUES 
	(1, 1);

--INSERT VIEWS---------------------------------------------------
INSERT INTO Views VALUES 
	('[Top posts]'),
	('[Posts of Users]'),
	('[Likes per User]');

--PROCEDURES-------------------------------------------------------
GO
CREATE PROCEDURE Run_function_Views
	(@test_id INT, @view_id INT, @testruns_id INT)
AS BEGIN
	DECLARE 
		@view_name VARCHAR(200),
		@t1 DATETIME,
		@t2 DATETIME;

	-- GET THE NAME OF THE VIEW -- 
	SELECT @view_name = Views.Name FROM Views
	WHERE Views.ViewID = @view_id;
	
	DECLARE
		@SELECT VARCHAR(200);
	
	SET @t1 = GETDATE();
	
	-- EXECUTE THE SELECT --
	SET @SELECT = 'SELECT * FROM ' + @view_name + ';';
	EXEC (@SELECT)

	SET @t2 = GETDATE();

	-- INSERT THE RESULTS IN TEST RUNS TABLES --
	INSERT INTO TestRunViews VALUES
		(@testruns_id, @view_id, @t1, @t2);
END;




GO
CREATE PROCEDURE Run_function_Tables
	(@test_id INT, @nor INT, @table_id INT, @testruns_id INT)
AS BEGIN
	DECLARE 
		@table_name VARCHAR(200),
		@t1 DATETIME,
		@t2 DATETIME;

	-- GET THE NAME OF THE TABLE -- 
	SELECT @table_name = Tables.Name FROM Tables
	WHERE Tables.TableID = @table_id;
	
	DECLARE
		@DELETE VARCHAR(200),
		@INSERT VARCHAR(300);

	-- DELETE ALL ROWS FROM TABLE --
	SET @DELETE = 'DELETE FROM ' + @table_name + ';';
	EXEC (@DELETE);
	
	SET @t1 = GETDATE();
	--WHILE @nor != 0
	--BEGIN
		--SET @INSERT = 'INSERT INTO ' @table_name ' VALUES '
		--SET @nor = @nor - 1;
	--END;
	SET @t2 = GETDATE();

	-- INSERT THE RESULTS IN TEST RUNS TABLES --
	INSERT INTO TestRunTables VALUES
		(@testruns_id, @table_id, @t1, @t2);
END;
DROP PROCEDURE Run_function_Views




GO
CREATE PROCEDURE Test
	@id_test INT
AS BEGIN
	DECLARE 
		@test_id INT,
		@table_id INT,
		@view_id INT,
		@nor INT,
		@position INT,
		@t1 DATETIME,
		@t2 DATETIME,
		@last_id INT,
		@test_name VARCHAR(100);

	-- INPUT EMPTY ROW IN TESTRUNS --
	INSERT INTO TestRuns VALUES (null, null, null);
	SET @last_id = SCOPE_IDENTITY();
	
	-- DECLARE AND OPEN CURSOR FOR TABLES --
	DECLARE ct CURSOR FOR
		SELECT * FROM TestTables
		WHERE TestTables.TestID = @id_test
		ORDER BY TestTables.Position;

	-- DECLARE AND OPEN CURSOR FOR VIEWS --
	DECLARE cv CURSOR FOR
		SELECT * FROM TestViews
		WHERE TestViews.TestID = @id_test

	OPEN ct;
	OPEN cv;

	SET @t1 = GETDATE();
	-- EXECUTE TESTS FOR VIEWS --
	FETCH cv INTO @test_id, @view_id;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC Run_function_Views @test_id, @view_id, @last_id;
			FETCH cv INTO @test_id, @view_id;
		END;
	
	-- EXECUTE TESTS FOR TABLES --
	FETCH ct INTO @test_id, @table_id, @nor, @position;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC Run_function_Tables @test_id, @nor, @table_id, @last_id;
			FETCH ct INTO @test_id, @table_id, @nor, @position;
		END;

	SET @t2 = GETDATE();

	CLOSE ct;
	DEALLOCATE ct;
	CLOSE cv;
	DEALLOCATE cv;

	-- GET TEST NAME --
	SELECT @test_name = Tests.Name FROM Tests
	WHERE Tests.TestID = @test_id;

	-- UPDATE ROW IN TESTRUNS WIH THE GENERATED DATA -- 
	UPDATE TestRuns
	SET Description = @test_name, StartAt = @t1, EndAt = @t2
	WHERE TestRunID = @last_id;
END;
GO
DROP PROCEDURE Test

EXEC Test 1
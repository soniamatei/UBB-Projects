CREATE TABLE Cats(
	id INT IDENTITY,
	name VARCHAR(50),
);
ALTER TABLE Cats
ADD animal_id int;

CREATE TABLE Versions(
	id INT IDENTITY PRIMARY KEY ,
	value INT
);

INSERT INTO Versions (value)
VALUES (0);


GO
CREATE PROCEDURE Modify_Column AS
BEGIN
		ALTER TABLE Shelters
		ALTER COLUMN name VARCHAR(50);
		UPDATE Versions SET value = 1;
END;

GO
CREATE PROCEDURE Modify_Column_Undo AS
BEGIN
		ALTER TABLE Shelters
		ALTER COLUMN name VARCHAR(100);
		UPDATE Versions SET value = 0;
END;

GO
CREATE PROCEDURE Add_Column AS
BEGIN
		ALTER TABLE Shelters
		ADD year_of_foundation int;
		UPDATE Versions SET value = 2;
END;

GO
CREATE PROCEDURE Add_Column_Undo AS
BEGIN
		ALTER TABLE Shelters
		DROP COLUMN year_of_foundation;
		UPDATE Versions SET value = 1;
END;

GO
CREATE PROCEDURE Add_Default_Constraint AS
BEGIN
		ALTER TABLE Medical_Treatments
		ADD CONSTRAINT DF_Medical_Treatments_cost DEFAULT 0 FOR cost;
		UPDATE Versions SET value = 3;
END

GO
CREATE PROCEDURE Add_Default_Constraint_Undo AS
BEGIN
		ALTER TABLE Medical_Treatments
		DROP CONSTRAINT DF_Medical_Treatments_cost;
		UPDATE Versions SET value = 2;
END

GO
CREATE PROCEDURE Add_Primary_Key AS
BEGIN
		
		ALTER TABLE Cats
		ADD CONSTRAINT PK_Cats PRIMARY KEY (id);
		UPDATE Versions SET value = 4;
END

GO
CREATE PROCEDURE Add_Primary_Key_Undo AS
BEGIN
		
		ALTER TABLE Cats
		DROP CONSTRAINT PK_Cats;
		UPDATE Versions SET value = 3;
END

GO
CREATE PROCEDURE Add_Candidate_Key AS
BEGIN
		
		ALTER TABLE Cats
		ADD CONSTRAINT U_Cats_name UNIQUE (id);
		UPDATE Versions SET value = 5;
END

GO
CREATE PROCEDURE Add_Candidate_Key_Undo AS
BEGIN
		
		ALTER TABLE Cats
		DROP CONSTRAINT U_Cats_name;
		UPDATE Versions SET value = 4;
END

GO
CREATE PROCEDURE Add_Foreign_Key AS
BEGIN
		
		ALTER TABLE Cats
		ADD CONSTRAINT FK_Cats_animal_id FOREIGN KEY (animal_id) REFERENCES Animals(aid);
		UPDATE Versions SET value = 6;
END

GO
CREATE PROCEDURE Add_Foreign_Key_Undo AS
BEGIN
		
		ALTER TABLE Cats
		DROP CONSTRAINT FK_Cats_animal_id;
		UPDATE Versions SET value = 5;
END

GO
CREATE PROCEDURE Create_Table AS
BEGIN
		
		CREATE TABLE Cats(
			id INT IDENTITY,
			name VARCHAR(50),
			animal_id INT,
			CONSTRAINT PK_Cats PRIMARY KEY (id),
			CONSTRAINT U_Cats_name UNIQUE (name),
			CONSTRAINT FK_Cats_animal_id FOREIGN KEY (animal_id) REFERENCES Animals(aid)
		);
		UPDATE Versions SET value = 7;
END

GO
CREATE PROCEDURE Create_Table_Undo AS
BEGIN
		
		DROP TABLE Cats;
		UPDATE Versions SET value = 6;
END





GO
CREATE PROCEDURE Procedure_Do
	@index INT
AS BEGIN
	/**/ IF @index = 1 EXEC Modify_Column
	ELSE IF @index = 2 EXEC Add_Column
	ELSE IF @index = 3 EXEC Add_Default_Constraint
	ELSE IF @index = 4 EXEC Add_Primary_Key
	ELSE IF @index = 5 EXEC Add_Candidate_Key
	ELSE IF @index = 6 EXEC Add_Foreign_Key
	ELSE IF @index = 7 EXEC Create_Table_Undo
END;

GO
CREATE PROCEDURE Procedure_Undo
	@index INT
AS BEGIN
	/**/ IF @index = 1 EXEC Modify_Column_Undo
	ELSE IF @index = 2 EXEC Add_Column_Undo
	ELSE IF @index = 3 EXEC Add_Default_Constraint_Undo
	ELSE IF @index = 4 EXEC Add_Primary_Key_Undo
	ELSE IF @index = 5 EXEC Add_Candidate_Key_Undo
	ELSE IF @index = 6 EXEC Add_Foreign_Key_Undo
	ELSE IF @index = 7 EXEC Create_Table
END;
Drop table Cats



Go
CREATE PROCEDURE Get_Version
	@target INT
AS BEGIN
	IF @target < 0 OR @target > 7 BEGIN 
		RETURN
	END
	
	DECLARE @version INT;
	SET @version = (SELECT TOP 1 value FROM Versions);

	IF @version < @target BEGIN
		WHILE @version < @target BEGIN
			SET @version = @version+1;
			EXEC Procedure_Do @version;
		END
	END ELSE IF @version > @target BEGIN
		WHILE @version > @target BEGIN
			EXEC Procedure_Undo @version;
			SET @version = @version-1;
		END
	END
END;

exec Get_Version 0
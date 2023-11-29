CREATE TABLE Train_Types(
	id INT PRIMARY KEY IDENTITY,
	name VARCHAR(200),
	description VARCHAR(200)
)

CREATE TABLE Trains(
	id INT PRIMARY KEY IDENTITY,
	name VARCHAR(200),
	type INT FOREIGN KEY REFERENCES Train_Types(id)
)

CREATE TABLE Stations(
	id INT PRIMARY KEY IDENTITY,
	name VARCHAR(200) UNIQUE
)

CREATE TABLE Routes(
	id INT PRIMARY KEY IDENTITY,
	name VARCHAR(200) UNIQUE,
	train INT FOREIGN KEY REFERENCES Trains(id),
)

CREATE TABLE Route_Stations(
	route INT FOREIGN KEY REFERENCES Routes(id),
	station INT FOREIGN KEY REFERENCES Stations(id),
	PRIMARY KEY(route, station),
	arrival TIME,
	departure TIME
)

--IF OBJECT_ID('Route_Stations', 'U') IS NOT NULL 
	--DROP TABLE Route_Stations
-- THEN STATIONS, ROUTES, TRAINS , TRAIN TYPES

GO
CREATE PROCEDURE Add_station_to_route (@route INT, @station INT, @arrival TIME, @departure TIME)
AS BEGIN

	IF NOT EXISTS (SELECT * FROM Stations WHERE @station = Stations.id)
		INSERT INTO Route_Stations VALUES (@route, @station, @arrival, @departure);
	ELSE 
		UPDATE Route_Stations
		SET Route_Stations.arrival = @arrival, Route_Stations.departure = @departure
		WHERE Route_Stations.station = @station;
END;

-- ONE INPUT OR INSERT AND ONE FOR UPDATE

GO
CREATE VIEW Show_Stations AS
	SELECT Routes.name
	FROM Routes
	WHERE (SELECT COUNT(*) FROM Stations) = (SELECT COUNT(*) FROM Route_Stations WHERE Route_Stations.route = Routes.id)

GO
CREATE FUNCTION List_names (@route_nb INT) RETURNS TABLE
AS 
	RETURN
		(SELECT Stations.name
		FROM Stations
		WHERE @route_nb < (SELECT COUNT(*) FROM Route_Stations WHERE Route_Stations.station = Stations.id));

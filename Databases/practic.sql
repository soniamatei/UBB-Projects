create table stadiums(
	id int identity primary key,
	name varchar(100) unique
	);

create table teams(
	id int identity primary key,
	country varchar(100) unique
	);

create table players(
	id int identity primary key,
	name varchar(100),
	birth_date date,
	birth_country varchar(100),
	position varchar(100),
	team int foreign key references teams(id)
	);

create table competition_stages(
	id int identity primary key,
	name varchar(100),
	eliminatory int,
	);
create table games(
	id int identity primary key,
	date date,
	team1 int foreign key references teams(id),
	team2 int foreign key references teams(id),
	stadium int foreign key references stadiums(id),
	stage int foreign key references competition_stages(id),
	final_score int,
	overtime int, -- 0 -> not overtime 1 -> overtime
)


go
create procedure add_game(@date int, @team1 int, @team2 int, 
							@stadium int, @stage int, @final_score int, @overtime int)
as begin
			if not exists (select * from games where games.team1 = @team1 and games.team2 = @team2
													 and games.stage = @stage)
						insert into games values (@date , @team1 , @team2 , @stadium , @stage , @final_score , @overtime)
			else
				update games 
				set final_score = @final_score
				where games.team1 = @team1 and games.team2 = @team2 and games.stage = @stage;		
end;

go 
create view stadiums_overtime as
	select stadiums.name
	from stadiums
	where stadiums.id in
		(select games.stadium
		from games 
		where games.stadium not in
			(select games.stadium
			from games
			where games.overtime = 0));

go 

--ex1

create table customers(
	id int identity primary key,
	name varchar(max),
	birth_date date
);
create table bank_accounts(
	id int identity primary key,
	iban int,
	current_balance int,
	holder int foreign key references customers(id)
);
create table cards(
	id int identity primary key,
	number int,
	cvv int,
	bank_acc int foreign key references bank_accounts(id)
);
create table atms(
	id int identity primary key,
	address varchar(max)
);
create table transactions(
	id int identity primary key,
	atm int foreign key references atms(id),
	card int foreign key references cards(id),
	sum int,
	time datetime default getdate()
);
--drop table transactions

go
create procedure delete_all_trans(@card_id int)
as begin
	delete from transactions where transactions.card = @card_id;
end;

go
create view show_card_numbers as
	select cards.number
	from cards
	where cards.id in (
		select c.card
		from 
			(select t.card, count(t.atm) atm_nb 
			 from 
				(select distinct transactions.atm, transactions.card from transactions) t
			 group by t.card) c
		where c.atm_nb = (select count(*) from atms)
	);
	
go
create function list_cards (@sum int) returns table
as
	return
		(select cards.number, cards.cvv
		from cards
		where cards.id in 
			(select s.card from
				(select transactions.card, sum(transactions.sum) suma
				from transactions
				group by transactions.card) s
			where s.suma > @sum)
		);

--ex2
create table presentation_shops(
	id int identity primary key,
	name varchar(max),
	city varchar(max)
	);

create table shoe_models(
	id int identity primary key,
	name varchar(max),
	season varchar(max)
	);

create table presentation_shops(
	id int identity primary key,
	nb_shoes int
	);
--drop table presentation_shops

create table women(
	id int identity primary key,
	name varchar(max),
	amount int
	);

create table shoes(
	id int identity primary key,
	price int,
	model int foreign key references shoe_models(id)
	);

create table shoes_and_shops(
	shoe int foreign key references shoes(id),
	shop int foreign key references presentation_shops(id),
	nb_shoes int,
	primary key(shoe, shop)
	);

create table spendings(
	id int identity primary key,
	woman int foreign key references women(id),
	shoe int foreign key references shoes(id),
	nb_of_shoes int,
	spent_amount int
	);

go 
create procedure add_shoes(@shoe int, @shop int, @number int) 
as begin
	if not exists (select * from shoes where shoes.id = @shoe)
		raiserror(60000, 10, 1, 'id shoe not good');
	if not exists (select * from presentation_shops where presentation_shops.id = @shop)
		raiserror(60000, 10, 1, 'id shoe not good');
	if not exists	(select * 
					from shoes_and_shops 
					where shoes_and_shops.shoe = @shoe and
					shoes_and_shops.shop = @shop)
		insert into shoes_and_shops values (@shoe, @shop, @number)
	else
		update shoes_and_shops
		set shoes_and_shops.nb_shoes = shoes_and_shops.nb_shoes + @number
		where shoes_and_shops.shoe = @shoe and shoes_and_shops.shop = @shop
end;

go
create view list_women as
	select s.woman
	from
		(select spendings.woman, shoes.model, spendings.nb_of_shoes
		from spendings inner join shoes on spendings.shoe = shoes.id) s
	group by s.woman, s.model
	having sum(s.nb_of_shoes) >=2;
	
go
create function list_shoes(@nb int) returns table
as
	return
		select shoes_and_shops.shoe
		from shoes_and_shops
		group by shoes_and_shops.shoe
		having count(shoes_and_shops.shop)>=@nb;
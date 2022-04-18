-- comedy movies with rating PG-13 -- 
select title from film 
where film_id in 
(select film_id from film_category where category_id=5) and rating like "PG-13";

-- Top 3 highest  rental horror films-- 
select film_id,count(film_id) from inventory,rental 
where inventory.inventory_id=rental.inventory_id group by film_id  
having film_id in (select film_id from film_category f,category c  where f.category_id=c.category_id and c.name like "Horror") 
order by count(film_id)  desc limit 3;


-- indian customers --
create view inventory_customer as
select i.film_id ,t.customer_id ,i.inventory_id
from inventory as i inner join 
(select c.customer_id,r.inventory_id
from customer as c inner join 
rental as r on 
c.customer_id = r.customer_id) as t 
on t.inventory_id = i.inventory_id;

select c.name from 
customer_list as c inner join 
(select distinct ic.customer_id
from inventory_customer as ic inner join 
(select FID from film_list where category like 'sports') as s
on s.FID = ic.film_id ) as t 
on t.customer_id = c.ID and c.country = 'India';


-- list of customers in canada  who have rented nick wahlberg --
select c.name 
from customer_list as c 
where c.country = 'canada' 
and c.ID in (select ic.customer_id
			from inventory_customer as ic inner join 
			(select fa.film_id ,concat(a.first_name,'  ',a.last_name) as fullname 
			from actor as a inner join 
			film_actor as fa
			On a.actor_id = fa.actor_id and a.first_name = 'NICK' and a.last_name = 'WAHLBERG') as af
			On af.film_id = ic.film_id order by ic.customer_id);


-- no of movies sean wllians acted --
select count(*) from film_actor f join actor a on a.actor_id = f.actor_id where a.first_name like 'SEAN' and a.last_name like 'WILLIAMS'
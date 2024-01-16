with actor_f as (select fa.actor_id as actor1, fa.film_id, fa_1.actor_id as actor2 from film_actor fa
join film_actor fa_1
where fa.film_id=fa_1.film_id
and fa.actor_id < fa_1.actor_id),
actor_1 as(
select a.film_id,title, a.actor1, ac.first_name, ac.last_name from actor_f a
join actor ac
on a.actor1 = ac.actor_id
join film using(film_id)),
actor_2 as(
select a.film_id, title, a.actor2, ac.first_name, ac.last_name from actor_f a
join actor ac
on a.actor2 = ac.actor_id
join film using(film_id))
select distinct a.title, a.actor1, concat(a.first_name, ' ',  a.last_name) as actor_1, b.actor2, concat(b.first_name, ' ', b.last_name) as actor_2 from actor_1 a
join actor_2 b
on a.film_id=b.film_id
;
with count as (select actor_id, count(film_id) as film_count
from film_actor
group by actor_id),
ranks as (select film_id, c.actor_id, c.film_count, rank() over (partition by film_id order by film_count desc) as ranks
from film_actor fa
join count c 
using(actor_id))
select  title, concat(first_name, ' ', last_name) as name, film_count 
from ranks r
join film using(film_id)
join actor using(actor_id)
where r.ranks=1
;
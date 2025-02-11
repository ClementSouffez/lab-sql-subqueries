USE sakila;

-- 1-How many copies of the film Hunchback Impossible exist in the inventory system?
-- 2-List all films whose length is longer than the average of all the films.
-- 3-Use subqueries to display all actors who appear in the film Alone Trip.
-- 4-Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
-- 5-Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
-- 6-Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
-- 7-Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
-- 8-Customers who spent more than the average payments.






-- 1-How many copies of the film Hunchbak Impossible exist in the inventory system?

select count(distinct title)
from film f
join inventory i
ON f.film_id= i.film_id
where title ='Hunchback Impossible'
  -- 1 movie


-- 2-List all films whose length is longer than the average of all the films.

SELECT length as average_length, film_id ,title
FROM film
WHERE length > "115.2720" 
GROUP BY title
ORDER BY average_length DESC;

SELECT count(film_id), avg(length) as av_length
FROM film
		-- "115.2720" --average of all films.

-- 3--Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name , last_name 
FROM actor a
JOIN film_actor f
USING (actor_id)
JOIN film
USING (film_id)
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip');

--  4--Sales have been lagging among young families, and you wish to target all 
--  family movies for a promotion. Identify all movies categorized as family films.

select name as category,title
from film
join film_category
using(film_id)
join category
using (category_id)
where category_id =(select category_id from category where name = 'Family');

-- 5 
select first_name, last_name, email
from customer c
join address a
using(address_id)
where city_id IN  
(
select city_id from city
where country_id = (select country_id from country where country = 'Canada')
);


-- 6 

select actor_id, title as film_name
from film
join film_actor
using (film_id)
where actor_id = 
(select actor_id
from film_actor
group by actor_id
order by count(film_id) desc
limit 1);


-- 7
select first_name, last_name, email
from customer c
join address a
using(address_id)
where city_id IN  
(
select city_id from city
where country_id = (select country_id from country where country = 'Canada')
);


-- 8 
select first_name, last_name, email
from customer
where customer_id IN
(select customer_id,sum(amount) as revenue
from payment 
group by customer_id
having sum(amount) >
(select avg(amount) FROM payment));
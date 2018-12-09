/*
SQL Homework Assignment
*/
-- 1a. Display the first and last names of all actors from the table actor.
USE sakila;
SELECT first_name, last_name
FROM actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.
SELECT CONCAT(first_name, ' ', last_name) 
AS 'Actor Name' 
FROM `actor`; 
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE 'Joe%';
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';
-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
/*3a. You want to keep a description of each actor. 
You don't think you will be performing queries on a description, 
so create a column in the table actor named description and use the data type BLOB 
(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
*/
ALTER TABLE actor
ADD(description BLOB);
DESCRIBE actor;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
ALTER TABLE actor
DROP COLUMN description;
DESCRIBE actor;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 2;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
-- check the record exists
SELECT * FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- update the record
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- check update was made correctly 
SELECT * FROM actor
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
*/
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';

SELECT * FROM actor
WHERE first_name = 'HARPO';
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
From staff s, address a
WHERE s.address_id = a.address_id;
-- OR --
SELECT s.first_name, s.last_name, a.address
FROM address a
INNER JOIN staff s ON s.address_id=a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) as total_sale
From staff s, payment p
WHERE s.staff_id = p.staff_id AND p.payment_date LIKE '2005-08-%'  
GROUP BY staff_id;
-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT fa.film_id, f.title, COUNT(fa.actor_id) NumberofActors
From film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id  
GROUP BY film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.film_id, f.title, COUNT(i.film_id) as NumberofCopies
From inventory i, film f
WHERE i.film_id = f.film_id AND f.title = 'Hunchback Impossible'  
GROUP BY title;
/*6e. Using the tables payment and customer and the JOIN command, 
list the total paid by each customer. 
List the customers alphabetically by last name:*/
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) as Name, 
SUM(p.amount) as 'Total Paid'
From payment p, customer c
WHERE p.customer_id = c.customer_id  
GROUP BY customer_id
ORDER BY last_name;
/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters K and Q have also 
soared in popularity. Use subqueries to display the titles of movies starting with 
the letters K and Q whose language is English.
*/

select l.language_id, f.title
from film f, language l
where f.language_id = l.language_id AND f.title LIKE 'Q%' OR f.title LIKE 'K%' AND l.name = 'English';

OR
 	
SELECT title
FROM film
WHERE language_id IN
	(
	SELECT language_id 
	FROM language
	WHERE name = 'English'
	) AND title LIKE 'K%' OR title LIKE 'Q%';


-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
	SELECT actor_id 
	FROM film_actor
	WHERE film_id IN
		(
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
		)
    );
	
/*
7c. You want to run an email marketing campaign in Canada, for which you will need the names 
and email addresses of all Canadian customers. Use joins to retrieve this information.
*/

SELECT first_name, last_name, email, city, country
FROM customer c
INNER JOIN address a
ON c.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country co
WHERE country = 'Canada';

/*
7d. Sales have been lagging among young families, and you wish to target all 
family movies for a promotion. Identify all movies categorized as family films.
*/

SELECT f.title, c.name
FROM film f
INNER JOIN film_category fa
ON f.film_id = fa.film_id
INNER JOIN category c
WHERE name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, count(r.inventory_id) as 'Times_Rented'
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
GROUP BY title
ORDER BY count(r.inventory_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT st.store_id, SUM(p.amount) as 'Total_Sold ($)'
FROM payment p
INNER JOIN staff s
ON p.staff_id = s.staff_id
INNER JOIN store st
ON s.store_id = st.store_id
GROUP BY st.store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id,  ci.city, co.country
FROM store s
INNER JOIN address a
ON s.address_id = a.address_id
INNER JOIN city ci
ON ci.city_id = a.city_id
INNER JOIN country co
ON ci.country_id = co.country_id;
/* 7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
*/
SELECT c.name as Genre, sum(p.amount) as Total_Sales
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN inventory i
ON i.film_id = fc.film_id 
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) desc LIMIT 5;

/*
8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres 
by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, 
you can substitute another query to create a view.
*/
CREATE VIEW sakila.top_five_genres AS
	SELECT c.name as Genre, sum(p.amount) as Total_Sales
	FROM category c
	INNER JOIN film_category fc
	ON c.category_id = fc.category_id
	INNER JOIN inventory i
	ON i.film_id = fc.film_id 
	INNER JOIN rental r
	ON i.inventory_id = r.inventory_id
	INNER JOIN payment p
	ON r.rental_id = p.rental_id
	GROUP BY c.name
	ORDER BY sum(p.amount) desc LIMIT 5;
    
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM sakila.top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW sakila.top_five_genres;
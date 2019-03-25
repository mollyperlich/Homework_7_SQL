-- 1a. Display the first and last names of all actors from the table actor.

use sakila;

SELECT
	a.first_name AS FirstName,
    a.last_name AS LastName
FROM 
	actor a;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT
	UPPER(CONCAT(a.first_name, ' ', a.last_name)) AS `Actor Name`
FROM 
	actor a;
    
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT
	a.actor_id AS ID,
    a.first_name AS 'First Name',
    a.last_name AS 'Last Name'
FROM
	actor a
WHERE
	a.first_name = 'Joe';
    
-- 2b. Find all actors whose last name contain the letters GEN:

SELECT
	a.actor_id AS ID,
    a.first_name AS 'First Name',
    a.last_name AS 'Last Name'
FROM
	actor a
WHERE
	a.last_name LIKE '%GEN%';
    
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT
	a.actor_id AS ID,
    a.first_name AS 'First Name',
    a.last_name AS 'Last Name'
FROM
	actor a
WHERE
	a.last_name LIKE '%LI%'
ORDER BY
	a.last_name ASC,
    a.first_name ASC;
    
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT
	c.country_id,
    c.country
FROM
	country c
WHERE
	c.country IN ('Afghanistan', 'Bangladesh', 'China');


-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

ALTER TABLE actor 
	ADD COLUMN Description_Note Blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor
	DROP COLUMN Description_Note;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT
	a.last_name AS 'Last Name',
	COUNT(a.last_name) As 'Count of Last Name'
FROM
	actor a
GROUP BY 
	a.last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT
	a.last_name AS 'Last Name',
	COUNT(a.last_name) As 'Count of Last Name'
FROM
	actor a
GROUP BY 
	a.last_name;
WHERE 
	COUNT(a.last_name) >= 2

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE
	actor
SET
	first_name = 'Harpo'
WHERE 
	first_name = 'Groucho'
    AND last_name = 'Williams'
	

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE
	actor
SET
	first_name = 'Groucho'
WHERE 
	first_name = 'Harper'
    AND last_name = 'Williams'
    
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT 
	s.first_name AS 'First Name',
    s.last_name AS 'Last Name',
    a.address AS 'Address'
FROM 
	staff s
    INNER JOIN address a ON (s.address_id = a.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

-- SELECT
-- 	s.staff_id AS 'Staff ID',
--     s.first_name AS 'First Name',
--     s.last_name AS 'Last Name',
--     p.amount AS 'Payment Amount'
-- FROM
-- 	payment pm 
--     INNER JOIN amount pm ON (p.staff_id = s.staff_id);

SELECT
	CONCAT(s.first_name,'',s.last_name) AS Staff_Name,
    SUM(p.amount) AS Payment_Total
FROM
	payment p
    INNER JOIN staff s ON (p.staff_id = s.staff_id)
WHERE
	p.payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY
	Staff_Name;
	
    
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT 
	f.title AS Title,
    COUNT(f.film_id) AS 'Numbe of Actors'
FROM 
	film f
    INNER JOIN film_actor fa ON (f.film_id = fa.film_id)
GROUP BY
	Title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT 
	COUNT(f.film_id) AS 'Number of Copies in Invetory'
FROM 
	film f
    INNER JOIN inventory i ON (f.film_id = i.film_id)
WHERE
	f.title = 'Hunchback Impossible';


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT 
	c.first_name AS 'First Name',
    c.last_name AS 'Last Name',
    SUM(p.amount) AS 'Total Amount Paid'
FROM
	customer c
    INNER JOIN payment p ON (c.customer_id = p.customer_id)
GROUP BY
	c.customer_id
ORDER BY 
	c.last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT 
	f.title As 'English Films w/ Q and K'
FROM
	film f
    INNER JOIN language l ON (f.language_id = l.language_id)
WHERE
	(f.title LIKE 'K%' OR f.title LIKE 'Q%') AND 
    (l.name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 
	a.first_name AS 'First Name',
    a.last_name AS 'Last Name'
FROM 
	film f
    INNER JOIN film_actor fa ON (f.film_id = fa.film_id)
    INNER JOIN actor a ON (fa.actor_id = a.actor_id)
WHERE
	f.title = 'Alone Trip'
ORDER BY
	'Last Name' ASC;


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT 
	c.first_name AS 'First Name',
    c.last_name AS 'Last Name',
    c.email
FROM 
	customer c
    INNER JOIN address a ON (c.address_id = a.address_id)
    INNER JOIN city cy ON (a.city_id = cy.city_id)
    INNER JOIN country ct ON (cy.country_id = ct.country_id)
WHERE
	ct.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
    
    
SELECT 
	f.title
FROM
	film f
    INNER JOIN film_category fc ON (f.film_id = fc.film_id)
    INNER JOIN category c ON (fc.category_id = c.category_id)
WHERE
	c.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.

SELECT 
	f.title,
    COUNT(f.film_id) AS 'Number of Times Rented'
FROM
	film f
    INNER JOIN inventory i ON (f.film_id = i.film_id)
    INNER JOIN rental r ON (i.inventory_id = r.inventory_id)
GROUP BY
	f.title
ORDER BY
	'Number of Times Rented' DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT
	SUM(p.amount) AS 'Revenue Per Store', s.store_id
FROM
	payment p
    INNER JOIN staff s ON (s.staff_id = p.staff_id)
GROUP BY store_id;
    
-- 7g. Write a query to display for each store its store ID, city, and country.
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT
	c.name AS Film_Category, SUM(p.amount) AS Revenue
FROM
	category c
    INNER JOIN film_category fc ON (c.category_id = fc.category_id)
    INNER JOIN inventory i ON (fc.film_id = i.film_id)
    INNER JOIN rental r ON (i.inventory_id = r.inventory_id)
    INNER JOIN payment p ON (r.rental_id = p.rental_id)
GROUP BY
	Film_Category
ORDER BY 
	Revenue DESC
LIMIT 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW 
	Top_Five_Genres AS

	SELECT
		c.name AS Film_Category,
		SUM(p.amount) AS Revenue
	FROM
		category c
		INNER JOIN film_category fc ON (c.category_id = fc.category_id)
		INNER JOIN inventory i ON (fc.film_id = i.film_id)
		INNER JOIN rental r ON (i.inventory_id = r.inventory_id)
		INNER JOIN payment p ON (r.rental_id = p.rental_id)
	GROUP BY
		Film_Category
	ORDER BY 
		Revenue DESC
	LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM Top_Five_Genres

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW Top_Five_Genres
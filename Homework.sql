SELECT 
    first_name, last_name
FROM
    sakila.actor;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM
    sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.
SELECT 
    actor_id, first_name, last_name
FROM
    sakila.actor
WHERE
    first_name LIKE 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT 
    first_name, last_name
FROM
    sakila.actor
WHERE
    last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
SELECT 
    last_name, first_name
FROM
    sakila.actor
WHERE
    last_name LIKE '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
SELECT 
    country_id, country
FROM
    sakila.country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB0
--  (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE sakila.actor
ADD COLUMN desctription VARCHAR(50) NOT NULL;
SELECT 
    *
FROM
    sakila.actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- modify column to BLOB
ALTER TABLE sakila.actor 
MODIFY COLUMN description BLOB;
ALTER TABLE sakila.actor;

-- Delete the description column.
ALTER TABLE sakila.actor
DROP COLUMN desctription;

SELECT 
    *
FROM
    sakila.actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name, COUNT(*) 'Count'
FROM
    actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT 
    last_name, COUNT(*) 'Count'
FROM
    actor
GROUP BY last_name
HAVING Count > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';
SELECT 
    *
FROM
    sakila.actor
WHERE
    first_name = 'HARPO';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO'
        AND last_name = 'WILLIAMS';
SELECT 
    *
FROM
    sakila.actor
WHERE
    first_name = 'GROUCHO';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESC address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT 
    f.first_name, f.last_name, fa.address
FROM
    staff f
        LEFT JOIN
    address fa ON f.address_id = fa.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT 
    *
FROM
    staff;
SELECT 
    *
FROM
    payment;
SELECT 
    f.first_name, f.last_name, SUM(fa.amount) AS 'TOTAL'
FROM
    staff f
        LEFT JOIN
    payment fa ON f.staff_id = fa.staff_id
GROUP BY f.first_name , f.last_name;

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT 
    f.title, COUNT(fa.actor_id) AS 'TOTAL'
FROM
    film f
        LEFT JOIN
    film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT 
    f.first_name, f.last_name, SUM(fa.amount) AS 'TOTAL'
FROM
    customer f
        LEFT JOIN
    payment fa ON f.customer_id = fa.customer_id
GROUP BY f.first_name , f.last_name
ORDER BY f.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
Use sakila;
SELECT 
    title
FROM
    film
WHERE
    (title LIKE 'K%' OR title LIKE 'Q%')
        AND language_id = (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'ALONE TRIP'));
        
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT 
    first_name, last_name, email
FROM
    customer cu
        JOIN
    address f ON (cu.address_id = f.address_id)
        JOIN
    city cit ON (f.city_id = cit.city_id)
        JOIN
    country cntry ON (cit.country_id = cntry.country_id);

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT 
    title
FROM
    film f
        JOIN
    film_category fcat ON (f.film_id = fcat.film_id)
        JOIN
    category fa ON (fcat.category_id = fa.category_id);

-- 7e. Display the most frequently rented movies in descending order.
SELECT 
    title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM
    film f
        JOIN
    inventory i ON (f.film_id = i.film_id)
        JOIN
    rental r ON (i.inventory_id = r.inventory_id)
GROUP BY title
ORDER BY Count_of_Rented_Movies DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    f.store_id, SUM(fa.amount)
FROM
    payment fa
        JOIN
    staff f ON (fa.staff_id = f.staff_id)
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT 
    store_id, city, country
FROM
    store s
        JOIN
    address a ON (s.address_id = a.address_id)
        JOIN
    city c ON (a.city_id = c.city_id)
        JOIN
    country cntry ON (c.country_id = cntry.country_id);

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT 
    c.name AS 'Top Five', SUM(p.amount) AS 'Gross'
FROM
    category c
        JOIN
    film_category fc ON (c.category_id = fc.category_id)
        JOIN
    inventory i ON (fc.film_id = i.film_id)
        JOIN
    rental r ON (i.inventory_id = r.inventory_id)
        JOIN
    payment p ON (r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY Gross
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
SELECT 
    c.name AS 'Top Five', SUM(p.amount) AS 'Gross'
FROM
    category c
        JOIN
    film_category fc ON (c.category_id = fc.category_id)
        JOIN
    inventory i ON (fc.film_id = i.film_id)
        JOIN
    rental r ON (i.inventory_id = r.inventory_id)
        JOIN
    payment p ON (r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY Gross
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT* FROM TopFive;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW TopFive

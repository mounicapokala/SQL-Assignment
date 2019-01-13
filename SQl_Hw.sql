use sakila;

#1a. Display the first and last names of all actors from the table actor.
select first_name,last_name from actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name,' ', last_name) as Actorname from actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id,first_name,last_name from actor where upper(first_name)="Joe";

#Find all actors whose last name contain the letters GEN:
select * from actor where last_name like "%GEN%";

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select last_name,first_name from actor where last_name like "%LI%" order by last_name,first_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id,country from country where country IN ("Afghanistan","Bangladesh","China");

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB 
Alter table actor add column Description BLOB;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
Alter table actor Drop Description;

#4a. List the last names of actors, as well as how many actors have that last name.
select last_name,count(last_name) as lastname_count from actor group by last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name,count(last_name) as lastname_count from actor group by last_name having lastname_count >= 2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor set first_name ="HARPO", last_name ="WILLIAMS" where first_name="GROUCHO" and last_name="WILLIAMS";

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor set first_name ="GROUCHO" where first_name ="HARPO" and last_name="WILLIAMS";

#5a.You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW create table address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select first_name ,last_name, address from staff INNER JOIN address where staff.address_id = address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select A.first_name, A.last_name, sum(B.amount) as "August 2005 sales"  from staff A INNER JOIN payment B ON
 A.staff_id = B.staff_id  where B.payment_date like "2005-08%" group by A.staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select film.film_id, film.title, count(film_actor.actor_id) as Actors from film_actor INNER JOIN film where film_actor.film_id = film.film_id group by film_id;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select film.title, count(inventory.inventory_id) as Copies from film INNER JOIN inventory where film.film_id = inventory.film_id and title ="Hunchback Impossible";

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.first_name, customer.last_name, sum(payment.amount) from payment INNER JOIN customer where payment.customer_id = customer.customer_id group by customer.customer_id order by last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title from film where title like "K%" or title like "Q%" and language_id IN (select language_id from language where name="English");
 
 #7b. Use subqueries to display all actors who appear in the film Alone Trip.
 select first_name,last_name,actor_id from actor where actor_id IN (select actor_id from film_actor where film_id IN (select film_id from film where 
 title = "Alone Trip"));
 
#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select first_name,last_name,email from customer A inner join address B ON A.address_id = B.address_id 
INNER JOIN city C ON B.city_id = C.city_id 
INNER JOIN country D ON  C.country_id = D.country_id where  country = "Canada";

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select film_id,title from film where film_id IN (select film_id from film_category where category_id IN ( select category_id from category where name="Family"));

#7e. Display the most frequently rented movies in descending order.
select count(C.rental_id) as "Rental_count",A.film_id,A.title from film A INNER JOIN inventory B ON A.film_id = B.film_id INNER JOIN rental C ON B.inventory_id = C.inventory_id
group by A.film_id order by Rental_count Desc;

#7f. Write a query to display how much business, in dollars, each store brought in.
select staff.first_name,staff.last_name,sum(payment.amount) as Totalamount from staff INNER JOIN payment where staff.staff_id = payment.staff_id group by payment.staff_id;

#7g. Write a query to display for each store its store ID, city, and country.
select store_id, city, country from store A INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id 
INNER JOIN country D ON C.country_id = D.country_id;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select name, sum(amount) as Gross_revenue from category A INNER JOIN film_category B ON A.category_id = B.category_id
INNER JOIN inventory C ON B.film_id = C.film_id
INNER JOIN rental D ON C.inventory_id = D.inventory_id
INNER JOIN payment E ON D.rental_id = E.rental_id group by name order by Gross_revenue Desc LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view.
# If you haven't solved 7h, you can substitute another query to create a view.
Create View genre as 
select name, sum(amount) as Gross_revenue from category A INNER JOIN film_category B ON A.category_id = B.category_id
INNER JOIN inventory C ON B.film_id = C.film_id
INNER JOIN rental D ON C.inventory_id = D.inventory_id
INNER JOIN payment E ON D.rental_id = E.rental_id group by name order by Gross_revenue Desc LIMIT 5;

#8b. How would you display the view that you created in 8a?
select * from genre;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP view genre;



















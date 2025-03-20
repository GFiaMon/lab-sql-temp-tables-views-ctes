/*
## Introduction

Welcome to the Temporary Tables, Views and CTEs lab!

In this lab, you will be working with the [Sakila] database on movie rentals. The goal of this lab is to help you practice and gain proficiency in using views, CTEs, and temporary tables in SQL queries.

Temporary tables are physical tables stored in the database that can store intermediate results for a specific query or stored procedure. Views and CTEs, on the other hand, are virtual tables that do not store data on their own and are derived from one or more tables or views. They can be used to simplify complex queries. Views are also used to provide controlled access to data without granting direct access to the underlying tables.

Through this lab, you will practice how to create and manipulate temporary tables, views, and CTEs. By the end of the lab, you will have gained proficiency in using these concepts to simplify complex queries and analyze data effectively.
*/

/*
## Challenge

**Creating a Customer Summary Report**

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.
*/
-- - Step 1: Create a View
		-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
use sakila;
-- 1        
select * from rental;
select * from customer;
-- 2
select * from rental
join customer
using (customer_id);
-- 3
-- rental_count customer's ID, name, email address
SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    COUNT(rental_id) AS rental_count
FROM
    rental
        JOIN
    customer USING (customer_id)
GROUP BY customer_id
;

-- 4 FINAL RESULT
CREATE VIEW customer_rental_information AS
SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    COUNT(rental_id) AS rental_count
FROM
    rental
        JOIN
    customer USING (customer_id)
GROUP BY customer_id
;

-- test View:
select * from customer_rental_information;
        
        
        
-- - Step 2: Create a Temporary Table
	-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
    
-- 1        
select * from payment;
select * from customer;

select customer_id,  sum(amount) as total_paid from customer_rental_information
join payment
using (customer_id)
group by customer_id
;
-- nr 2 COMPLETED:
CREATE TEMPORARY TABLE temp_customer_payments_2 AS
select customer_id, sum(amount) as total_paid from customer_rental_information
join payment
using (customer_id)
group by customer_id
;

/*
Show tables;
-- to see all the columms i wanted:
CREATE TEMPORARY TABLE temp_customer_payments AS
select customer_id,
    first_name,
    last_name,
    email,
    COUNT(rental_id) AS rental_count, sum(amount) as total_paid from customer_rental_information
join payment
using (customer_id)
group by customer_id, customer_id,
    first_name,
    last_name,
    email
;
*/

-- Option 2
/*
CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT
    crs.customer_id,
    crs.first_name,
    crs.last_name,
    crs.email,
    crs.rental_count,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM customer_rental_summary crs
LEFT JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id, crs.first_name, crs.last_name, crs.email, crs.rental_count;
SELECT * FROM temp_customer_payments ORDER BY total_paid DESC;
*/

        
-- - Step 3: Create a CTE and the Customer Summary Report
		-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid. 
		-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
        
select * from temp_customer_payments_2;
select * from customer_rental_information;

WITH cte_rental_payment AS (
SELECT 
    first_name, last_name, email, rental_count, total_paid
FROM
    temp_customer_payments_2
JOIN
    customer_rental_information USING (customer_id)
    )
SELECT first_name, last_name, email, rental_count, total_paid, 
		(total_paid / rental_count) AS average_payment_per_rental
FROM cte_rental_payment;


-- Option 2

/*
WITH customer_payment_summary AS (
    SELECT
        crs.first_name,
        crs.last_name,
        crs.email,
        crs.rental_count,
        tcp.total_paid
    FROM customer_rental_summary crs
    JOIN temp_customer_payments tcp
        ON crs.customer_id = tcp.customer_id
)
SELECT * FROM customer_payment_summary ORDER BY total_paid DESC;

*/

  

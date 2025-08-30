use chinook;

-- Objective Questions

-- 1) .	Does any table have missing values or duplicates? If yes how would you handle it ?

-- -- NULL Check For 1) Customers TABLE

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
  SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS null_first_name,
  SUM(CASE WHEN last_name IS NULL THEN 1 ELSE 0 END) AS null_last_name,
  SUM(CASE WHEN company IS NULL THEN 1 ELSE 0 END) AS null_company,
  SUM(CASE WHEN address IS NULL THEN 1 ELSE 0 END) AS null_address,
  SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
  SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_state,
  SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
  SUM(CASE WHEN postal_code IS NULL THEN 1 ELSE 0 END) AS null_postal_code,
  SUM(CASE WHEN phone IS NULL THEN 1 ELSE 0 END) AS null_phone,
  SUM(CASE WHEN fax IS NULL THEN 1 ELSE 0 END) AS null_fax,
  SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS null_email,
  SUM(CASE WHEN support_rep_id IS NULL THEN 1 ELSE 0 END) AS null_support_rep_id
FROM customer;

-- Duplicate Check for customer table  

SELECT first_name, last_name, email, COUNT(*) AS dup_count
FROM customer
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;
 
-- --  Replacemt Of Null Values In Customer table
 

 SELECT 
  customer_id,
  first_name,
  last_name,
  COALESCE(company, 'Individual') AS company,
  address,
  city,
  COALESCE(state, 'Unknown') AS state,
  country,
  COALESCE(postal_code, 'Not Provided') AS postal_code,
  COALESCE(phone, 'Not Provided') AS phone,
  COALESCE(fax, 'Not Provided') AS fax,
  email,
  support_rep_id
FROM customer;



-- -- NULL Check for Invoice Table 

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN invoice_id IS NULL THEN 1 ELSE 0 END) AS null_invoice_id,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
  SUM(CASE WHEN invoice_date IS NULL THEN 1 ELSE 0 END) AS null_invoice_date,
  SUM(CASE WHEN billing_address IS NULL THEN 1 ELSE 0 END) AS null_billing_address,
  SUM(CASE WHEN billing_city IS NULL THEN 1 ELSE 0 END) AS null_billing_city,
  SUM(CASE WHEN billing_state IS NULL THEN 1 ELSE 0 END) AS null_billing_state,
  SUM(CASE WHEN billing_country IS NULL THEN 1 ELSE 0 END) AS null_billing_country,
  SUM(CASE WHEN billing_postal_code IS NULL THEN 1 ELSE 0 END) AS null_billing_postal_code,
  SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS null_total
FROM invoice;

-- -- Duplicate Check For Invoice Table

SELECT customer_id, invoice_date, total, COUNT(*) AS dup_count
FROM invoice
GROUP BY customer_id, invoice_date, total
HAVING COUNT(*) > 1;


-- Null Check In Invoice_line Table

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN invoice_line_id IS NULL THEN 1 ELSE 0 END) AS null_invoice_line_id,
  SUM(CASE WHEN invoice_id IS NULL THEN 1 ELSE 0 END) AS null_invoice_id,
  SUM(CASE WHEN track_id IS NULL THEN 1 ELSE 0 END) AS null_track_id,
  SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_unit_price,
  SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity
FROM invoice_line;

-- Duplicate Check For Invoice_line Table

SELECT 
  invoice_id, 
  track_id, 
  unit_price, 
  quantity,
  COUNT(*) AS duplicate_count
FROM invoice_line
GROUP BY invoice_id, track_id, unit_price, quantity
HAVING COUNT(*) > 1;

-- To remove Duplactes In Invoice_Line Table

SET SQL_SAFE_UPDATES = 0;

WITH duplicates_to_keep AS (
  SELECT MIN(invoice_line_id) AS invoice_line_id
  FROM invoice_line
  GROUP BY invoice_id, track_id, unit_price, quantity
)
DELETE FROM invoice_line
WHERE invoice_line_id NOT IN (
  SELECT invoice_line_id FROM duplicates_to_keep
);

SET SQL_SAFE_UPDATES = 1;



-- NULL Check For Track Table
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN track_id IS NULL THEN 1 ELSE 0 END) AS null_track_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name,
  SUM(CASE WHEN album_id IS NULL THEN 1 ELSE 0 END) AS null_album_id,
  SUM(CASE WHEN media_type_id IS NULL THEN 1 ELSE 0 END) AS null_media_type_id,
  SUM(CASE WHEN genre_id IS NULL THEN 1 ELSE 0 END) AS null_genre_id,
  SUM(CASE WHEN composer IS NULL THEN 1 ELSE 0 END) AS null_composer,
  SUM(CASE WHEN milliseconds IS NULL THEN 1 ELSE 0 END) AS null_milliseconds,
  SUM(CASE WHEN bytes IS NULL THEN 1 ELSE 0 END) AS null_bytes,
  SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_unit_price
FROM track;

-- Replacemnt of Null Values

SELECT
  track_id,
  name,
  album_id,
  media_type_id,
  genre_id,
  COALESCE(composer, 'Unknown') AS composer,
  milliseconds,
  bytes,
  unit_price
FROM track;

-- Duplicate Check
SELECT name, album_id, media_type_id, COUNT(*) AS dup_count
FROM track
GROUP BY name, album_id, media_type_id
HAVING COUNT(*) > 1;

-- REMOVE DUPLICATES

WITH duplicates_to_keep AS (
  SELECT MIN(track_id) AS track_id
  FROM track
  GROUP BY name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price
)
DELETE FROM track
WHERE track_id NOT IN (
  SELECT track_id FROM duplicates_to_keep
);


-- NULL Check FOR Album Table
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN album_id IS NULL THEN 1 ELSE 0 END) AS null_album_id,
  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_title,
  SUM(CASE WHEN artist_id IS NULL THEN 1 ELSE 0 END) AS null_artist_id
FROM album;

-- Duplicate Check
SELECT title, artist_id, COUNT(*) AS dup_count
FROM album
GROUP BY title, artist_id
HAVING COUNT(*) > 1;


-- NULL Check for artist table
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN artist_id IS NULL THEN 1 ELSE 0 END) AS null_artist_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name
FROM artist;

-- Duplicate Check
SELECT name, COUNT(*) AS dup_count
FROM artist
GROUP BY name
HAVING COUNT(*) > 1;

-- NULL Check for Genre Table
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN genre_id IS NULL THEN 1 ELSE 0 END) AS null_genre_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name
FROM genre;

-- Duplicate Check
SELECT name, COUNT(*) AS dup_count
FROM genre
GROUP BY name
HAVING COUNT(*) > 1;


-- NULL Check For Media_Type
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN media_type_id IS NULL THEN 1 ELSE 0 END) AS null_media_type_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name
FROM media_type;

-- Duplicate Check
SELECT name, COUNT(*) AS dup_count
FROM media_type
GROUP BY name
HAVING COUNT(*) > 1;

-- NULL Check for playlist Table 
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN playlist_id IS NULL THEN 1 ELSE 0 END) AS null_playlist_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name
FROM playlist;

-- Duplicate Check
SELECT name, COUNT(*) AS dup_count
FROM playlist
GROUP BY name
HAVING COUNT(*) > 1;


-- NULL Check for playlist_track
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN playlist_id IS NULL THEN 1 ELSE 0 END) AS null_playlist_id,
  SUM(CASE WHEN track_id IS NULL THEN 1 ELSE 0 END) AS null_track_id
FROM playlist_track;

-- Duplicate Check (besides PK which is composite)
SELECT playlist_id, track_id, COUNT(*) AS dup_count
FROM playlist_track
GROUP BY playlist_id, track_id
HAVING COUNT(*) > 1;


-- NULL Check for employee Table
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS null_employee_id,
  SUM(CASE WHEN last_name IS NULL THEN 1 ELSE 0 END) AS null_last_name,
  SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS null_first_name,
  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_title,
  SUM(CASE WHEN reports_to IS NULL THEN 1 ELSE 0 END) AS null_reports_to,
  SUM(CASE WHEN birthdate IS NULL THEN 1 ELSE 0 END) AS null_birthdate,
  SUM(CASE WHEN hire_date IS NULL THEN 1 ELSE 0 END) AS null_hire_date,
  SUM(CASE WHEN address IS NULL THEN 1 ELSE 0 END) AS null_address,
  SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
  SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_state,
  SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
  SUM(CASE WHEN postal_code IS NULL THEN 1 ELSE 0 END) AS null_postal_code,
  SUM(CASE WHEN phone IS NULL THEN 1 ELSE 0 END) AS null_phone,
  SUM(CASE WHEN fax IS NULL THEN 1 ELSE 0 END) AS null_fax,
  SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS null_email
FROM employee;

-- Replacement of null value in Employee table 

SELECT
  employee_id,
  first_name,
  last_name,
  COALESCE(reports_to, 'Top-Level') AS manager
FROM employee;

-- Duplicate Check
SELECT first_name, last_name, email, COUNT(*) AS dup_count
FROM employee
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;


-- 2.	Find the top-selling tracks and top artist in the USA and identify their most famous genres

-- For Top Selling Tracks

SELECT 
    t.name AS track_name,
    ar.name AS artist_name,
    g.name AS genre,
    SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE i.billing_country = 'USA'
GROUP BY t.track_id
ORDER BY total_sales DESC
LIMIT 10;


-- top artist in the USA

SELECT 
    ar.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
WHERE i.billing_country = 'USA'
GROUP BY ar.artist_id
ORDER BY total_sales DESC
LIMIT 1;

-- most famous genres

WITH top_artist AS (
    SELECT ar.artist_id, ar.name
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN album al ON t.album_id = al.album_id
    JOIN artist ar ON al.artist_id = ar.artist_id
    WHERE i.billing_country = 'USA'
    GROUP BY ar.artist_id, ar.name
    ORDER BY SUM(il.unit_price * il.quantity) DESC
    LIMIT 1
)
SELECT 
    ta.name AS artist_name,
    g.name AS genre,
    COUNT(*) AS track_count
FROM top_artist ta
JOIN album al ON al.artist_id = ta.artist_id
JOIN track t ON t.album_id = al.album_id
LEFT JOIN genre g ON t.genre_id = g.genre_id
GROUP BY ta.name, g.name
ORDER BY track_count DESC;

-- 3) What is the customer demographic breakdown (age, gender, location) of Chinook's customer base? 


SELECT 
    country,
    COALESCE(state, 'Unknown') AS state,
    COALESCE(city, 'Unknown') AS city,
    COUNT(*) AS total_customers
FROM customer
GROUP BY country, state, city
ORDER BY country, state, city;

-- 4)	Calculate the total revenue and number of invoices for each country, state, and city:

SELECT
    billing_country AS country,
    COALESCE(billing_state, 'Unknown') AS state,
    COALESCE(billing_city, 'Unknown') AS city,
    COUNT(invoice_id) AS total_invoices,
    SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_country, billing_state, billing_city
ORDER BY billing_country, billing_state, billing_city;


-- 5.	Find the top 5 customers by total revenue in each country

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country,
        SUM(i.total) AS total_revenue
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.country
),
ranked_customers AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY country ORDER BY total_revenue DESC) AS rnk
    FROM customer_revenue
)
SELECT customer_id, first_name, last_name, country, total_revenue
FROM ranked_customers
WHERE rnk <= 5
ORDER BY country, rnk;

-- 6.	Identify the top-selling track for each customer

WITH customer_track_sales AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        t.track_id,
        t.name AS track_name,
        SUM(il.unit_price * il.quantity) AS total_spent
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    GROUP BY c.customer_id, c.first_name, c.last_name, t.track_id, t.name
),
ranked_tracks AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total_spent DESC) AS rnk
    FROM customer_track_sales
)
SELECT
    customer_id,
    first_name,
    last_name,
    track_id,
    track_name,
    total_spent
FROM ranked_tracks
WHERE rnk = 1
ORDER BY customer_id;

-- 7.	Are there any patterns or trends in customer purchasing behavior (e.g., frequency of purchases, preferred payment methods, average order value)?


SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.country,
    COUNT(i.invoice_id) AS total_purchases,
    ROUND(SUM(i.total), 2) AS total_revenue,
    ROUND(AVG(i.total), 2) AS average_order_value,
    MIN(i.invoice_date) AS first_purchase_date,
    MAX(i.invoice_date) AS last_purchase_date
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.country
ORDER BY total_revenue DESC;

-- 8.	What is the customer churn rate?

WITH customer_activity AS (
    SELECT 
        c.customer_id,
        MAX(i.invoice_date) AS last_purchase_date
    FROM customer c
    LEFT JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
),
churned_customers AS (
    SELECT 
        customer_id
    FROM customer_activity
    WHERE last_purchase_date < DATE_SUB((SELECT MAX(invoice_date) FROM invoice), INTERVAL 1 YEAR)
)
SELECT 
    (SELECT COUNT(*) FROM churned_customers) AS churned_customers,
    (SELECT COUNT(*) FROM customer) AS total_customers,
    ROUND(
        (SELECT COUNT(*) FROM churned_customers) * 100.0 / 
        (SELECT COUNT(*) FROM customer), 2
    ) AS churn_rate_percentage;

-- 9.	Calculate the percentage of total sales contributed by each genre in the USA and identify the best-selling genres and artists.
-- Percentage of Total Sales by Genre in the USA

SELECT
    g.name AS genre,
    SUM(il.quantity) AS tracks_sold,
    ROUND(
        CAST(SUM(il.quantity) AS FLOAT) /
        (SELECT SUM(il2.quantity)
         FROM invoice i2
         JOIN invoice_line il2 ON i2.invoice_id = il2.invoice_id
         WHERE i2.billing_country = 'USA') * 100, 2
    ) AS percentage_sold
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE i.billing_country = 'USA'
GROUP BY g.name ORDER BY tracks_sold DESC;

--  Best-Selling Artists in the USA
SELECT
    ar.name AS artist,
    SUM(il.quantity) AS tracks_sold
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
WHERE i.billing_country = 'USA'
GROUP BY ar.name
ORDER BY tracks_sold DESC
LIMIT 10;

-- 10.	Find customers who have purchased tracks from at least 3 different genres

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT g.name) AS genre_count
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT g.name) >= 3
ORDER BY genre_count DESC;

-- 11.	Rank genres based on their sales performance in the USA

SELECT 
    g.name AS genre,
    COUNT(il.invoice_line_id) AS total_tracks_sold,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(il.unit_price * il.quantity) DESC) AS genre_rank
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE i.billing_country = 'USA'
GROUP BY g.genre_id, g.name
ORDER BY total_revenue DESC;


-- 12.	Identify customers who have not made a purchase in the last 3 months

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    MAX(i.invoice_date) AS last_purchase_date
FROM customer c
LEFT JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING MAX(i.invoice_date) < DATE_SUB(
    (SELECT MAX(invoice_date) FROM invoice), INTERVAL 3 MONTH
)
ORDER BY last_purchase_date;


-- Subjective Questions

-- 1.	Recommend the three albums from the new record label that should be prioritised for advertising and promotion in the USA based on genre sales analysis

SELECT 
    al.album_id,
    al.title AS album_title,
    ar.name AS artist_name,
    g.name AS genre_name,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS total_sales_usa
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
WHERE c.country = 'USA'
GROUP BY al.album_id, al.title, ar.name, g.name
ORDER BY total_sales_usa DESC
LIMIT 3;


-- 2.	Determine the top-selling genres in countries other than the USA and identify any commonalities or differences 

WITH genre_sales AS (
    SELECT
        c.country,
        g.name AS genre,
        SUM(il.unit_price * il.quantity) AS total_sales
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    WHERE c.country <> 'USA'
    GROUP BY c.country, g.name
),
ranked_genres AS (
    SELECT
        country,
        genre,
        total_sales,
        RANK() OVER (PARTITION BY country ORDER BY total_sales DESC) AS rnk
    FROM genre_sales
)
SELECT
    country,
    genre AS top_selling_genre,
    total_sales
FROM ranked_genres
WHERE rnk = 1
ORDER BY country;




-- 3.	Customer Purchasing Behavior Analysis: How do the purchasing habits 
-- (frequency, basket size, spending amount) of long-term customers differ from
--  those of new customers? What insights can these patterns provide about customer loyalty and retention strategies?



WITH FirstPurchase AS (
    SELECT 
        customer_id,
        MIN(invoice_date) AS first_purchase_date
    FROM invoice
    GROUP BY customer_id
),
InvoiceDates AS (
    SELECT MAX(invoice_date) AS latest_invoice_date FROM invoice
),
CustomerType AS (
    SELECT 
        f.customer_id,
        CASE 
            WHEN DATEDIFF(i.latest_invoice_date, f.first_purchase_date) >= 365 THEN 'Loyal'
            ELSE 'New'
        END AS customer_type
    FROM FirstPurchase f
    CROSS JOIN InvoiceDates i
),
CustomerBehavior AS (
    SELECT 
        c.customer_type,
        inv.customer_id,
        COUNT(DISTINCT inv.invoice_id) AS purchase_frequency,
        SUM(il.quantity) * 1.0 / COUNT(DISTINCT inv.invoice_id) AS avg_basket_size,
        SUM(inv.total) AS total_spent,
        AVG(inv.total) AS avg_invoice_amount
    FROM invoice inv
    JOIN invoice_line il ON inv.invoice_id = il.invoice_id
    JOIN CustomerType c ON inv.customer_id = c.customer_id
    GROUP BY c.customer_type, inv.customer_id
)
SELECT 
    customer_type AS customer_segment,
    COUNT(*) AS num_customers,
    ROUND(AVG(purchase_frequency), 2) AS avg_purchase_frequency,
    ROUND(AVG(avg_basket_size), 2) AS avg_basket_size,
    ROUND(AVG(total_spent), 2) AS avg_total_spent,
    ROUND(AVG(avg_invoice_amount), 2) AS avg_invoice_amount
FROM CustomerBehavior
GROUP BY customer_type;




-- 4.	Product Affinity Analysis: Which music genres, artists, or albums are 
-- frequently purchased together by customers? How can this information guide product recommendations and cross-selling initiatives?

-- 4a) Frequent genre pairs purchased together
SELECT
    g1.name AS genre_1,
    g2.name AS genre_2,
    COUNT(DISTINCT il1.invoice_id) AS times_purchased_together
FROM invoice_line il1
JOIN track t1 ON il1.track_id = t1.track_id
JOIN genre g1 ON t1.genre_id = g1.genre_id
JOIN invoice_line il2 ON il1.invoice_id = il2.invoice_id AND il1.track_id < il2.track_id
JOIN track t2 ON il2.track_id = t2.track_id
JOIN genre g2 ON t2.genre_id = g2.genre_id
WHERE g1.genre_id <> g2.genre_id
GROUP BY g1.name, g2.name
ORDER BY times_purchased_together DESC
LIMIT 10;

-- 4b) Frequent artist pairs purchased together
SELECT
    a1.name AS artist_1,
    a2.name AS artist_2,
    COUNT(DISTINCT il1.invoice_id) AS times_purchased_together
FROM invoice_line il1
JOIN track t1 ON il1.track_id = t1.track_id
JOIN album al1 ON t1.album_id = al1.album_id
JOIN artist a1 ON al1.artist_id = a1.artist_id
JOIN invoice_line il2 ON il1.invoice_id = il2.invoice_id AND il1.track_id < il2.track_id
JOIN track t2 ON il2.track_id = t2.track_id
JOIN album al2 ON t2.album_id = al2.album_id
JOIN artist a2 ON al2.artist_id = a2.artist_id
WHERE a1.artist_id <> a2.artist_id
GROUP BY a1.name, a2.name
ORDER BY times_purchased_together DESC
LIMIT 10;


-- 4c) Frequent album pairs purchased together

SELECT
    al1.title AS album_1,
    al2.title AS album_2,
    COUNT(DISTINCT il1.invoice_id) AS times_purchased_together
FROM invoice_line il1
JOIN track t1 ON il1.track_id = t1.track_id
JOIN album al1 ON t1.album_id = al1.album_id
JOIN invoice_line il2 ON il1.invoice_id = il2.invoice_id AND il1.track_id < il2.track_id
JOIN track t2 ON il2.track_id = t2.track_id
JOIN album al2 ON t2.album_id = al2.album_id
WHERE al1.album_id <> al2.album_id
GROUP BY al1.title, al2.title
ORDER BY times_purchased_together DESC
LIMIT 10;



-- 5.	Regional Market Analysis: Do customer purchasing
-- behaviors and churn rates vary across different geographic regions or store locations? 
-- How might these correlate with local demographic or economic factors?



WITH last_invoice_per_customer AS (
    SELECT 
        c.customer_id,
        c.country,
        MAX(i.invoice_date) AS last_purchase_date
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.country
),
churned_customers AS (
    SELECT 
        country,
        COUNT(*) AS churned_customers
    FROM last_invoice_per_customer
    WHERE DATE(last_purchase_date) < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
    GROUP BY country
),
sales_summary AS (
    SELECT 
        c.country,
        COUNT(DISTINCT c.customer_id) AS total_customers,
        COUNT(i.invoice_id) AS total_purchases,
        ROUND(SUM(i.total), 2) AS total_revenue,
        ROUND(AVG(i.total), 2) AS avg_invoice_amount
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.country
)

SELECT 
    s.country,
    s.total_customers,
    s.total_purchases,
    s.total_revenue,
    s.avg_invoice_amount,
    COALESCE(c.churned_customers, 0) AS churned_customers,
    ROUND(COALESCE(c.churned_customers, 0) * 100.0 / s.total_customers, 2) AS churn_rate_percent
FROM sales_summary s
LEFT JOIN churned_customers c ON s.country = c.country
ORDER BY s.total_revenue DESC;



-- 6.	Customer Risk Profiling: Based on customer profiles 
-- (age, gender, location, purchase history), which customer segments are more
-- likely to churn or pose a higher risk of reduced spending? What factors contribute to this risk?

WITH customer_rfm AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country,
        MAX(i.invoice_date) AS last_purchase,
        COUNT(i.invoice_id) AS frequency,
        SUM(i.total) AS monetary_value,
        DATEDIFF(CURRENT_DATE(), MAX(i.invoice_date)) AS days_since_last_purchase
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.country
),
risk_profile AS (
    SELECT *,
        CASE
            WHEN days_since_last_purchase > 365 THEN 'High Risk'
            WHEN frequency <= 2 AND monetary_value < 20 THEN 'At Risk'
            WHEN days_since_last_purchase <= 90 AND frequency >= 5 AND monetary_value >= 50 THEN 'Loyal'
            ELSE 'Regular'
        END AS risk_category
    FROM customer_rfm
)
SELECT
    risk_category,
    country,
    COUNT(*) AS customer_count,
    ROUND(AVG(frequency), 2) AS avg_frequency,
    ROUND(AVG(monetary_value), 2) AS avg_spending,
    ROUND(AVG(days_since_last_purchase), 2) AS avg_days_since_last_purchase
FROM risk_profile
GROUP BY risk_category, country
ORDER BY risk_category, customer_count DESC;

-- 7.	Customer Lifetime Value Modeling: How can you leverage customer data 
-- (tenure, purchase history, engagement) to predict the lifetime value of different 
-- customer segments? This could inform targeted marketing and loyalty program strategies.
--  Can you observe any common characteristics or purchase patterns among customers who have stopped purchasing?


WITH customer_rfm AS (
    SELECT
        c.customer_id,
        MAX(i.invoice_date) AS last_purchase,
        MIN(i.invoice_date) AS first_purchase,
        COUNT(i.invoice_id) AS frequency,
        ROUND(AVG(i.total), 2) AS avg_order_value,
        ROUND(SUM(i.total), 2) AS total_value,
        DATEDIFF(MAX(i.invoice_date), MIN(i.invoice_date)) / 365.0 AS customer_lifespan_years
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
),
clv_model AS (
    SELECT *,
        ROUND(avg_order_value * frequency / NULLIF(customer_lifespan_years, 0), 2) AS clv
    FROM customer_rfm
)
SELECT * FROM clv_model
ORDER BY clv DESC;

use chinook;

-- 10) 10.	How can you alter the "Albums" table to add a new column named "ReleaseYear" of type INTEGER to store the release year of each album?


ALTER TABLE Album
ADD COLUMN ReleaseYear INTEGER;

select * from album;

-- 11) Chinook is interested in understanding the purchasing behavior of customers based on their geographical location. 
-- They want to know the average total amount spent by customers from each country, along with the number of customers and the
--  average number of tracks purchased per customer. Write an SQL query to provide this information.

SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) AS number_of_customers,
    ROUND(SUM(i.total) / COUNT(DISTINCT c.customer_id), 2) AS avg_total_spent_per_customer,
    ROUND(SUM(il.quantity) * 1.0 / COUNT(DISTINCT c.customer_id), 2) AS avg_tracks_purchased_per_customer
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
GROUP BY c.country
ORDER BY avg_total_spent_per_customer DESC;

WITH top_10_countries AS (
 SELECT D.country
 FROM customer A
 INNER JOIN address B ON A.address_id = B.address_id
 INNER JOIN city C ON B.city_id = C.city_id
 INNER JOIN country D ON C.country_id = D.country_id
 GROUP BY D.country
 ORDER BY COUNT(A.customer_id) DESC
 LIMIT 10

),
top_10_cities AS (
 SELECT C.city
 FROM customer A
 INNER JOIN address B ON A.address_id = B.address_id
 INNER JOIN city C ON B.city_id = C.city_id
 INNER JOIN country D ON C.country_id = D.country_id
 WHERE D.country IN (SELECT country FROM top_10_countries)
 GROUP BY D.country, C.city
 ORDER BY COUNT(A.customer_id) DESC
 LIMIT 10

),
top_5_customers AS (
 SELECT 
 A.customer_id,
 A.first_name,
 A.last_name,
 D.country,
 C.city,
 SUM(F.amount) AS total_paid
 FROM customer A
 INNER JOIN address B ON A.address_id = B.address_id
 INNER JOIN city C ON B.city_id = C.city_id
 INNER JOIN country D ON C.country_id = D.country_id
 INNER JOIN payment F ON A.customer_id = F.customer_id
 WHERE C.city IN (SELECT city FROM top_10_cities)
 GROUP BY A.customer_id, A.first_name, A.last_name, D.country, C.city
 ORDER BY total_paid DESC
 LIMIT 5

),
all_customers AS (
 SELECT 
 A.customer_id,
 D.country
 FROM customer A
 INNER JOIN address B ON A.address_id = B.address_id
 INNER JOIN city C ON B.city_id = C.city_id
 INNER JOIN country D ON C.country_id = D.country_id

)

SELECT 
 all_customers.country,
 COUNT(DISTINCT all_customers.customer_id) AS all_customer_count,
 COUNT(DISTINCT top_5_customers.customer_id) AS
top_customer_count
 FROM all_customers
 RIGHT JOIN top_5_customers
 ON all_customers.country = top_5_customers.country
 GROUP BY all_customers.country;

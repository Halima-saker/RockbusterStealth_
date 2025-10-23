SELECT D.country,
COUNT( A.customer_id) AS all_customer_count,
COUNT( top_5_customers.customer_id) AS top_customer_count
FROM country D
INNER JOIN city C ON D.country_id = C.country_id
INNER JOIN address B ON C.city_id = B.city_id
INNER JOIN customer A ON B.address_id = A.address_id
LEFT JOIN 
    (SELECT A.customer_id, A.first_name, A.last_name, c.city, d.country, SUM(amount) AS total_amount_paid
    FROM customer A
    INNER JOIN address B ON A.address_id = B.address_id
    INNER JOIN city C ON b.city_id = c.city_id
    INNER JOIN country D ON c.country_id = d.country_id
    INNER JOIN payment E ON A.customer_id = E.customer_id
    WHERE c.city IN
        (SELECT C.city
        FROM customer A
        INNER JOIN address B ON A.address_id = B.address_id
        INNER JOIN city C ON B.city_id = C.city_id
        INNER JOIN country D ON C.country_id = D.country_id
        WHERE D.country IN
            (SELECT D.country
            FROM customer A
            INNER JOIN address B ON A.address_id = B.address_id
            INNER JOIN city C ON B.city_id = C.city_id
            INNER JOIN country D ON C.country_id = D.country_id
            GROUP BY country
            ORDER BY COUNT (customer_id) DESC
            LIMIT 10)
        GROUP BY D.country, C.city
        ORDER BY COUNT (customer_id) DESC
        LIMIT 10)
    GROUP BY A.customer_id, A.first_name, A.last_name, c.city, d.country
    ORDER BY total_amount_paid DESC
    LIMIT 5) AS top_5_customers ON A.customer_id = top_5_customers.customer_id
GROUP BY D.country
--Having COUNT(DISTINCT top_5_customers.customer_id) > 0
ORDER BY all_customer_count DESC
Limit 5

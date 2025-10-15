USE sql_store;

SELECT * FROM customers
WHERE customer_id = 1
ORDER BY first_name;

SELECT 1, 2;

SELECT first_name, last_name, points, points * 10 + 100
FROM customers;

SELECT 
     first_name,
     last_name,
	 points,
     (points + 10) * 100
FROM customers;

SELECT 
     first_name,
     last_name,
	 points,
     (points + 10) * 100 AS discount_factor
FROM customers;

SELECT 
     first_name,
     last_name,
	 points,
     (points + 10) * 100 AS 'discount factor'
FROM customers;

SELECT * FROM sql_store.customers;
SELECT DISTINCT state from customers;

SELECT name, unit_price, unit_price * 1.1 AS 'new unit_price' FROM sql_store.products;

#The where clause in sql

SELECT * FROM customers
WHERE points > 3000;

#BOOLEAN CLAUSE

SELECT * FROM customers WHERE birth_date > '1990-01-01' AND points > 1000;
SELECT * FROM customers WHERE birth_date > '1990-01-01' OR points > 1000;
SELECT * FROM customers WHERE birth_date > '1990-01-01' OR points > 1000 AND state = 'VA';

#ORDER IN BOOLEAN

SELECT * FROM customers 
         WHERE birth_date > '1990-01-01' OR 
         (points > 1000 AND state = 'VA');
         
  SELECT * FROM customers WHERE NOT (birth_date > '1990-01-01' OR points > 1000);    
  #SAME RESULT AS CODE 55
  SELECT * FROM customers WHERE birth_date <= '1990-01-01' AND points <= 1000; 
  
  SELECT * FROM sql_store.order_items;
  SELECT * FROM sql_store.order_items WHERE order_id = 6 AND unit_price * quantity > 30 ; 
  
SELECT * FROM sql_store.customers WHERE state = 'VA' OR state = 'GA' OR state = 'FL' ;
  
  #The IN OPERATOR
  
SELECT * FROM sql_store.customers WHERE state IN ('VA', 'GA', 'FL' );
SELECT * FROM sql_store.customers WHERE state NOT IN ('VA', 'GA', 'FL' );

#BTW OPERATOR

SELECT * FROM sql_store.customers WHERE points BETWEEN 1000 AND 3000;

#LIKE OPERATOR AND % SIGN

SELECT * FROM sql_store.customers WHERE last_name LIKE 'b%';
SELECT * FROM sql_store.customers WHERE last_name LIKE 'brush%';
SELECT * FROM sql_store.customers WHERE last_name LIKE '%y';
SELECT * FROM sql_store.customers WHERE last_name LIKE '_____y';

SELECT * FROM sql_store.customers WHERE address LIKE '%trail%' OR address LIKE '%avenue%' ;

SELECT * FROM sql_store.customers WHERE phone LIKE '%9';
SELECT * FROM sql_store.customers WHERE phone  NOT LIKE '%9';

#REGEXP  (REGULAR EXPRESSIONS)
SELECT * FROM sql_store.customers WHERE phone REGEXP '9';
SELECT * FROM sql_store.customers WHERE phone REGEXP '^9';
SELECT * FROM sql_store.customers WHERE phone REGEXP '9$';
SELECT * FROM sql_store.customers WHERE last_name REGEXP 'son$';
SELECT * FROM sql_store.customers WHERE last_name REGEXP 'son|field';
SELECT * FROM sql_store.customers WHERE last_name REGEXP '^field|son|good';
SELECT * FROM sql_store.customers WHERE last_name REGEXP '[gim]e';
SELECT * FROM sql_store.customers WHERE last_name REGEXP 'e[gim]';

SELECT * FROM sql_store.customers WHERE last_name REGEXP '[a-h]e';

#NOT OPERATOR (SELECTING MISSING values)
SELECT * 
FROM sql_store.customers WHERE phone IS NULL;
select * FROM sql_store.customers WHERE phone IS NOT NULL;

-- ORDER By CLAUSE
SELECT *
FROM sql_store.customers
ORDER BY first_name;

SELECT *
FROM sql_store.customers
ORDER BY first_name DESC;

SELECT *
FROM sql_store.customers
ORDER BY state, first_name;

SELECT first_name, last_name
FROM customers
ORDER BY birth_date;

SELECT first_name, last_name, 10 AS points
FROM customers
ORDER BY first_name, points;

SELECT first_name, last_name, 10 AS points
FROM customers
ORDER BY 1, 2;

SELECT *
FROM sql_store.order_items
WHERE order_id = 2
ORDER BY quantity*unit_price DESC;

SELECT *, quantity*unit_price AS total_price
FROM sql_store.order_items
WHERE order_id = 2
ORDER BY quantity*unit_price DESC;

SELECT *, quantity*unit_price AS total_price
FROM sql_store.order_items
WHERE order_id = 2
ORDER BY total_price DESC;

SELECT *, quantity*unit_price AS total_price
FROM sql_store.order_items
LIMIT 3;

-- SKIP RECORDS BEFORE LIMITS
SELECT *
FROM sql_store.order_items
LIMIT 3, 6;

-- RESTORING DATABASES
 


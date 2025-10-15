-- INNER JOINS
SELECT *
FROM orders
JOIN customers
ON orders.customer_id = customers.customer_id;

SELECT order_id, first_name, last_name
FROM orders
JOIN customers
ON orders.customer_id = customers.customer_id;

SELECT order_id, orders.customer_id, first_name, last_name
FROM orders
JOIN customers
ON orders.customer_id = customers.customer_id;

SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;

-- JOIN TABLES across multiple databases

 SELECT *
 FROM order_items oi
 JOIN sql_inventory.products p 
	ON oi.product_id = p.product_id;
    
    -- SELF JOIN
    USE sql_hr;
    SELECT *
    FROM employees e
    JOIN employees m
		ON e.reports_to = m.employee_id;
        
SELECT e.employee_id,
	   e.first_name,
       m.first_name AS managers
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id;
    
-- JOIN TWO OR MORE TABLES
   SELECT *
    FROM sql_store.orders o
    JOIN sql_store.customers c
		ON o.customer_id = c.customer_id
	JOIN sql_store.order_statuses os
		ON o.status = os.order_status_id;

 SELECT o.order_id,
		o.order_date,
        c.first_name,
        c.last_name,
        os.name AS Status
    FROM sql_store.orders o
    JOIN sql_store.customers c
		ON o.customer_id = c.customer_id
	JOIN sql_store.order_statuses os
		ON o.status = os.order_status_id;
        
-- COMPOUND JOINS
USE sql_store;
SELECT * 
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_Id
    AND oi.product_id = oin.product_id;
    
-- IMPLICIT INNER JOIN SYNTHAX;
 SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

-- CROSS JOIN
  SELECT *
FROM orders , customers;

SELECT o.order_id, c.first_name, c.customer_id
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
ORDER BY c.customer_id;
-- The output shows only the customers that have ordered but if you want to see the all the customers including the ones that didnt place an order u'll use OUTER JOIN

-- OUTER JOIN (LEFT JOIN) - ALL THE CONDITIONS IN THE LEFT TABLE i.e CUSTOMERS WERE RETURNED
SELECT c.first_name, c.customer_id, o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- RIGHT OUTER JOIN (ALL THE CONDITIONS IN THE RIGHT TABLE WILL BE RETURNED REGARDLESS OF IT BEIGN TRUE NOT
SELECT c.first_name, c.customer_id, o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
-- NOTE THAT THE OUTPUT GAVE US SAME RESULT AS USING INNER JOIN

-- OUTER JOIN BETWEEN MULTIPLE TABLES
 SELECT c.first_name, c.customer_id, o.order_id, sh.name AS shipperName
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;
-- THE OUTPUT GAVE A RESULT OF CUSTOMERS THAT HAS SHIPPER NAME AND ID BCOS OF THE 2ND JOIN 

SELECT c.first_name, c.customer_id, o.order_id, sh.name AS shipperName
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;
 --  THIS GAVE A RESULT THAT INCLUDED ALL THE CUSTOMERS REGARDLESS OF THEIR ORDER AND SHIPPER STATUS
 
 -- AS BEST PRACTICE USE LEFT JOINS AND ALTERNATE YOUR FIELD USAGE FOR GETTING SAME RESULT AS USING RIGHT JOIN  
-- EXERCISE  
SELECT 
	o.order_id, 
    o.order_date,
    c.first_name AS customer,
    sh.name AS shipper,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
	ON o.status = os.order_status_id;

-- SELF OUTER JOIN
USE sql_hr;
SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;
    
-- USING CLAUSE (USED INSTEAD OF 'ON' TO SIMPLIFY THE CODE AND IT CAN ONLY BE USED IF THE TABLES HAVE THE SAME COLUMN IN THEM)

USE sql_store;
SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);
    
-- COMPOUND USING CLAUSE 

SELECT *
FROM sql_store.order_items oi
JOIN sql_store.order_item_notes oin
	USING (order_id, product_id);

-- EXERCISE
USE sql_invoicing;

SELECT p.date,
	   c.name AS client,
       p.amount,
       pm.name AS payment_method
FROM payments p
JOIN  clients c USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;
    
SELECT p.date,
	   c.name AS client,
       p.amount,
       pm.name AS payment_method
FROM payments p
LEFT JOIN  clients c USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;
    
-- CROSS JOINS (JOINS ALL CONTENTS OF BOTH TABLES TOGETHER)
SELECT *
FROM sql_store.customers 
CROSS JOIN sql_store.products p;

-- IMPLICIT CROSS JOINS
SELECT 
	c.first_name AS customers,
    p.name AS products
FROM sql_store.customers c
CROSS JOIN sql_store.products p 
order by c.first_name;
-- CROSS JOINS IS BEST USED WITH TABLES OF DIFFERENT SIZES OR COLOURS E.T.C THAT YOU WANT TO MATCH TOGETHER 

SELECT *
FROM sql_store.shippers
CROSS JOIN sql_store.products;

SELECT *
FROM sql_store.shippers, sql_store.products p; 

-- UNIONS (USE FOR JOINING ROWS IN A TABLE)
use sql_store;
select
	order_id,
    order_date,
    'Active' AS Status
from orders
where order_date >= '2019-01-01'
union	
select
	order_id,
    order_date,
    'Archived' AS Status
from orders
where order_date < '2019-01-01';
-- it can be used for multiple tables and databases too
-- Exercise

select	
	customer_id,
    first_name,
    points, 
    'Bronze' AS type
from customers
where points < 2000
union
select	
	customer_id,
    first_name,
    points, 
    'Silver' AS type
from customers
where points BETWEEN 2000 AND 3000
union
select	
	customer_id,
    first_name,
    points,
    'Gold' AS type
from customers
where points > 3000
order by first_name;

-- COLUMN ATTRIBUTES
-- INSERT A ROW INTO A TABLE

INSERT INTO customers
VALUES (DEFAULT, 'John', 'Smith', '1990-01-01', NULL, 'address', 'city', 'CA', DEFAULT);

-- YOU CAN ALSO SUPPLY THE COLUMN NAMES WCH ULL BE INSERTING VALUES INTO
 INSERT INTO customers 
	(First_name,
    Last_name,
    birth_date,
    address,
    city,
    State)
VALUES 
	('John', 
    'Smith', 
    '1990-01-01', 
    'address', 
    'city', 
    'CA') ;

-- INSERTING MULTIPLE ROWS IN A TABLE
INSERT INTO Shippers (name)
VALUES ('shipper1'),
		('shipper2'),
        ('shipper3');
        
INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('Product1', 10, 1.95),
        ('Product2', 11, 1.95),
        ('Product3', 12, 1.95);

-- INSERTING MULTIPLE TABLES HIERACHIALLY
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 2.95),
	    (LAST_INSERT_ID(), 2, 1, 3.95);

-- CREATE A COPY OF A TABLE
CREATE TABLE orders_archived AS 
SELECT * FROM orders;

-- Copying only a subset of records into a table
 INSERT INTO orders_archived
 SELECT *
 FROM orders
 WHERE order_date < '2019-01-01';
 
 -- EXERCISE
 USE sql_invoicing;
 CREATE TABLE invoices_archived AS 
 SELECT
	i.invoice_id,
    i.number,
    c.name AS client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.payment_date,
    i.due_date
FROM invoices i
JOIN clients c
	USING (client_id)
WHERE payment_date IS NOT NULL; 

-- UPDATE CLAUSE
UPDATE INVOICES
SET payment_total = 10, payment_date ='2019-03-01'
WHERE invoice_id = 1;

 UPDATE INVOICES
SET payment_total = DEFAULT, payment_date = NULL
WHERE invoice_id = 1;

UPDATE INVOICES
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE invoice_id = 3;

-- UPDATING MULTIPLE ROWS
UPDATE INVOICES
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id = 3;
 
 -- UPDATING MULTIPLE ROWS
UPDATE INVOICES
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id IN (3, 4);

USE sql_store;
UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';

-- SUBQUERIES IN UPDATE CLAUSE
USE sql_invoicing;
UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id =
		(SELECT client_id
		FROM clients
		WHERE name = 'Myworks');

-- MULTIPLE RECORDS UPDATE USAGE
 UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id IN
		(SELECT client_id
		FROM clients
		WHERE state IN ('NY', 'CA'));
        
-- exercise
UPDATE orders
SET comments = 'Gold Customers'
WHERE customer_id IN
	(SELECT customer_id
    FROM customers
    WHERE points > 3000);
    
-- DELETING ROWS
 DELETE FROM invoices
 WHERE client_id = 1;
 
 DELETE FROM invoices
 WHERE client_id =
	(SELECT *
    FROM clients
    WHERE name = 'Myworks');
 
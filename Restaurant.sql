
-- I'm a restaurant owner, create 5 tables
-- 1 fact, 4 dimension
-- Search google, how to add foreign key
-- Write SQL 3-5 queries to analyze data
-- Subquery or WITH
-- sqlite command, edit view
.mode column
.header on

  --Staff
  CREATE TABLE dim_staff (
staff_id INT PRIMARY KEY,
staff_name TEXT,
staff_age INT ,
staff_gender text );

--staff value
insert	into dim_staff VALUES
(1,'Aek',34,'Male'),
(2,'Art',22,'Male'),
(3,'Aee',28,'Male'),
(4,'Ann',42,'Female'),
(5,'Aoy',30,'Female');

--Branch
CREATE TABLE dim_branch (
branch_id INT PRIMARY Key ,
address TEXT );

INSERT into dim_branch VALUES 
(1,'Bangkok'),
(2,'Chiangmai'),
(3,'Hatyai');

--Product type
CREATE TABLE dim_product_type (
product_type_id int PRIMARY KEY,
product_type TEXT);

insert into dim_product_type VALUES 
(1,'Food'),
(2,'Beverage');

--Payment type
CREATE TABLE dim_payment_type (
payment_id INT PRIMARY KEY,
payment_type TEXT);

insert into dim_payment_type VALUES 
(1,'Credit Card'),
(2,'Cash');

--Product
CREATE TABLE dim_product(
product_id INT PRIMARY KEY,
product_name TEXT,
product_price REAL,
product_type_id INT,
FOREIGN KEY (product_type_id) REFERENCES dim_product_type(product_type_id));

INSERT INTO dim_product VALUES 
(2,'Beef Lover',299,1),
(3,'Chicken Chispy',99,1),
(4,'Mlik Tea',49,2),
(5,'Cappuchino',59,2),
(6,'Black Coffee',49,2);

--customer type
CREATE TABLE dim_customer_type(
customer_type_id INT PRIMARY KEY,
customer_type TEXT);

INSERT INTO dim_customer_type VALUES 
(1,'Family'),
(2,'Couple'),
(3,'Other');

--order 
CREATE TABLE Fact_order(
order_id INT PRIMARY KEY,
order_date TEXT,
customer_name Text,
staff_id INT,
branch_id INT,
product_id INT,
customer_type_id INT,
payment_id INT,
product_quantity INT,
FOREIGN KEY (staff_id) REFERENCES dim_staff(staff_id),
FOREIGN KEY (branch_id) REFERENCES dim_branch(branch_id),
FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
FOREIGN KEY (customer_type_id) REFERENCES dim_customer_type(customer_type_id),
FOREIGN KEY (payment_id) REFERENCES dim_payment_type(payment_id)
  );

INSERT INTO Fact_order VALUES 
(1,'2022-1-17','Zlatan',5,1,2,1,1,3),
(2,'2022-1-17','Totti',1,1,6,2,1,2),
(3,'2022-1-18','kook',1,1,2,1,1,5),
(4,'2022-1-18','alexis',2,2,3,1,1,1),
(5,'2022-1-18','alexis',3,3,1,1,2,4),
(6,'2022-1-19','Lukaku',4,3,4,2,2,2),
(7,'2022-1-19','Bruno',1,1,5,2,1,3),
(8,'2022-1-20','Torres',2,2,6,2,2,2),
(9,'2022-1-21','Delight',4,3,3,1,1,3),
(10,'2022-1-22','Mane',5,1,1,1,1,2),
(11,'2022-1-22','Mane',2,2,2,1,2,2),
(12,'2022-1-23','Salah',5,1,6,2,2,2);

--SUM 2022-1-18
SELECT 
sub.Date,
SUM(totals) AS Totals
FROM
(SELECT 
Fact_order.order_date AS Date,
Fact_order.customer_name AS Name,
dim_product.product_name As Detail,
dim_product.product_price As Price,
Fact_order.product_quantity AS Counts,
dim_product.product_price * Fact_order.product_quantity  AS totals
FROM Fact_order , dim_product
WHERE dim_product.product_id = Fact_order.product_id
AND Fact_order.order_date ='2022-1-18')
AS sub;

--Create View
CREATE VIEW Result AS 
SELECT 
Fact_order.order_date AS Date,
Fact_order.customer_name AS Name,
dim_product_type.product_type AS Type,
dim_product.product_name As Detail,
dim_product.product_price As Price,
Fact_order.product_quantity AS Counts,
dim_product.product_price * Fact_order.product_quantity  AS totals,
dim_payment_type.payment_type AS payment,
dim_branch.address AS branch
FROM Fact_order , dim_product , dim_product_type , dim_payment_type , dim_branch
WHERE dim_product_type.product_type_id = dim_product.product_type_id  
AND dim_product.product_id = Fact_order.product_id
AND dim_payment_type.payment_id = Fact_order.payment_id 
AND dim_branch.branch_id = Fact_order.branch_id
;


--Branch Revenue
SELECT 
bra.branch,
Sum(bra.totals) AS Revenue 
FROM
(SELECT 
Result.totals,
Result.payment,
Result.branch
FROM Result
) AS bra
Group by bra.branch
ORDER by 1 desc;

--Type Total
SELECT 
	sub.Type,
	sum(sub.totals) AS TOTAL
FROM
(SELECT
Result.Date,
Result.Type,
Result.totals
FROM Result
) AS sub 
GROUP BY sub.Type
;






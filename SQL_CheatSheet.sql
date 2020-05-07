-- Creating a table with certain constrains.
CREATE TABLE products(productid NUMBER(10) PRIMARY KEY, product_name VARCHAR2(30) NOT NULL,price  NUMBER(10) NOT NULL,CHECK(price>100), product_catagory VARCHAR2(20));

-- Altering a table to modify the column.
ALTER TABLE products MODIFY (product_catagory VARCHAR2(25));

-- Altering the table to add the column.
ALTER TABLE products ADD (supplier_name VARCHAR2(20));

-- Altering the table to rename the column.
ALTER TABLE products RENAME COLUMN price TO product_price;

-- Altering the table to drop or delete the column.
ALTER TABLE products DROP COLUMN supplier_name;

-- Altering the table to add multiple columns.
ALTER TABLE products ADD (product_type VARCHAR2(20),supplier_name VARCHAR2(30), supplierid NUMBER(20) UNIQUE);

-- Altering the table to drop multiple columns.
ALTER TABLE products DROP (product_type, supplierid);

-- Renaming the table name.
RENAME products TO products_table;

-- All columns, single row insertion.
INSERT INTO products_table VALUES (101,'Whey Protein',120,'Sports Supplements','Optimum Nutrition');

-- All columns multiple row insertion.
INSERT INTO products_table VALUES (&productid,'&product_name',&product_price,'&product_category','&supplier_name');

-- Particular column single row
INSERT INTO products_table (productid,product_name,product_price) VALUES (103,'Airpods',5000);

-- Particular column multiple rows
 INSERT INTO products_table (productid, product_name, product_price) VALUES (&productid,'&product_name',&product_price);
 
 -- Altering the table to add the column.
ALTER TABLE products_table ADD (order_date DATE);

-- Entire column update
UPDATE products_table SET order_date = sysdate;

-- Particular column multiple rows insertion
 INSERT INTO products_table (productid, product_name, product_price,product_catagory,supplier_name) VALUES (&productid,'&product_name',&product_price,'&product_catagory','&supplier_name');
 
-- Particular row single column update
UPDATE products_table SET supplier_name='Apple' WHERE productid=103;

-- Particular row multiple column update
UPDATE products_table SET product_price=5500, product_catagory='Electronics' WHERE productid=103;
UPDATE products_table SET product_catagory='Books',supplier_name='Oracle' WHERE productid=202;


-- Multiple rows single column update
UPDATE products_table SET product_price=1500 WHERE productid IN (101,102);


-- Multiple row multiple column update
UPDATE products_table SET product_catagory='Electronics', supplier_name='Apple' WHERE productid IN (103,201);

-- Particular record delete
DELETE FROM products_table WHERE productid=202;

-- Multiple record delete
DELETE FROM products_table WHERE supplier_name IN ('Apple');

-- Saves the above statements to secondary memory and finalize it.
COMMIT;

-- Goes to the previous state or undo the previous single or multiple commands. It works inside the primary memory. 
ROLLBACK;

-- Select Statements

SELECT * FROM products_table;

SELECT DISTINCT supplier_name FROM products_table;

SELECT * FROM products_table WHERE supplier_name='Apple';

SELECT productid, product_name, supplier_name FROM products_table;

SELECT productid, product_name, supplier_name FROM products_table WHERE product_catagory IN ('Sports Supplements','Electronics') ;


-- Clauses used with group by.

SELECT MAX(product_price) FROM products_table;

SELECT MIN(product_price) FROM products_table;

SELECT AVG(product_price) FROM products_table;

SELECT COUNT(product_price) FROM products_table;

-- Order by

SELECT * FROM products_table ORDER BY product_price;

SELECT * FROM products_table ORDER BY product_price DESC;

-- Where and use of between, not between, like, AND & OR.

SELECT * FROM products_table WHERE supplier_name = 'Apple' AND product_catagory='Electronics';

SELECT * FROM products_table WHERE supplier_name = 'Apple' OR product_catagory='Sports Supplements';

SELECT * FROM products_table WHERE product_price BETWEEN 100 AND 500;

SELECT * FROM products_table WHERE product_price NOT BETWEEN 100 AND 500;

SELECT * FROM products_table WHERE supplier_name LIKE 'A%';

SELECT * FROM products_table WHERE product_catagory LIKE '%s';

SELECT * FROM products_table WHERE product_catagory LIKE '_p%';

SELECT * FROM products_table WHERE product_catagory LIKE '%n__';

SELECT * FROM products_table WHERE ROWNUM  BETWEEN 1 AND 3;

SELECT * FROM products_table WHERE ROWNUM<=5;


-- Group by

SELECT MAX(product_price) FROM products_table GROUP BY product_price;

SELECT supplier_name, COUNT(*) FROM products_table GROUP BY supplier_name;

SELECT supplier_name, COUNT(*) FROM products_table GROUP BY supplier_name HAVING (supplier_name='Apple');



------------------------------------ Creating Another Table--------------------------------------------------------

CREATE TABLE orders (orderid NUMBER PRIMARY KEY, productid NUMBER, FOREIGN KEY (productid) REFERENCES products_table(productid));

INSERT INTO orders VALUES(100,101);
INSERT INTO orders VALUES(101,102);
INSERT INTO orders VALUES(103,103);
INSERT INTO orders VALUES(104,201);

---------------------------------------------------------------------------------------------------------------------------

--inner join (provides the data that are common to both the tables).

SELECT A.orderid,b.productid, b.product_name FROM orders A INNER JOIN products_table b ON A.productid=b.productid;

-- left join (provides the data that are common to both the tabkes plus the remaining datas from the left table.)
SELECT A.orderid,b.productid, b.product_name FROM orders A LEFT JOIN products_table b ON A.productid=b.productid;

--right join (provides the data that are common to both the tabkes plus the remaining datas from the right table.)
SELECT A.orderid,b.productid, b.product_name FROM orders A RIGHT JOIN products_table b ON A.productid=b.productid;

-------------------------------------------------------------------------------------------------------------------------------

-- Subqueries

-- Single row subquery. It returns oly one value and that is assined by "=" Operator.
-- Gives the maximum price
SELECT * FROM products_table WHERE product_price = (SELECT MAX(product_price) FROM products_table);

-- Gives the second maximum price.
SELECT * FROM products_table WHERE product_price = (SELECT MAX(product_price) FROM products_table WHERE product_price<(SELECT MAX(product_price) FROM products_table));

-- Multiple row subquery

-- The ANY operator returns true if any of the subquery values meet the condition.

-- =any gives the values that are between 100 and 1000 in this case.
SELECT * FROM products_table WHERE product_price = ANY (SELECT product_price FROM products_table WHERE product_price BETWEEN 100 AND 1000); 

-- <any gives the values that are between 100 and 1000 plus the values that are less than those values.
SELECT * FROM products_table WHERE product_price < ANY (SELECT product_price FROM products_table WHERE product_price BETWEEN 100 AND 1000); 

-- <any gives the values that are between 100 and 1000 plus the values that are greater than those values.
SELECT * FROM products_table WHERE product_price > ANY (SELECT product_price FROM products_table WHERE product_price BETWEEN 100 AND 1000); 


-- The ALL operator returns true if all of the subquery values meet the condition.

-- >all displays the values that are greater then the retrieved values from the subquery.
SELECT * FROM products_table WHERE product_price > ALL (SELECT product_price FROM products_table WHERE product_price BETWEEN 0 AND 2000); 

-- <all displays the values that are greater then the retrieved values from the subquery.
SELECT * FROM products_table WHERE product_price < ALL (SELECT product_price FROM products_table WHERE product_price BETWEEN 0 AND 2000); 

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Having Keyword
SELECT product_price FROM products_table GROUP BY product_price HAVING product_price>100; 





















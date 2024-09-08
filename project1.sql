CREATE TABLE CUSTOMERS (
	CUST_ID SERIAL PRIMARY KEY,
	CUST_NAME VARCHAR(100) NOT NULL
);

CREATE TABLE ORDERS (
	ORD_ID SERIAL PRIMARY KEY,
	ORD_DATE DATE NOT NULL,
	CUST_ID INTEGER NOT NULL,
	FOREIGN KEY (CUST_ID) REFERENCES CUSTOMERS (CUST_ID)
);

CREATE TABLE PRODUCTS (
	P_ID SERIAL PRIMARY KEY,
	P_NAME VARCHAR(100) NOT NULL,
	PRICE NUMERIC NOT NULL
);

CREATE TABLE ORDER_ITEMS (
	ITEM_ID SERIAL PRIMARY KEY,
	ORD_ID INTEGER NOT NULL,
	P_ID INTEGER NOT NULL,
	QUANTITY INTEGER NOT NULL,
	FOREIGN KEY (ORD_ID) REFERENCES ORDERS (ORD_ID),
	FOREIGN KEY (P_ID) REFERENCES PRODUCTS (P_ID)
);

INSERT INTO
	CUSTOMERS (CUST_NAME)
VALUES
	('Raju'),
	('Sham'),
	('Paul'),
	('Alex');

INSERT INTO
	ORDERS (ORD_DATE, CUST_ID)
VALUES
	('2024-01-01', 1), -- Raju first order
	('2024-02-01', 2), -- Sham first order
	('2024-03-01', 3), -- Paul first order
	('2024-04-04', 2);

-- Sham second order
INSERT INTO
	PRODUCTS (P_NAME, PRICE)
VALUES
	('Laptop', 55000.00),
	('Mouse', 500),
	('Keyboard', 800.00),
	('Cable', 250.00);

INSERT INTO
	ORDER_ITEMS (ORD_ID, P_ID, QUANTITY)
VALUES
	(1, 1, 1), -- Raju ordered 1 Latop
	(1, 4, 2), -- Raju ordered 2 Cables
	(2, 1, 1), -- Sham ordered 1 Laptop
	(3, 2, 1), -- Paul ordered 1 Mouse
	(3, 4, 5), -- Paul ordered 5 Cable
	(4, 3, 1);

-- Sham ordered 1 Keyboard
SELECT
	C.CUST_NAME,
	O.ORD_DATE,
	P.P_NAME,
	P.PRICE,
	OI.QUANTITY,
	(OI.QUANTITY * P.PRICE) AS TOTAL_PRICE
FROM
	ORDER_ITEMS OI
	JOIN PRODUCTS P ON OI.P_ID = P.P_ID
	JOIN ORDERS O ON O.ORD_ID = OI.ORD_ID
	JOIN CUSTOMERS C ON O.CUST_ID = C.CUST_ID;

--VIEWS
-- In sql a veiw is a virtual table thats based on the resutl set of a
-- sql statementa view contains rows and columns just like a real table
-- and its field come form one or more real table in the database 
CREATE VIEW BILLING_INFO AS
SELECT
	C.CUST_NAME,
	O.ORD_DATE,
	P.P_NAME,
	P.PRICE OI.QUANTITY,
	(OI.QUANTITY * P.PRICE) AS TOTAL_PRICE
FROM
	ORDER_ITEMS OI
	JOIN PRODUCTS P ON OI.P_ID = P.P_ID
	JOIN ORDERS O ON O.ORD_ID = OI.ORD_ID
	JOIN CUSTOMERS C ON O.CUST_ID = C.CUST_ID;

--NOTE we can't use where clause when we are using the group by
--so insted to using the where clause we use HAVING clause
--example 1) GROUP BY HAVING 
SELECT
	P_NAME,
	SUM (TOTAL_PRICE)
FROM
	BILLING_INFO
GROUP BY
	P_NAME
HAVING
	SUM(TOTAL_PRICE) > 1500;

--example 2) 
select 
coalesce (p_name,'total'),
sum(total_price) from billing_info
group by rollup(p_name)
order by sum(total_price);


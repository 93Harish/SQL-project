--1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) as per the following criteria and sort them in descending order of category: a. If the category is 2050, increase the price by 2000 b. If the category is 2051, increase the price by 500 c. If the category is 2052, increase the price by 600. Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]  
  #Answer:
  SELECT 
product_class_code, 
product_id,
 product_desc, 

 CASE 
            WHEN product_class_code = 2050 THEN product_price+2000
			WHEN product_class_code = 2051 THEN product_price+500
			WHEN product_class_code = 2052 THEN product_price+600
			ELSE product_price
			END AS product_price
FROM PRODUCT
ORDER BY PRODUCT_CLASS_CODE desc;


--2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show inventory status of products as below as per their available quantity: a. For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock' b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'. Hint: Use case statement. (60 ROWS) [NOTE: TABLES TO BE USED – product, product_class]
# Answer:
select * from product;
select * from product_class;
SELECT 
Pc.product_class_desc, 
P.product_id, 
P.product_desc, 
P.product_quantity_avail,
CASE WHEN Pc.product_class_desc IN ('Electronics','Computer') AND P.product_quantity_avail <=10 THEN 'Low Stock'
            WHEN Pc.product_class_desc IN ('Electronics','Computer') AND P.product_quantity_avail >=11 AND  P.product_quantity_avail <= 30 THEN 'In Stock'
            WHEN Pc.product_class_desc IN ('Electronics','Computer') AND P.product_quantity_avail >=31 THEN 'Enough  Stock'
			WHEN Pc.product_class_desc IN ('Stationery','Clothes') AND P.product_quantity_avail <=20 THEN 'Low Stock'
            WHEN Pc.product_class_desc IN ('Stationery','Clothes') AND P.product_quantity_avail >=21 AND  P.product_quantity_avail <= 80 THEN 'In Stock'
            WHEN Pc.product_class_desc IN ('Stationery','Clothes') AND P.product_quantity_avail >=81 THEN 'Enough  Stock'
			WHEN P.product_quantity_avail <=15 THEN 'Low Stock'
            WHEN P.product_quantity_avail >=16 AND  P.product_quantity_avail <= 50 THEN 'In Stock'
            WHEN P.product_quantity_avail >=51 THEN 'Enough  Stock'
			WHEN P.product_quantity_avail=0 THEN 'out of stock'

END AS Inventory_status

FROM PRODUCT P
INNER JOIN PRODUCT_CLASS Pc
ON P.PRODUCT_CLASS_CODE = Pc.PRODUCT_CLASS_CODE;



--3.Write a query to show the number of cities in all countries other than USA & MALAYSIA, with more than 1 city, in the descending order of CITIES. (2 rows) [NOTE: ADDRESS TABLE]
# Answer:

select * from address;

SELECT 
COUNTRY,
COUNT(CITY) AS Count_City

FROM ADDRESS
WHERE COUNTRY NOT IN('USA','Malaysia')
GROUP BY COUNTRY
HAVING Count_City >1;


--4. Write a query to display the customer_id,customer full name ,city,pincode,and order details (order id, product class desc, product desc, subtotal(product_quantity * product_price)) for orders shipped to cities whose pin codes do not have any 0s in them. Sort the output on customer name and subtotal. (52 ROWS) [NOTE: TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class]
# Answer:

SELECT C.CUSTOMER_ID,
(C.CUSTOMER_FNAME  || ' ' ||  C.CUSTOMER_LNAME) AS CUSTOMER_NAME,
A.CITY,
A.PINCODE,
OH.ORDER_ID,
PC.PRODUCT_CLASS_DESC,
P.PRODUCT_DESC,
(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) AS SUBTOTAL
FROM ONLINE_CUSTOMER C
LEFT JOIN ADDRESS A
ON C.ADDRESS_ID = A.ADDRESS_ID
LEFT JOIN ORDER_HEADER OH
ON C.CUSTOMER_ID = OH.CUSTOMER_ID
LEFT JOIN ORDER_ITEMS OI
ON OH.ORDER_ID = OI.ORDER_ID
LEFT JOIN PRODUCT P 
ON OI.PRODUCT_ID = P.PRODUCT_ID
LEFT JOIN  PRODUCT_CLASS PC
ON P.PRODUCT_CLASS_CODE = PC.PRODUCT_CLASS_CODE
WHERE A.PINCODE NOT LIKE '%0%' 
AND OH.ORDER_STATUS = 'Shipped'
ORDER BY   SUBTOTAL  AND CUSTOMER_NAME DESC;


--5. Write a Query to display product id,product description,totalquantity(sum(product quantity) for a given item whose product id is 201 and which item has been bought along with it maximum no. of times. Display only one record which has the maximum value for total quantity in this scenario. (USE SUB-QUERY)(1 ROW)[NOTE : ORDER_ITEMS TABLE,PRODUCT TABLE]
# Answer:

SELECT 
P.PRODUCT_ID,
PRODUCT_DESC,
SUM(SUB.MAX_QUANTITY) AS TOTAL_QUANTITY

FROM PRODUCT P

INNER JOIN (
SELECT PRODUCT_ID,
MAX(PRODUCT_QUANTITY) AS MAX_QUANTITY
FROM ORDER_ITEMS
WHERE PRODUCT_ID = 201) SUB;


--6. Write a query to display the customer_id,customer name, email and order details (order id, product desc,product qty, subtotal(product_quantity * product_price)) for all customers even if they have not ordered any item.(225 ROWS) [NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]
#Answer:
SELECT
C.CUSTOMER_ID,
(C.CUSTOMER_FNAME  || ' ' ||  C.CUSTOMER_LNAME) AS CUSTOMER_NAME,
C.CUSTOMER_EMAIL,
OH.ORDER_ID,
P.PRODUCT_DESC,
OI.PRODUCT_QUANTITY,
(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) AS SUBTOTAL

FROM ONLINE_CUSTOMER C
LEFT JOIN ORDER_HEADER OH
ON C.CUSTOMER_ID = OH.CUSTOMER_ID
LEFT JOIN ORDER_ITEMS OI
ON OH.ORDER_ID= OI.ORDER_ID
LEFT JOIN PRODUCT P
ON OI.PRODUCT_ID = P.PRODUCT_ID
ORDER BY OH.ORDER_ID;

--7.Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]
# Answer

SELECT 
	
    CARTON_ID,B.CARTON_VOL
FROM
    (SELECT 
        CARTON_ID, (LEN * WIDTH * HEIGHT) CARTON_VOL
    FROM
        CARTON) B
WHERE
    B.CARTON_VOL > (SELECT 
            SUM(A.opt_vol)
        FROM
            (SELECT 
                (LEN * WIDTH * HEIGHT * PRODUCT_QUANTITY) opt_vol
            FROM
                PRODUCT p, ORDER_ITEMS o
            WHERE
                p.PRODUCT_ID = o.PRODUCT_ID
                    AND o.ORDER_ID = 10006) A)
ORDER BY 2
LIMIT 1;

--8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products with credit card or Net banking as the mode of payment per shipped order. (6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]
# Answer:
SELECT 
        c.CUSTOMER_ID,
            CONCAT(c.CUSTOMER_FNAME, ' ', c.CUSTOMER_LNAME) AS CUSTOMER_FULLNAME,
            o.ORDER_ID,
            SUM(o.PRODUCT_QUANTITY) 
    FROM
        online_customer c, order_items o, order_header h
    WHERE
        o.ORDER_ID = h.ORDER_ID
            AND c.CUSTOMER_ID = h.CUSTOMER_ID
            AND h.ORDER_STATUS = 'Shipped'
    GROUP BY 1,2,3
    HAVING SUM(o.PRODUCT_QUANTITY) > 14
    ORDER BY 2;
    
--9 Write a query to display the order_id, customer id and cutomer full name of customers starting with the alphabet "A" along with (product_quantity) as total quantity of products shipped for order ids > 10030. (5 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]
    # Answer:
    SELECT 
        c.CUSTOMER_ID,
            CONCAT(c.CUSTOMER_FNAME, ' ', c.CUSTOMER_LNAME) AS CUSTOMER_FULLNAME,
            o.ORDER_ID,
            SUM(o.PRODUCT_QUANTITY) AS  Total_quantity
    FROM
        online_customer c, order_items o, order_header h
    WHERE
        o.ORDER_ID = h.ORDER_ID
            AND c.CUSTOMER_ID = h.CUSTOMER_ID
            AND o.ORDER_ID > 10060
            AND h.ORDER_STATUS = 'Shipped'
    GROUP BY 1,2,3;
    
    
 --10 Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]
    # Answer:
    
    SELECT 
SUB.PRODUCT_CLASS_DESC,
(SUB.TOTAL_QUANTITY * SUB.PRODUCT_PRICE) AS TOTAL_VALUE,
SUB.TOTAL_QUANTITY AS TOTAL_QUANTITY

FROM

(SELECT 
PC.PRODUCT_CLASS_DESC,
P.PRODUCT_PRICE,
SUM(OI.PRODUCT_QUANTITY) AS TOTAL_QUANTITY
FROM PRODUCT_CLASS PC
INNER JOIN PRODUCT P
ON PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
INNER JOIN ORDER_ITEMS OI
ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN ORDER_HEADER OH
ON OI.ORDER_ID = OH.ORDER_ID
INNER JOIN ONLINE_CUSTOMER C
ON OH.CUSTOMER_ID = C.CUSTOMER_ID
INNER JOIN ADDRESS A
ON C.ADDRESS_ID = A.ADDRESS_ID

WHERE A.COUNTRY NOT IN ('India','USA')
AND OH.ORDER_STATUS = 'Shipped'

GROUP BY 1,2) SUB


ORDER BY SUB.TOTAL_QUANTITY DESC
LIMIT 1;
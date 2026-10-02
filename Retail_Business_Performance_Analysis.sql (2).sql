create database Retail_Business;
use Retail_Business;
 
create table customers(
CustomerID int,
CustomerName varchar(50),
City varchar(30),
JoinDate date
);

create table products(
ProductID int,	
ProductName	varchar(50),
Category varchar(50),
Price int
);

create table orders(
OrderID	int,
CustomerID int,
OrderDate date,
EmployeeID int
);

create table orderdetails(
OrderDetailID	int,
OrderID	int,
ProductID int,
Quantity int
);

create table Employee(
EmployeeID int(30),
EmployeeName varchar(50),	
Department	varchar(50),
HireDate date
);

select * from customers;
select * from products;
select * from orders;
select * from orderdetails;
select * from Employee;

-- =====================================================
-- 1.	Display all orders with customer names.
-- =====================================================

select o.orderid,c.customername,o.customerid,o.orderdate,o.employeeid
from orders o
join customers c 
on o.customerid=c.customerid
;


-- =====================================================
-- 2.	Show product names and quantities for each order.
-- =====================================================

select o.orderid,p.productname, sum(od.quantity) TotalQuantites
from orderdetails od
join products p
on 
p.productid=od.productid
join orders o 
on
od.orderid=o.orderid
group by o.orderid,p.productname
order by o.orderid,p.productname;

-- =====================================================
-- 3.	Display employee name who handled each order.
-- =====================================================

select o.orderid,e.employeename
from orders o
join employee e
on
o.employeeid=e.employeeid
;

-- ===============================================================================
-- 4.	Show all customers and their orders (including customers without orders).
-- ===============================================================================

select c.customername,o.orderid
from customers c
left join orders o
on c.customerid=o.customerid
;

-- ===============================================================================
-- 5.	Display total number of orders handled by each employee.
-- ===============================================================================

select e.employeename,count(o.orderid) Totalorders
from orders o
join employee e
on  o.employeeid=e.employeeid
group by e.employeename ;
 
 -- ===============================================================================
--  Section 2 — Subqueries
-- 6.	Find customers who placed more than 1 order.
-- ===============================================================================

select customerid,customername from 
customers
where customerid in(
select customerid
from orders
group by customerid
having count(orderid)>1)
;

-- ===============================================================================
-- 7.	Display products with price higher than the average product price.
-- ===============================================================================

select  productid,productname from
products 
where price > (select avg(price) avgprice from products);

-- 8.	Find the customer who placed the highest number of orders.

select customerid,customername
from customers
where customerid=(select customerid from orders
group by customerid
order by count(orderid) desc
limit 1
);


-- ===============================================================================
-- 9.	Show orders where total quantity is greater than the average quantity.
-- ===============================================================================


select orderid,sum(quantity) as TotalQuantity
from orderdetails
group by orderid
having sum(quantity) >(select avg(quantity) from orderdetails);


-- ===============================================================================
-- 10.	Find employees who handled more orders than the average employee.
-- ===============================================================================

select employeeid,employeename ,Totalorders from 
(select e.employeeid,e.employeename,count(o.orderid) Totalorders,
avg(count(o.orderid)) over() Avgorders from employee e
join orders o
on e.employeeid=o.employeeid
group by e.employeeid,e.employeename ) as sub
where 
TotalOrders > Avgorders;


-- ===============================================================================
-- Section 3 — CTE (Common Table Expressions)

-- 11.	Using CTE, calculate total sales amount for each order.
-- ===============================================================================
with Totalsale as
(select od.orderid,sum(od.quantity*p.price) TotalSAles
from orderdetails od
join products p
on
od.productid=p.productid
group by od.orderid)
select orderid,TotalSales from Totalsale
order by  orderid ;


select od.orderid,sum(od.quantity*p.price) TotalSAles
from orderdetails od
join products p
on
od.productid=p.productid
group by od.orderid
order by od.orderid ;


-- ===============================================================================
-- 12.	Using CTE, find customers whose total purchase amount is greater than 20,000.
-- ===============================================================================



with customersales as
(select c.customerid,c.customername ,sum(od.quantity*p.price) Totalpurchaseamount
from customers c
join orders o 
on c.customerid=o.customerid
join orderdetails od
on o.orderid=od.orderid
join products p
on od.productid = p.productid
group by c.customerid,c.customername)
select customerid,customername,Totalpurchaseamount
from customersales
where Totalpurchaseamount > 20000
order by Totalpurchaseamount desc;

 -- ===============================================================================
--  13.	Using CTE, display the total revenue generated by each product category.
-- ===============================================================================

with totalamount as 
(select p.category,sum(od.quantity*p.price) TotalRevenue
from products p
join orderdetails od
on 
p.productid=od.productid
group by p.category
order by p.category)
select category,TotalRevenue
from totalamount;

-- ===============================================================================
-- 14.	Using CTE, find the top 3 customers based on total spending.
-- ===============================================================================
with totalamount as
(select c.customername,sum(od.quantity*p.price) TotalSpending
from products p
join orderdetails od
on
p.productid=od.productid
join orders o
on
od.orderid=o.orderid
join customers c
on o.customerid=c.customerid
group by  c.customername)
select customername,TotalSpending
from totalamount
order by TotalSpending DESC
limit 3;


-- ===============================================================================
-- Section 4 — Window Functions
-- 15.	Assign rank to customers based on total purchase amount.
-- ===============================================================================

with customersales as
(select c.customerid,c.customername ,sum(od.quantity*p.price) Totalpurchaseamount
from customers c
join orders o 
on c.customerid=o.customerid
join orderdetails od
on o.orderid=od.orderid
join products p
on od.productid = p.productid
group by c.customerid,c.customername)
select customerid,customername,Totalpurchaseamount,
rank() over( order by Totalpurchaseamount desc ) as RN
from customersales
 ;
 
 
-- ===============================================================================
-- 16.	Display cumulative sales amount by order date.
-- ===============================================================================

select o.orderdate,
sum(sum(od.quantity*p.price)) over(order by o.orderdate) cumilativesalesAmount
from orderdetails od
join orders o
on
od.orderid=o.orderid
join products p
on od.productid=p.productid
group by o.orderdate;


select o.orderdate,sum(od.quantity*p.price) Totalsales,
sum(sum(od.quantity*p.price)) over(order by o.orderdate) CumilativesalesAmount
from orderdetails od
join orders o
on
od.orderid=o.orderid
join products p
on od.productid=p.productid
group by o.orderdate;


-- ===============================================================================
-- 17.	Display running total of sales for each employee.
-- ===============================================================================
select e.employeeid,e.employeename,
sum(sum(od.quantity*p.price)) over(order by o.orderdate partition by e.employeeid) RunningTotal
from employee e
join orders o
on e.employeeid=o.employeeid
join orderdetails od
on o.orderid=od.orderid
join products p
on
od.productid=p.productid
group by e.employeeid,e.employeename 
;



select e.employeeid,e.employeename,sum(od.quantity*p.price) Totalsales,
sum(sum(od.quantity*p.price)) over(partition by e.employeeid) RunningTotal
from employee e
join orders o
on e.employeeid=o.employeeid
join orderdetails od
on o.orderid=od.orderid
join products p
on
od.productid=p.productid
group by e.employeeid,e.employeename ;


-- ===============================================================================
-- 18.	Find the highest priced product in each category.
-- ===============================================================================
select price,category  	from 
(select price,category,
row_number() over(partition by category order by price desc) as rn 
from products )t
where rn =1;


select price,category  	from 
(select price,category,
rank() over(partition by category order by price desc) as rn 
from products )t
where rn =1;



-- ===============================================================================
-- 21.	Find customers who never placed an order.
-- ===============================================================================
select c.customerid,o.orderid
from customers c
left join orders o
on c.customerid=o.customerid
where o.orderid is null ;


-- ===============================================================================
-- 22.	Find the second highest selling product.
-- ===============================================================================

select productid,productname ,totalsolds from (select p.productid,p.productname,
sum(od.quantity) totalsolds,
dense_rank() over(order by sum(od.quantity) desc ) as rn
from products p
join orderdetails od
on p.productid=od.productid
group by p.productid,p.productname )t
where rn=2;


-- ===============================================================================
-- 23.	Identify duplicate orders placed on the same day.
-- ===============================================================================

select orderid,orderdate from orders 
where orderdate in (select orderdate
from orders 
group by orderdate
having count(orderid)>1);



-- ===============================================================================
-- 24.	Find the top performing employee each month.
-- ===============================================================================
select employeeid,employeename as Top_performer ,Totalsales,monthly from 
(select e.employeeid,e.employeename,
date_format(o.orderdate,"%Y-%m") monthly,
sum(od.quantity*p.price) Totalsales,
dense_rank() over(partition by date_format(o.orderdate,"%Y-%m") order by sum(od.quantity*p.price) desc) rn
from employee e
join orders o
on e.employeeid=o.employeeid
join orderdetails od
on o.orderid=od.orderid
join products p
on
od.productid=p.productid
group by  e.employeeid,e.employeename,monthly
)t where rn=1;





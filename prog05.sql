-- Tyre McGee A04673107

CREATE TABLE customer (
   CustomerID INT(6) NOT NULL,
   LastName VARCHAR(45) NOT NULL,
   FirstName VARCHAR(45) NOT NULL,
   Address VARCHAR(200) NOT NULL,
   City  VARCHAR(45) NOT NULL,
   State VARCHAR(2) NOT NULL,
   ZIP INT(5) NOT NULL,
   Phone VARCHAR(12) NOT NULL,
  PRIMARY KEY (CustomerID));

CREATE TABLE salesperson (
   SalesPersonID INT(6) NOT NULL,
   SalesPersonLastName VARCHAR(45) NOT NULL,
   SalesPersonFirstName VARCHAR(45) NOT NULL,
   SalesPersonCode INT(6) NULL,
   PRIMARY KEY (SalesPersonID));

CREATE TABLE sales_order (
   SalesOrderNumber INT NOT NULL,
   CustomerID INT(6) NOT NULL,
   SalesPersonID INT(6) NULL, 
   Date DATE NULL,
   Subtotal DECIMAL(10,2) NULL,
   Tax DECIMAL(10,2) NULL,
   Total  DECIMAL(10,2) NULL,
  PRIMARY KEY (SalesOrderNumber)),
  ADD CONSTRAINT customerID_fk
  FOREIGN KEY (CustomerID)
  REFERENCES customer (CustomerID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  ADD CONSTRAINT SalesPersonID_fk
  FOREIGN KEY (SalesPersonID)
  REFERENCES salesperson (SalesPersonID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE item (
   ItemNumber  INT NOT NULL,
   UnitPrice  DECIMAL(10,2) NULL,
   Description  VARCHAR(100) NULL,
  PRIMARY KEY (ItemNumber));

CREATE TABLE order_line_item (
   SalesOrderNumber INT NOT NULL,
   LineNumber INT NOT NULL,
   ItemNumber INT(6) NULL,
   Quantity INT NOT NULL,
   UnitPrice DECIMAL(10,2) NULL,
   ExtendedPrice DECIMAL(10,2) NULL,
  PRIMARY KEY (SalesOrderNumber, LineNumber))
   ADD CONSTRAINT sales_order_number_fk
  FOREIGN KEY (SalesOrderNumber)
  REFERENCES sales_order (SalesOrderNumber)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  ADD CONSTRAINT ItemNumber_fk
  FOREIGN KEY (ItemNumber)
  REFERENCES item (ItemNumber)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

INSERT into customer (customerID, LastName, FirstName, Address, City, State, ZIP, Phone)
VALUES ( 689326, 'Smith', 'Will', '305 Enemy Of the State Ave.', 'Los Angeles', 'CA', 90210, '213-732-2732'),
(237023, 'Ferell', 'Will', '600 Channel 3 Dr.', 'Los Angeles', 'CA', 90210, '213-463-8365'),
(523742, 'Obama', 'Barock', "44 Y'all miss me Rd.", 'Chicago', 'IL', 60007, '773-482-9084'),
(964535, 'Wallace', 'Christopher', '1994 Call me big Poppa Dr.', 'New York', 'NY', 10455, '718-738-0384'),
(109393, 'Harden', 'James', '13 Free Throw Flopper Blvd.', 'Houston', 'TX', 77001, '281-732-3581')

INSERT into item (ItemNumber, UnitPrice, Description)
VALUES(723822, 500.00, 'Time Machine'),
(532033, 865.59, 'Teleportation Machine'),
(935627, 19.99, 'Memory Eraser'),
(126744, 65.99, 'Ray Gun'),
(846386, 6.99, 'Light Saber')

INSERT into salesperson (SalesPersonID, SalesPersonLastName, SalesPersonFirstName, SalesPersonCode)
VALUES (528394, 'Tyson', 'Mike', 237420),
(947291, 'Rock', 'Chris', 983274),
(364922, 'Gates', 'Bill', 632729),
(294682, 'Dogg', 'Snoop', 632822),
(943692, 'Duncan', 'Tim', 234692)

INSERT into order_line_item (SalesOrderNumber, LineNumber,ItemNumber, Quantity, UnitPrice, ExtendedPrice)
VALUES(293643, 4, 935627, 2, 19.99, 19.99),
(352723,8, 846386, 2 , 6.99, 6.99),
(529103,2, 723822,1 , 500.00, 500.00),
(742034, 2, 532033,1, 865.59, 865.59),
(938432, 7, NULL, 1, 283.99, 828.59)

INSERT into sales_order (SalesOrderNumber, CustomerID, SalesPersonID, Date, Subtotal, Tax, Total)
VALUES(352723, 689326, 364922, '2019-12-01', 100.00, 8.25, 108.25),
(938432, 689326, 947291, '2018-07-22', 250.00, 19.63, 269.63),
(529103, 109393, 943692, '2019-03-09', 20.00, 1.64, 21.64),
(293643, 523742, 294682, '2019-10-12', 5.00, 0.41, 5.41),
(742034, 237023, NULL, '2019-02-25', 50.00, 4.10, 54.10)


-- 1.Join the order_line_item table and the sales_order table on salespersonID
select s.SalesOrderNumber, o.LineNumber, o.ItemNumber, o.quantity, o.unitprice, o.extendedprice, 
s.customerID, s.salespersonid, s.date, s.subtotal, s.tax, s.total
from order_line_item o
left join sales_order s
on  o.SalesOrderNumber = s.SalesOrderNumber

-- 2.Show how much money Snoop Dogg made
select total
from sales_order
where salespersonID in (
	select salespersonid
    from salesperson
    where salespersonlastname = 'Dogg'
    )

-- 3. Show all the customers that live in CA
select *
from customer
where State = 'CA'

-- 4.Show the sales order table total with the name of seller
select sp.salespersonlastname, sp.salespersonfirstname, so.total
from salesperson sp
inner join sales_order so
on so.salespersonid = sp.salespersonid

-- 5.Show the sales order table total with the name of buyer
select c.lastname, c.firstname, so.total
from customer c
inner join sales_order so
on c.customerid = so.customerid

-- 6. Show all items that cost more than $100
select *
from item
where unitprice >= 100

-- .7 Show how much money was made in 2019
select sum(Total) as TotalSales
from sales_order
where date >= '2019-01-01'

-- 8.Find the customers who bought more than 1 item
select c.lastname, c.firstname
from customer c
join sales_order so
on c.customerID = so.CustomerID
where so.SalesOrderNumber in (
select salesordernumber
from order_line_item
where quantity > 1
)

-- 9. How many items Tim Duncan Sold
select quantity 
from order_line_item
where salesordernumber in (
	select salesordernumber
    from sales_order
    where salespersonId in(
		select salespersonId
        from salesperson
        where SalesPersonLastName = 'Duncan'
        )
     )

-- 10. Show all customers living in Houston
select LastName, Firstname
from customer
where city = 'Houston'
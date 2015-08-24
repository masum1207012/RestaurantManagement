drop table delevery_boy;
drop table orders;
drop table customers;
drop table area;
drop table food;
--------------------------------------------------------------------DDL---------------------------------------------------------------
create table food(
	food_id integer ,
	f_name varchar(10) not null,
	category varchar(10) not null,
	price number(4),
	amount number(4)	
);

create table area(
	area_id number(3),
	area_name varchar(10)	
);

create table delevery_boy(
	boy_id number(3),
	delevered_where number(3),
	boy_name varchar(10),
	delevery_date date
);

create table customers(
	customer_id number(10),
	customer_name varchar(10),
	house_no number(3),
	customer_area_id number(3),
	buyed number(6)
);

create table orders(
	order_food_id integer,
	order_customer_id number(10),
	quantity number(3),
	order_date date
);


-----------------------------------ALTER/PRIMARY KEY/ FOREIGN KEY/ON DELETE CASCADE/DATE---------------------------------------------
--select * from tab;
alter table orders modify order_date date default sysdate;

alter table food add constraint fpk primary key(food_id);

alter table area add constraint apk primary key(area_id);

alter table delevery_boy add constraint dpk primary key(boy_id);
alter table delevery_boy add constraint dfk foreign key (delevered_where) references area(area_id) on delete cascade;

alter table customers add constraint cpk primary key(customer_id);
alter table customers add constraint cfk foreign key(customer_area_id) references area(area_id) on delete cascade;

alter table orders add constraint ofk1	foreign key(order_customer_id) references customers(customer_id) on delete cascade;
alter table orders add constraint ofk2	foreign key(order_food_id) references food(food_id) on delete cascade;
alter table orders add constraint opk primary key(order_customer_id,order_food_id);

---------------------------------------------------------RENAME COLUMN/ DROP COLUMN---------------------------------------------------

alter table area rename column area_name to name_of_area;
alter table delevery_boy drop column delevery_date;
---------------------------------------------------------DESCRIBE---------------------------------------------------------------------
describe food;
describe area;
describe delevery_boy;
describe customers;
describe orders;


--------------------------------------------------------------SEQUENCE---------------------------------------------------------------
drop sequence food_id_ai;
drop sequence area_id_ai;
drop sequence boy_id_ai;
drop sequence customer_id_ai;

CREATE SEQUENCE food_id_ai
  START WITH 1
  INCREMENT BY 1
  CACHE 100;

CREATE SEQUENCE area_id_ai
  START WITH 1
  INCREMENT BY 1
  CACHE 100;

CREATE SEQUENCE boy_id_ai
  START WITH 1
  INCREMENT BY 1
  CACHE 100;

CREATE SEQUENCE customer_id_ai
  START WITH 1
  INCREMENT BY 1
  CACHE 100;
-----------------------------------------------------------TRIGGER-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER insert_into_food
  BEFORE INSERT ON food
  FOR EACH ROW
BEGIN
  :new.food_id:= food_id_ai.nextval;
END;
/


CREATE OR REPLACE TRIGGER insert_into_boy
  BEFORE INSERT ON delevery_boy
  FOR EACH ROW
BEGIN
  :new.boy_id:= boy_id_ai.nextval;
END;
/

---------------------------------------------------------INSERT/PL SQL---------------------------------------------------------------

SET SERVEROUTPUT ON;
BEGIN
insert into food (f_name, category, price, amount) values('Beef', 'Biriani' , 8, 50);
insert into food (f_name, category, price, amount) values('Mutton', 'Chop' , 8, 50);
insert into food (f_name, category, price, amount) values('Tehari', 'Biriani' , 8, 50);
insert into food (f_name, category, price, amount) values('Moglai', 'Porata' , 8, 50);
insert into food (f_name, category, price, amount) values('Hidrabadi', 'Biriani' , 8, 50);


insert into area  values(area_id_ai.nextval,'doulatpur');
insert into area  values(area_id_ai.nextval,'fulbari');
insert into area  values(area_id_ai.nextval,'fultola');
insert into area  values(area_id_ai.nextval,'religate');
insert into area  values(area_id_ai.nextval,'khalishpur');


insert into delevery_boy (delevered_where, boy_name) values (1,'ashik');
insert into delevery_boy (delevered_where, boy_name) values (2,'masum');
insert into delevery_boy (delevered_where, boy_name) values (3,'aziz');
insert into delevery_boy (delevered_where, boy_name) values (4,'munta');
insert into delevery_boy (delevered_where, boy_name) values (5,'golap');

insert into customers values( customer_id_ai.nextval, 'kakon',1,1,500);
insert into customers values( customer_id_ai.nextval,'tanim',1,2,500);
insert into customers values( customer_id_ai.nextval,'golla',1,3,500);
insert into customers values( customer_id_ai.nextval,'ash',1,4,500);
insert into customers values( customer_id_ai.nextval,'sarker',1,5,500);

insert into orders (order_food_id, order_customer_id, quantity) values ( 1,1,5);
insert into orders (order_food_id, order_customer_id, quantity) values ( 1,2,5);
insert into orders (order_food_id, order_customer_id, quantity) values ( 1,3,5);
insert into orders (order_food_id, order_customer_id, quantity) values ( 1,4,5);
insert into orders (order_food_id, order_customer_id, quantity) values ( 1,5,5);


END;
/
commit;
-------------------------------SELECT/FROM/WHERE/IN/NOT IN/BETWEEN/NOT BETWEEN/ORDER BY/ GROUP BY/ HAVING/COUNT/AVG/MAX------------
select distinct customer_name from customers;

select customer_name from customers where customer_id not in(1,4);

select customer_name from customers where customer_id in(1,4);

select customer_name from customers where customer_id between 1 and 4;

select customer_name from customers where customer_id >= 1 and customer_id<=4;

select customer_name from customers where customer_id >= 1 or customer_id<=4;

select customer_id, customer_name from customers where customer_name like '%tan%';

select count(customer_name),customer_area_id  from customers where customer_area_id not in (1) group by customer_area_id having customer_area_id>=1;  

select customer_name,customer_area_id  from customers where customer_area_id not in (1) order by customer_area_id;

select avg(quantity) from orders where order_food_id=1;
--------------------------------------------------------SUB QUERY---------------------------------------------------------------------

select * from orders where quantity in(select max(quantity) from orders);

----------------------------------------------------------------DELETE----------------------------------------------------------------

delete from orders where order_customer_id=5;

delete from area where area_id=3;
	
delete from customers where customer_id=5;

-----------------------------------------------------------UPDATE---------------------------------------------------------------------

update area set name_of_area='fulbari Gt' where area_id=2;




select * from food;
select * from area;
select * from delevery_boy;
select * from customers;
select * from orders;


---------------------------------------FUNCTION(for knowing the average quantity)---------------------------------------------------------

CREATE OR REPLACE FUNCTION avg_quantity RETURN NUMBER IS
   avg_qty orders.quantity%type;
BEGIN
  SELECT AVG(quantity) INTO avg_qty
  FROM orders;
   RETURN avg_qty;
END;
/

-----------------------------------------FUNCTION(for knowing the area name of a specific id)--------------------------------------------

CREATE OR REPLACE FUNCTION area_name(id area.area_id%type) RETURN varchar IS
   name area.name_of_area%type;
BEGIN
  SELECT name_of_area INTO name
  FROM area where area_id=id;
   RETURN name;
END;
/

-------------------------CURSOR/SUB PL SQL(for giving the order of a product which is not in order)----------------------------------------------
   -- f_id:=&food_id1;
   -- c_id:=&customer_id;
   -- qty:=&quantity;

SET SERVEROUTPUT ON;
declare
	f_id orders.order_food_id%type;
	c_id orders.order_customer_id%type;
	qty orders.quantity%type;
	count1 int :=1;
	var NUMBER;
BEGIN
	f_id:=3;
	c_id:=2;
	qty:=1;

    --inner block
    DECLARE
    	CURSOR order_cur IS
        select order_food_id from orders where order_customer_id=c_id and order_food_id=f_id;
    	order_t  order_cur%ROWTYPE;
	BEGIN
    	OPEN  order_cur;
    	FETCH order_cur INTO order_t;
    	if order_t.order_food_id=f_id then
    	count1:=0;
    	end if;
    	CLOSE order_cur;
    end;
    --inner block ends
    --dbms_output.put_line();
    if count1 = 1 then
    insert into orders (order_food_id, order_customer_id, quantity) values (f_id, c_id, qty);

    else 
    	dbms_output.put_line('WARNING: You have an order of the same product');
    end if;
      dbms_output.put_line('AVG quantity is: '|| avg_quantity);

      dbms_output.put_line('Area name of area id 1 is : ' || area_name(1));

END;
/

-----------------------------------------------Procedure(for creating a new area)----------------------------------------------------------

CREATE OR REPLACE PROCEDURE insert_area (
  a_name area.name_of_area%type) IS
BEGIN
  INSERT INTO area
  VALUES (area_id_ai.nextval, a_name);
END insert_area;
/



SET SERVEROUTPUT ON;
DECLARE
	a_name1 area.name_of_area%type;
BEGIN
	
	insert_area('kuet');
END;
/

--a_name1:='&name_of_area_can_be_supplied';
--------------------------------------------LOOP/CURSOR(for knowing the customer's name)-----------------------------------------------------

SET SERVEROUTPUT ON;
DECLARE
    	CURSOR customer_cur IS
        select customer_name, customer_area_id from customers;
    	customer_t  customer_cur%ROWTYPE;
    	counter NUMBER;
    	count1 number;
	BEGIN
	counter:=0;
		select count(customer_id) into count1 from customers;
    	OPEN  customer_cur;
    	 LOOP
    	 	FETCH customer_cur INTO customer_t;
         	counter := counter + 1;
         	EXIT WHEN counter > count1; 
         	DBMS_OUTPUT.PUT_LINE ('Customer name: ' || customer_t.customer_name ||' ; Customer area_id: ' || customer_t.customer_area_id );
    	END LOOP;
    	CLOSE customer_cur;
end;
/

---------------------------------------------------------Minus/Union/Intersection--------------------------------------------------


select customer_name from customers
minus
select customer_name from customers where customer_area_id=1;


select customer_name from customers where customer_area_id=1
union
select customer_name from customers where customer_area_id=2;


select customer_id from customers
intersect
select order_customer_id from orders;


--------------------------------------------------------------Join/Outer join--------------------------------------------------------------------
select customer_id,customer_name from customers join orders on customers.customer_id=orders.order_customer_id;

select c.customer_id,c.customer_name,a.name_of_area from customers c inner join area a on c.customer_area_id=a.area_id;

select c.customer_id,c.customer_name,a.name_of_area from customers c left outer join area a on c.customer_area_id=a.area_id;

select c.customer_id,c.customer_name,a.name_of_area from customers c right outer join area a on c.customer_area_id=a.area_id;

select c.customer_id,c.customer_name,a.customer_name from customers c join customers a on c.customer_area_id=a.customer_area_id;
---------------------------------------------------------------as---------------------------------------------------------------------
select order_customer_id , order_food_id , (quantity * price) as bill from orders join food on(order_food_id=food_id);
-------------------------------------------------------------Natural Join-------------------------------------------------------------
alter table customers rename column customer_area_id to area_id;

select customer_name, name_of_area from customers natural join area;

alter table customers rename column area_id to customer_area_id;
--------------------------------------------------------------Add Month---------------------------------------------------------------
SELECT ADD_MONTHS (order_date,6) AS Six_months_Extension
FROM orders
WHERE order_customer_id=2;
----------------------------------------------SAVEPOINT/ROLLBACK----------------------------------------------------------------------
savepoint Save;
insert into food (f_name, category, price, amount) values('kacchi', 'Biriani' , 8, 50);
savepoint Save1;
rollback to Save;
SELECT * FROM food;
------------------------------------------------------------OS TIME------------------------------------------------------------------
SELECT systimestamp from dual;









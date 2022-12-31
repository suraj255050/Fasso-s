/* AUTHOR - SURAJ CHOWKI
TOOL USED - MYSQL Workbench 8.0 CE

select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from driver;
select * from rolls;
select * from rolls_recipes;

Q.1 How many rolls were ordered?
/* --------- SOLUTION --------- */
select count(roll_id) from customer_orders;

Q.2 how many unique customer order were made?
/* --------- SOLUTION --------- */
select count(distinct customer_id) from customer_orders;

Q.3 how many successful order were delivered by each driver?
/* --------- SOLUTION --------- */
select driver_id ,count(distinct order_id) from driver_order
 where cancellation not in ('cancellation','cuatomer cancellation')
 group by driver_id;
 
 Q.4 how many of each type of roll was delivered?
 /* --------- SOLUTION --------- */
select roll_id,count(roll_id) 
from customer_orders 
where order_id in (
select order_id from
(select *,case when	cancellation in  ('cancellation','cuatomer cancellation') then 'c' else 'nc' end as order_cancel_details from driver_order)a 
where order_cancel_details='nc') 
group by roll_id;

Q.5 how many veg and non veg rolls were ordered by each customer?
/* --------- SOLUTION --------- */
select a.*,b.roll_name from
(
select customer_id,roll_id, count(roll_id)from customer_orders 
group by customer_id,roll_id)a inner join rolls b on a.roll_id = b.roll_id;


Q.6 what was the maximum number of rolls delivered in single order?
 /* --------- SOLUTION --------- */
select * from
(
select *,rank() over(order by cnt desc) rnk from
(
select order_id,count(roll_id) cnt
from(
select * from customer_orders
where order_id in(select order_id from
(select *,case when cancellation in  ('cancellation','cuatomer cancellation') then 'c' else 'nc' end as order_cancel_details from driver_order)a 
where order_cancel_details='nc'))b
group by order_id
)C)d where rnk=1;


Q.7 what is the number of order for each day of the week?
/* --------- SOLUTION --------- */
select dow,count(distinct order_id) from
(select *,dayname(order_date) dow from customer_orders)a
group by dow;

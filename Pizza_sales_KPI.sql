create schema Pizza_DB;
use Pizza_DB;

SELECT * FROM pizza_db.pizza_sales;

-- TOTAL REVENUE
select 
	round(sum(total_price),2) as Total_Revenue
from pizza_sales;


-- AVERAGE ORDER VLAUE
select 
	round(sum(total_price)/count(distinct order_id),2) as avg_order_value
from pizza_sales;


-- TOTAL PIZZA SOLD
select 
	sum(quantity) as Total_pizza_sold
from pizza_sales;


-- TOTAL ORDERS PLACED
-- SOLUTION 1
select 
	count(distinct order_id)
from pizza_sales;

-- SOLUTION 2
select x.Total_order_placed
from(
	select 
		sum(quantity) ,
		row_number() over() as Total_order_placed
	from pizza_sales
	group by order_id) x
order by x.Total_order_placed desc
limit 1;


-- AVERAGE PIZZA PER ORDER
select 
	sum(quantity)/count(distinct order_id) as Avg_pizza_per_order
from pizza_sales;

-- TOTAL ORDER ON DAILY BASES
select
	order_date,count(distinct order_id) as daily_orders,sum(quantity) as pizza_quantity 
from pizza_sales
group by order_date;

-- total order placed on days
select 
	dayname(order_date) as day,count(distinct order_id) as Total_orders_weekly
from pizza_sales
group by dayname(order_date)
order by Total_orders desc;

-- TOTAL ORDER ON peak hours
select date_format(order_time,'%l') as hour,count(distinct order_id) as Total_orders_hourly
from pizza_sales
group by date_format(order_time,'%l')
order by Total_orders desc;


-- TOTAL ORDER ON MONTHLY BASES
select 
	month(order_date) as Month,
    date_format(order_date,'%M') as Month_name,
    count(distinct order_id) as Total_order_monthly
from pizza_sales
group by Month(order_date),date_format(order_date,'%M')
order by Total_order_monthly desc;


-- PIZZA SALES BY CATEGORY
select 
	pizza_category,round(sum(total_price),2) as Total_sales,
    round(sum(total_price)*100/(select sum(total_price)
						  from pizza_sales),2) as Total_sales_pct
from pizza_sales
group by pizza_category;


select 
	pizza_category,round(sum(total_price),2) as Total_sales,
    round(sum(total_price)*100/(select sum(total_price)
						  from pizza_sales
                          where month(order_date)=1  ),2) as Total_sales_pct
from pizza_sales
where month(order_date)=1  -- for january month use 1 similarly for other month can be find sales category wise
group by pizza_category;

/*
quarter(date)-to get data quarterly
January-March returns 1
April-June returns 2
July-Sep returns 3
Oct-Dec returns 4
*/
select 
	pizza_category,round(sum(total_price),2) as Total_sales,
    round(sum(total_price)*100/(select sum(total_price)
						  from pizza_sales
                          where quarter(order_date)=2 ),2) as Total_sales_pct
from pizza_sales
where quarter(order_date)=2       
group by pizza_category;


-- pct of sales by pizza size
select 
	pizza_size,
    round(sum(total_price),2) as Total_sales,
    round(sum(total_price)*100/(select
								sum(total_price) 
					        from pizza_sales),2) as Total_sales_pct_pizza_size
from pizza_sales
group by pizza_size
order by Total_sales_pct_pizza_size desc;


-- pizza sold by pizza category
select 
	pizza_category,sum(quantity) as No_of_pizza
from pizza_sales
group by pizza_category;


-- TOP 5 PIZZA BY REVENUE, quantity ,ORDERS
select pizza_name,
	round(sum(total_price),2) as Total_revenue
from pizza_sales
group by pizza_name
order by Total_revenue desc
limit 5;

select pizza_name,
    sum(quantity) as Total_quantity
from pizza_sales
group by pizza_name
order by Total_quantity desc
limit 5;

select pizza_name,
    count(distinct order_id) as Total_orders
from pizza_sales
group by pizza_name
order by Total_orders desc
limit 5;


-- BOTTOM 5 BY REVENUE QUANTITY ORDERS
select pizza_name,
	round(sum(total_price),2) as Total_revenue
from pizza_sales
group by pizza_name
order by Total_revenue 
limit 5;

select pizza_name,
    sum(quantity) as Total_quantity
from pizza_sales
group by pizza_name
order by Total_quantity
limit 5;

select pizza_name,
    count(distinct order_id) as Total_orders
from pizza_sales
group by pizza_name
order by Total_orders 
limit 5;
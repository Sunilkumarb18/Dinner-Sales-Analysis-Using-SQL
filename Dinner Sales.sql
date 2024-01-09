--menu,members,sales

select * from menu
select * from members
select * from sales

select customer_id,
       sum(m.price) [Total Amount Spent]
from sales s
left join menu m on s.product_id=m.product_id
group by customer_id

select customer_id,
       COUNT(distinct order_date) [Total No of Visits]
from sales 
group by customer_id

select distinct b.customer_id,a.product_id from (
select distinct customer_id,s.product_id
from menu m 
inner join sales s on s.product_id=m.product_id
) a inner join sales b on a.customer_id=b.customer_id
order by b.customer_id

select a.customer_id,m.product_name from (
select customer_id,
       order_date,
	   product_id,
	   row_number() over(partition by customer_id order by order_date) rnk
from sales) a
left join menu m on m.product_id=a.product_id
where a.rnk=1

select top 1 m.product_name,
             COUNT(*)[No of times Purchased] 
from sales s
left join menu m on s.product_id=m.product_id
group by m.product_name
order by COUNT(*) desc

select customer_id,product_name,[No of times purchased] from (select customer_id,
       m.product_name,
	   COUNT(s.product_id)[No of times purchased] ,
	   ROW_NUMBER() over (partition by customer_id order by COUNT(s.product_id) desc) rnk
from sales s 
left join menu m on m.product_id=s.product_id
group by customer_id,m.product_name) a
where rnk=1


select customer_id,product_name from (
                                      select s.*,
                                             ROW_NUMBER()over (partition by s.customer_id order by s.product_id) rnk
                                      from sales s 
                                      left join members m on m.customer_id=s.customer_id
                                      where s.order_date>=m.join_date) a
left join menu mm on mm.product_id=a.product_id
where rnk=1


select customer_id,product_name from (
                                      select s.*,
                                             ROW_NUMBER()over (partition by s.customer_id order by s.product_id) rnk
                                      from sales s 
                                      left join members m on m.customer_id=s.customer_id
                                      where s.order_date<m.join_date) a
left join menu mm on mm.product_id=a.product_id
where rnk=1

select s.customer_id,
       count(s.product_id)[Total Items],
	   SUM(price)[Total Price] 
from sales s
left join members m on m.customer_id=s.customer_id
left join menu mm on mm.product_id=s.product_id
where s.order_date<m.join_date
group by s.customer_id


select * from menu
alter table menu add point int null

update m
set m.point=case when product_name='sushi' then 20 
                 else 10 
            end
from menu m

select a.customer_id,
       SUM(point*[count of product id])[Total Points] 
	   from (
              select s.customer_id,
			         s.product_id,
					 count(s.product_id) as [count of product id]
	          from sales s
              left join menu m on m.product_id=s.product_id
              group by s.customer_id,s.product_id) a 
	left join menu m on m.product_id=a.product_id
    group by a.customer_id


select * from members

select s.customer_id,
       COUNT(product_id)*20 [Total Points] 
from sales s
left join members m on m.customer_id=s.customer_id
where s.order_date>=m.join_date and FORMAT(s.order_date,'MM')=1
group by s.customer_id


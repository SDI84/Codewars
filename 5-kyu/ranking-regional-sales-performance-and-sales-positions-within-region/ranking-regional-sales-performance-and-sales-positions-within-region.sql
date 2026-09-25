with s as (
      select region_id,sale_date,sales_amount, 
      dense_rank() over (partition by region_id order by sales_amount desc, sale_date desc) as sales_rank_within_region
      from daily_sales
    ),
    m as (
      select region_id, sale_date,
      dense_rank() over (order by sale_date,region_id desc) as earliest_top_sale_rank
      from s
      where sales_rank_within_region = 1
    )
select s.*,m.earliest_top_sale_rank
from s
inner join m on s.region_id = m.region_id
order by m.earliest_top_sale_rank, s.sales_rank_within_region
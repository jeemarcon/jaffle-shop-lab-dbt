select
    (select sum(amount) from {{ ref('fct_orders') }})            as fct_total,
    (select sum(lifetime_value) from {{ ref('dim_customers') }}) as dim_total
where abs(fct_total - dim_total) > 0.01
{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

with orders as (

    select * from {{ ref('stg_jaffle_shop__orders') }}

    {% if is_incremental() %}
    where order_date >= (
        select dateadd(day, -3, max(order_date)) from {{ this }}
    )
    {% endif %}

),

payments as (

    select * from {{ ref('stg_stripe__payment') }}

),

order_payments as (
    select
        order_id,
        sum (case when payment_status = 'success' then payment_amount end) as amount

    from payments
    group by 1
),

final as(

    select 
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce (order_payments.amount, 0) as amount
    from orders
    left join order_payments using (order_id)

)

select * from final
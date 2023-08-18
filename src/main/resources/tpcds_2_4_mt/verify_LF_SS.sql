-- ========================================================
--    Verify the row can be selected from store_sales:
-- ========================================================

select
    ss_sold_date_sk,
    ss_sold_time_sk,
    ss_item_sk,
    ss_customer_sk,
    ss_cdemo_sk,
    ss_hdemo_sk,
    ss_addr_sk,
    ss_store_sk,
    ss_promo_sk,
    ss_ticket_number,
    ss_quantity,
    ss_wholesale_cost,
    ss_list_price,
    ss_sales_price,
    ss_ext_discount_amt,
    ss_ext_sales_price,
    ss_ext_wholesale_cost,
    ss_ext_list_price,
    ss_ext_tax,
    ss_coupon_amt,
    ss_net_paid,
    ss_net_paid_inc_tax,
    ss_net_profit
from store_sales
where
ss_sold_date_sk _VAR0_ and
ss_sold_time_sk _VAR1_ and
ss_item_sk _VAR2_ and
ss_customer_sk _VAR3_ and
ss_cdemo_sk _VAR4_ and
ss_hdemo_sk _VAR5_ and
ss_addr_sk _VAR6_ and
ss_store_sk _VAR7_ and
ss_promo_sk _VAR8_;

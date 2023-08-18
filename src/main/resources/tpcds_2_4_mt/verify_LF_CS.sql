-- ========================================================
--    Verify the row can be selected from catalog_sales:
-- ========================================================

select
    cs_sold_date_sk,
    cs_sold_time_sk,
    cs_ship_date_sk,
    cs_bill_customer_sk,
    cs_bill_cdemo_sk,
    cs_bill_hdemo_sk,
    cs_bill_addr_sk,
    cs_ship_customer_sk,
    cs_ship_cdemo_sk,
    cs_ship_hdemo_sk,
    cs_ship_addr_sk,
    cs_call_center_sk,
    cs_catalog_page_sk,
    cs_ship_mode_sk,
    cs_warehouse_sk,
    cs_item_sk,
    cs_promo_sk,
    cs_order_number,
    cs_quantity,
    cs_wholesale_cost,
    cs_list_price,
    cs_sales_price,
    cs_ext_discount_amt,
    cs_ext_sales_price,
    cs_ext_wholesale_cost,
    cs_ext_list_price,
    cs_ext_tax,
    cs_coupon_amt,
    cs_ext_ship_cost,
    cs_net_paid,
    cs_net_paid_inc_tax,
    cs_net_paid_inc_ship,
    cs_net_paid_inc_ship_tax,
    cs_net_profit
from catalog_sales
where 
cs_sold_date_sk _VAR0_ and
cs_sold_time_sk _VAR1_ and
cs_ship_date_sk _VAR2_ and
cs_bill_customer_sk _VAR3_ and
cs_bill_cdemo_sk _VAR4_ and
cs_bill_hdemo_sk _VAR5_ and
cs_bill_addr_sk _VAR6_ and
cs_ship_customer_sk _VAR7_ and
cs_ship_cdemo_sk _VAR8_ and
cs_ship_hdemo_sk _VAR9_ and
cs_ship_addr_sk _VAR10_ and
cs_call_center_sk _VAR11_ and
cs_catalog_page_sk _VAR12_ and
cs_ship_mode_sk _VAR13_ and
cs_warehouse_sk _VAR14_ and
cs_item_sk _VAR15_ and
cs_promo_sk _VAR16_;

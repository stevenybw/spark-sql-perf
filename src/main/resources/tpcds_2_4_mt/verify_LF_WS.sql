-- ========================================================
--    Verify the row can be selected from web_sales:
-- ========================================================

select
    ws_sold_date_sk,
    ws_sold_time_sk,
    ws_ship_date_sk,
    ws_item_sk,
    ws_bill_customer_sk,
    ws_bill_cdemo_sk,
    ws_bill_hdemo_sk,
    ws_bill_addr_sk,
    ws_ship_customer_sk,
    ws_ship_cdemo_sk,
    ws_ship_hdemo_sk,
    ws_ship_addr_sk,
    ws_web_page_sk,
    ws_web_site_sk,
    ws_ship_mode_sk,
    ws_warehouse_sk,
    ws_promo_sk,
    ws_order_number,
    ws_quantity,
    ws_wholesale_cost,
    ws_list_price,
    ws_sales_price,
    ws_ext_discount_amt,
    ws_ext_sales_price,
    ws_ext_wholesale_cost,
    ws_ext_list_price,
    ws_ext_tax,
    ws_coupon_amt,
    ws_ext_ship_cost,
    ws_net_paid,
    ws_net_paid_inc_tax,
    ws_net_paid_inc_ship,
    ws_net_paid_inc_ship_tax,
    ws_net_profit
from web_sales
where
ws_sold_date_sk _VAR0_ and
ws_sold_time_sk _VAR1_ and
ws_ship_date_sk _VAR2_ and
ws_item_sk _VAR3_ and
ws_bill_customer_sk _VAR4_ and
ws_bill_cdemo_sk _VAR5_ and
ws_bill_hdemo_sk _VAR6_ and
ws_bill_addr_sk _VAR7_ and
ws_ship_customer_sk _VAR8_ and
ws_ship_cdemo_sk _VAR9_ and
ws_ship_hdemo_sk _VAR10_ and
ws_ship_addr_sk _VAR11_ and
ws_web_page_sk _VAR12_ and
ws_web_site_sk _VAR13_ and
ws_ship_mode_sk _VAR14_ and
ws_warehouse_sk _VAR15_ and
ws_promo_sk _VAR16_;

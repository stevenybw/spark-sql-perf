-- ========================================================
--    Verify the row can be selected from catalog_returns:
-- ========================================================

select
    cr_returned_date_sk,  
    cr_returned_time_sk,
    cr_item_sk,
    cr_refunded_customer_sk  
    cr_refunded_cdemo_sk,
    cr_refunded_hdemo_sk,
    cr_refunded_addr_sk,
    cr_returning_customer_sk,
    cr_returning_cdemo_sk,
    cr_returning_hdemo_sk,
    cr_returning_addr_sk,
    cr_call_center_sk,
    cr_catalog_page_sk,
    cr_ship_mode_sk,
    cr_warehouse_sk,
    cr_reason_sk,
    cr_order_number,
    cr_return_quantity,
    cr_return_amount,
    cr_return_tax,
    cr_return_amt_inc_tax
    cr_fee,
    cr_return_ship_cost  
    cr_refunded_cash,
    cr_reversed_charge   
    cr_store_credit,
    cr_net_loss
from catalog_returns
where
cr_returned_date_sk _VAR0_ and
cr_returned_time_sk _VAR1_ and
cr_item_sk _VAR2_ and
cr_refunded_customer_sk _VAR3_ and
cr_refunded_cdemo_sk _VAR4_ and
cr_refunded_hdemo_sk _VAR5_ and
cr_refunded_addr_sk _VAR6_ and
cr_returning_customer_sk _VAR7_ and
cr_returning_cdemo_sk _VAR8_ and
cr_returning_hdemo_sk _VAR9_ and
cr_returning_addr_sk _VAR10_ and
cr_call_center_sk _VAR11_ and
cr_catalog_page_sk _VAR12_ and
cr_ship_mode_sk _VAR13_ and
cr_warehouse_sk _VAR14_ and
cr_reason_sk _VAR15_;

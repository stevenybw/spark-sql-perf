-- ==============================================
--    Fetch two rows randomly from crv: 
-- ==============================================

select
    cr_return_date_sk,
    cr_return_time_sk,
    cr_item_sk,
    cr_refunded_customer_sk,
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
    cr_return_amt_inc_tax,
    cr_fee,
    cr_return_ship_cost,
    cr_refunded_cash,
    cr_reversed_charge,
    cr_merchant_credit,
    cr_net_loss
from crv
where cr_return_time_sk >= (select floor( max(cr_return_time_sk) * rand()) from crv ) 
order by cr_return_time_sk limit 2;

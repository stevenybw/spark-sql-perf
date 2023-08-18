-- ========================================================
--    Verify the row can be selected from store_returns:
-- ========================================================

select
    sr_returned_date_sk,
    sr_return_time_sk,
    sr_item_sk,
    sr_customer_sk,
    sr_cdemo_sk,
    sr_hdemo_sk,
    sr_addr_sk,
    sr_store_sk,
    sr_reason_sk,
    sr_ticket_number,
    sr_return_quantity,
    sr_return_amt,
    sr_return_tax,
    sr_return_amt_inc_tax,
    sr_fee,
    sr_return_ship_cost,
    sr_refunded_cash,
    sr_reversed_charge,
    sr_store_credit,
    sr_net_loss
from store_returns
where
sr_returned_date_sk _VAR0_ and
sr_return_time_sk _VAR1_ and
sr_item_sk _VAR2_ and
sr_customer_sk _VAR3_ and
sr_cdemo_sk _VAR4_ and
sr_hdemo_sk _VAR5_ and
sr_addr_sk _VAR6_ and
sr_store_sk _VAR7_ and
sr_reason_sk _VAR8_;

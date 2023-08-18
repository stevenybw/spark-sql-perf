-- ========================================================
--    Verify the row can be selected from web_returns:
-- ========================================================

select
    wr_returned_date_sk,
    wr_returned_time_sk,
    wr_item_sk,
    wr_refunded_customer_sk,
    wr_refunded_cdemo_sk,
    wr_refunded_hdemo_sk,
    wr_refunded_addr_sk,
    wr_returning_customer_sk,
    wr_returning_cdemo_sk,
    wr_returning_hdemo_sk,
    wr_returning_addr_sk,
    wr_web_page_sk,
    wr_reason_sk,
    wr_order_number,
    wr_return_quantity,
    wr_return_amt,
    wr_return_tax,
    wr_return_amt_inc_tax,
    wr_fee,
    wr_return_ship_cost,
    wr_refunded_cash,
    wr_reversed_charge,
    wr_account_credit,
    wr_net_loss
from web_returns
where 
wr_returned_date_sk _VAR0_ and
wr_returned_time_sk _VAR1_ and
wr_item_sk _VAR2_ and
wr_refunded_customer_sk _VAR3_ and
wr_refunded_cdemo_sk _VAR4_ and
wr_refunded_hdemo_sk _VAR5_ and
wr_refunded_addr_sk _VAR6_ and
wr_returning_customer_sk _VAR7_ and
wr_returning_cdemo_sk _VAR8_ and
wr_returning_hdemo_sk _VAR9_ and
wr_returning_addr_sk _VAR10_ and
wr_web_page_sk _VAR11_ and
wr_reason_sk _VAR12_;

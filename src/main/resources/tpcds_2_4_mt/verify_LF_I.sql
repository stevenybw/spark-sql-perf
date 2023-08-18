-- ========================================================
--    Verify the row can be selected from inventory:
-- ========================================================

select
    inv_date_sk,
    inv_item_sk,
    inv_warehouse_sk,
    inv_quantity_on_hand
from inventory
where
inv_date_sk _VAR0_ and
inv_item_sk _VAR1_ and
inv_warehouse_sk _VAR2_;

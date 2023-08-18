-- ==============================================
--    Fetch two rows randomly from iv: 
-- ==============================================

select
    inv_date_sk,
    inv_item_sk,
    inv_warehouse_sk,
    inv_quantity_on_hand
from iv
where inv_item_sk >= (select floor( max(inv_item_sk) * rand()) from iv ) 
order by inv_item_sk limit 2;

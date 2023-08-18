-- ====================
--    Verify  DF_I
-- ====================

select * from inventory where inv_date_sk >= ( select min(d_date_sk) from date_dim  where  d_date between 'INV_S_1' and 'INV_E_1') and 
                inv_date_sk <= ( select max(d_date_sk) from date_dim  where  d_date between 'INV_S_1' and 'INV_E_1');

select * from inventory where inv_date_sk >= ( select min(d_date_sk) from date_dim  where  d_date between 'INV_S_2' and 'INV_E_2') and 
                inv_date_sk <= ( select max(d_date_sk) from date_dim  where  d_date between 'INV_S_2' and 'INV_E_2');

select * from inventory where inv_date_sk >= ( select min(d_date_sk) from date_dim  where  d_date between 'INV_S_3' and 'INV_E_3') and 
                inv_date_sk <= ( select max(d_date_sk) from date_dim  where  d_date between 'INV_S_3' and 'INV_E_3');

-- ====================
--    Verify  DF_WS
-- ====================

select * from web_returns where wr_order_number in (select ws_order_number from web_sales, date_dim where ws_sold_date_sk=d_date_sk and d_date between 'CSW_S_1' and 'CSW_E_1');
delete from web_sales where ws_sold_date_sk >= (select min(d_date_sk) from date_dim where d_date between 'CSW_S_1' and 'CSW_E_1') and
                 ws_sold_date_sk <= (select max(d_date_sk) from date_dim where d_date between 'CSW_S_1' and 'CSW_E_1');

select * from web_returns where wr_order_number in (select ws_order_number from web_sales, date_dim where ws_sold_date_sk=d_date_sk and d_date between 'CSW_S_2' and 'CSW_E_2');
delete from web_sales where ws_sold_date_sk >= (select min(d_date_sk) from date_dim where d_date between 'CSW_S_2' and 'CSW_E_2') and 
                ws_sold_date_sk<= (select max(d_date_sk) from date_dim where d_date between 'CSW_S_2' and 'CSW_E_2');

select * from web_returns where wr_order_number in (select ws_order_number from web_sales, date_dim where ws_sold_date_sk=d_date_sk and d_date between 'CSW_S_3' and 'CSW_E_3');
select * from web_sales where ws_sold_date_sk >= (select min(d_date_sk) from date_dim where d_date between 'CSW_S_3' and 'CSW_E_3') and
                ws_sold_date_sk<= (select max(d_date_sk) from date_dim where d_date between 'CSW_S_3' and 'CSW_E_3');

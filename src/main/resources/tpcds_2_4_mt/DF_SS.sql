delete from store_returns where sr_ticket_number in (select ss_ticket_number from store_sales, date_dim   where ss_sold_date_sk=d_date_sk and d_date between 'CSW_S_1' and 'CSW_E_1');
delete from store_sales where ss_sold_date_sk >= (select min(d_date_sk) from date_dim  where d_date between 'CSW_S_1' and 'CSW_E_1') and
                ss_sold_date_sk <= (select max(d_date_sk) from date_dim  where d_date between 'CSW_S_1' and 'CSW_E_1');

delete from store_returns where sr_ticket_number in (select ss_ticket_number from store_sales, date_dim   where ss_sold_date_sk=d_date_sk and d_date between 'CSW_S_2' and 'CSW_E_2');
delete from store_sales where ss_sold_date_sk >= (select min(d_date_sk) from date_dim  where d_date between 'CSW_S_2' and 'CSW_E_2') and
                ss_sold_date_sk<= (select max(d_date_sk) from date_dim  where d_date between 'CSW_S_2' and 'CSW_E_2');

delete from store_returns where sr_ticket_number in (select ss_ticket_number from store_sales, date_dim   where ss_sold_date_sk=d_date_sk and d_date between 'CSW_S_3' and 'CSW_E_3');
delete from store_sales where ss_sold_date_sk >= (select min(d_date_sk) from date_dim  where d_date between 'CSW_S_3' and 'CSW_E_3') and
                ss_sold_date_sk <= (select max(d_date_sk) from date_dim  where d_date between 'CSW_S_3' and 'CSW_E_3');


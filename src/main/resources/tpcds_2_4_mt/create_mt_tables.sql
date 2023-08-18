create database if not exists ${DB};
use ${DB};

-- ============================================================
--   Table: s_catalog_page
-- ============================================================
drop table if exists s_catalog_page_${ROUND};
create table s_catalog_page_${ROUND}
(
    cpag_catalog_number         integer               not null,
    cpag_catalog_page_number    integer               not null,
    cpag_department             char(20)                      ,
    cpag_id                     char(16)                      ,
    cpag_start_date             char(10)                      ,
    cpag_end_date               char(10)                      ,
    cpag_description            varchar(100)                  ,
    cpag_type                   varchar(100)                  
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_catalog_page';

-- ============================================================
--   Table: s_zip_to_gmt                                       
-- ============================================================
drop table if exists s_zip_to_gmt_${ROUND};
create table s_zip_to_gmt_${ROUND}
(
    zipg_zip                    char(5)               not null,
    zipg_gmt_offset             integer               not null
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_zip_to_gmt';


-- ============================================================
--   Table: s_purchase_lineitem                                
-- ============================================================
drop table if exists s_purchase_lineitem_${ROUND};
create table s_purchase_lineitem_${ROUND}
(
    plin_purchase_id            integer               not null,
    plin_line_number            integer               not null,
    plin_item_id                char(16)                      ,
    plin_promotion_id           char(16)                      ,
    plin_quantity               bigint                        ,
    plin_sale_price             decimal(7,2)                  ,
    plin_coupon_amt             decimal(7,2)                  ,
    plin_comment                varchar(100)                  
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_purchase_lineitem';

-- ============================================================
--   Table: s_customer                                         
-- ============================================================
drop table if exists s_customer_${ROUND};
create table s_customer_${ROUND}
(
    cust_customer_id            char(16)              not null,
    cust_salutation             char(10)                      ,
    cust_last_name              char(20)                      ,
    cust_first_name             char(20)                      ,
    cust_preffered_flag         char(1)                       ,
    cust_birth_date             char(10)                      ,
    cust_birth_country          char(20)                      ,
    cust_login_id               char(13)                      ,
    cust_email_address          char(50)                      ,
    cust_last_login_chg_date    char(10)                      ,
    cust_first_shipto_date      char(10)                      ,
    cust_first_purchase_date    char(10)                      ,
    cust_last_review_date       char(10)                      ,
    cust_primary_machine_id     char(15)                      ,
    cust_secondary_machine_id   char(15)                      ,
    cust_street_number          smallint                      ,
    cust_suite_number           char(10)                      ,
    cust_street_name1           char(30)                      ,
    cust_street_name2           char(30)                      ,
    cust_street_type            char(15)                      ,
    cust_city                   char(60)                      ,
    cust_zip                    char(10)                      ,
    cust_county                 char(30)                      ,
    cust_state                  char(2)                       ,
    cust_country                char(20)                      ,
    cust_loc_type               char(20)                      ,
    cust_gender                 char(1)                       ,
    cust_marital_status         char(1)                       ,
    cust_educ_status            char(20)                      ,
    cust_credit_rating          char(10)                      ,
    cust_purch_est              decimal(7,2)                  ,
    cust_buy_potential          char(15)                      ,
    cust_depend_cnt             smallint                      ,
    cust_depend_emp_cnt         smallint                      ,
    cust_depend_college_cnt     smallint                      ,
    cust_vehicle_cnt            smallint                      ,
    cust_annual_income          decimal(9,2)                  
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_customer';

-- ============================================================
--   Table: s_customer_address                                 
-- ============================================================
drop table if exists s_customer_address_${ROUND};
create table s_customer_address_${ROUND}
(
    cadr_address_id             char(16)              not null,
    cadr_street_number          integer                       ,
    cadr_street_name1           char(25)                      ,
    cadr_street_name2           char(25)                      ,
    cadr_street_type            char(15)                      ,
    cadr_suitdecimal            char(10)                      ,
    cadr_city                   char(60)                      ,
    cadr_county                 char(30)                      ,
    cadr_state                  char(2)                       ,
    cadr_zip                    char(10)                      ,
    cadr_country                char(20)                      
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_customer_address';

-- ============================================================
--   Table: s_purchase                                         
-- ============================================================
drop table if exists s_purchase_${ROUND};
create table s_purchase_${ROUND}
(
    purc_purchase_id            integer               not null,
    purc_store_id               char(16)                      ,
    purc_customer_id            char(16)                      ,
    purc_purchase_date          char(10)                      ,
    purc_purchase_time          integer                       ,
    purc_register_id            integer                       ,
    purc_clerk_id               integer                       ,
    purc_comment                char(100)                     
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_purchase';

-- ============================================================
--   Table: s_catalog_order                                    
-- ============================================================
drop table if exists s_catalog_order_${ROUND};
create table s_catalog_order_${ROUND}
(
    cord_order_id               integer               not null,
    cord_bill_customer_id       char(16)                      ,
    cord_ship_customer_id       char(16)                      ,
    cord_order_date             char(10)                      ,
    cord_order_time             integer                       ,
    cord_ship_mode_id           char(16)                      ,
    cord_call_center_id         char(16)                      ,
    cord_order_comments         varchar(100)                  
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_catalog_order';

-- ============================================================
--   Table: s_web_order                                        
-- ============================================================
drop table if exists s_web_order_${ROUND};
create table s_web_order_${ROUND}
(
    word_order_id               integer               not null,
    word_bill_customer_id       char(16)                      ,
    word_ship_customer_id       char(16)                      ,
    word_order_date             char(10)                      ,
    word_order_time             integer                       ,
    word_ship_mode_id           char(16)                      ,
    word_web_site_id            char(16)                      ,
    word_order_comments         char(100)                     
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_web_order';

-- ============================================================
--   Table: s_item                                             
-- ============================================================
drop table if exists s_item_${ROUND};
create table s_item_${ROUND}
(
    item_item_id                char(16)              not null,
    item_item_description       char(200)                     ,
    item_list_price             decimal(7,2)                  ,
    item_wholesale_cost         decimal(7,2)                  ,
    item_size                   char(20)                      ,
    item_formulation            char(20)                      ,
    item_color                  char(20)                      ,
    item_units                  char(10)                      ,
    item_container              char(10)                      ,
    item_manager_id             integer                       
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_item';

-- ============================================================
--   Table: s_catalog_order_lineitem                           
-- ============================================================
drop table if exists s_catalog_order_lineitem_${ROUND};
create table s_catalog_order_lineitem_${ROUND}
(
    clin_order_id               integer               not null,
    clin_line_number            integer               not null,
    clin_item_id                char(16)                      ,
    clin_promotion_id           char(16)                      ,
    clin_quantity               bigint                        ,
    clin_sales_price            decimal(7,2)                  ,
    clin_coupon_amt             decimal(7,2)                  ,
    clin_warehouse_id           char(16)                      ,
    clin_ship_date              char(10)                      ,
    clin_catalog_number         integer                       ,
    clin_catalog_page_number    integer                       ,
    clin_ship_cost              decimal(7,2)                  
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_catalog_order_lineitem';

-- ============================================================
--   Table: s_web_order_lineitem                               
-- ============================================================
drop table if exists s_web_order_lineitem_${ROUND};
create table s_web_order_lineitem_${ROUND}
(
    wlin_order_id               integer               not null,
    wlin_line_number            integer               not null,
    wlin_item_id                char(16)                      ,
    wlin_promotion_id           char(16)                      ,
    wlin_quantity               bigint                       ,
    wlin_sales_price            decimal(7,2)                  ,
    wlin_coupon_amt             decimal(7,2)                  ,
    wlin_warehouse_id           char(16)                      ,
    wlin_ship_date              char(10)                      ,
    wlin_ship_cost              decimal(7,2)                  ,
    wlin_web_page_id            char(16)                      
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_web_order_lineitem';

-- ============================================================
--   Table: s_store                                            
-- ============================================================
drop table if exists s_store_${ROUND};
create table s_store_${ROUND}
(
    stor_store_id               char(16)              not null,
    stor_closed_date            char(10)                      ,
    stor_name                   char(50)                      ,
    stor_employees              integer                       ,
    stor_floor_space            integer                       ,
    stor_hours                  char(20)                      ,
    stor_store_manager          char(40)                      ,
    stor_market_id              integer                       ,
    stor_geography_class        char(100)                     ,
    stor_market_manager         char(40)                      ,
    stor_tax_percentage         decimal(5,2)                  
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_store';

-- ============================================================
--   Table: s_call_center                                      
-- ============================================================
drop table if exists s_call_center_${ROUND};
create table s_call_center_${ROUND}
(
    call_center_id              char(16)              not null,
    call_open_date              char(10)                      ,
    call_closed_date            char(10)                      ,
    call_center_name            char(50)                      ,
    call_center_class           char(50)                      ,
    call_center_employees       integer                       ,
    call_center_sq_ft           integer                       ,
    call_center_hours           char(20)                      ,
    call_center_manager         char(40)                      ,
    call_center_tax_percentage  decimal(7,2)                  
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_call_center';

-- ============================================================
--   Table: s_web_site                                         
-- ============================================================
drop table if exists s_web_site_${ROUND};
create table s_web_site_${ROUND}
(
    wsit_web_site_id            char(16)              not null,
    wsit_open_date              char(10)                      ,
    wsit_closed_date            char(10)                      ,
    wsit_site_name              char(50)                      ,
    wsit_site_class             char(50)                      ,
    wsit_site_manager           char(40)                      ,
    wsit_tax_percentage         decimal(5,2)                  
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_web_site';

-- ============================================================
--   Table: s_warehouse                                        
-- ============================================================
drop table if exists s_warehouse_${ROUND};
create table s_warehouse_${ROUND}
(
    wrhs_warehouse_id           char(16)              not null,
    wrhs_warehouse_desc         char(200)                     ,
    wrhs_warehouse_sq_ft        integer                       
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_warehouse';

-- ============================================================
--   Table: s_web_page                                         
-- ============================================================
drop table if exists s_web_page_${ROUND};
create table s_web_page_${ROUND}
(
    wpag_web_page_id            char(16)              not null,
    wpag_create_date            char(10)                      ,
    wpag_access_date            char(10)                      ,
    wpag_autogen_flag           char(1)                       ,
    wpag_url                    char(100)                     ,
    wpag_type                   char(50)                      ,
    wpag_char_cnt               integer                       ,
    wpag_link_cnt               integer                       ,
    wpag_image_cnt              integer                       ,
    wpag_max_ad_cnt             integer                       
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_web_page';

-- ============================================================
--   Table: s_promotion                                        
-- ============================================================
drop table if exists s_promotion_${ROUND};
create table s_promotion_${ROUND}
(
    prom_promotion_id           char(16)              not null,
    prom_promotion_name         char(30)                      ,
    prom_start_date             char(10)                      ,
    prom_end_date               char(10)                      ,
    prom_cost                   decimal(7,2)                  ,
    prom_response_target        char(1)                       ,
    prom_channel_dmail          char(1)                       ,
    prom_channel_email          char(1)                       ,
    prom_channel_catalog        char(1)                       ,
    prom_channel_tv             char(1)                       ,
    prom_channel_radio          char(1)                       ,
    prom_channel_press          char(1)                       ,
    prom_channel_event          char(1)                       ,
    prom_channel_demo           char(1)                       ,
    prom_channel_details        char(100)                     ,
    prom_purpose                char(15)                      ,
    prom_discount_active        char(1)                       ,
    prom_discount_pct           decimal(5,2)                  
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_promotion';

-- ============================================================
--   Table: s_store_returns                                    
-- ============================================================
drop table if exists s_store_returns_${ROUND};
create table s_store_returns_${ROUND}
(
    sret_store_id               char(16)                      ,
    sret_purchase_id            char(16)              not null,
    sret_line_number            integer               not null,
    sret_item_id                char(16)              not null,
    sret_customer_id            char(16)                      ,
    sret_return_date            char(10)                      ,
    sret_return_time            char(10)                      ,
    sret_ticket_number          char(20)                      ,
    sret_return_qty             integer                       ,
    sret_return_amt             decimal(7,2)                  ,
    sret_return_tax             decimal(7,2)                  ,
    sret_return_fee             decimal(7,2)                  ,
    sret_return_ship_cost       decimal(7,2)                  ,
    sret_refunded_cash          decimal(7,2)                  ,
    sret_reversed_charge        decimal(7,2)                  ,
    sret_store_credit           decimal(7,2)                  ,
    sret_reason_id              char(16)                      
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_store_returns';

-- ============================================================
--   Table: s_catalog_returns                                  
-- ============================================================
drop table if exists s_catalog_returns_${ROUND};
create table s_catalog_returns_${ROUND}
(
    cret_call_center_id         char(16)                      ,
    cret_order_id               integer               not null,
    cret_line_number            integer               not null,
    cret_item_id                char(16)              not null,
    cret_return_customer_id     char(16)                      ,
    cret_refund_customer_id     char(16)                      ,
    cret_return_date            char(10)                      ,
    cret_return_time            char(10)                      ,
    cret_return_qty             integer                       ,
    cret_return_amt             decimal(7,2)                  ,
    cret_return_tax             decimal(7,2)                  ,
    cret_return_fee             decimal(7,2)                  ,
    cret_return_ship_cost       decimal(7,2)                  ,
    cret_refunded_cash          decimal(7,2)                  ,
    cret_reversed_charge        decimal(7,2)                  ,
    cret_merchant_credit        decimal(7,2)                  ,
    cret_reason_id              char(16)                      ,
    cret_shipmode_id            char(16)                      ,
    cret_catalog_page_id        char(16)                      ,
    cret_warehouse_id           char(16)                      
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_catalog_returns';

-- ============================================================
--   Table: s_web_returns                                      
-- ============================================================
drop table if exists s_web_returns_${ROUND};
create table s_web_returns_${ROUND}
(
    wret_web_site_id            char(16)                      ,
    wret_order_id               integer               not null,
    wret_line_number            integer               not null,
    wret_item_id                char(16)              not null,
    wret_return_customer_id     char(16)                      ,
    wret_refund_customer_id     char(16)                      ,
    wret_return_date            char(10)                      ,
    wret_return_time            char(10)                      ,
    wret_return_qty             integer                       ,
    wret_return_amt             decimal(7,2)                  ,
    wret_return_tax             decimal(7,2)                  ,
    wret_return_fee             decimal(7,2)                  ,
    wret_return_ship_cost       decimal(7,2)                  ,
    wret_refunded_cash          decimal(7,2)                  ,
    wret_reversed_charge        decimal(7,2)                  ,
    wret_account_credit         decimal(7,2)                  ,
    wret_reason_id              char(16)                      
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_web_returns';

-- ============================================================
--   Table: s_inventory                                        
-- ============================================================
drop table if exists s_inventory_${ROUND};
create table s_inventory_${ROUND}
(
    invn_warehouse_id           char(16)              not null,
    invn_item_id                char(16)              not null,
    invn_date                   char(10)              not null,
    invn_qty_on_hand            integer                       
)
using csv OPTIONS(mode "simple")
location '${LOCATION}/s_inventory';



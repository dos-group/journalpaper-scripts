-- TPCH schema for Hive 10.0
--

-- `lineitem` table
CREATE EXTERNAL TABLE IF NOT EXISTS lineitem ( 
  l_orderkey BIGINT,
  l_partkey BIGINT,
  l_suppkey BIGINT,
  l_linenumber BIGINT,
  l_quantity FLOAT,
  l_extendedprice FLOAT,
  l_discount FLOAT,
  l_tax FLOAT,
  l_returnflag STRING ,
  l_linestatus STRING ,
  l_shipdate STRING,
  l_commitdate STRING,
  l_receiptdate STRING,
  l_shipinstruct STRING,
  l_shipmode STRING,
  l_comment STRING )
ROW FORMAT DELIMITED FIELDS TERMINATED by '|' 
STORED AS TEXTFILE 
LOCATION '${IN}/lineitem.tbl';

-- `customer` table
CREATE EXTERNAL TABLE IF NOT EXISTS customer ( 
  c_custkey BIGINT,
  c_name STRING,
  c_address STRING,
  c_nationkey INT,
  c_phone STRING,
  c_acctbal FLOAT,
  c_mktsegment STRING,
  c_comment STRING )
ROW FORMAT DELIMITED FIELDS TERMINATED by '|' 
STORED AS TEXTFILE 
LOCATION '${IN}/customer.tbl';

-- `nation` table
CREATE EXTERNAL TABLE IF NOT EXISTS nation ( 
  n_nationkey INT,
  n_name STRING,
  n_regionkey INT,
  n_comment STRING )
ROW FORMAT DELIMITED FIELDS TERMINATED by '|' 
STORED AS TEXTFILE 
LOCATION '${IN}/nation.tbl';

-- `orders` table
CREATE EXTERNAL TABLE IF NOT EXISTS orders ( 
  o_orderkey BIGINT,
  o_custkey BIGINT,
  o_orderstatus STRING,
  o_totalprice FLOAT,
  o_orderdate STRING,
  o_orderpriority STRING,
  o_clerk STRING,
  o_shippriority INT,
  o_comment STRING )
ROW FORMAT DELIMITED FIELDS TERMINATED by '|' 
STORED AS TEXTFILE
LOCATION '${IN}/orders.tbl';

-- `part` table
CREATE EXTERNAL TABLE IF NOT EXISTS part ( 
  p_partkey BIGINT,
  p_name STRING,
  p_mfgr STRING,
  p_brand STRING,
  p_type STRING,
  p_size INT,
  p_container STRING,
  p_retailprice FLOAT,
  p_comment STRING )
ROW FORMAT DELIMITED FIELDS TERMINATED by '|' 
STORED AS TEXTFILE 
LOCATION '${IN}/part.tbl';

-- `supplier` table
CREATE EXTERNAL TABLE IF NOT EXISTS supplier ( 
  s_suppkey BIGINT,
  s_name STRING,
  s_address STRING,
  s_nationkey INT,
  s_phone STRING,
  s_acctbal FLOAT,
  s_comment STRING )
ROW FORMAT DELIMITED FIELDS TERMINATED by '|' 
STORED AS TEXTFILE 
LOCATION '${IN}/supplier.tbl';

-- `partsupp` table
CREATE EXTERNAL TABLE IF NOT EXISTS partsupp ( 
  ps_partkey BIGINT,
  ps_suppkey BIGINT,
  ps_availqty INT,
  ps_supplycost FLOAT,
  ps_comment STRING )
ROW FORMAT DELIMITED FIELDS TERMINATED by '|' 
STORED AS TEXTFILE 
LOCATION '${IN}/partsupp.tbl';

-- `region` table
CREATE EXTERNAL TABLE IF NOT EXISTS region (
  r_regionkey INT,
  r_name STRING,
  r_comment STRING )
ROW FORMAT DELIMITED FIELDS TERMINATED by '|' 
STORED AS TEXTFILE 
LOCATION '${IN}/region.tbl';
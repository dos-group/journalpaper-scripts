-- TPCH Query #3
--

set mapred.reduce.tasks=${NODE_COUNT};

INSERT OVERWRITE DIRECTORY '${OUT}' 
SELECT
    l.l_orderkey,
    SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue,
    o.o_orderdate,
    o.o_shippriority
FROM
    customer c
    JOIN orders o ON (c.c_custkey = o.o_custkey)
    JOIN lineitem l ON (l.l_orderkey = o.o_orderkey)
WHERE
    c.c_mktsegment = 'HOUSEHOLD'
    AND o.o_orderdate < '1995-03-15'
    AND l.l_shipdate > '1995-03-15'
GROUP BY
    l.l_orderkey,
    o.o_orderdate,
    o.o_shippriority
SORT BY
    revenue DESC,
    o_orderdate ASC
LIMIT 10;
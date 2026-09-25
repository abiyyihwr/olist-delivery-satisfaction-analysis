---------------------------- VOLUME & RELATIONSHIP CHECK ----------------------------

-- Orders Table --
SELECT *
FROM orders;

-- Total Rows by Table


-- SUMMARY ROWS TABLE --
SELECT 'orders' AS nama_tabel,
    COUNT(*) AS total_rows
FROM orders
WHERE order_status == 'delivered'
UNION ALL
SELECT 'order_items',
    COUNT(*) AS total_rows
FROM order_items
UNION ALL
SELECT 'order_review',
    COUNT(*) AS total_rows
FROM order_reviews
UNION ALL
SELECT 'customers',
    COUNT(*) AS total_rows
FROM customers
UNION ALL
SELECT 'sellers',
    COUNT(*) AS total_rows
FROM sellers;

-- MISSING VALUES : orders Table --
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN order_status IS NULL OR order_status = '' THEN 1 ELSE 0 END) AS missing_order_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL OR order_purchase_timestamp = '' THEN 1 ELSE 0 END) AS missing_order_purchase_timestamp,
    SUM(CASE WHEN order_approved_at IS NULL OR order_approved_at = '' THEN 1 ELSE 0 END) AS missing_order_approved_at,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL OR order_delivered_carrier_date = '' THEN 1 ELSE 0 END) AS missing_order_delivered_carrier_date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL OR order_delivered_customer_date = '' THEN 1 ELSE 0 END) AS missing_order_delivered_customer_date,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL OR order_estimated_delivery_date = '' THEN 1 ELSE 0 END) AS missing_order_estimated_delivery_date
FROM orders
WHERE order_status == 'delivered';

SELECT
    (missing_order_delivered_carrier_date * 100.0 / total_rows) AS pct_miss_delivered_carrier,
    (missing_order_delivered_customer_date * 100.0 / total_rows)  AS pct_miss_delivered_customer
FROM (
    SELECT 
        COUNT(*) AS total_rows,
        SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS missing_order_id,
        SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS missing_customer_id,
        SUM(CASE WHEN order_status IS NULL OR order_status = '' THEN 1 ELSE 0 END) AS missing_order_status,
        SUM(CASE WHEN order_purchase_timestamp IS NULL OR order_purchase_timestamp = '' THEN 1 ELSE 0 END) AS missing_order_purchase_timestamp,
        SUM(CASE WHEN order_approved_at IS NULL OR order_approved_at = '' THEN 1 ELSE 0 END) AS missing_order_approved_at,
        SUM(CASE WHEN order_delivered_carrier_date IS NULL OR order_delivered_carrier_date = '' THEN 1 ELSE 0 END) AS missing_order_delivered_carrier_date,
        SUM(CASE WHEN order_delivered_customer_date IS NULL OR order_delivered_customer_date = '' THEN 1 ELSE 0 END) AS missing_order_delivered_customer_date,
        SUM(CASE WHEN order_estimated_delivery_date IS NULL OR order_estimated_delivery_date = '' THEN 1 ELSE 0 END) AS missing_order_estimated_delivery_date
    FROM orders
    WHERE order_status == 'delivered'
);

-- MISSING VALUES : order_items Table --
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN order_item_id IS NULL OR order_item_id = '' THEN 1 ELSE 0 END) AS missing_order_item_id,
    SUM(CASE WHEN seller_id IS NULL OR seller_id = '' THEN 1 ELSE 0 END) AS missing_seller_id,
    SUM(CASE WHEN shipping_limit_date IS NULL OR shipping_limit_date = '' THEN 1 ELSE 0 END) AS missing_shipping_limit_date
FROM order_items;

-- MISSING VALUES : order_reviews Table --
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN review_id IS NULL OR review_id = '' THEN 1 ELSE 0 END) AS missing_review_id,
    SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN review_score IS NULL OR review_score = '' THEN 1 ELSE 0 END) AS missing_review_score
FROM order_reviews;

-- MISSING VALUES : customers Table --
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN customer_unique_id IS NULL OR customer_unique_id = '' THEN 1 ELSE 0 END) AS missing_customer_unique_id,
    SUM(CASE WHEN customer_state IS NULL OR customer_state = '' THEN 1 ELSE 0 END) AS missing_customer_state
FROM customers;

-- MISSING VALUES : sellers Table --
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN seller_id IS NULL OR seller_id = '' THEN 1 ELSE 0 END) AS missing_seller_id,
    SUM(CASE WHEN seller_state IS NULL OR seller_state = '' THEN 1 ELSE 0 END) AS missing_seller_state
FROM sellers;


-- MISSING VALUE AFTER JOIN : order_items to orders -- 
SELECT
    total_miss_order_id,
    (total_miss_order_id * 100.0 / total_rows) AS total_pct
FROM (
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_items.order_id IS NULL OR order_items.order_id = '' THEN 1 ELSE 0 END) AS total_miss_order_id
FROM orders
LEFT JOIN order_items USING(order_id)
WHERE orders.order_status == 'delivered'
);

-- MISSING VALUE AFTER JOIN : order_reviews to orders --
SELECT
    total_miss_order_id,
    (total_miss_order_id * 100.0 / total_rows) AS total_pct,
    (total_miss_review_score * 100.0 / total_rows) AS total_pct_score
FROM (
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN `or`.order_id IS NULL OR `or`.order_id = '' THEN 1 ELSE 0 END) AS total_miss_order_id,
    SUM(CASE WHEN `or`.review_score IS NULL OR `or`.review_score = '' THEN 1 ELSE 0 END) AS total_miss_review_score
FROM orders o
LEFT JOIN order_reviews `or` USING(order_id)
WHERE o.order_status == 'delivered'
);

-- MISSING VALUE AFTER JOIN : customers to orders --
SELECT
    total_miss_cust_id,
    (total_miss_cust_id * 100.0 / total_rows) AS total_pct
FROM (
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN cs.customer_id IS NULL OR cs.customer_id = '' THEN 1 ELSE 0 END) AS total_miss_cust_id
FROM orders o
LEFT JOIN customers cs USING(customer_id)
WHERE o.order_status == 'delivered'
);

-- MISSING VALUE AFTER JOIN : sellers to order_items --
SELECT
    total_miss_seller_id,
    (total_miss_seller_id * 100.0 / total_rows) AS total_pct
FROM (
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN s.seller_id IS NULL OR s.seller_id = '' THEN 1 ELSE 0 END) AS total_miss_seller_id
FROM order_items oi
LEFT JOIN sellers s USING(seller_id)
);

---------------------------- DATA QUALITY CHECK ----------------------------


-- DUPLICATES CHECK : orders table --
SELECT
    order_id,
    COUNT(*) AS total_unique
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- DUPLICATES CHECK : order_items table --
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS total_duplikasi
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

SELECT
    order_id,
    seller_id
FROM order_items
GROUP BY order_id
HAVING COUNT(seller_id) > 1;

SELECT
    COUNT(*) AS total_order
FROM (
    SELECT
        order_id
    FROM order_items
    GROUP BY order_id
    HAVING COUNT(order_item_id) > 1
        AND COUNT(DISTINCT shipping_limit_date) > 1
) AS subquery;

-- DUPLICATES CHECK : order_reviews table --
WITH review_duplicates AS (
    SELECT
        order_id,
        review_score
    FROM (
        SELECT
            order_id,
            review_score,
            COUNT(*) OVER(PARTITION BY order_id) AS total_duplicates
        FROM order_reviews
)
WHERE total_duplicates > 1 
)
SELECT
    COUNT(DISTINCT order_id) AS total_order_id_duplicated
FROM review_duplicates;

WITH duplikasi_ulasan AS (
    SELECT
        order_id,
        review_score,
        MIN(review_score) OVER(PARTITION BY order_id) AS min_score,
        MAX(review_score) OVER(PARTITION BY order_id) AS max_score
    FROM order_reviews
),
cek AS (
SELECT
    order_id,
    review_score
FROM duplikasi_ulasan
WHERE min_score != max_score
)
SELECT
    COUNT(DISTINCT order_id) AS total_different_score_duplicates
FROM cek;

-- DUPLICATES CHECK : customers table --
SELECT
    customer_id,
    COUNT(*) AS total_rows
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- DUPLICATES CHECK : sellers table --
SELECT
    seller_id,
    COUNT(*) AS total_rows
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- INVALID DATE : orders table --
-- RULE : order_purchase_timestamp < order_delivered_carrier_date < order_delivered_customer_date
WITH orders_filtered AS (
    SELECT
        order_id,
        order_purchase_timestamp,
        order_delivered_carrier_date,
        order_delivered_customer_date
    FROM orders
    WHERE order_status = 'delivered'
        AND NOT (
            order_purchase_timestamp < order_delivered_carrier_date
            AND 
            order_delivered_carrier_date < order_delivered_customer_date
        )
)
SELECT
    COUNT(*) AS total_invalid
FROM orders_filtered;

WITH orders_filtered AS (
    SELECT 
        order_id,
        CASE 
            WHEN order_purchase_timestamp > order_delivered_carrier_date THEN 'Pembelian melewati waktu kurir'
            WHEN order_delivered_carrier_date > order_delivered_customer_date THEN 'Kurir melewati waktu diterima pelanggan'
            ELSE 'Lainnya'
        END AS jenis_anomali
    FROM orders
    WHERE order_status = 'delivered'
      AND (
          order_purchase_timestamp >= order_delivered_carrier_date 
          OR 
          order_delivered_carrier_date >= order_delivered_customer_date
      )
)
SELECT 
    jenis_anomali,
    COUNT(*) AS total_invalid
FROM orders_filtered
GROUP BY jenis_anomali;

SELECT
        order_id,
        order_purchase_timestamp,
        order_delivered_carrier_date,
        order_delivered_customer_date
FROM orders
WHERE order_status = 'delivered'
    AND order_purchase_timestamp = order_delivered_carrier_date;    

SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM orders
WHERE order_status = 'delivered'
    AND order_delivered_carrier_date = order_delivered_customer_date;
    
-- OUTLIER VALUE : order_delivered_customer_date & order_estimated_delivery_date -- 
WITH outlier_delivery_date AS (
    SELECT
        order_id,
        order_purchase_timestamp,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        ROUND(JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_delivered_customer_date)) AS diff_delivery_date
    FROM orders
    WHERE order_status = 'delivered' 
        AND order_delivered_customer_date IS NOT NULL
        AND NOT (
          order_purchase_timestamp >= order_delivered_carrier_date 
          OR 
          order_delivered_carrier_date >= order_delivered_customer_date
      )
),
ranked_data AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY diff_delivery_date) AS quartile
    FROM outlier_delivery_date
),
quartiles AS (
    SELECT
        MIN(diff_delivery_date) AS min_diff,
        MAX(diff_delivery_date) AS max_diff,
        AVG(diff_delivery_date) AS mean,
        MAX(CASE WHEN quartile = 1 THEN diff_delivery_date END) AS q1,
        MAX(CASE WHEN quartile = 2 THEN diff_delivery_date END) AS q2,
        MAX(CASE WHEN quartile = 3 THEN diff_delivery_date END) AS q3
    FROM ranked_data
)
SELECT order_id, order_purchase_timestamp, order_delivered_carrier_date, 
       order_delivered_customer_date, order_estimated_delivery_date, diff_delivery_date
FROM outlier_delivery_date
ORDER BY diff_delivery_date ASC   -- lihat yang paling delay parah
LIMIT 10;

WITH agg_month_day AS (
    SELECT strftime('%m-%d', order_delivered_customer_date) AS month_day, COUNT(*) AS total
    FROM orders
    WHERE order_status = 'delivered'
    GROUP BY month_day
    ORDER BY total DESC
)
SELECT 'average_order' AS metrik,
    ROUND(AVG(total)) AS total_order
FROM agg_month_day
UNION ALL
SELECT '09-19',
    total
FROM agg_month_day
WHERE month_day = '09-19';

WITH outlier_delivery_date AS (
    SELECT
        order_id,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        ROUND(JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_delivered_customer_date)) AS diff_delivery_date
    FROM orders
    WHERE order_status = 'delivered' 
        AND order_delivered_customer_date IS NOT NULL
        AND NOT (
          order_purchase_timestamp >= order_delivered_carrier_date 
          OR 
          order_delivered_carrier_date >= order_delivered_customer_date
      )
)
SELECT
    strftime('%m-%d', order_delivered_customer_date) AS month_day,
    COUNT(*) AS total_outlier
FROM outlier_delivery_date
WHERE diff_delivery_date < -9  -- lower_bound dari IQR yang sudah kita hitung
GROUP BY month_day
ORDER BY total_outlier DESC
LIMIT 10;

WITH outlier_delivery_date AS (
    SELECT
        order_id,
        order_purchase_timestamp,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        ROUND(JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_delivered_customer_date)) AS diff_delivery_date
    FROM orders
    WHERE order_status = 'delivered' 
        AND order_delivered_customer_date IS NOT NULL
        AND NOT (
          order_purchase_timestamp >= order_delivered_carrier_date 
          OR 
          order_delivered_carrier_date >= order_delivered_customer_date
      )
)
SELECT order_id, order_purchase_timestamp, order_delivered_carrier_date, order_delivered_customer_date
FROM outlier_delivery_date
WHERE diff_delivery_date < -9
    AND strftime('%m-%d', order_delivered_customer_date) IN ('09-19','04-16','04-03','04-06','04-10')
ORDER BY order_delivered_customer_date;

-- ganti ORDER BY ... DESC untuk lihat yang paling "cepat"/mencurigakan
-- SELECT 
--     *,
--     (q3 - q1) AS iqr,
--     q1 - (1.5 * (q3 - q1)) AS lower_bound,
--     q3 + (1.5 * (q3 - q1)) AS upper_bound
-- FROM quartiles;

-- OUTLIER VALUE : order_delivered_carrier_date & shipping_limit_date -- 
WITH shipping_date AS (
    SELECT
        order_id,
        MIN(shipping_limit_date) OVER(PARTITION BY order_id) AS min_shipping_date
    FROM order_items
),
delivery_carrier_date AS (
    SELECT
        order_id,
        order_purchase_timestamp,
        order_delivered_carrier_date
    FROM orders
    WHERE order_status = 'delivered' 
        AND order_delivered_customer_date IS NOT NULL
        AND NOT (
          order_purchase_timestamp >= order_delivered_carrier_date 
          OR 
          order_delivered_carrier_date >= order_delivered_customer_date
      )
),
combined_date AS (
    SELECT
        delivery_carrier_date.order_id,
        delivery_carrier_date.order_purchase_timestamp,
        delivery_carrier_date.order_delivered_carrier_date,
        shipping_date.min_shipping_date,
        (ROUND(JULIANDAY(shipping_date.min_shipping_date) - JULIANDAY(delivery_carrier_date.order_delivered_carrier_date))) AS diff_shipping,
        (ROUND(JULIANDAY(shipping_date.min_shipping_date) - JULIANDAY(delivery_carrier_date.order_purchase_timestamp))) AS diff_purchase
    FROM delivery_carrier_date
    LEFT JOIN shipping_date
        ON delivery_carrier_date.order_id = shipping_date.order_id
),
ranked_date AS (
    SELECT
        *,
        NTILE(4) OVER(ORDER BY diff_shipping ASC) AS quartile
    FROM combined_date
),
stats AS (
    SELECT
        MIN(diff_shipping) AS min_diff,
        MAX(diff_shipping) AS max_diff,
        AVG(diff_shipping) AS mean,
        MAX(CASE WHEN quartile = 1 THEN diff_shipping END) AS q1,
        MAX(CASE WHEN quartile = 2 THEN diff_shipping END) AS q2,
        MAX(CASE WHEN quartile = 3 THEN diff_shipping END) AS q3
    FROM ranked_date
),
bounds AS (
    SELECT
        *,
        (q3 - q1) AS iqr,
        q1 - (1.5 * (q3 - q1)) AS lower_bound,
        q3 + (1.5 * (q3 - q1)) AS upper_bound
    FROM stats
)
SELECT DISTINCT *
FROM combined_date
WHERE diff_shipping > 9.5
ORDER BY diff_shipping DESC
LIMIT 10;

CREATE INDEX IF NOT EXISTS idx_customers_customerid ON customers(customer_id);
CREATE INDEX IF NOT EXISTS idx_orderreviews_orderid ON order_reviews(order_id);

DROP TABLE IF EXISTS mart_delivery_performance;
CREATE TABLE mart_delivery_performance AS
WITH orders_filtered AS (
    SELECT
        order_id, customer_id, order_delivered_carrier_date,
        order_delivered_customer_date, order_estimated_delivery_date
    FROM orders
    WHERE order_status = 'delivered'
        AND order_delivered_customer_date IS NOT NULL
        AND order_delivered_carrier_date IS NOT NULL
        AND (order_purchase_timestamp < order_delivered_carrier_date
             AND order_delivered_carrier_date < order_delivered_customer_date)
),
order_items_filtered AS (
    SELECT order_id, MIN(shipping_limit_date) AS shipping_date
    FROM order_items
    WHERE order_id != 'c2bb89b5c1dd978d507284be78a04cb2'
    GROUP BY order_id
),
join_1 AS (
    SELECT o_f.order_id, o_f.customer_id, o_f.order_delivered_customer_date,
           o_f.order_estimated_delivery_date
    FROM orders_filtered o_f
    INNER JOIN order_items_filtered o_i_f ON o_f.order_id = o_i_f.order_id
    WHERE o_f.order_delivered_carrier_date <= o_i_f.shipping_date
),
order_reviews_filtered AS (
    SELECT order_id, review_score FROM (
        SELECT order_id, review_score,
            ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY review_creation_date DESC) AS ranked
        FROM order_reviews
    ) WHERE ranked = 1
),
join_2 AS (
    SELECT j1.order_id, j1.customer_id, j1.order_delivered_customer_date,
           j1.order_estimated_delivery_date, o_r_f.review_score
    FROM join_1 j1
    LEFT JOIN order_reviews_filtered o_r_f ON j1.order_id = o_r_f.order_id
    WHERE o_r_f.review_score IS NOT NULL
)
SELECT j2.order_id, j2.order_delivered_customer_date, j2.order_estimated_delivery_date,
       j2.review_score, cs.customer_state
FROM join_2 j2
INNER JOIN customers cs ON j2.customer_id = cs.customer_id;

-- POST MART VALIDATION --
SELECT COUNT(*) AS total_rows FROM mart_delivery_performance;

SELECT order_id, COUNT(*) 
FROM mart_delivery_performance 
GROUP BY order_id 
HAVING COUNT(*) > 1;

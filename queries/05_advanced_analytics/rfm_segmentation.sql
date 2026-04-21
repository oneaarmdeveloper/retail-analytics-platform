-- Author: oneaarmdeveloper
-- Goals: RFM Customer Segmentation (Recency, Frequency, Monetary)
-- Date: 21.04.2026

USE retail_analytics;

WITH rfm_base AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.customer_tier,
        c.city,
        DATEDIFF(CURRENT_DATE, MAX(o.order_date)) AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS monetary
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY c.customer_id, c.first_name, c.last_name, c.customer_tier, c.city
),
rfm_scores AS (
    SELECT 
        customer_id, customer_name, customer_tier, city,
        recency_days, frequency, monetary,
        -- R Score: Lower days = better. NTILE(1)=worst, NTILE(5)=best. Reverse for RFM standard.
        (6 - NTILE(5) OVER (ORDER BY recency_days ASC)) AS r_score,
        -- F Score: Higher frequency = better
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        -- M Score: Higher monetary = better
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)
SELECT 
    customer_id, customer_name, customer_tier, city,
    recency_days, frequency, monetary,
    r_score, f_score, m_score,
    (r_score + f_score + m_score) AS rfm_total,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 4 AND m_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'Promising New Spenders'
        WHEN r_score >= 3 AND m_score >= 4 THEN 'Potential Loyalists'
        WHEN r_score >= 2 AND f_score >= 4 AND m_score >= 4 THEN 'At Risk Champions'
        WHEN r_score >= 2 AND f_score >= 3 THEN 'Cannot Lose Them'
        WHEN r_score <= 2 AND f_score >= 2 AND m_score <= 2 THEN 'Hibernating'
        WHEN r_score <= 1 THEN 'Lost'
        ELSE 'Need Attention'
    END AS rfm_segment
FROM rfm_scores
ORDER BY rfm_total DESC, monetary DESC;


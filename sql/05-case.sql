SELECT *
FROM orders;

SELECT
	order_id,
    user_id,
    product_id,
    quantity,
    status,
    CASE status
		WHEN 'PENDING' THEN '주문 대기'
		WHEN 'COMPLETED' THEN '결제 완료'
		WHEN 'SHIPPED' THEN '배송'
		WHEN 'CANCELLED' THEN '주문 취소'
        ELSE '알 수 없음'
    END AS status_korean
FROM
	orders;

SELECT
	name,
    price,
    CASE
		WHEN price >= 100000 THEN '고가'
        WHEN price >= 30000 THEN '중가'
        ELSE '저가'
    END AS price_label
FROM products;

SELECT
	name,
    price,
    CASE
		WHEN price >= 30000 THEN '중가'
        WHEN price >= 100000 THEN '고가'
        ELSE '저가'
    END AS price_label
FROM products;

SELECT
	name,
    price,
    CASE
		WHEN price >= 100000 THEN '고가'
        WHEN price >= 30000 THEN '중가'
        ELSE '저가'
    END AS price_label
FROM products
ORDER BY
    CASE
		WHEN price >= 100000 THEN 1
        WHEN price >= 30000 THEN 2
        ELSE 3
    END ASC,
    price DESC;

SELECT
    CASE
		WHEN year(birth_date) >= 1990 THEN '1990년대생'
		WHEN year(birth_date) >= 1980 THEN '1980년대생'
        ELSE '그 이전 출생'
    END as birth_decade,
    COUNT(*) AS customer_count
FROM users
GROUP BY
	CASE
		WHEN year(birth_date) >= 1990 THEN '1990년대생'
		WHEN year(birth_date) >= 1980 THEN '1980년대생'
        ELSE '그 이전 출생'
    END;


SELECT 'Total' AS category,
		COUNT(*) AS total_orders
FROM orders

UNION

SELECT
    status,
    COUNT(*)
FROM orders
GROUP BY status;

SELECT
	DISTINCT
	(SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM orders WHERE status = 'COMPLETED') AS completed_count,
    (SELECT COUNT(*) FROM orders WHERE status = 'SHIPPED') AS shipped_count,
    (SELECT COUNT(*) FROM orders WHERE status = 'PENDING') AS pending_count
FROM orders;

SELECT
 (SELECT COUNT(*) FROM orders) AS total_orders,
 (SELECT COUNT(*) FROM orders WHERE status = 'COMPLETED') AS
completed_count,
 (SELECT COUNT(*) FROM orders WHERE status = 'SHIPPED') AS shipped_count,
 (SELECT COUNT(*) FROM orders WHERE status = 'PENDING') AS pending_count;
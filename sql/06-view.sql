SELECT
	p.category,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN o.status = 'SHIPPED' THEN 1 ELSE 0 END) AS shipped_count,
    SUM(CASE WHEN o.status = 'PENDING' THEN 1 ELSE 0 END) AS pending_count
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category;

DROP VIEW IF EXISTS v_category_order_status;

CREATE VIEW v_category_order_status AS
SELECT
	p.category,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN o.status = 'SHIPPED' THEN 1 ELSE 0 END) AS shipped_count,
    SUM(CASE WHEN o.status = 'PENDING' THEN 1 ELSE 0 END) AS pending_count
FROM
	orders o
JOIN
	products p ON o.product_id = p.product_id
GROUP BY
	p.category;

SELECT *
FROM v_category_order_status;

ALTER VIEW v_category_order_status AS
SELECT
	p.category,
    SUM(p.price * o.quantity) AS total_sales,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN o.status = 'SHIPPED' THEN 1 ELSE 0 END) AS shipped_count,
    SUM(CASE WHEN o.status = 'PENDING' THEN 1 ELSE 0 END) AS pending_count
FROM
	orders o
JOIN
	products p ON o.product_id = p.product_id
GROUP BY
	p.category;

SELECT *
FROM v_category_order_status;

SELECT *
FROM v_category_order_status;
SELECT user_id,
	name,
	email
FROM users;

SELECT user_id,
	order_id
FROM orders
ORDER BY user_id ASC;

SELECT
	u.user_id,
    u.name,
    o.user_id,
    o.order_id
FROM users u
JOIN orders o ON u.user_id = o.user_id
ORDER BY u.user_id;

/*
JOIN을 이용하여 한 번도 주문하지 않는 고객을 조회해보세요.
*/
SELECT
	u.user_id,
    u.name,
    o.user_id,
    o.order_id
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id;

/*
주문 정보가 NULL인 고객이 바로 '한 번도 주문하지 않은 고객'이다.
WHERE 절을 사용해서 이들만 찾아보자.
*/

SELECT
	u.user_id,
    u.name,
    o.user_id,
    o.order_id
FROM users u
LEFT JOIN orders o on u.user_id = o.user_id
WHERE o.order_id IS NULL;

/*
한 번도 팔리지 않은 상품 찾기
*/

SELECT *
FROM products;

SELECT *
FROM orders;

SELECT
	p.product_id,
    p.name,
    p.price,
    o.product_id,
    o.order_id
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

SELECT
	o.order_id,
	p.*
FROM orders o
RIGHT JOIN products p ON o.product_id = p.product_id
WHERE o.order_id IS NULL;

SELECT
	user_id,
    name,
    email
FROM users
WHERE user_id = 1;

SELECT order_id,
	product_id,
    user_id
FROM orders
WHERE user_id = 1;

SELECT
	o.order_id,
    o.product_id,
    o.user_id as orders_user_id,
    u.user_id as users_user_id,
    u.name,
    u.email
FROM
	orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.user_id = 1;

SELECT
	u.user_id as users_user_id,
    u.name,
    u.email,
	o.order_id,
    o.product_id,
    o.user_id as orders_user_id
FROM
	users u
JOIN orders o ON u.user_id = o.user_id
WHERE u.user_id = 1;

SELECT user_id,
	name,
    email
FROM users;

SELECT order_id,
	product_id,
    user_id
FROM orders;

SELECT
	o.order_id,
    o.product_id,
    o.user_id AS orders_user_id,
    u.user_id AS users_user_id,
    u.name,
    u.email
FROM orders o
JOIN users u ON o.user_id = u.user_id;

SELECT
	u.user_id AS users_user_id,
    u.name,
    u.email,
	o.order_id,
    o.product_id,
    o.user_id AS orders_user_id
FROM users u
JOIN orders o ON u.user_id = o.user_id;

SELECT *
FROM employees;

/*
아래 두 쿼리의 차이는?
*/
SELECT *
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id;

SELECT *
FROM employees e
JOIN employees m ON e.employee_id = m.manager_id;


/*
아래 두 쿼리의 차이는?
*/
SELECT
	e.name AS employee_name,
    m.name AS manager_name
FROM employees e
JOIN employees m ON e.employee_id = m.manager_id;


SELECT
	e.name AS employee_name,
    m.name AS manager_name
FROM employees e
LEFT JOIN employees m on e.manager_id = m.employee_id;

SELECT *
FROM sizes;

SELECT
	s.size,
    c.color
FROM sizes s
CROSS JOIN colors c;

SELECT *
FROM colors;

SELECT
	CONCAT('기본티셔츠-', c.color, '-', s.size) AS product_name,
    s.size,
    c.color
FROM sizes s
CROSS JOIN colors c
ORDER BY product_name ASC;

CREATE TABLE product_options (
	option_id BIGINT AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    size VARCHAR(10) NOT NULL,
    color VARCHAR(20) NOT NULL,
    PRIMARY KEY (option_id)
);


INSERT INTO product_options (product_name, size, color)
SELECT
	CONCAT('기본티셔츠-', c.color, '-', s.size) AS product_name,
    s.size,
    c.color
FROM sizes s
CROSS JOIN colors c;

SELECT *
FROM product_options;

/*
2025년 6월에 '서울'에 거주하는 고객이 주문한 모든 내역에 대해,
고객 이름, 고객 이메일, 주문 날짜, 주문한 상품 명, 주문한 상품 가격, 주문 수량을 포함하는
상세 보고서를 최신 주문순으로 작성하라.
*/

-- users, products, orders, employees, sizes, colors

SELECT *
FROM users;

SELECT *
FROM orders;

SELECT *
FROM products;

SELECT
	u.name AS `고객 이름`,
    u.email AS `고객 이메일`,
    o.order_date AS `주문 날짜`,
    p.name AS `주문한 상품 명`,
    p.price AS `주문한 상품 가격`,
    o.quantity AS `주문 수량`
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id
WHERE u.address LIKE '서울%'
AND o.order_date >= '2025-06-01' AND o.order_date < '2025-07-01'
ORDER BY o.order_date DESC;
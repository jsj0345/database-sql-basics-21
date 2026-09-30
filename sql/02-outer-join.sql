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
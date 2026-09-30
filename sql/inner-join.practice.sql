USE my_shop2;

/*
1. INNER JOIN을 사용하여 orders 테이블과 products 테이블을 연결해라.
모든 주문에 대해 주문 ID, 상품명, 주문 수량이 포함된 목록을 조회하는
SQL을 작성하고 order_id 오름차순 정렬하시오.
가독성을 위해 테이블 별칭을 사용해야 한다.
*/

SELECT
	o.order_id,
    p.name,
    o.quantity
FROM orders o
JOIN products p ON o.product_id = p.product_id
ORDER BY o.order_id;

/*
2. orders, users, products 세 개의 테이블을 모두 조인해라.
SHIPPED (배송) 상태인 주문에 대해 주문 ID, 고객 이름, 상품명, 주문 날짜를 조회하는 SQL을 작성해라.
*/

SELECT
	o.order_id AS `주문 ID`,
    u.name AS `고객 이름`,
    o.order_date AS `주문 날짜`,
    o.status AS `상태`
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'SHIPPED';

/*
3. INNER JOIN과 집계 함수를 함께 사용해서 각 고객이 지금까지 주문한 총 구매액을 계산해라.
결과는 고객 이름과 총 구매액으로 구성되어야 하며, 총 구매액이 높은 순서대로 정렬 해야 한다.

orders => quantity
product => price
*/

SELECT *
FROM users;

SELECT
	u.name AS `user_name`,
    SUM(o.quantity * p.price) AS `total_purchase_amount`
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id
GROUP BY u.name
ORDER BY SUM(o.quantity * p.price) DESC;
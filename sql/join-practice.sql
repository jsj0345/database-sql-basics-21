USE my_shop2;

/*
1.
products 테이블과 orders 테이블을 LEFT JOIN 하여,
'전자기기' 카테고리에 속하지만 단 한 번도 판매되지 않은
상품의 이름과 가격을 조회하는 SQL을 작성해라.
*/

SELECT *
FROM products;

SELECT *
FROM orders;

SELECT
	o.order_id,
	p.name AS `상품 이름`,
    p.price AS `상품 가격`
FROM products p
LEFT JOIN orders o ON o.product_id = p.product_id
WHERE p.category = '전자기기'
AND o.order_id IS NULL;

/*
2.
모든 고객의 이름과 각 고객이 주문한 총 횟수를 조회하는 SQL을 작성해라.
주문을 한 번도 하지 않은 고객은 주문 횟수가 0으로 표시되어야 한다.
결과는 고객 이름으로 오름차순 정렬해라.
*/

SELECT *
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id;

SELECT
	u.name AS '고객 이름',
    IFNULL(COUNT(o.order_id), 0) AS 'order_count'
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.name
ORDER BY u.name ASC;

-- 원래는 CONUT(*)로 했었는데 이건 주문 건수를 카운트 하는건데 주문을 안한 고객은 order_id가 NULL이므로
-- IFNULL(COUNT(o.order_id, 0)) 로 수정.

/*
3.
RIGHT JOIN을 사용하여, 가입은 했지만 주문 기록이 없는 고객의 이름과
이메일을 찾는 SQL을 작성해라
*/

SELECT
	u.name AS `고객 이름`,
    u.email AS `이메일`
FROM orders o
RIGHT JOIN users u ON o.user_id = u.user_id
WHERE o.order_id IS NULL;

/*
4.
모든 고객의 이름과 그 고객이 주문한 상품의 이름을 조회하는 SQL을 작성해라.
한 고객이 여러 상품을 주문했다면 모든 상품명이 나와야 하며,
주문 기록이 없는 고객의 상품명은 NULL로 표시되어야 한다.
결과는 고객 이름(user_name), 상품 이름 순(product_name)으로 정렬해라.
*/

SELECT
	u.name AS `user_name`,
    p.name AS `product_name`
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
LEFT JOIN products p ON o.product_id = p.product_id
ORDER BY user_name ASC, product_name ASC;

/*
5.
employees 테이블을 셀프 조인하여 '최과장'의 직속 부하 직원들의
이름과 직원 ID를 모두 조회하는 SQL 쿼리를 작성해라.
*/

SELECT *
FROM employees;

SELECT
	e.employee_id,
    e.name,
    m.employee_id AS `manager_id`,
    m.name AS `manager_name`
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE m.name = '최과장';

/*
6.
sizes와 colors 테이블을 CROSS JOIN 하여 모든 색상과 사이즈 조합을
만들었던 것을 응용해 보자.
'면(Cotton)'과 '실크(Slik)' 라는 두 가지 재질 옵션을 가진 materials 테이블을 새로 만들고,
기존의 sizes, colors 테이블과 모두 CROSS JOIN하여 '상품명-색상-사이즈-재질'형태의 모든 조합을
조회하는 쿼리를 작성해라.
*/

CREATE TABLE materials (
	texture VARCHAR(20)
);

INSERT INTO materials VALUES
('Cotton'),
('Slik');

SELECT
	CONCAT_WS('-', '기본 티셔츠', c.color, s.size, m.texture) AS 'product_full_name',
    s.size,
    c.color,
    m.texture AS 'material'
FROM sizes s
CROSS JOIN colors c
CROSS JOIN materials m
ORDER BY size ASC, c.color ASC;

/*
7.
users, orders, products 세 개의 테이블을 조인하여 '네이트' 고객이 주문한 모든 상품의 이름
주문 날짜, 주문 수량을 조회하는 SQL 쿼리를 작성해라.
결과는 주문 날짜 최신순으로 정렬해라.
*/

SELECT
	u.name AS `customer_name`,
    p.name AS `product_name`,
    o.order_date,
    o.quantity
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN products p ON o.product_id = p.product_id
WHERE u.name = '네이트'
ORDER BY o.order_date DESC;

/*
8.
JOIN과 집계 함수를 함께 사용하는 종합 문제다.
users, orders, products 테이블을 조인하여 '서울'에 거주하는 고객별로 총 주문 금액을 계산하는 쿼리를
작성하시오.
*/

SELECT
	u.name AS `customer_name`,
    SUM(price * quantity) AS `total_spent`
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN products p ON o.product_id = p.product_id
WHERE u.address LIKE '서울%'
GROUP BY u.name
ORDER BY SUM(price * quantity) DESC;
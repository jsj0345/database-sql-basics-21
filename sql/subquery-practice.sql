/*
1. 가장 비싼 상품 조회하기
products 테이플에서 가격이 가장 비싼 상품의 product_id, name, price를 조회해라.
WHERE 절에 스칼라 서브쿼리를 사용하여 문제를 해결해야 한다.
*/

SELECT product_id,
	   name,
       price
FROM products
WHERE price = (
	SELECT MAX(price)
    FROM products
);

/*
2. order_id가 1인 주문과 동일한 상품을 주문한 다른 모든 주문의
order_id, user_id, order_date를 조회해라.

스칼라 서브쿼리를 활용해야 한다.
*/

SELECT
	o.order_id AS '주문 ID',
    o.user_id AS '고객 ID',
    o.order_date AS '주문 일시'
FROM orders o
WHERE o.product_id = (SELECT product_id
					  FROM orders
					  WHERE order_id = 1)
AND order_id != 1;

/*
3.
각 고객별로 총 몇 번의 주문을 했는지 '총주문횟수'를 이름과 함께 조회해라.
정렬은 user_id 오름차순이다.
한 번도 주문하지 않은 고객도 결과에 포함되어야 한다.
SELECT 절에 상관 서브쿼리를 사용하여 해결해야 한다.
*/

SELECT *
FROM users;

SELECT *
FROM orders;

SELECT
	u.name,
    (SELECT COUNT(*)
	 FROM orders o
     WHERE o.user_id = u.user_id) AS `총 주문 횟수`
FROM users u
ORDER BY u.user_id ASC;
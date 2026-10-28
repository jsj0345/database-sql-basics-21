USE sql_practice_shop;

SELECT VERSION();

/*
1.
products에서 is_active = 1이고 stock > 0인 상품의
`product_id`, `product_name`, `price`, `stock`을 조회한다.
**가격 높은 순**, 가격이 같으면 `product_id` 오름차순.
*/

SELECT
	product_id,
    product_name,
    price,
    stock
FROM products
WHERE stock > 0 AND is_active = 1
ORDER BY price DESC, product_id ASC;

SELECT
	COUNT(*)
FROM products
WHERE stock > 0 AND is_active = 1
ORDER BY price DESC, product_id ASC;

/*
2.
상품 가격이 **30,000원 이상 80,000원 이하**인 상품의 이름과 가격을 조회한다. 가격 오름차순.
*/
SELECT
	product_name AS '상품 이름',
    price AS '가격'
FROM products
WHERE price BETWEEN 30000 AND 80000
ORDER BY price ASC;

SELECT
	COUNT(*)
FROM products
WHERE price BETWEEN 30000 AND 80000
ORDER BY price ASC;

/*
03.
상품명에 **`키보드`**가 포함된 상품의 ID, 이름, 가격을 조회한다. 비활성 상품도 포함한다.
*/
SELECT
	product_id,
    product_name AS '상품명',
    price AS '가격'
FROM products
WHERE product_name LIKE '%키보드%';

/*
4.
카테고리 ID가 `1` 또는 `3`이며, 가격이 40,000원 이상이고 판매 중인 상품을 조회한다. 상품명과 가격을 출력한다.
*/
SELECT
	product_name AS '상품명',
    price AS '가격'
FROM products
WHERE category_id IN (1, 3)
AND price >= 40000
AND is_active = 1;

/*
5.
판매 중인 상품을 **가격 내림차순, 상품 ID 오름차순**으로 정렬했을 때 **두 번째 페이지**에 해당하는 5개를 조회한다.
한 페이지는 5개이며, 첫 페이지는 1~5위이다.
*/
SELECT
	product_id,
    product_name AS '상품명',
    price AS '가격'
FROM products
WHERE is_active = 1
ORDER BY price DESC, product_id ASC LIMIT 5 OFFSET 5;

/*
6.
**9월 1일 00:00:00 이상, 10월 1일 00:00:00 미만**의 주문 중 `CANCELLED`를 제외한 주문의 ID,
고객 ID, 주문 시각, 상태를 조회한다. 주문 시각 오름차순. (`DATETIME` 필터 실습)
*/
SELECT *
FROM orders;

SELECT
	order_id,
	customer_id,
    ordered_at,
    status
FROM orders
WHERE ordered_at >= '2026-09-01' AND ordered_at < '2026-10-01'
AND status NOT IN ('CANCELLED')
ORDER BY ordered_at ASC;

/*
7.
고객이 거주하는 서로 다른 `region`을 중복 없이 조회하고, 지역명 오름차순으로 정렬한다.
*/
SHOW TABLES;

DESC customers;

SELECT *
FROM customers;

SELECT DISTINCT region
FROM customers
ORDER BY region ASC;

## LEVEL 2 — 실무에서 가장 많이 쓰는 JOIN (8~14)

/*
08.
모든 주문의 `order_id`, `ordered_at`, `status`, `customer_name`, `email`을 한 번에 출력한다.
최신 주문 순.
*/
SELECT *
FROM orders;

SELECT *
FROM customers;

SELECT
	order_id,
    ordered_at AS '주문 날짜',
    status AS '현재 주문 상태',
    customer_name,
    email
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.ordered_at DESC;

SELECT
	COUNT(*)
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.ordered_at DESC;


/*
09.
상품별로 상품명, 카테고리명, 가격을 출력한다. **판매 중인 상품**만 대상으로 한다.
*/
SELECT *
FROM products;

SELECT *
FROM categories;

SELECT
	p.product_name AS '상품명',
    c.category_name AS '카테고리명',
    p.price AS '가격'
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = 1;

SELECT
	COUNT(*)
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = 1;

/*
10.
`order_id = 24`인 주문에 포함된 **상품명, 수량, 주문 당시 단가, 품목별 금액(수량×단가)**을 출력한다.
JOIN으로 필요한 정보를 연결한다.
*/

SELECT *
FROM orders;

SELECT *
FROM order_items;

SELECT *
FROM products;

SELECT
	p.product_name AS '상품명',
    oi.quantity AS '수량',
    oi.unit_price AS '주문 단가',
    oi.quantity * oi.unit_price AS '품목별 금액'
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = 24;


/*
11.
한 번도 주문하지 않은 고객의 ID, 이름, 이메일을 조회한다. `LEFT JOIN`과 `IS NULL`을 활용해 보자.
*/
SELECT
	c.customer_id AS '고객 ID',
    c.customer_name AS '이름',
    c.email AS '이메일'
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

/*
12.
`COMPLETED` 또는 `SHIPPED` 상태의 주문이 **한 건도 없는 고객**의 ID와 이름을 조회한다.
**취소 주문만 있는 고객은 결과에 포함**되어야 한다. (11번과 차이에 주의)
*/
SELECT *
FROM orders;

SELECT
	c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id -- 한번도 주문하지 않은 고객을 고려해야하니 LEFT JOIN 활용
GROUP BY c.customer_id, c.customer_name
HAVING SUM(CASE
				WHEN status IN ('COMPLETED', 'SHIPPED') THEN 1
                ELSE 0
			END) = 0; -- COMPLETED, SHIPPED를 이력이 아예 없는것 고려(이때 레프트 조인으로 인해 주문 안한 고객도 한번에 처리 가능)


/*
13.
`order_items`에 한 번도 등장하지 않은 상품의 ID와 이름을 조회한다.
판매 여부는 상관없다.
*/
SELECT *
FROM order_items;

SELECT
	p.product_id,
	p.product_name AS '상품 이름'
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

/*
14.
모든 고객의 ID, 이름, 총 주문 건수를 출력한다. **주문이 0건인 고객도 표시**한다.
주문 건수 내림차순, 고객 ID 오름차순.
*/

SELECT
	c.customer_id,
    c.customer_name AS '고객 이름',
    SUM(CASE
				WHEN o.order_id IS NOT NULL THEN 1
                ELSE 0
		END) AS `총 주문 건수`
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY `총 주문 건수` DESC, c.customer_id ASC;
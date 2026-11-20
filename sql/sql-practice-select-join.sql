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

/*
15.
각 주문 상태(`status`)별 주문 건수를 조회한다. `status`, `order_count`를 출력한다.
*/
SHOW TABLES;

SELECT *
FROM orders;

SELECT
	status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status;

/*
16.
고객별로 **유효 주문(`COMPLETED`, `SHIPPED`)의 총 주문 금액**을 계산한다. 고객 ID, 이름, 유효 주문 건수, 총 매출액을 출력한다.
유효 주문이 없는 고객은 제외한다.
주문 건수를 세는 과정에서 상세 품목 수 때문에 **중복 집계되지 않도록 주의**한다.
*/

SHOW TABLES;

SELECT *
FROM orders;

SELECT *
FROM customers;

SELECT *
FROM order_items;

SELECT
	c.customer_id AS '고객 ID',
    c.customer_name AS '이름',
    COUNT(DISTINCT o.order_id) AS '주문 건수', -- order_items 테이블이랑 조인 할 때 , 건수를 그냥 조회하면 상세 품목 수로 인해 오버카운팅 발생으로 인한 문제 방지.
    SUM(oi.quantity * oi.unit_price) AS 'total_sales'
    -- GROUP BY c.customer_id, c.customer_name으로 해야 그룹핑을 할 때 컬럼 조회가 가능함.
    -- 그리고 c.customer_id는 프라이머리 키라 외래키랑 연결할 때, 1:N의 관계가 가능해서 정상적으로 total_sales의 값이 나옴.
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.customer_id, c.customer_name;

/*
17.

16번 결과 중 유효 주문 매출 합계가 **150,000원 이상**인 고객만 조회한다.
매출액 내림차순.
*/
SELECT
	c.customer_id AS '고객 ID',
    c.customer_name AS '이름',
    COUNT(DISTINCT o.order_id) AS '주문 건수', -- order_items 테이블이랑 조인 할 때 , 건수를 그냥 조회하면 상세 품목 수로 인해 오버카운팅 발생으로 인한 문제 방지.
    SUM(oi.quantity * oi.unit_price) AS `매출액`
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.customer_id, c.customer_name
HAVING SUM(oi.quantity * oi.unit_price) >= 150000
ORDER BY `매출액` DESC;

/*
18.
유효 주문을 기준으로 카테고리 이름, 판매 수량 합계, 매출액 합계를 출력한다. **상품 가격이 아닌 주문 상세 단가**를 사용한다.
매출액 내림차순.
*/
SELECT *
FROM products;

SELECT *
FROM categories;

SELECT *
FROM orders;

SELECT *
FROM order_items;

SELECT
	c.category_name AS '카테고리 이름',
    SUM(oi.quantity) AS '판매수량 합계',
    SUM(oi.quantity * oi.unit_price) AS `매출액`
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.category_name
ORDER BY `매출액` DESC;

/*
19.
유효 주문이 있는 고객별로 **주문 한 건당 평균 금액**을 계산한다.
주문 금액은 품목을 합산한 뒤 평균을 내야 한다. 고객 ID, 이름, 평균 주문 금액을 출력한다.
소수 둘째 자리까지 반올림한다.
*/

SELECT
	c.customer_id,
    c.customer_name AS '고객 이름',
    ROUND(SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id), 2) AS '평균 주문 금액'
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.customer_id, c.customer_name;

-- ROUND(AVG(oi.quantity * oi.unit_price), 2) AS '평균 주문 금액' (이렇게 하면 주문 건 당이 아님.)

/*
예를 들어서, 주문을 케이크 1개(9000원), 커피 1잔(4500원) 이렇게 한다면
13500원이니까 주문 1건임. 근데 9000원, 4500원을 각각 하나의 주문으로 인식해서 계산한 것임 위의 계산 방법이 그럼.
*/

/*
20.
유효 주문 기준 **2026년 7월·8월·9월·10월**의 월별 주문 건수와 매출 합계를 출력한다.
`YYYY-MM` 형태의 월을 표시하고 시간순으로 정렬한다
*/

SELECT *
FROM orders;

SELECT *
FROM order_items;

SELECT
	DATE_FORMAT(o.ordered_at, '%Y-%m') AS 'month',
	COUNT(DISTINCT o.order_id) AS '월별 주문 건수', -- 여기서 DISTINCT를 쓰지 않으면 한 주문당이 아님 주문에 있는 품목 당임.
    SUM(oi.quantity * oi.unit_price) AS '매출 합계'
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status IN ('COMPLETED', 'SHIPPED') AND (DATE_FORMAT(o.ordered_at, '%Y-%m') >= '2026-07' AND DATE_FORMAT(o.ordered_at, '%Y-%m') < '2026-11')
GROUP BY DATE_FORMAT(o.ordered_at, '%Y-%m') -- 년,월만 나오게 하는 함수
ORDER BY DATE_FORMAT(o.ordered_at, '%Y-%m') ASC;

/*
21.
모든 고객 중 **취소 주문을 포함한 전체 주문 건수**가 많은 상위 5명을 조회한다. 동률 시 고객 ID 오름차순으로 정렬한다.
고객 ID, 이름, 주문 건수를 출력한다.
*/

SELECT
	c.customer_id AS '고객 ID',
    c.customer_name AS '이름',
    COUNT(*) AS `주문 건수`
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY `주문 건수` DESC, c.customer_id LIMIT 5; -- 많은 순이니까 내림 차순이면서 상위 5명.

/*
22.
`payments`에서 `payment_status='PAID'`만 대상으로 결제 수단별 결제 건수와 결제 금액 합계를 출력한다.
결제 금액 내림차순.
*/

SELECT *
FROM payments;

SELECT
	payment_method AS '결제 수단',
	COUNT(*) AS '결제 건수',
    SUM(amount) AS '결제 금액 합계'
FROM payments
WHERE payment_status = 'PAID'
GROUP BY payment_method
ORDER BY SUM(amount) DESC;

/*
23.
판매 중인 상품을 `CASE`로 다음처럼 분류한다.
**3만원 미만 → '저가'**, **3만원 이상 8만원 미만 → '중가'**,
**8만원 이상 → '고가'**. 상품명, 가격, 가격대(`price_band`)를 출력한다.
*/

SELECT *
FROM products;

SELECT
	product_name AS '상품명',
	price AS '가격',
    CASE
		WHEN price < 30000 THEN '저가'
        WHEN price >= 30000 AND price < 80000 THEN '중가'
        WHEN price >= 80000 THEN '고가'
    END AS 'price_band'
FROM products
WHERE is_active = 1;

SELECT COUNT(*)
FROM products
WHERE is_active = 1;

/*
24.
주문 ID, 주문 상태 코드, 상태명을 출력한다.
`PENDING=접수`, `SHIPPED=배송중`, `COMPLETED=완료`, `CANCELLED=취소`로 표시한다.
*/

SELECT *
FROM orders;

SELECT
	order_id,
    status,
    CASE status
		WHEN 'PENDING' THEN '접수'
        WHEN 'SHIPPED' THEN '배송중'
        WHEN 'COMPLETED' THEN '완료'
        WHEN 'CANCELLED' THEN '취소'
    END AS '주문 상태'
FROM orders;

/*
25.
고객별 `COMPLETED`, `SHIPPED`, `PENDING`, `CANCELLED` 주문 건수를 **각각 별도의 컬럼**으로 표시한다.
고객 ID, 고객명, 4가지 상태별 건수를 출력한다. 주문이 없는 고객도 0건으로 표시한다.
*/

SELECT
	c.customer_id,
    c.customer_name,
    SUM(CASE WHEN o.status = 'COMPLETED' THEN 1 ELSE 0 END) AS 'COMPLETED',
    SUM(CASE WHEN o.status = 'SHIPPED' THEN 1 ELSE 0 END) AS 'SHIPPED',
    SUM(CASE WHEN o.status = 'PENDING' THEN 1 ELSE 0 END) AS 'PENDING',
    SUM(CASE WHEN o.status = 'CANCELLED' THEN 1 ELSE 0 END) AS 'CANCELLED'
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

/*
26.
카테고리별로 **완료 주문에서 판매된 수량**, **배송중 주문에서 판매된 수량**을 각각 출력한다.
*/

SELECT *
FROM order_items;

SELECT
	c.category_name,
    SUM(CASE WHEN o.status = 'COMPLETED' THEN oi.quantity ELSE 0 END) AS 'completed_quantity', -- 주문 건 수를 따지려는게 아니라 주문 안에 있는 수량을 따져야함.
    SUM(CASE WHEN o.status = 'SHIPPED' THEN oi.quantity ELSE 0 END) AS 'shipped_quantity'
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.category_name;

/*
27.
각 고객의 유효 주문 총매출에 따라 `VIP(300,000원 이상)`,
`GOLD(150,000원 이상 300,000원 미만)`, `NORMAL(150,000원 미만)`로 분류한다.
유효 주문이 없는 고객은 `NORMAL`이다.
고객 ID, 이름, 총매출, 등급을 출력한다.
*/

SELECT *
FROM customers;

SELECT *
FROM orders;

SELECT *
FROM order_items;

SELECT *
FROM orders; -- COMPLETED, SHIPPED만 유효 주문

SELECT *
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_name = '서예린';

SELECT *
FROM order_items;

SELECT *
FROM orders;

SELECT
	c.customer_id,
    c.customer_name,
    SUM(CASE
			WHEN o.status IN ('COMPLETED', 'SHIPPED') THEN oi.unit_price * oi.quantity
            ELSE 0 -- CASE문을 이용해서 위에 조건을 걸어둔 상태값 외에는 무조건 0으로 취급.
         END)
    AS total_sales,
    CASE
		WHEN SUM(CASE
			WHEN o.status IN ('COMPLETED', 'SHIPPED') THEN oi.unit_price * oi.quantity
            ELSE 0
			END) >= 300000 THEN 'VIP'
        WHEN SUM(CASE
			WHEN o.status IN ('COMPLETED', 'SHIPPED') THEN oi.unit_price * oi.quantity
            ELSE 0
		END) >= 150000 THEN 'GOLD'
        ELSE 'NORMAL'
		END AS 'GRADE'  -- total_sales를 이용하지 못하니까 CASE문으로 등급 정리
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id -- 한번도 주문하지 않은 고객의 정보가 나와야하므로 LEFT JOIN을 이용한다.
LEFT JOIN order_items oi ON o.order_id = oi.order_id -- 여기서 JOIN을 쓰면 조건에 맞는 데이터만 조회된다. LEFT JOIN 사용하기.
GROUP BY c.customer_id, c.customer_name;

/*
28.
전체 상품의 평균 판매 가격보다 비싼 상품의 이름, 가격을 조회한다.
비활성 상품도 평균 계산에 포함한다.
*/

SELECT *
FROM products;

SELECT
	product_name,
	price
FROM products
WHERE price > (SELECT AVG(price)
				FROM products);

/*
29.
**유효 주문을 한 번이라도 생성한 고객**의 ID, 이름을 조회한다.
결과에 고객이 중복되면 안 된다.
*/

SELECT *
FROM orders;

SELECT DISTINCT
	c.customer_id,
    c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('COMPLETED', 'SHIPPED')
ORDER BY c.customer_id ASC;

/*
30.
전체 주문 중 가장 최신 주문 시각과 동일한 시각에 주문한 고객의 ID, 이름, 주문 시각을 조회한다.
*/

SELECT *
FROM orders;

SELECT MAX(ordered_at)
FROM orders;

SELECT
	c.customer_id AS '고객 ID',
    c.customer_name AS '이름',
    o.ordered_at AS '주문 시각'
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.ordered_at IN (SELECT MAX(ordered_at) FROM orders);

/*
31.
각 상품의 가격이 자기 카테고리 상품 평균 가격보다 높은 상품만 조회한다.
상품명, 카테고리 ID, 가격을 출력한다.
*/

SHOW TABLES;

SELECT *
FROM products;

SELECT *
FROM categories;

SELECT
	   p.product_name AS '상품명',
	   p.category_id,
       p.price AS '가격'
FROM products p
JOIN (SELECT
			category_id,
            AVG(price) AS '평균가'
		FROM products
        GROUP BY category_id) cmp ON p.category_id = cmp.category_id
WHERE p.price > cmp.평균가;

/*
33.
유효 주문의 주문 ID, 고객 ID, 주문 시각, 주문 상태, 주문 총액을 반환하는 v_valid_order_totals VIEW를 만든다.
생성 뒤 VIEW에서 금액이 가장 큰 주문 5개를 조회한다.
뷰의 SELECT에 주문 상세를 합산해야 한다.
*/

SHOW TABLES;

SELECT *
FROM orders;

SELECT *
FROM order_items;


CREATE VIEW v_valid_order_totals AS (
SELECT
	o.order_id,
    c.customer_id,
    o.ordered_at,
    o.status,
    cmp.주문당금액
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN (SELECT
			order_id,
            SUM(unit_price * quantity) AS '주문당금액'
		FROM order_items
        GROUP BY order_id) cmp ON o.order_id = cmp.order_id
WHERE o.status IN ('COMPLETED', 'SHIPPED')
);

DROP VIEW IF EXISTS v_valid_order_totals;

SELECT *
FROM v_valid_order_totals
ORDER BY 주문당금액 DESC LIMIT 5;

/*
34.
주문 화면에서 customer_id = 2이고 ordered_at이 2026년 7월 1일 이상 2026년 10월 1일 미만인 주문을 최신순으로 조회한다고 가정한다.
(1) 조회 SQL 작성,
(2) EXPLAIN 실행,
(3) orders(customer_id, ordered_at) 복합 인덱스 생성,
(4) EXPLAIN 재실행. 어떤 인덱스가 후보에 올라왔는지 비교한다.
샘플 데이터가 작아 옵티마이저가 인덱스를 선택하지 않을 수도 있다.
*/

SELECT *
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id = 2 AND (DATE(ordered_at) >= '2026-07-01' AND DATE(ordered_at) < '2026-10-01')
ORDER BY o.ordered_at DESC;

EXPLAIN
SELECT *
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id = 2 AND (DATE(ordered_at) >= '2026-07-01' AND DATE(ordered_at) < '2026-10-01')
ORDER BY o.ordered_at DESC;

CREATE INDEX ordered_at_idx ON orders(customer_id, ordered_at DESC);

EXPLAIN
SELECT *
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id = 2 AND (DATE(ordered_at) >= '2026-07-01' AND DATE(ordered_at) < '2026-10-01')
ORDER BY o.ordered_at DESC;

/*
35.
제품 ID가 10인 상품의 재고를 3개 차감한다.
단, 재고가 3개 이상일 때만 차감되도록 쿼리를 작성한다.
차감 직후 SELECT로 재고를 확인한다.
반복 실행 시 재고가 계속 줄어들 수 있으니 주의한다.
*/

SELECT *
FROM products;

UPDATE products
SET stock = stock - 3
WHERE stock >= 3 AND product_id = 10;

SELECT *
FROM products
WHERE product_id = 10;

/*
36.
- 등록된 모든 상품 카테고리에 속한 상품들을 단 한 번이라도 유효 주문에
포함시켜 구매해 본 적이 있는 고객을 찾는다.

- 해당 조건을 만족하는 customer_id, customer_name, email을 조회한다.

- 정렬 조건은 customer_id 오름차순이다.
*/

SELECT *
FROM order_items;

SELECT *
FROM orders;

SELECT *
FROM customers;

SELECT *
FROM categories;

SELECT *
FROM products;

SELECT DISTINCT
	c.customer_id,
    c.customer_name,
    c.email
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
-- JOIN categories ca ON p.category_id = ca.category_id
WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.customer_id, c.customer_name, c.email
HAVING COUNT(DISTINCT p.category_id) >= 4 -- 이렇게 작성을 해야 고객이 주문한 카테고리가 중복으로 카운트 안된다.
ORDER BY c.customer_id ASC;

/*
37. 지역별 평균 매출을 초과한 고객 조회

쇼핑몰에서는 지역별 고객의 구매 실적을 비교하려고 한다.
각 고객의 유효 주문 총매출이 해당 고객이 속한 지역의 고객 1인당 평균 유효 매출보다 높은 고객을 조회한다.

요구사항은 다음과 같다.
- 유효 주문은 COMPLETED, SHIPPED만 인정한다.
- 유효 주문이 없는 고객도 지역 평균 계산에 포함하며, 해당 고객의 매출은 0원으로 취급한다.
- 지역 평균은 해당 지역 전체 고객의 유효 매출 합계를 해당 지역 전체 고객 수로 나눈 값이다.
- 자신의 지역 평균보다 매출이 높은 고객만 인정한다.
- 지역 평균 매출은 소수점 둘째 자리까지 반올림하여 출력한다.
- 총매출 내림차순으로 정렬하고, 동률이면 고객 ID 오름차순으로 정렬한다.

출력 컬럼은 다음과 같다.
- customer_id, customer_name, region, total_sales, region_avg_sales
*/

SELECT *
FROM customers;

SELECT *
FROM order_items;

SELECT *
FROM products;

SELECT *
FROM orders;

/*
SELECT *
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN (SELECT
	c.region,
	ROUND((SUM(CASE
		WHEN o.status IN ('COMPLETED', 'SHIPPED') THEN oi.unit_price * oi.quantity
        ELSE 0
        END) / COUNT(c.customer_id)), 2)
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
-- WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.region) cmp ON cmp.region = c.region
WHERE o.status IN ('COMPLETED', 'SHIPPED')
*/

SELECT
	c.customer_id,
    c.customer_name,
    c.region,
    SUM(oi.unit_price * oi.quantity) AS '총 매출',
    `지역별 매출`
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN (SELECT
	c.region,
	ROUND((SUM(CASE
		WHEN o.status IN ('COMPLETED', 'SHIPPED') THEN oi.unit_price * oi.quantity
        ELSE 0
        END) / COUNT(DISTINCT c.customer_id)), 2) AS `지역별 매출` -- 여기서 DISTINCT를 작성해서 평균 매출을 정상적으로 나오게한다. c.customer_id가 여러번 등록된다.
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id -- customer_id 여러번 중복
-- WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.region) cmp ON cmp.region = c.region
WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.customer_id, c.customer_name, c.region, `지역별 매출`
HAVING SUM(oi.unit_price * oi.quantity) > `지역별 매출`
ORDER BY `총 매출` DESC, c.customer_id ASC;

-- 지역별 평균 매출 금액 (소수점 아래 둘째 자리까지만)
SELECT
	c.region,
	ROUND((SUM(CASE
		WHEN o.status IN ('COMPLETED', 'SHIPPED') THEN oi.unit_price * oi.quantity
        ELSE 0
        END) / COUNT(c.customer_id)), 2)
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
-- WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.region;

SELECT *
FROM customers;

SELECT *
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE c.region = '대전';

/*
38. 카테고리별 매출 1위 상품 조회

쇼핑몰에서는 각 카테고리에서 가장 높은 매출을 기록한 상품을 파악하려고 한다.

카테고리별로 유효 주문 매출액이 가장 높은 상품을 조회한다.

요구사항
- 유효 주문은 COMPLETED, SHIPPED만 인정한다.
- 매출액은 주문 당시 단가(unit_price)와 수량(quantity)을 기준으로 계산한다.
- 상품의 현재 판매 가격(products.price)은 매출 계산에 사용하지 않는다.
- 한 상품이 여러 주문에 포함되어 있다면 모든 유효 주문의 매출을 합산한다.
- 유효 주문 이력이 없는 상품의 매출은 0원으로 취급한다.
- 카테고리 내에서 매출액이 가장 높은 상품만 조회한다.
- 매출액이 동일한 공동 1위 상품이 있다면 모두 조회해야 한다.
- 카테고리 ID 오름차순, 동일 카테고리 내에서는 상품 ID 오름차순으로 정렬한다.

출력 컬럼
category_id, category_name, product_id, product_name, total_quantity, total_sales
*/

/*
내일 다시 해결 해 볼 것.
지금 문제점 -> 카테고리별 최고 매출 뽑아내지 못함.
		 -> 카테고리 아이디를 기반으로 조인을 했을 때 말도 안되는 양의 데이터가 나옴.
         -> 공동 1위 상품이 있을 때 모두 조회 해결 x
*/

-- WITH를 사용한 이유 => total_sales를 재사용하기 위함.
WITH category_products_total_sales AS (
SELECT
	c.category_id,
	c.category_name,
	cmp.product_id,
	cmp.product_name,
	cmp.total_quantity,
    cmp.total_sales
FROM categories c
-- JOIN order_items oi ON o.order_id = oi.order_id 여기서 JOIN을 쓰지 않은 이유는 과다하게 데이터가 중복 될 수 있어서 주석 처리함.
-- JOIN products p ON oi.product_id = p.product_id
-- JOIN categories c ON p.category_id = c.category_id
JOIN (SELECT
			c2.category_id,
            c2.category_name,
            p2.product_id,
            p2.product_name,
            SUM(CASE
					WHEN o2.status IN ('COMPLETED', 'SHIPPED') THEN oi2.quantity
                    ELSE 0
				END) AS `total_quantity`, -- 주문을 취소한것도 0으로 취급. 유효 주문이 아니므로.
            SUM(CASE
					WHEN o2.status IN ('COMPLETED', 'SHIPPED') THEN oi2.unit_price * oi2.quantity
                    ELSE 0
				END) AS `total_sales`
		FROM orders o2
		JOIN order_items oi2 ON o2.order_id = oi2.order_id
		RIGHT JOIN products p2 ON oi2.product_id = p2.product_id -- 여기서 RIGHT JOIN을 사용한 이유는 아예 주문하지 않은 상품도 매출 0으로 포함시켜야 하기 때문.
		JOIN categories c2 ON p2.category_id = c2.category_id
        GROUP BY c2.category_id, c2.category_name, p2.product_id, p2.product_name
        ORDER BY c2.category_id ASC, total_sales DESC) cmp ON c.category_id = cmp.category_id
)

SELECT *
FROM category_products_total_sales
WHERE (category_id, total_sales) IN (SELECT
							category_id,
							MAX(total_sales)
						FROM category_products_total_sales
                        GROUP BY category_id, category_name) -- 여기서 카테고리 아이디까지 비교해야한다.
-- 만약에 total_sales로만 비교하면 문제가 되는게 전자기기, 도서에서 둘다 200000인 경우가 있으면 두 경우가 다 조회된다.
ORDER BY category_id ASC, product_id ASC;


/*
SELECT
	c.category_id,
	c.category_name,
	p.product_id,
	p.product_name,
	cmp.total_quantity,
	cmp.total_sales,
	o.status,
	o.order_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN (SELECT
			c2.category_id,
            c2.category_name,
            p2.product_name,
            SUM(oi2.quantity) AS `total_quantity`, -- 주문을 취소하든 PENDING 상태든 QUANTITY는 그대로 두기. (매출액만 0으로)
            SUM(CASE
					WHEN o2.status IN ('COMPLETED', 'SHIPPED') THEN oi2.unit_price * oi2.quantity
                    ELSE 0
				END) AS `total_sales`
		FROM orders o2
		JOIN order_items oi2 ON o2.order_id = oi2.order_id
		JOIN products p2 ON oi2.product_id = p2.product_id
		JOIN categories c2 ON p2.category_id = c2.category_id
        GROUP BY c2.category_id, c2.category_name, p2.product_name
        ORDER BY c2.category_id ASC, total_sales DESC) cmp ON c.category_id = cmp.category_id;
*/

SELECT *
FROM products;

SELECT *
FROM order_items;

SELECT *
FROM categories;

SELECT *
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id; -- order_id를 외래키로 쓰기 때문에 한 주문에 어떤 물품을 주문했는지 다 볼 수 있다.

SELECT *
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
ORDER BY o.order_id, oi.order_item_id;

/*
SELECT *
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.status IN ('COMPLETED', 'SHIPPED')
GROUP BY c.category_id, c.category_name
*/

SELECT *
FROM order_items;

SELECT *
FROM products;

/*
SELECT
	DISTINCT c.category_id, c.category_name, p.product_id, p.product_name, cmp.total_quantity, cmp.total_sales, o.status, o.order_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN (SELECT
			c2.category_id,
            c2.category_name,
            p2.product_name,
            SUM(oi2.quantity) AS `total_quantity`,
            SUM(oi2.unit_price * oi2.quantity) AS `total_sales`
		FROM orders o2
		JOIN order_items oi2 ON o2.order_id = oi2.order_id
		JOIN products p2 ON oi2.product_id = p2.product_id
		JOIN categories c2 ON p2.category_id = c2.category_id
        WHERE o2.status IN ('COMPLETED', 'SHIPPED')
        GROUP BY c2.category_id, c2.category_name, p2.product_name
        ORDER BY SUM(oi2.unit_price * oi2.quantity) DESC) cmp ON c.category_id = cmp.category_id;
*/

-- 카테고리 아이디와 카테고리 이름으로 묶어서 가장 매출액 높은 물품 뽑아내기


SELECT *
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;
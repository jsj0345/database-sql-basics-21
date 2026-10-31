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
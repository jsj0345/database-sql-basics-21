/*
1.
user 테이블에는 고객의 주소, 생년월일과 같은 민감한 정보가 포함되어 있다.
마케팅팀에서는 고객에게 이메일을 보내기 위해 이름과 이메일 주소만 필요하다.

보안을 위해 고객의 user_id, name, email 컬럼만을 포함하는 v_customer_email_list라는 이름의
뷰를 생성하세요.
*/

CREATE VIEW v_customer_email_list AS
SELECT
	u.user_id,
    u.name AS '고객명',
    u.email
FROM users u;

SELECT *
FROM v_customer_email_list;

/*
2.
운영팀에서는 현재 주문 내역을 확인할 때마다 orders, users, products 테이블을 매번 JOIN해야 해서 불편함을 겪고 있다.

주문 ID(order_id), 고객 이름(name), 상품 이름(name), 주문 수량(quantity), 주문 상태(status)를
한 번에 볼 수 있는 v_order_summary 라는 이름의 뷰를 생성하여 업무 효율을 높여라.
*/

SELECT
	o.order_id,
    u.name AS '고객명',
    p.name AS '상품명',
	o.quantity AS '주문 수량',
    o.status AS '주문 상태'
FROM orders o
JOIN users u ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id;

CREATE VIEW v_order_summary AS
SELECT
	o.order_id,
    u.name AS '고객명',
    p.name AS '상품명',
	o.quantity AS '주문 수량',
    o.status AS '주문 상태'
FROM orders o
JOIN users u ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id;

SELECT *
FROM v_order_summary;

/*
3.
전략기획팀은 '전자기기' 카테고리의 상품들에 대한 주문 건수와 총매출액을 집중적으로 분석하고자 한다.

products 테이블과 orders 테이블을 JOIN하여, '전자기기' 카테고리에 속한 상품들의 총 주문 건수(total_orders)와
총 매출액(total_sales)을 계산하는 v_electronics_sales_status 뷰를 생성해라.
*/

SELECT
	p.category,
	COUNT(*) AS 'total_orders',
    SUM(price * quantity) AS 'total_sales'
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE p.category = '전자기기'
GROUP BY p.category;

CREATE VIEW v_electronic_sales_status AS
SELECT
	p.category,
	COUNT(*) AS 'total_orders',
    SUM(price * quantity) AS 'total_sales'
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE p.category = '전자기기'
GROUP BY p.category;

SELECT *
FROM v_electronic_sales_status;

/*
4.
방금 문제에서 만들었던 뷰에서 평균 주문액도 함께 보고싶다는 추가 요청이 왔다.
기존 뷰를 수정하고 총 주문 건수, 총 매출액, 그리고 평균 주문액을 보여주도록 변경해보자.
*/

ALTER VIEW v_electronic_sales_status AS
SELECT
	p.category,
	COUNT(*) AS 'total_orders',
    SUM(price * quantity) AS 'total_sales',
    AVG(price * quantity) AS 'average_order_value'
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE p.category = '전자기기'
GROUP BY p.category;

SELECT *
FROM v_electronic_sales_status;
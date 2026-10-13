/*
1.
products 테이블에서 상품의 category 컬럼 값을 영문으로 변경하여 조회해라.
'전자기기'는 'Electronics', '도서'는 'Books',
'패션'은 'Fashion'으로 표시하고, category_english 라는 별칭을 사용해라.
상품 이름, 원래 카테고리, 그리고 영문 카테고리를 함께 출력해야 한다.
*/

USE my_shop2;

SELECT
	name,
    category,
    CASE category
		WHEN '전자기기' THEN 'Electronics'
        WHEN '도서' THEN 'Books'
        WHEN '패션' THEN 'Fashion'
    ELSE '이외 카테고리'
    END AS 'category_english'
FROM products;

/*
2.
orders 테이블의 주문들을 수량에 따라 분류하고 싶다.
수량이 2개 이상이면 '다량 주문', 1개이면 '단일 주문'으로 표시하는
order_type 컬럼을 만들어라.
주문 ID, 수량, order_type 컬럼을 조회 하되, '다량 주문'이
'단일 주문'보다 먼저 나오도록 정렬해라.
*/

SELECT
	o.order_id,
    o.quantity,
    CASE
		WHEN o.quantity>=2 THEN '다량 주문'
        WHEN o.quantity>=1 THEN '단일 주문'
    END AS order_type
FROM orders o
ORDER BY
	CASE
		WHEN o.quantity>=2 THEN 1
        WHEN o.quantity>=1 THEN 2
    END ASC;

/*
3.
products 테이블의 상품들을 재고 수량에 따라 그룹화하여 각 그룹에 속한 상품의 수를 세어보아라.

재고가 50개 이상이면 '재고 충분'
20개 이상 50개 미만이면 '재고 보통'
20개 미만이면 '재고 부족'

stock_level과 product_count라는 컬럼명으로 결과를 출력해야 한다.
*/

SELECT *
FROM products;

SELECT
	CASE
		WHEN stock_quantity >= 50 THEN '재고 충분'
        WHEN stock_quantity >= 20 AND stock_quantity < 50 THEN '재고 보통'
        ELSE '재고 부족'
    END AS stock_level,
    COUNT(*) AS product_count
FROM products
GROUP BY
	CASE
		WHEN stock_quantity >= 50 THEN '재고 충분'
        WHEN stock_quantity >= 20 AND stock_quantity < 50 THEN '재고 보통'
        ELSE '재고 부족'
    END;

/*
4.
각 사용자가 카테고리별로 몇 건의 주문을 했는지 피벗 테이블 형태로 조회해라.
사용자 이름, 총 주문 건수, '전자기기' 주문 건수, '도서', '패션' 주문 건수를 각각 user_name, total_orders,
electronic_orders, book_orders, fashion_orders 컬럼으로 출력해야 한다. 한 번도 주문하지 않은 고객도 결과에 포함해야 한다.
*/

SELECT *
FROM users;

SELECT *
FROM orders;

SELECT *
FROM products;

SELECT
	u.name AS user_name,
	COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN p.category = '전자기기' THEN 1 ELSE 0 END) AS electronic_orders,
    SUM(CASE WHEN p.category = '도서' THEN 1 ELSE 0 END) AS book_orders,
    SUM(CASE WHEN p.category = '패션' THEN 1 ELSE 0 END) AS fashion_orders
FROM users u
LEFT JOIN orders o ON o.user_id = u.user_id
LEFT JOIN products p ON o.product_id = p.product_id
GROUP BY u.name;

/*
GROUP BY 와 CASE

GROUP BY u.name을 사용하면 사용자 이름이 같은 행들이 하나의 그룹으로 묶여.
해당 그룹에는 여러 주문 내역이 존재하고, 각 주문에는 category 값도 존재하겠지.
그런데 SELECT p.category처럼 일반 컬럼을 그대로 조회하면 그룹 안에 여러 값이 있으므로 어떤 값을 반환해야 할지 모호해.
하지만 그룹으로 묶였다고 해서 개별 행의 데이터가 사라지는 건 아니야.
따라서 SUM(), COUNT(), MAX() 같은 집계 함수는 그룹에 속한 여러 행의 컬럼 값을 이용해서 하나의 결과를 계산할 수 있어.
*/
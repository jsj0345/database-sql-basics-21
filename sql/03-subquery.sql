SELECT AVG(price)
FROM products;

SELECT name,
	price
FROM products
WHERE price > 167166.6667;

SELECT name,
	price
FROM products
WHERE price > (SELECT AVG(price)
				FROM products);

SELECT *
FROM users;

SELECT *
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.order_id = 1;

SELECT name, address
FROM users
WHERE address = '서울시 강남구';

SELECT name
FROM users
WHERE address = (SELECT u.address
				FROM orders o
				JOIN users u ON o.user_id = u.user_id
				WHERE o.order_id = 1);

-- "서울 또는 성남에 사는 고객의 주소를 모두 조회"
SELECT *
FROM users;

SELECT address
FROM users
WHERE address LIKE '%서울%'
OR address LIKE '%성남%';

SELECT address
FROM users
WHERE name IN ('션', '네이트');

SELECT name, address
FROM users
WHERE address IN (SELECT address
			FROM users
			WHERE name IN ('션', '네이트'));

SELECT DISTINCT address
FROM users
WHERE address IN (SELECT address
			FROM users
			WHERE address LIKE '%서울%'
			OR address LIKE '%성남%');

-- '전자기기' 카테고리에 속한 모든 상품들을 주문한 주문 내역 전부 보기
SELECT o.*,
		p.name
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE p.category = '전자기기';

SELECT product_id
FROM products
WHERE category = '전자기기'
ORDER BY product_id;

SELECT *
FROM orders
WHERE product_id IN (1, 2, 3, 6)
ORDER BY order_id;

SELECT *
FROM orders
WHERE product_id IN (SELECT product_id
						FROM products p
                        WHERE p.category = '전자기기'
					)
ORDER BY order_id;

/*
'전자기기' 카테고리에 있는 상품들보다 비싼 상품들은
어떤 것들이 있는지 리스트를 뽑기.
*/

SELECT p.name, p.price
FROM products p
WHERE p.price > ANY (SELECT price
					FROM products
                    WHERE category = '전자기기');

-- > ANY 를 쓴 쿼리를 대체할 수 있는 쿼리
SELECT p.name, p.price
FROM products p
WHERE p.price > (SELECT MIN(price)
                    FROM products
                    GROUP BY category
                    HAVING category = '전자기기');

SELECT p.name, p.price
FROM products p
WHERE p.price > ALL (SELECT price
					FROM products
                    WHERE category = '전자기기');

SELECT p.name, p.price
FROM products p
WHERE p.price > (SELECT MAX(price)
				FROM products
				WHERE category = '전자기기');

/*
쇼핑몰의 고객 "네이트가 한 주문이 있다. 이 주문과
동일한 고객이면서 주문 처리 상태도 같은 모든 주문을 찾아보자."
*/

SELECT user_id, status
FROM orders WHERE order_id = 3;

SELECT *
FROM orders
WHERE (user_id, status) = (2, 'SHIPPED');

SELECT *
FROM orders
WHERE (user_id, status) = (SELECT user_id, status
FROM orders WHERE order_id = 3);

SELECT *
FROM orders
WHERE (user_id, status) IN (SELECT u.user_id,
								status
                           FROM orders o
                           JOIN users u ON o.user_id = u.user_id
                           WHERE u.name = '네이트' AND o.status = 'SHIPPED');

SELECT user_id, min(order_date)
FROM orders
GROUP BY user_id;

SELECT
	o.order_id,
    o.user_id,
    o.order_date,
    u.name,
    p.name AS product_name
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN products p ON o.product_id = p.product_id
WHERE (o.user_id, o.order_date) IN (
	SELECT user_id, min(order_date)
	FROM orders
	GROUP BY user_id
);
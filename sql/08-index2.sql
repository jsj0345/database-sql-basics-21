USE my_shop2;

EXPLAIN
SELECT *
FROM items
WHERE price BETWEEN 50000 AND 100000;

EXPLAIN
SELECT *
FROM items
WHERE price BETWEEN 1000 AND 200000;

SELECT
item_id,
price,
item_name
FROM items
WHERE price BETWEEN 50000 AND 100000;

EXPLAIN
SELECT
item_id,
price,
item_name
FROM items
WHERE price BETWEEN 50000 AND 100000;

EXPLAIN
SELECT
item_id,
price
FROM items
WHERE price BETWEEN 50000 AND 100000;

DROP INDEX idx_items_price ON items;

CREATE INDEX idx_items_price_name ON items(price, item_name);

EXPLAIN
SELECT
item_id,
price,
item_name
FROM items
WHERE price BETWEEN 50000 AND 100000;

SHOW INDEX FROM items;

DROP INDEX idx_items_item_name ON items;
DROP INDEX idx_items_price_name ON items;

SHOW INDEX FROM items;

CREATE INDEX idx_items_category_price ON items(category, price);

SHOW INDEX FROM items;

EXPLAIN
SELECT *
FROM items
WHERE category = '전자기기';

EXPLAIN
SELECT *
FROM items
WHERE category = '전자기기' AND price = 120000;

EXPLAIN
SELECT *
FROM items
WHERE category = '전자기기'
AND price > 100000
ORDER BY price;

SELECT *
FROM items
WHERE price = 80000;

EXPLAIN
SELECT *
FROM items
WHERE price = 80000;

EXPLAIN
SELECT *
FROM items
WHERE category >= '패션'
AND price = 20000;

/*
인덱스에 장애가 생긴다면 어떻게 해야할까?
=> 서비스가 빨리 돌아가야 하니까 일단 임시 인덱스를 만들어보자. (임시 방편)
*/

CREATE INDEX idx_items_price_category_temp ON items(price, category);

EXPLAIN
SELECT *
FROM items
WHERE category >= '패션'
AND price = 20000;

DROP INDEX idx_items_price_category_temp ON items;

SHOW INDEX FROM items;

EXPLAIN
SELECT *
FROM items
WHERE category IN ('패션', '헬스/뷰티') AND price = 20000;

SHOW TABLES;

DESC sellers;

DESC items;

SELECT
	s.seller_name,
    i.item_name,
    i.price
FROM items i
JOIN sellers s ON i.seller_id = s.seller_id
WHERE s.seller_name = '행복쇼핑';

SHOW INDEX FROM items;

SHOW INDEX FROM sellers;

EXPLAIN
SELECT
	s.seller_name,
    i.item_name,
    i.price
FROM items i
JOIN sellers s ON i.seller_id = s.seller_id
WHERE s.seller_name = '행복쇼핑';
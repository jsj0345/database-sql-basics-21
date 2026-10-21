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
USE my_shop2;

SELECT *
FROM users;

DESC users;

INSERT INTO users (name, email) VALUES ('냐옹이', NULL);
-- Error Code: 1048. Column 'email' cannot be null

SELECT *
FROM users;

INSERT INTO users(name, email, address) VALUES ('가짜 션', 'sean@example.com', '서울시 어딘가');
-- Error Code: 1062. Duplicate entry 'sean@example.com' for key 'users.email'

INSERT INTO users(user_id, name, email) VALUES (1, '누군가', 'someone@...');
-- Error Code: 1062. Duplicate entry '1' for key 'users.PRIMARY'

DESC orders;

INSERT INTO orders(user_id, product_id, quantity) VALUES (2, 2, 1);

SELECT *
FROM orders;

CREATE TABLE GAMES (
	game_id INT PRIMARY KEY AUTO_INCREMENT,
    game_genre VARCHAR(100) NOT NULL,
    game_name VARCHAR(100) NOT NULL UNIQUE
);

ALTER TABLE GAMES MODIFY COLUMN game_name VARCHAR(100) NOT NULL UNIQUE;

DESC GAMES;

CREATE TABLE popular_games (
	game_id INT,
    user_count INT DEFAULT 0,
    CONSTRAINT fk_popular_games_GAMES FOREIGN KEY (game_id) REFERENCES GAMES(game_id)
);

INSERT INTO GAMES(game_genre, game_name) VALUES
('MMORPG', '메이플스토리'),
('CASUAL', '카트라이더');

SELECT *
FROM games;

SELECT *
FROM popular_games;

INSERT INTO popular_games(game_id, user_count) VALUES
(1, 300),
(2, 500);

SELECT *
FROM popular_games;

SELECT *
FROM games g
JOIN popular_games pg ON g.game_id = pg.game_id;

-- 존재하지 않는 user_id인 999번 고객의 주문 넣어보기
INSERT INTO orders (user_id, product_id, quantity) VALUES (999, 1, 1);
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`my_shop2`.`orders`, CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`))

SELECT *
FROM orders
WHERE user_id = 1;

-- 1번 고객은 주문이 있음. 이 상태에서 1번 고객에 대한 정보를 지워보기
DELETE FROM users
WHERE user_id = 1;
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`my_shop2`.`orders`, CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`))
-- orders가 users를 참조하는데 users는 부모, orders는 자식 => 부모가 없어지고 자식만 둔다는 개념? (X)

DELETE FROM orders
WHERE user_id = 1;
-- 자식에 있는 데이터를 먼저 삭제.

SELECT *
FROM users;

DROP TABLE orders;

CREATE TABLE orders (
	order_id BIGINT AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    quantity INT NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    PRIMARY KEY (order_id),

    CONSTRAINT fk_orders_users FOREIGN KEY (user_id)
		REFERENCES users(user_id) ON DELETE CASCADE,

    CONSTRAINT fk_orders_products FOREIGN KEY (product_id)
		REFERENCES products(product_id)
);

-- 션 회원 다시 등록
INSERT INTO users(user_id, name, email, address, birth_date) VALUES
(1, '션', 'sean@example.com', '서울시 강남구', '1990-01-15');

-- 주문 데이터 다시 입력
INSERT INTO orders(user_id, product_id, quantity, status) VALUES
(1, 1, 1, 'COMPLETED'),
(1, 4, 2, 'COMPLETED'),
(2, 2, 1, 'SHIPPED');

SELECT *
FROM orders
WHERE user_id = 1;

DELETE FROM users
WHERE user_id = 1;

SELECT *
FROM orders;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;

-- CHECK 제약 조건을 추가하여 products 테이블 재생성
CREATE TABLE products (
	product_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price INT NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    discount_rate DECIMAL(5, 2) DEFAULT 0.00 CHECK (discount_rate BETWEEN 0.00 AND 100.00)
);

INSERT INTO products (name, category, price, stock_quantity)
VALUES ('오류상품', '전자기기', -5000, 10);

-- Error Code: 3819. Check constraint 'products_chk_1' is violated.

INSERT INTO products (name, category, price, stock_quantity, discount_rate)
VALUES ('오류상품', '전자기기', 55000, 10, 120.00);
-- Error Code: 3819. Check constraint 'products_chk_3' is violated.
CREATE DATABASE IF NOT EXISTS my_shop2;
USE my_shop2;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS sizes;
DROP TABLE IF EXISTS colors;

-- 고객 테이블 생성
CREATE TABLE users (
	user_id BIGINT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    address VARCHAR(255),
    birth_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id)
);

-- 상품 테이블 생성
CREATE TABLE products (
	product_id BIGINT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price INT NOT NULL,
    stock_quantity INT NOT NULL,
    PRIMARY KEY (product_id)
);

-- 주문 테이블 생성
CREATE TABLE orders (
	order_id BIGINT AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    quantity INT NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    PRIMARY KEY (order_id),

    CONSTRAINT fk_orders_users FOREIGN KEY (user_id)
		REFERENCES users (user_id),

    CONSTRAINT fk_orders_products FOREIGN KEY (product_id)
		REFERENCES products (product_id)
);

-- 직원 테이블 생성
CREATE TABLE employees (
	employee_id BIGINT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    manager_id BIGINT,
    PRIMARY KEY (employee_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- 사이즈 테이블
CREATE TABLE sizes (
	size VARCHAR(10) PRIMARY KEY
);

-- 색상 테이블
CREATE TABLE colors (
	color VARCHAR(20) PRIMARY KEY
);

-- 고객 데이터 입력
INSERT INTO users (name, email, address, birth_date) VALUES
('션', 'sean@example.com', '서울시 강남구', '1990-01-15'),
('네이트', 'nate@example.com', '경기도 성남시', '1988-05-22'),
('세종대왕', 'sejong@example.com', '서울시 종로구', '1397-05-15'),
('이순신', 'sunsin@example.com', '전라남도 여수시', '1545-04-28'),
('마리 퀴리', 'marie@example.com', '서울시 강남구', '1867-11-07'),
('레오나르도 다빈치', 'vinci@example.com', '이탈리아 피렌체', '1452-04-15');

-- 상품 데이터 입력
INSERT INTO products (name, category, price, stock_quantity) VALUES
('프리미엄 게이밍 마우스', '전자기기', 75000, 50),
('기계식 키보드', '전자기기', 120000, 30),
('4K UHD 모니터', '전자기기', 350000, 20),
('관계형 데이터베이스 입문', '도서', 28000, 100),
('고급 가죽 지갑', '패션', 150000, 15),
('스마트 워치', '전자기기', 280000, 40);

-- 주문 데이터 입력
INSERT INTO orders (user_id, product_id, quantity, status, order_date) VALUES
(1, 1, 1, 'COMPLETED', '2025-06-10 10:00:00'),
(1, 4, 2, 'COMPLETED', '2025-06-10 10:05:00'),
(2, 2, 1, 'SHIPPED', '2025-06-11 14:20:00'),
(3, 4, 1, 'COMPLETED', '2025-06-12 09:00:00'),
(4, 3, 1, 'PENDING', '2025-06-15 11:30:00'),
(5, 1, 1, 'COMPLETED', '2025-06-16 18:00:00'),
(2, 1, 2, 'SHIPPED', '2025-06-17 12:00:00');

-- 직원 데이터 입력
INSERT INTO employees (employee_id, name, manager_id) VALUES
(1, '김회장', NULL),
(2, '박사장', 1),
(3, '이부장', 2),
(4, '최과장', 3),
(5, '정대리', 4),
(6, '홍사원', 4);

-- 사이즈 데이터 입력
INSERT INTO sizes(size) VALUES
('S'), ('M'), ('L'), ('XL');

-- 색상 데이터 입력
INSERT INTO colors(color) VALUES
('Red'), ('Blue'), ('Black');

SELECT *
FROM users;

SELECT *
FROM products;

SELECT *
FROM orders;

SELECT *
FROM orders;

SELECT *
FROM orders
INNER JOIN users ON orders.user_id = users.user_id;

SELECT *
FROM orders
INNER JOIN users ON orders.user_id = users.user_id
WHERE status = 'COMPLETED';

SELECT
	user_id,
    name,
    order_date
FROM orders
INNER JOIN users ON orders.user_id = users.user_id
WHERE orders.status = 'COMPLETED';

SELECT
	users.user_id,
    users.name,
    orders.order_date
FROM orders
INNER JOIN users ON orders.user_id = users.user_id
WHERE orders.status = 'COMPLETED';

SELECT DISTINCT user_id
FROM orders;

SELECT user_id
FROM users
ORDER BY user_id;

SELECT
	orders.order_id,
    orders.order_date,
    orders.user_id as orders_user_id,
    users.user_id as users_user_id,
    users.name
FROM orders
INNER JOIN users ON orders.user_id = users.user_id
ORDER BY orders.order_id;
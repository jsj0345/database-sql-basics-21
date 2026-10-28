DROP DATABASE IF EXISTS sql_practice_shop;
CREATE DATABASE sql_practice_shop;
USE sql_practice_shop;

CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  region VARCHAR(30) NOT NULL,
  joined_at DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE products (
  product_id INT PRIMARY KEY,
  category_id INT NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  price INT NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
  CONSTRAINT chk_products_price CHECK (price >= 0),
  CONSTRAINT chk_products_stock CHECK (stock >= 0)
) ENGINE=InnoDB;

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  ordered_at DATETIME NOT NULL,
  status ENUM('PENDING','SHIPPED','COMPLETED','CANCELLED') NOT NULL,
  CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price INT NOT NULL,
  CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT uq_order_product UNIQUE (order_id, product_id),
  CONSTRAINT chk_order_item_quantity CHECK (quantity > 0),
  CONSTRAINT chk_order_item_unit_price CHECK (unit_price >= 0)
) ENGINE=InnoDB;

CREATE TABLE payments (
  payment_id INT PRIMARY KEY,
  order_id INT NOT NULL UNIQUE,
  payment_method ENUM('CARD','BANK_TRANSFER','KAKAO_PAY') NOT NULL,
  payment_status ENUM('PAID','REFUNDED') NOT NULL,
  amount INT NOT NULL,
  paid_at DATETIME NOT NULL,
  CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT chk_payments_amount CHECK (amount >= 0)
) ENGINE=InnoDB;

INSERT INTO customers (customer_id, customer_name, email, region, joined_at) VALUES
  (1, '김민수', 'minsu@example.com', '서울', '2026-01-05'),
  (2, '이지은', 'jieun@example.com', '경기', '2026-01-18'),
  (3, '박서준', 'seojun@example.com', '부산', '2026-02-01'),
  (4, '최유진', 'yujin@example.com', '서울', '2026-02-09'),
  (5, '정하늘', 'haneul@example.com', '인천', '2026-02-21'),
  (6, '오지훈', 'jihoon@example.com', '대전', '2026-03-03'),
  (7, '한수빈', 'subin@example.com', '경기', '2026-03-15'),
  (8, '윤도현', 'dohyun@example.com', '서울', '2026-04-02'),
  (9, '서예린', 'yerin@example.com', '광주', '2026-04-12'),
  (10, '임지수', 'jisu@example.com', '부산', '2026-05-01'),
  (11, '배현우', 'hyunwoo@example.com', '경기', '2026-05-11'),
  (12, '강다은', 'daeun@example.com', '서울', '2026-06-03');

INSERT INTO categories (category_id, category_name) VALUES
  (1, '전자기기'),
  (2, '패션'),
  (3, '생활용품'),
  (4, '도서'),
  (5, '식품'),
  (6, '스포츠');

INSERT INTO products (product_id, category_id, product_name, price, stock, is_active) VALUES
  (1, 1, '무선 마우스', 35000, 40, 1),
  (2, 1, '기계식 키보드', 120000, 18, 1),
  (3, 1, 'USB-C 허브', 49000, 35, 1),
  (4, 1, '블루투스 이어폰', 89000, 20, 1),
  (5, 2, '후드 티셔츠', 59000, 50, 1),
  (6, 2, '데님 팬츠', 79000, 25, 1),
  (7, 2, '캔버스 백', 29000, 45, 1),
  (8, 3, '텀블러', 25000, 60, 1),
  (9, 3, 'LED 스탠드', 45000, 15, 1),
  (10, 3, '수납 정리함', 19000, 70, 1),
  (11, 4, 'SQL 입문서', 28000, 30, 1),
  (12, 4, '자바 실무 가이드', 38000, 22, 1),
  (13, 5, '드립백 커피', 18000, 80, 1),
  (14, 5, '견과류 세트', 32000, 28, 1),
  (15, 6, '요가 매트', 26000, 38, 1),
  (16, 6, '러닝 벨트', 21000, 33, 1),
  (17, 1, '유선 키보드', 20000, 0, 0),
  (18, 6, '폼롤러', 24000, 12, 1),
  (19, 4, '알고리즘 문제집', 34000, 15, 1),
  (20, 3, '무드등', 39000, 16, 1);

INSERT INTO orders (order_id, customer_id, ordered_at, status) VALUES
  (1, 1, '2026-07-02 10:12:00', 'COMPLETED'),
  (2, 2, '2026-07-03 11:40:00', 'COMPLETED'),
  (3, 3, '2026-07-05 16:20:00', 'SHIPPED'),
  (4, 1, '2026-07-07 09:02:00', 'COMPLETED'),
  (5, 4, '2026-07-08 13:15:00', 'CANCELLED'),
  (6, 5, '2026-07-10 20:10:00', 'COMPLETED'),
  (7, 6, '2026-07-13 15:30:00', 'PENDING'),
  (8, 2, '2026-07-16 12:50:00', 'SHIPPED'),
  (9, 7, '2026-07-18 18:25:00', 'COMPLETED'),
  (10, 8, '2026-07-20 08:55:00', 'COMPLETED'),
  (11, 3, '2026-07-22 14:20:00', 'CANCELLED'),
  (12, 9, '2026-07-24 19:00:00', 'CANCELLED'),
  (13, 10, '2026-08-01 12:30:00', 'COMPLETED'),
  (14, 1, '2026-08-03 11:00:00', 'SHIPPED'),
  (15, 5, '2026-08-06 10:10:00', 'COMPLETED'),
  (16, 4, '2026-08-08 17:35:00', 'PENDING'),
  (17, 11, '2026-08-11 13:10:00', 'COMPLETED'),
  (18, 7, '2026-08-15 14:45:00', 'SHIPPED'),
  (19, 6, '2026-08-19 09:20:00', 'COMPLETED'),
  (20, 8, '2026-08-22 16:55:00', 'CANCELLED'),
  (21, 2, '2026-09-01 10:30:00', 'COMPLETED'),
  (22, 3, '2026-09-04 15:05:00', 'COMPLETED'),
  (23, 10, '2026-09-07 12:15:00', 'PENDING'),
  (24, 1, '2026-09-10 19:40:00', 'COMPLETED'),
  (25, 5, '2026-09-14 11:20:00', 'SHIPPED'),
  (26, 11, '2026-09-18 18:00:00', 'COMPLETED'),
  (27, 7, '2026-09-21 09:55:00', 'CANCELLED'),
  (28, 4, '2026-09-27 12:00:00', 'COMPLETED'),
  (29, 8, '2026-10-02 10:05:00', 'PENDING'),
  (30, 2, '2026-10-05 13:35:00', 'COMPLETED');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  (1, 1, 2, 35000),
  (1, 11, 1, 28000),
  (2, 5, 1, 59000),
  (2, 8, 2, 25000),
  (3, 4, 1, 89000),
  (3, 13, 3, 18000),
  (4, 3, 2, 49000),
  (5, 6, 1, 79000),
  (6, 9, 1, 45000),
  (6, 14, 2, 32000),
  (7, 15, 1, 26000),
  (8, 2, 1, 120000),
  (8, 13, 2, 18000),
  (9, 7, 2, 29000),
  (9, 11, 1, 28000),
  (10, 12, 1, 38000),
  (10, 10, 3, 19000),
  (11, 1, 1, 35000),
  (12, 16, 2, 21000),
  (13, 1, 1, 35000),
  (13, 5, 1, 59000),
  (14, 4, 2, 89000),
  (15, 8, 2, 25000),
  (15, 13, 4, 18000),
  (16, 19, 1, 34000),
  (17, 2, 1, 120000),
  (17, 15, 2, 26000),
  (18, 6, 1, 79000),
  (18, 14, 1, 32000),
  (19, 3, 1, 49000),
  (19, 18, 2, 24000),
  (20, 20, 1, 39000),
  (21, 11, 2, 28000),
  (21, 12, 1, 38000),
  (22, 4, 1, 89000),
  (22, 9, 1, 45000),
  (23, 16, 2, 21000),
  (24, 2, 1, 120000),
  (24, 7, 1, 29000),
  (25, 14, 2, 32000),
  (25, 10, 1, 19000),
  (26, 19, 2, 34000),
  (26, 1, 1, 35000),
  (27, 8, 1, 25000),
  (28, 20, 1, 39000),
  (28, 5, 2, 59000),
  (29, 15, 1, 26000),
  (30, 3, 2, 49000),
  (30, 13, 1, 18000);

INSERT INTO payments (payment_id, order_id, payment_method, payment_status, amount, paid_at) VALUES
  (1, 1, 'BANK_TRANSFER', 'PAID', 98000, '2026-07-02 10:12:00'),
  (2, 2, 'KAKAO_PAY', 'PAID', 109000, '2026-07-03 11:40:00'),
  (3, 3, 'CARD', 'PAID', 143000, '2026-07-05 16:20:00'),
  (4, 4, 'BANK_TRANSFER', 'PAID', 98000, '2026-07-07 09:02:00'),
  (5, 5, 'KAKAO_PAY', 'REFUNDED', 79000, '2026-07-08 13:15:00'),
  (6, 6, 'CARD', 'PAID', 109000, '2026-07-10 20:10:00'),
  (7, 8, 'KAKAO_PAY', 'PAID', 156000, '2026-07-16 12:50:00'),
  (8, 9, 'CARD', 'PAID', 86000, '2026-07-18 18:25:00'),
  (9, 10, 'BANK_TRANSFER', 'PAID', 95000, '2026-07-20 08:55:00'),
  (10, 11, 'KAKAO_PAY', 'REFUNDED', 35000, '2026-07-22 14:20:00'),
  (11, 12, 'CARD', 'REFUNDED', 42000, '2026-07-24 19:00:00'),
  (12, 13, 'BANK_TRANSFER', 'PAID', 94000, '2026-08-01 12:30:00'),
  (13, 14, 'KAKAO_PAY', 'PAID', 178000, '2026-08-03 11:00:00'),
  (14, 15, 'CARD', 'PAID', 122000, '2026-08-06 10:10:00'),
  (15, 17, 'KAKAO_PAY', 'PAID', 172000, '2026-08-11 13:10:00'),
  (16, 18, 'CARD', 'PAID', 111000, '2026-08-15 14:45:00'),
  (17, 19, 'BANK_TRANSFER', 'PAID', 97000, '2026-08-19 09:20:00'),
  (18, 20, 'KAKAO_PAY', 'REFUNDED', 39000, '2026-08-22 16:55:00'),
  (19, 21, 'CARD', 'PAID', 94000, '2026-09-01 10:30:00'),
  (20, 22, 'BANK_TRANSFER', 'PAID', 134000, '2026-09-04 15:05:00'),
  (21, 24, 'CARD', 'PAID', 149000, '2026-09-10 19:40:00'),
  (22, 25, 'BANK_TRANSFER', 'PAID', 83000, '2026-09-14 11:20:00'),
  (23, 26, 'KAKAO_PAY', 'PAID', 103000, '2026-09-18 18:00:00'),
  (24, 27, 'CARD', 'REFUNDED', 25000, '2026-09-21 09:55:00'),
  (25, 28, 'BANK_TRANSFER', 'PAID', 157000, '2026-09-27 12:00:00'),
  (26, 30, 'CARD', 'PAID', 116000, '2026-10-05 13:35:00');
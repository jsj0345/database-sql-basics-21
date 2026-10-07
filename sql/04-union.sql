DROP TABLE IF EXISTS retired_users;

CREATE TABLE retired_users (
	id BIGINT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    retired_date DATE NOT NULL
);

-- 탈퇴 고객 데이터 입력
INSERT INTO retired_users (id, name, email, retired_date) VALUES
(1, '션', 'sean@example.com', '2024-12-31'),
(7, '아이작 리턴', 'newton@example.com', '2025-01-10');

SELECT *
FROM retired_users;

SELECT name,
	email
FROM users
UNION
SELECT name,
	email
FROM retired_users;

--

SELECT u.name,
	   u.email
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id
WHERE p.category = '전자기기'

UNION

select name,
	   email
FROM users
WHERE address LIKE '서울%';

SELECT u.name,
	   u.email
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id
WHERE p.category = '전자기기'

UNION ALL

select name,
	   email
FROM users
WHERE address LIKE '서울%';

SELECT name,
	   email
FROM users
UNION
SELECT name, email
FROM retired_users
ORDER BY name;

SELECT name, email, created_at FROM users
UNION ALL
SELECT name, email, retired_date FROM retired_users
ORDER BY created_at;

SELECT name, email, created_at AS event_date FROM users
UNION ALL
SELECT name, email, retired_date AS event_date FROM retired_users
ORDER BY event_date;
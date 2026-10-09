USE my_shop2;

/*
1.
우리 쇼핑몰의 모든 고객(활동 고객과 탈퇴 고객)의 이름과
이메일을 중복 없이 조회하여 하나의 목록으로 만드시오.
*/

SELECT *
FROM users;

SELECT *
FROM retired_users;

SELECT name,
	   email
FROM users

UNION

SELECT name,
	   email
FROM retired_users;

/*
2.
- '전자기기' 카테고리 상품을 한 번이라도 구매한 고객
- 한 번의 주문으로 상품을 2개 이상 구매한 고객

성능을 고려하여, 두 그룹의 목록을 중복 제거 없이 모두 합쳐서 조회하시오.
컬럼 별칭은 고객명, 이메일로 지정한다.
*/

SELECT DISTINCT u.name AS `고객명`,
	   u.email AS `이메일`
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.product_id IN (SELECT p.product_id
						FROM products p
                        WHERE p.category = '전자기기')

UNION ALL

SELECT u.name AS `고객명`,
	   u.email AS `이메일`
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.quantity >= 2;

/*
3.
'고객 가입' 이벤트와 '상품 주문' 이벤트를 시간 순서대로 정렬하여
조회하시오.

- users 테이블의 created_at은 '고객 가입' 이벤트로 간주한다.
- orders 테이블의 order_date는 '상품 주문' 이벤트로 간주한다.
- 결과는 이벤트_날짜, 이벤트_종류, 상세_내용 컬럼으로 구성한다.
- 상세_내용에는 고객 가입 시 고객의 이름, 상품 주문 시 상품의 이름을 표시한다.
- 최신 이벤트가 가장 위에 오도록 내림차순으로 정렬.
*/

SELECT *
FROM users;

SELECT *
FROM orders;

SELECT *
FROM products;

SELECT created_at AS `이벤트 날짜`,
	   '고객가입' AS `이벤트 종류`,
       name AS `상세 내용`
FROM users

UNION ALL

SELECT order_date AS `이벤트 날짜`,
	   '상품 주문' AS `이벤트 종류`,
       p.name AS `상세 내용`
FROM orders o
JOIN products p ON o.product_id = p.product_id
ORDER BY `이벤트 날짜` DESC;

/*
4. 회사의 모든 관련 인물(users의 고객과 employees의 직원)을 통합한 인명록을 만드시오.

- 결과에는 이름, 역할, 이메일 컬럼이 포함되어야 한다.
- 고객의 연락처는 email 컬럼을 사용한다.
- 직원의 이메일은 name 컬럼 뒤에 '@my-shop.com'을 붙여서 생성한다.
- 최종 결과는 이름순으로 오름차순 정렬해라.
*/

SELECT name AS `이름`,
	   '직원' AS '직원',
       CONCAT(name,'@my-shop.com') AS '이메일'
FROM employees

UNION ALL

SELECT name AS `이름`,
	   '고객' AS '고객',
       email AS '이메일'
FROM users

ORDER BY `이름` ASC;
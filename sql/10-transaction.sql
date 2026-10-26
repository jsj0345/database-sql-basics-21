USE my_shop2;

DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
	id INT PRIMARY KEY,
    owner_name VARCHAR(255) NOT NULL,
    balance INT NOT NULL
);

INSERT INTO accounts (id, owner_name, balance) VALUES
(1, 'A고객', 50000),
(2, 'B고객', 20000);

SELECT *
FROM accounts;

START TRANSACTION;

UPDATE accounts
SET balance = balance - 10000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 10000
WHERE id = 2;

SELECT *
FROM accounts;

COMMIT;

START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE id = 1;

ROLLBACK;

SELECT *
FROM accounts;

/*
A(Atomicity) => 원자성(더 이상 쪼갤 수 없는 논리적 단위)
C(Consistency) => 일관성(데이터베이스에 설정된 모든 규칙을 위반하지 않는 성질)
I(Isolation) => 하나의 트랜잭션이 실행 중일 때, 다른 트랜잭션이 해당 트랜잭션의 중간 결과에 끼어들어 간섭할 수 없다.
(단, 트랜잭션을 실행 하기전의 값들은 읽을 수 있음(커밋 하기 전의 값)
D(Durability, 지속성) => 커밋 된 데이터는 절대 사라지지 않는다는 성질
*/
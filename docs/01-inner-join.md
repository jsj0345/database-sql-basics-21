## 1. 한 테이블만 봐서는 필요한 정보가 부족할 수 있다

주문 정보를 조회할 때 `orders` 테이블만 확인하면 주문 자체에 대한 값은 볼 수 있다.

하지만 주문 데이터에는 고객의 이름이나 상품의 이름이 직접 들어 있지 않고, 다른 테이블을 가리키는 식별 값이 저장되어 있다.

예를 들어 주문 데이터에 `user_id`가 들어 있다면 실제 고객 이름은 `users` 테이블에서 다시 확인해야 한다.

```sql
SELECT *
FROM orders;
```

데이터가 몇 건 없다면 각 테이블을 직접 확인할 수도 있지만, 데이터가 많아질수록 이런 방식으로 필요한 값을 하나씩 찾는 것은 어렵다.

즉 **한 테이블에 필요한 정보가 모두 들어 있지 않을 때 여러 테이블의 데이터를 연결해서 조회할 방법이 필요하다.**

---

## 2. 처음부터 모든 정보를 한 테이블에 넣지 않는 이유

조회만 생각하면 고객, 상품, 주문 정보를 하나의 테이블에 모두 저장하는 것이 편해 보일 수 있다.

하지만 같은 정보가 여러 행에 반복되기 시작하면 데이터 관리가 어려워진다.

예를 들어 한 고객이 여러 번 주문하면 고객 이름, 이메일, 주소 같은 값도 주문 횟수만큼 계속 반복해서 저장될 수 있다.

이 구조에서는 다음과 같은 문제가 생길 수 있다.

### 같은 정보가 반복해서 저장되는 경우

한 고객이 여러 번 주문할수록 고객 정보도 계속 중복된다.

```text
고객 정보 + 주문 1
고객 정보 + 주문 2
고객 정보 + 주문 3
...
```

같은 내용을 여러 번 저장해야 하므로 불필요한 중복이 생긴다.

### 하나의 값을 여러 곳에서 고쳐야 하는 경우

고객의 이메일이 변경되었는데 같은 정보가 여러 주문 행에 들어 있다면 관련된 값을 모두 수정해야 한다.

일부만 수정되면 같은 고객을 나타내는 데이터끼리 서로 다른 값을 가지게 될 수 있다.

### 주문이 없어도 저장해야 하는 정보가 있는 경우

상품은 아직 주문되지 않았더라도 먼저 등록할 수 있어야 한다.

그런데 주문과 상품 정보를 하나의 구조에 묶어두면 주문이 없다는 이유로 상품 자체를 저장하기 어려운 상황이 생길 수 있다.

### 주문 삭제가 다른 정보까지 없애는 경우

하나의 행 안에 주문과 고객 정보가 함께 들어 있다면 주문 기록을 삭제하면서 고객 정보까지 같이 사라질 수 있다.

내가 이해한 핵심은 **성격이 다른 데이터를 무조건 한 테이블에 모으면 조회는 단순해 보여도 데이터 자체를 관리하기 어려워질 수 있다는 것**이다.

---

## 3. 데이터를 나누어 저장한 뒤 다시 연결한다

이런 중복과 이상 현상을 줄이기 위해 데이터는 역할에 따라 여러 테이블로 나누어 관리할 수 있다.

이 과정을 이해할 때 이번 내용에서는 `users`, `products`, `orders`처럼 서로 다른 정보를 별도의 테이블에 저장하는 구조를 사용했다.

```text
users     → 고객 정보
products  → 상품 정보
orders    → 주문 정보
```

테이블을 나누면 같은 고객이나 상품 정보를 주문마다 반복해서 저장하지 않아도 된다.

대신 실제 조회에서는 다시 여러 테이블의 정보가 필요한 경우가 생긴다.

예를 들어 주문 날짜와 고객 이름을 함께 보고 싶다면 `orders`와 `users`의 데이터를 한 결과에서 확인해야 한다.

이때 사용하는 것이 `JOIN`이다.

내 기준에서는 `JOIN`을 **분리해서 보관한 데이터를 연결 기준에 맞춰 다시 함께 조회하는 방법**으로 이해했다.

---

## 4. INNER JOIN은 서로 연결되는 행만 남긴다

`INNER JOIN`은 두 테이블을 연결했을 때 지정한 조건이 서로 맞는 행만 결과에 포함한다.

예를 들어 다음 두 값이 같은 경우를 연결 기준으로 사용할 수 있다.

```text
orders.user_id
users.user_id
```

두 값이 일치하는 주문과 고객이 서로 한 행으로 연결되는 방식이다.

기본 형태는 다음과 같다.

```sql
SELECT 조회할_컬럼
FROM 첫번째_테이블
INNER JOIN 두번째_테이블
    ON 첫번째_테이블.연결컬럼 = 두번째_테이블.연결컬럼;
```

여기서 역할을 나눠서 보면 이해하기 쉽다.

```text
FROM        → 먼저 사용할 테이블
INNER JOIN  → 함께 연결할 테이블
ON          → 두 테이블을 어떤 기준으로 연결할지 지정
```

`INNER JOIN`에서 중요한 부분은 `ON`이다.

두 테이블을 적어놓는 것만으로는 어떤 행끼리 연결해야 하는지 알 수 없기 때문에, `ON`에서 연결 조건을 정해준다.

---

## 5. 주문과 고객 정보를 연결해서 조회하기

주문 정보와 고객 정보를 함께 확인하려면 두 테이블이 공통으로 가지고 있는 `user_id`를 기준으로 연결할 수 있다.

```sql
SELECT
    users.name,
    orders.order_date
FROM orders
INNER JOIN users
    ON orders.user_id = users.user_id;
```

이 쿼리는 `orders.user_id`와 `users.user_id`가 같은 데이터를 서로 연결하고, 그중 고객 이름과 주문 날짜를 결과로 보여준다.

처음 조인을 확인할 때는 모든 컬럼을 조회해 연결 결과를 살펴볼 수도 있다.

```sql
SELECT *
FROM orders
INNER JOIN users
    ON orders.user_id = users.user_id;
```

다만 실제로 필요한 값이 일부라면 모든 컬럼을 가져오기보다 필요한 컬럼만 지정하는 편이 결과를 확인하기 쉽다.

---

## 6. JOIN으로 연결한 뒤 WHERE로 다시 조건을 줄일 수 있다

테이블을 연결한 뒤에도 기존에 사용하던 `WHERE` 조건을 붙일 수 있다.

예를 들어 완료된 주문만 보고 싶다면 다음처럼 작성할 수 있다.

```sql
SELECT
    users.name,
    orders.order_date
FROM orders
INNER JOIN users
    ON orders.user_id = users.user_id
WHERE orders.status = 'COMPLETED';
```

여기서는 역할이 서로 다르다.

```text
ON
→ orders와 users에서 어떤 행끼리 연결할지 결정

WHERE
→ 연결된 결과 중 어떤 행을 남길지 결정
```

즉 `ON`은 테이블 사이의 연결 조건이고, `WHERE`는 조회 결과에 적용할 조건으로 구분해서 이해했다.

---

## 7. 이름이 같은 컬럼은 어느 테이블의 값인지 구분해야 한다

여러 테이블을 함께 조회하면 서로 같은 이름의 컬럼이 존재할 수 있다.

`orders`와 `users`에 모두 `user_id`가 있다면 다음처럼 컬럼 이름만 작성했을 때 어떤 테이블의 값을 의미하는지 모호해질 수 있다.

```sql
SELECT user_id
FROM orders
INNER JOIN users
    ON orders.user_id = users.user_id;
```

이 경우에는 `테이블명.컬럼명` 형식으로 소속을 명확하게 적을 수 있다.

```sql
SELECT
    users.user_id,
    users.name,
    orders.order_date
FROM orders
INNER JOIN users
    ON orders.user_id = users.user_id;
```

한쪽 테이블에만 존재하는 컬럼은 테이블명을 생략해도 모호하지 않을 수 있다.

하지만 여러 테이블을 함께 사용하는 쿼리에서는 내가 보고 있는 컬럼이 어디에 속하는지 바로 확인할 수 있도록 테이블명을 같이 적는 방식으로 정리했다.

---

## 8. INNER JOIN 쿼리를 읽는 순서

다음과 같은 쿼리를 기준으로 흐름을 보면 이해하기 쉽다.

```sql
SELECT
    users.user_id,
    users.name,
    orders.order_date
FROM orders
INNER JOIN users
    ON orders.user_id = users.user_id
WHERE orders.status = 'COMPLETED';
```

이번 내용에서 배운 논리적인 처리 흐름은 다음과 같다.

```text
FROM / JOIN
→ ON 조건에 맞는 orders와 users의 행을 연결

WHERE
→ 연결된 결과에서 COMPLETED 상태만 남김

SELECT
→ 마지막으로 필요한 컬럼만 결과에 표시
```

내가 쿼리를 읽을 때는 `SELECT`부터 바로 해석하기보다 먼저 **어떤 테이블을 연결하는지**, 그 다음 **무슨 조건으로 연결하는지**, 마지막으로 **어떤 데이터를 남기고 보여주는지** 순서로 보는 것이 이해하기 편했다.

---

## 9. 이번 내용에서 정리한 INNER JOIN의 핵심

```text
테이블을 분리해서 저장
→ 같은 정보가 반복되는 문제를 줄임

분리된 정보가 한 번에 필요함
→ JOIN으로 다시 연결

INNER JOIN
→ 연결 조건이 서로 맞는 행만 결과에 포함

ON
→ 두 테이블을 연결하는 기준

WHERE
→ 연결한 결과에서 필요한 행만 필터링

테이블명.컬럼명
→ 여러 테이블에서 같은 컬럼명이 있을 때 소속을 구분
```

결국 이번 내용에서 내가 이해한 `INNER JOIN`은 **따로 관리하고 있는 테이블의 데이터를 공통된 값을 기준으로 연결하고, 필요한 정보만 하나의 조회 결과로 만드는 방법**이다.

---

## 10. 어떤 테이블을 먼저 적을지 정하는 기준

`INNER JOIN`은 같은 조건으로 두 테이블을 연결한다면 테이블의 작성 순서를 바꿔도 서로 매칭되는 데이터는 동일하다.

그래서 작성 순서 자체보다 **이번 조회에서 어떤 데이터를 기준으로 보고 있는지**를 먼저 생각하는 편이 이해하기 쉽다.

예를 들어 주문 정보를 중심으로 고객 정보를 함께 보고 싶다면 다음과 같이 작성할 수 있다.

```sql
FROM orders
JOIN users
```

반대로 고객을 먼저 보고 그 고객의 주문 정보를 연결하고 싶다면 순서를 바꿔서 작성할 수 있다.

```sql
FROM users
JOIN orders
```

이번 예제는 완료된 주문과 해당 주문의 고객 정보를 확인하는 내용이므로 `orders`를 먼저 두는 형태로 볼 수 있다.

---

## 11. 긴 테이블 이름을 줄여서 사용하기

조인을 사용하면 여러 테이블의 컬럼을 함께 다루기 때문에 다음처럼 테이블 이름을 계속 적게 된다.

```text
users.user_id
users.name
orders.order_date
orders.status
```

이런 반복을 줄이기 위해 테이블에 짧은 이름을 붙여서 사용할 수 있다.

```sql
SELECT
    u.user_id,
    u.name,
    o.order_date
FROM orders AS o
INNER JOIN users AS u
    ON o.user_id = u.user_id
WHERE o.status = 'COMPLETED';
```

여기서는 다음과 같이 별칭을 붙였다.

```text
orders → o
users  → u
```

별칭을 지정한 뒤에는 원래 테이블 이름 대신 별칭으로 컬럼을 표현할 수 있다.

```text
orders.status → o.status
users.name    → u.name
```

즉 같은 테이블 이름을 계속 반복하지 않고 더 짧게 작성할 수 있다.

---

## 12. AS 없이 별칭 붙이기

테이블에 별칭을 붙일 때 `AS`는 생략할 수 있다.

다음 두 표현은 같은 의미다.

```sql
FROM orders AS o
```

```sql
FROM orders o
```

따라서 앞의 조인 쿼리도 다음처럼 작성할 수 있다.

```sql
SELECT
    u.user_id,
    u.name,
    o.order_date
FROM orders o
INNER JOIN users u
    ON o.user_id = u.user_id
WHERE o.status = 'COMPLETED';
```

테이블 이름 뒤에 별칭을 바로 적어도 같은 방식으로 사용할 수 있다.

---

## 13. INNER JOIN을 JOIN으로 줄여 쓰기

`INNER JOIN`에서 `INNER`도 생략할 수 있다.

```sql
SELECT
    u.user_id,
    u.name,
    o.order_date
FROM orders o
JOIN users u
    ON o.user_id = u.user_id
WHERE o.status = 'COMPLETED';
```

여기서 `JOIN`은 앞에서 사용한 `INNER JOIN`과 같은 의미다.

이번 내용에서 생략할 수 있는 표현만 정리하면 다음과 같다.

```text
orders AS o  → orders o
users AS u   → users u

INNER JOIN   → JOIN
```

결국 같은 내부 조인이라도 테이블 별칭을 사용하고 생략 가능한 표현을 줄이면 쿼리를 더 간결하게 작성할 수 있다.



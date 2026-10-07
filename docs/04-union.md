# UNION

## 1. 서로 다른 조회 결과를 하나로 모으기

지금까지는 하나의 `SELECT`문에서 필요한 데이터를 조회하거나, 여러 테이블의 정보가 필요하면 `JOIN`을 사용했다.

그런데 서로 다른 조회에서 나온 결과를 **하나의 목록으로 합쳐야 하는 경우**도 있다.

예를 들어 현재 고객과 탈퇴 고객이 서로 다른 테이블에 저장되어 있고, 두 테이블에서 이름과 이메일을 각각 조회한다고 생각할 수 있다.

```sql
SELECT name, email
FROM users;

SELECT name, email
FROM retired_users;
```

두 조회는 각각 별도의 결과를 만든다.

이 결과를 하나로 이어서 조회할 때 `UNION`을 사용할 수 있다.

```sql
SELECT name, email
FROM users

UNION

SELECT name, email
FROM retired_users;
```

내가 이해한 `UNION`은 **테이블 자체를 연결하는 것이 아니라 각각의 SELECT가 만들어낸 결과를 하나의 결과로 합치는 방법**이다.

---

## 2. 합칠 수 있는 결과의 형태가 맞아야 한다

`UNION`은 두 조회 결과를 하나로 합치기 때문에 아무 `SELECT`문이나 서로 연결할 수 있는 것은 아니다.

각 조회에서 반환하는 결과의 구조가 서로 맞아야 한다.

이번 내용에서 확인한 조건은 다음과 같다.

```text
첫 번째 SELECT의 컬럼 개수
=
두 번째 SELECT의 컬럼 개수
```

그리고 같은 위치에 있는 컬럼끼리는 서로 사용할 수 있는 데이터 타입이어야 한다.

예를 들어 첫 번째 조회가 다음과 같은 구조라면

```text
name | email
```

두 번째 조회 역시 같은 개수의 컬럼을 반환해야 한다.

즉 `UNION`을 볼 때는 각각의 쿼리를 따로 보기보다 **두 SELECT가 최종적으로 어떤 모양의 결과를 만드는지** 먼저 확인하는 것이 중요하다.

---

## 3. 결과의 컬럼 이름은 첫 번째 조회를 기준으로 한다

`UNION`으로 여러 결과를 합치더라도 최종 결과에는 하나의 컬럼 이름이 필요하다.

이때 결과 컬럼의 이름은 첫 번째 `SELECT`에서 사용한 컬럼 이름을 따른다.

예를 들어 다음처럼 조회하면

```sql
SELECT name, email
FROM users

UNION

SELECT name, email
FROM retired_users;
```

최종 결과 역시 첫 번째 조회를 기준으로 `name`, `email`이라는 컬럼 이름을 사용한다.

따라서 뒤쪽 `SELECT`의 컬럼은 단순히 같은 위치의 값으로 합쳐지는 것으로 이해했다.

---

## 4. UNION은 같은 결과를 한 번만 남긴다

`UNION`으로 두 조회 결과를 합쳤을 때 양쪽에 완전히 같은 행이 존재할 수 있다.

이 경우 `UNION`은 같은 행을 그대로 여러 번 남기지 않고 중복을 제거한다.

```text
첫 번째 조회 결과
A
B

두 번째 조회 결과
B
C
```

이를 `UNION`으로 합치면 결과는 다음과 같이 볼 수 있다.

```text
A
B
C
```

`B`는 두 조회에 모두 존재하지만 최종 결과에서는 한 번만 남는다.

즉 `UNION`은 단순히 결과를 이어 붙이는 것에서 끝나는 것이 아니라 **합쳐진 결과에서 동일한 행을 하나로 정리한다.**

---

## 5. 중복까지 그대로 유지하려면 UNION ALL을 사용한다

조회 결과에 같은 값이 여러 번 나타나더라도 그대로 유지해야 하는 경우에는 `UNION ALL`을 사용할 수 있다.

```sql
SELECT name, email
FROM users

UNION ALL

SELECT name, email
FROM retired_users;
```

`UNION`과 `UNION ALL`의 차이는 이번 내용에서는 중복 처리 여부로 구분할 수 있다.

| 구분 | 처리 방식 |
| --- | --- |
| `UNION` | 합친 결과에서 중복된 행을 제거 |
| `UNION ALL` | 각 조회 결과를 그대로 모두 포함 |

따라서 어떤 것을 사용할지는 **같은 행이 여러 번 나타나도 되는지**를 먼저 판단해야 한다.

```text
중복을 제거해야 함
→ UNION

중복도 그대로 필요함
→ UNION ALL
```

---

## 6. UNION ALL은 중복을 제거하는 과정이 없다

`UNION`은 결과를 합친 뒤 동일한 행을 제거하는 과정이 필요하다.

반면 `UNION ALL`은 중복을 제거하지 않고 각각의 조회 결과를 그대로 합친다.

```text
UNION
→ 결과를 합침
→ 중복 제거

UNION ALL
→ 결과를 그대로 합침
```

따라서 중복 제거가 필요하지 않은 상황이라면 `UNION ALL`에서는 그 작업 자체가 발생하지 않는다.

이번 내용에서는 두 연산자의 차이를 단순히 결과 모양만 보는 것이 아니라, **중복을 처리하는 과정이 있는지 없는지**까지 함께 구분했다.

---

## 7. 정렬은 합쳐진 최종 결과에 적용한다

`UNION`이나 `UNION ALL`로 여러 조회 결과를 합친 뒤에는 전체 결과를 정렬할 수도 있다.

이때 `ORDER BY`는 각각의 `SELECT`에 따로 적용하는 것이 아니라 마지막에 작성한다.

```sql
SELECT name, email
FROM users

UNION

SELECT name, email
FROM retired_users

ORDER BY name;
```

흐름을 나누어 보면 다음과 같다.

```text
첫 번째 SELECT 결과 조회
        +
두 번째 SELECT 결과 조회
        ↓
UNION으로 결과 결합
        ↓
ORDER BY로 최종 결과 정렬
```

즉 여기서 `ORDER BY`가 대상으로 하는 것은 첫 번째 조회나 두 번째 조회 중 하나가 아니라 **UNION으로 만들어진 전체 결과**다.

---

## 8. 정렬할 때도 최종 결과의 컬럼을 기준으로 본다

앞에서 `UNION`의 결과 컬럼 이름은 첫 번째 `SELECT`를 기준으로 한다고 정리했다.

따라서 마지막의 `ORDER BY`에서도 최종 결과에서 사용할 수 있는 컬럼 이름을 기준으로 정렬해야 한다.

예를 들어 두 테이블에 같은 의미의 날짜가 서로 다른 이름으로 저장되어 있을 수 있다.

```text
users
→ created_at

retired_users
→ retired_date
```

이 두 컬럼을 같은 위치에서 합치더라도 최종 결과의 컬럼 이름은 첫 번째 `SELECT`를 기준으로 결정된다.

따라서 두 값을 하나의 의미로 표현하고 싶다면 별칭을 붙여 사용할 수 있다.

```sql
SELECT name, email, created_at AS event_date
FROM users

UNION ALL

SELECT name, email, retired_date AS event_date
FROM retired_users

ORDER BY event_date DESC;
```

여기서는 서로 다른 이름의 날짜 컬럼을 `event_date`라는 하나의 이름으로 표현했다.

이렇게 하면 최종 결과에서 해당 컬럼이 어떤 의미로 사용되는지 확인하기도 쉽고, 정렬할 때도 같은 이름을 사용할 수 있다.

---

## 9. 이번 내용에서 정리한 UNION의 흐름

이번에 학습한 내용을 하나의 흐름으로 정리하면 다음과 같다.

```text
서로 다른 SELECT 결과가 있음
        ↓
하나의 결과로 합쳐야 함
        ↓
각 SELECT의 컬럼 개수와 위치 확인
        ↓
중복 제거가 필요한지 판단
        ↓
UNION 또는 UNION ALL 선택
        ↓
필요하다면 마지막 ORDER BY로 전체 결과 정렬
```

내가 이해한 핵심은 **UNION은 서로 다른 SELECT문의 결과 구조를 맞춘 뒤 하나의 결과 집합으로 합치는 방법**이라는 것이다.

이때 중복을 제거하려면 `UNION`, 중복까지 그대로 유지하려면 `UNION ALL`을 사용한다.

그리고 여러 조회를 모두 합친 결과를 정렬해야 한다면 `ORDER BY`는 마지막에 적용한다.
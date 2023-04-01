# SQL 활용

### 서브쿼리 [Subquery]

쿼리 안에 존재하는 또 다른 쿼리

수행 순서는 가장 내부에 있는 서브 쿼리부터 수행된다.

- 용어정리

    외부 쿼리 → 메인쿼리

    내부 쿼리 → 서브쿼리

- 스칼라 서브쿼리 [Scalar Subquery, 위치: SELECT 절]

    **SELECT절 뿐만 아니라 컬럼이 오는 대부분 위치에 사용가능**

    → 예를 들면 UPDATE의 SET절, ORDER BY절등이 있다.

    컬럼에 사용되는 대신 반드시 값을 하나만 반환해야한다.

    → 그러지 않으면 에러를 뱉는다.

    - 예시

        ```sql
        select (select M.MEMBER_ID from MEMBER_SAMPLE_1 M where MEMBER_UUID = PR.MEMBER_UUID) as MEMBER_ID,
               CONTENT,
               REGDATE
        from PRODUCT_REVIEW_SAMPLE_1 PR;
        ```

- 인라인 뷰 [Inline View, 위치: FROM절]

    **FROM절등 테이블 명이 올 수 있는 위치에 사용가능**

    - 예시

        ```sql
        select PR.PRODUCT_CODE,
               P.PRODUCT_NAME,
               P.PRICE,
               (select M.MEMBER_ID from MEMBER_SAMPLE_1 M where MEMBER_UUID = PR.MEMBER_UUID) as MEMBER_ID,
               PR.CONTENT
        from PRODUCT_REVIEW_SAMPLE_1 PR,
             (select PRODUCT_CODE, PRODUCT_NAME, PRICE from PRODUCT_SAMPLE_1) P
        where PR.PRODUCT_CODE = P.PRODUCT_CODE;
        ```

- 중첩 서브쿼리 [Nested Subquery, 위치: WHERE절 & HAVING절]
    - 비연관 서브쿼리 [Un-correlated Subquery]

        메인쿼리와 관계를 맺고 있지 않는 중첩 서브쿼리

        - 예시

            ```sql
            select NAME,
                   JOB,
                   BIRTHDAY,
                   AGENCY_CODE
            from ENTERTAINER
            where AGENCY_CODE = (select AGENCY_CODE from AGENCY where AGENCY_NAME = 'EDAM엔터테인먼트');
            ```

    - 연관 서브쿼리 [Correlated Subquery]

        메인쿼리와 관계를 맺고 있는 중첩 서브쿼리

        - 예시

            ```sql
            select ORDER_NO,
                   DRINK_CODE,
                   ORDER_CNT
            from CAFE_ORDER CO1
            where ORDER_CNT = (select MAX(ORDER_CNT) from CAFE_ORDER CO2 where CO1.DRINK_CODE=CO2.DRINK_CODE);
            ```

    - 단일 행 서브쿼리 [Single Row Subquery]

        서브쿼리가 1건 이하의 로우만 반환

        단일 행 비교 연산자와 함께 사용한다.

        → =, <, >, ≤, ≥, <> 등등

        - 예시

            ```sql
            select *
            from PRODUCT_SAMPLE_1
            where PRICE = (select max(PRICE) from PRODUCT_SAMPLE_1);
            ```

    - 다중 행 서브쿼리 [Multi Row Subquery]

        서브쿼리가 2건 이상의 로우만 반환

        다중 행 비교 연산자와 함께 사용한다.

        → IN, ALL, ANY, SOME, EXISTS

        - 예시

            ```sql
            select *
            from PRODUCT_SAMPLE_1
            where PRODUCT_CODE in (select PRODUCT_CODE from PRODUCT_REVIEW_SAMPLE_1);
            ```

    - 다중 컬럼 서브쿼리 [Multi Column Subquery]

        서브쿼리가 여러 컬럼의 데이터를 반환

        - 예시

            ```sql
            select *
            from EMPLOYEES
            where (JOB_ID, SALARY) in (select JOB_ID, SALARY from JOBS where MAX_SALARY = 10000);
            ```



### 뷰 [View]

특정 SELECT 문에 이름을 붙여서 재사용이 가능하도록 저장해놓은 오브젝트

SQL에서 테이블처럼 사용가능

- 주의점

    뷰는 가상 테이블이라 실제 데이터를 저장하지 않고 SELECT문만 가지고 있다.

- 특징
    1. 보안성

        보안이 필요한 컬럼을 가진 테이블일 경우 해당 컬럼을 제외한 뷰를 생성해 제공하여 보안유지

    2. 독립성

        테이블 스키마가 변경되어도 뷰만 수정하여 사용가능

    3. 편리성

        복잡한 쿼리 구문을 뷰명으로 단축시켜 가독성을 높일 수 있음

- 예시

    ```sql
    -- 뷰 생성
    create or replace view DEPT_EMP_MEMBER as
    select DEP.DEPARTMENT_ID,
           DEP.DEPARTMENTS_NAME,
           EMP.FIRST_NAME,
           EMP.LAST_NAME
    from DEPARTMENTS DEP
             left outer join EMPLOYEES EMP on DEP.DEPARTMENT_ID = EMP.DEPARTMENT_ID;
    -- 뷰 사용
    select * from DEPT_EMP_MEMBER where DEPARTMENTS_NAME = 'IT Department';

    -- 뷰 삭제
    drop view DEPT_EMP_MEMBER;
    ```


### 집합 연산자

각 쿼리의 결과를 가지고 연산을 하는 명령어

- UNION ALL

    !![[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-08-29_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_9.50.18.png]]

    - 예시

        ```sql
        select *
        from RUNNING_MAN
        UNION ALL
        select *
        from INFINITE_CHALLENGE;
        ```

- UNION

    !![[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-08-29_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_9.51.02.png]]

    - 예시

        ```sql
        select *
        from RUNNING_MAN
        UNION
        select *
        from INFINITE_CHALLENGE;
        ```

    - 주의점

        UNION ALL은 전부 출력하지만 UNION은 중복 제거 검증을 거쳐 제거하는 로직을 한번 더 돌게 된다.

        이로 인한 성능 저하가 존재 한다.

        → 만약 확실하게 교집합되는 부분(중복)이 없다면 UNION ALL을 선택해야한다.

- INTERSECT

    !![[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-08-29_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_9.51.14.png]]

    - 예시

        ```sql
        select *
        from RUNNING_MAN
        INTERSECT
        select *
        from INFINITE_CHALLENGE;
        ```

    - 주의점

        **헤더 값은 첫 번째 쿼리를 따라간다!!**

- MINUS/EXCEPT

    !![[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-08-29_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_9.51.25.png]]

    - 예시

        ```sql
        select *
        from RUNNING_MAN
        MINUS
        select *
        from INFINITE_CHALLENGE;
        ```


### 그룹 함수

데이터를 GROUP BY하여 나타낼 수 있는 함수

- ROLLUP

    소 그룹간의 소계 및 총계를 계산하는 함수

    **집계 함수를 합쳐 반환**

    - ROLLUP(A)
        1. A로 그룹핑
        2. (반복)…
        3. 총 합계
        - 예시

            ```sql
            -- 주문 수량을 날짜 별로 그룹핑 카운트
            select ORDER_DT, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY ORDER_DT;

            -- 주문 수량을 날짜별로 그룹핑 카운트 이후 합계 계산을 위해 rollup
            select ORDER_DT, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY rollup (ORDER_DT)
            order by ORDER_DT;
            ```

    - ROLLUP(A, B)
        1. A, B로 그룹핑
        2. A로 그룹핑
        3. (반복)…
        4. 총 합계
        - 예시

            ```sql
            -- 주문 수량을 날짜&주문음료 별로 그룹핑하여 카운트
            select ORDER_DT, ORDER_ITEM, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY ORDER_DT, ORDER_ITEM
            order by ORDER_DT;

            -- 주문 수량을 날짜&주문음료 별로 그룹핑한 소계를 구하고 날짜별로 그룹핑을 하여 소계를 구한 뒤 총 합계를 구하기 위해 rollup
            select ORDER_DT, ORDER_ITEM, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY rollup (ORDER_DT, ORDER_ITEM)
            order by ORDER_DT;
            ```

    - ROLLUP(A, B, C)
        1. A, B, C로 그룹핑
        2. A, B로 그룹핑
        3. A로 그룹핑
        4. (반복)…
        5. 총 합계
        - 예시

            ```sql
            -- 주문 수량을 날짜&주문음료&판매사원 별로 그룹핑하여 카운트
            select ORDER_DT, ORDER_ITEM, REG_NAME, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY ORDER_DT, ORDER_ITEM, REG_NAME
            order by ORDER_DT;

            -- 주문 수량을 날짜&주문음료&판매사원 별로 그룹핑한 소계를 구하고 날짜&주문음료 별로 그룹핑한 소계를 구하고 날짜 별로 그룹핑한 소계를 구한 뒤 총 합계를 구하기 위해 rollup
            select ORDER_DT, ORDER_ITEM, REG_NAME, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY rollup (ORDER_DT, ORDER_ITEM, REG_NAME)
            order by ORDER_DT;
            ```

        - 주의점

            괄호를 추가하여 ORDER_DT, ORDER_ITEM&REG_NAME으로 그루핑하는 것이 가능하다.

            특정 컬럼들만 묶어서 ROLLUP하는 것이 가능하다.

- CUBE

    소 그룹 간의 소계 및 총계를 다차원적으로 계산할 수 있는 함수

    조합할 수 있는 모든 그룹에 대해 소계를 집계할 수 있다.

    **실제 돌렸을때의 서순은 좀 다르지만 결과 자체는 이런식이다.**

    **일반적으로 단일 그룹핑 결과가 복수 그룹핑 결과 다음에 사이사이에 들어가는 편이다.**

    - CUBE(A)

        이 경우는 ROLLUP과 결과가 같다.

        1. A로 그룹핑
        2. (반복)…
        3. 총합계
        - 예시

            ```sql
            -- 주문 수량을 날짜별로 그룹핑하여 카운트
            select ORDER_DT, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY ORDER_DT
            order by ORDER_DT;

            -- 주문 수량을 날짜별로 그룹핑한 뒤 총합계를 구하기 위해 cube
            select ORDER_DT, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY Cube(ORDER_DT)
            order by ORDER_DT;
            ```

    - CUBE(A, B)
        1. A, B로 그룹핑
        2. A로 그룹핑
        3. (반복)…
        4. B로 그룹핑
        5. 총합계
        - 예시

            ```sql
            -- 주문 수량을 날짜&주문음료별로 그룹핑
            select ORDER_DT, ORDER_ITEM, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY ORDER_DT, ORDER_ITEM
            order by ORDER_DT;

            -- 주문 수량을 날짜&주문음료별로 그룹핑한 뒤 카운트, 날짜 별로 그룹핑한 뒤 카운트 한뒤 주문음료별 각 카운트를 구하고 총 합계를 구하기 위해 CUBE
            select ORDER_DT, ORDER_ITEM, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY cube (ORDER_DT, ORDER_ITEM)
            order by ORDER_DT;

            -- 결과적으론 같은 위와 쿼리
            select ORDER_DT, ORDER_ITEM, COUNT(*)
            from STARBUCKS_ORDER
                GROUP BY ORDER_DT, ORDER_ITEM
            UNION ALL
            select ORDER_DT, NULL, COUNT(*)
            from STARBUCKS_ORDER
                GROUP BY ORDER_DT
            UNION ALL
            select NULL, ORDER_ITEM, COUNT(*)
            from STARBUCKS_ORDER
                GROUP BY ORDER_ITEM
            UNION ALL
            select NULL, NULL, COUNT(*)
            from STARBUCKS_ORDER
                ORDER BY 1,2;
            ```

    - CUBE(A, B, C)
        1. A, B, C로 그룹핑
        2. A, B로 그룹핑
        3. A, C로 그룹핑
        4. B, C로 그룹핑
        5. A로 그룹핑
        6. B로 그룹핑
        7. (반복)…
        8. C로 그룹핑
        9. 총합계
        - 예시

            ```sql
            -- 주문 수량을
            -- 날짜&주문음료&판매사원별로 그룹핑하여 카운트,
            -- 날짜&주문음료별로 그룹핑하여 카운트,
            -- 날짜&판매사원별로 그룹핑하여 카운트,
            -- 주문음료&판매사원별로 그룹핑하여 카운트,
            -- 날짜별로 그룹핑하여 카운트,
            -- 주문음료별로 그룹핑하여 카운트,
            -- 판매사원별로 그룹핑하여 카운트한 뒤 총 합계를 구하기 위해 CUBE
            select ORDER_DT, ORDER_ITEM,REG_NAME, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY CUBE(ORDER_DT, ORDER_ITEM, REG_NAME)
            order by ORDER_DT;

            -- 이때 괄호를 날짜와 주문 음료에 추가하면 이 두 컬럼을 하나로 묶어서 반환한다.
             select ORDER_DT, ORDER_ITEM,REG_NAME, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY CUBE((ORDER_DT, ORDER_ITEM), REG_NAME)
            order by ORDER_DT, ORDER_ITEM, REG_NAME;
            -- 또다른 괄호를 추가한 케이스
             select ORDER_DT, ORDER_ITEM,REG_NAME, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY CUBE(ORDER_DT, (ORDER_ITEM, REG_NAME))
            order by ORDER_DT, ORDER_ITEM, REG_NAME;
            ```

- GROUPING SETS

    특정 항목에 대한 소계를 계산하는 함수

    파라미터로 ROLLUP, CUBE, ( )를 넣을 수 있으며

    일반적으로 ROLLUP을 넣어 그룹을 하나로 묶어서 사용하는 편이다.

    → (예: GROUPING SETS(A, ROLLUP(B, C)))

    - GROUPING SETS(A, B)
        1. A로 그룹핑
        2. B로 그룹핑
        - 예시

            ```sql
            select ORDER_DT, ORDER_ITEM, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY GROUPING SETS (ORDER_DT, ORDER_ITEM)
            order by ORDER_DT;
            ```

    - GROUPING SETS(A, B, ( ))
        1. A로 그룹핑
        2. B로 그룹핑
        3. 총합계
        - 예시

            ```sql
            -- 여기서 전체 합(총계)를 구하기 위해 파라미터를 추가
            -- [( ) 버전]
            select ORDER_DT, ORDER_ITEM, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY GROUPING SETS (ORDER_DT, ORDER_ITEM, ())
            order by ORDER_DT, ORDER_ITEM;
            ```

    - GROUPING SETS(A, ROLLUP(B))
        1. A로 그룹핑
        2. B로 그룹핑
        3. 총합계
        - 예시

            ```sql
            -- [ROLLUP 버전] IDE에서 에러가 나오긴하지만 실행해보면 잘된다.
            select ORDER_DT, ORDER_ITEM, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY GROUPING SETS (ORDER_DT, rollup(ORDER_ITEM))
            order by ORDER_DT, ORDER_ITEM;
            ```

    - GROUPING SETS(A, ROLLUP(B, C))
        1. A로 그룹핑
        2. B, C로 그룹핑
        3. B로 그룹핑
        4. 총합계
        - 예시

            ```sql
            select ORDER_DT, ORDER_ITEM, REG_NAME, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY GROUPING SETS (ORDER_DT, rollup(ORDER_ITEM, REG_NAME))
            order by ORDER_DT, ORDER_ITEM, REG_NAME;
            ```

    - GROUPING SETS(A, B, ROLLUP(C))
        1. A로 그룹핑
        2. B로 그룹핑
        3. C로 그룹핑
        4. 총합계
        - 예시

            ```sql
            select ORDER_DT, ORDER_ITEM, REG_NAME, COUNT(*)
            from STARBUCKS_ORDER
            GROUP BY GROUPING SETS (ORDER_DT, ORDER_ITEM, rollup(REG_NAME))
            order by ORDER_DT, ORDER_ITEM, REG_NAME;
            ```

    - 주의점

        **ROLLUP 등으로 그룹을 묶는다고 해도 단일 그룹핑 결과도 같이 반환해준다.**

- GROUPING

    ROLLUP, CUBE, GROUPING SETS와 함께 쓰이며 소계를 나타내는 ROW를 구분되게 반환

    소계를 나타내는 ROW를 NULL로 반환하지 않고 원하는 위치에 원하는 텍스트로 반환이 가능하게 해준다.

    다만 CASE문을 사용해야 한다.→ 실무에서 거의 쓸일 없다는 뜻이다.

    - 예시

        ```sql
        select case grouping(ORDER_DT) when 1 then 'total' else ORDER_DT end     as ORDER_DT,
               case grouping(ORDER_ITEM) when 1 then 'total' else ORDER_ITEM end as ORDER_ITEM,
               COUNT(*)
        from STARBUCKS_ORDER
        GROUP BY rollup (ORDER_DT, ORDER_ITEM)
        order by ORDER_DT;
        ```


### 윈도우 함수

OVER와 함께 사용되는 함수

- 순위함수
    1. RANK

        순위를 매기면서 같은 순위가 존재하면 존재하는 수만큼 다음 순위를 건너 뛴다.

        → 1, 2, 2, 4, 5, 5, 7…

        - 예시

            ```sql
            -- RANK
            select ORDER_DT, COUNT(*), RANK() OVER (ORDER BY COUNT(*) DESC) AS RANK
            from STARBUCKS_ORDER
            group by ORDER_DT;

            -- RANK 파티션을 추가해 각 부서별(DEPARTMENT_ID별) 봉급이 제일 높은 사원부터 순위를 매김
            select FIRST_NAME,
                   LAST_NAME,
                   DEPARTMENT_ID,
                   SALARY,
                   RANK() over ( partition by DEPARTMENT_ID order by SALARY desc ) as RANK
            from EMPLOYEES;
            ```


        만약 그룹핑 결과 10개 그룹에서 동일 7위가 3그룹이 나왔다면

        → 1,2,3,4,5,6,7,7,7,10

    2. DENSE_RANK

        순위를 매기면서 같은 순위가 존재해도 다음 순위로 건너 뛰지 않고 다음 순위를 매긴다.

        - 예시

            ```sql
            -- DENSE_RANK
            select ORDER_DT, COUNT(*), DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS DENSE_RANK
            from STARBUCKS_ORDER
            group by ORDER_DT;

            -- DENSE_RANK 파티션을 추가해 각 부서별(DEPARTMENT_ID별) 봉급이 제일 높은 사원부터 순위를 매김
            select FIRST_NAME,
                   LAST_NAME,
                   DEPARTMENT_ID,
                   SALARY,
                   DENSE_RANK() over ( partition by DEPARTMENT_ID order by SALARY desc ) as DENSE_RANK
            from EMPLOYEES;
            ```


        만약 그룹핑 결과 10개 그룹에서 동일 7위가 3그룹이 나왔다면

        → 1,2,3,4,5,6,7,7,7,8

    3. ROW_NUMBER

        순위를 매기면서 같은 순위가 존재해도 같은 순위에 각각 임의의 랭크를 부여한다.

        넘어가거나 뛰어넘기는 일없이 그냥 번호를 매겨버린다.

        - 예시

            ```sql
            -- ROW_NUMBER
            select ORDER_DT, COUNT(*), ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS ROW_NUMBER
            from STARBUCKS_ORDER
            group by ORDER_DT;

            -- ROW_NUMBER 파티션을 추가해 각 부서별(DEPARTMENT_ID별) 봉급이 제일 높은 사원부터 순위를 매김
            select FIRST_NAME,
                   LAST_NAME,
                   DEPARTMENT_ID,
                   SALARY,
                   ROW_NUMBER() over ( partition by DEPARTMENT_ID order by SALARY desc ) as ROW_NUMBER
            from EMPLOYEES;
            ```


        만약 그룹핑 결과 10개 그룹에서 동일 7위가 3그룹이 나왔다면

        → 1,2,3,4,5,6,7,8,9,10

- 집계함수
    1. SUM

        데이터의 합계를 반환

        파라미터로 NUMBER형, 즉 숫자형만 받을 수 있다.

        - 예시

            ```sql
            -- SUM
            select
                sum(SCORE)
            from SQLD;

            -- SUM 개인별 총 점수를 over절 PARTITION BY로 구하기
            select STUDENT_NAME,
                   SUBJECT,
                   SCORE,
                   sum(SCORE) over ( PARTITION BY STUDENT_NAME ) as TOTAL_SCORE
            from SQLD;

            -- SUM 개인별 총 점수를 over절 PARTITION BY로 구할 때 ORDER BY를 추가해 데이터 누적값 구하기 [Oracle 전용 구문 추가 버전]
            select STUDENT_NAME,
                   SUBJECT,
                   SCORE,
                   sum(SCORE) over ( PARTITION BY STUDENT_NAME ORDER BY SUBJECT DESC RANGE UNBOUNDED PRECEDING ) as TOTAL_SCORE
            from SQLD;

            -- SUM 개인별 총 점수를 over절 PARTITION BY로 구할 때 ORDER BY를 추가해 데이터 누적값 구하기 [Oracle 전용 구문 생략 버전]
            select STUDENT_NAME,
                   SUBJECT,
                   SCORE,
                   sum(SCORE) over ( PARTITION BY STUDENT_NAME ORDER BY SUBJECT DESC ) as TOTAL_SCORE
            from SQLD;
            ```

        - 주의점

            **ORDER BY에 따라 동일 컬럼은 한번에 SUM한 결과를 반환하는것을 주의!**

    2. MAX

        데이터의 최댓값을 반환

        - 예시

            ```sql
            -- MAX
            select
                MAX(SCORE) as MAX_SCORE
            from SQLD;

            -- MAX 과목별 MAX 점수를 over절 PARTITION BY로 구하기
             select
                 STUDENT_NAME,
                 SUBJECT,
                 SQLD.SCORE,
                MAX(SCORE) over ( PARTITION BY SUBJECT) as MAX_SCORE
            from SQLD;

            -- MAX 과목별 MAX 점수를 받은 사람만 over절 PARTITION BY로 구하기 [인라인뷰 활용]
             select
                 STUDENT_NAME,
                 SUBJECT,
                 SCORE
            from (
                select STUDENT_NAME,
                       SUBJECT,
                       SCORE,
                       MAX(SCORE) over ( PARTITION BY SUBJECT) as MAX_SCORE
                from SQLD
                 )
            where SCORE = MAX_SCORE;
            ```

    3. MIN

        데이터의 최솟값을 반환

        - 예시

            ```sql
            -- MIN
            select
                MIN(SCORE) as MIN_SCORE
            from SQLD;

            -- MIN 과목별 MIN 점수를 over절 PARTITION BY로 구하기
             select
                 STUDENT_NAME,
                 SUBJECT,
                 SQLD.SCORE,
                MIN(SCORE) over ( PARTITION BY SUBJECT) as MIN_SCORE
            from SQLD;

            -- MIN 과목별 MIN 점수를 받은 사람만 over절 PARTITION BY로 구하기 [인라인뷰 활용]
             select
                 STUDENT_NAME,
                 SUBJECT,
                 SCORE
            from (
                select STUDENT_NAME,
                       SUBJECT,
                       SCORE,
                       MIN(SCORE) over ( PARTITION BY SUBJECT) as MIN_SCORE
                from SQLD
                 )
            where SCORE = MIN_SCORE;
            ```

        - 주의점

            **order by ~ DESC를 추가하게 되면 매 행마다 최소값을 찾을려고 하면 현재 행이 최소값이기 때문에**

            **윈도잉절 default가 UNBOUND PRECEDING이라 매번 현재 행을 최솟값으로 리턴한다.**

            **order by ~ desc가 있는지 확인!!!**

    4. AVG
        - 예시

            ```sql
            -- AVG
            select
                AVG(SCORE) as AVG_SCORE
            from SQLD;

            -- AVG 과목별 AVG 점수를 over절 PARTITION BY로 구하기 [ROUND연산을 통해 반올림]
             select
                 STUDENT_NAME,
                 SUBJECT,
                 SQLD.SCORE,
                ROUND(AVG(SCORE) over ( PARTITION BY SUBJECT)) as AVG_SCORE
            from SQLD;

            -- AVG 과목별 AVG 점수를 받은 사람만 over절 PARTITION BY로 구하기 [인라인뷰 활용, ROUND연산을 통해 반올림]
             select
                 STUDENT_NAME,
                 SUBJECT,
                 SCORE
            from (
                select STUDENT_NAME,
                       SUBJECT,
                       SCORE,
                       ROUND(AVG(SCORE) over ( PARTITION BY SUBJECT)) as AVG_SCORE
                from SQLD
                 )
            where SCORE >= AVG_SCORE;
            ```

    5. COUNT

        특정 데이터의 총 ROW수를 반환

        **→ NULL 컬럼의 ROW는 무시하니 주의 할 것!! [컬럼형 함수 특징]**

        - 예시

            ```sql
            -- COUNT
            select
                COUNT(*) as COUNT_SCORE
            from SQLD;

            -- COUNT 과목별 PASS한 카운트를 over절 PARTITION BY로 구하기
             select
                 STUDENT_NAME,
                 SUBJECT,
                 SQLD.SCORE,
                COUNT(*) over ( PARTITION BY SUBJECT) as PASS_COUNT
            from SQLD
            where RESULT = 'PASS';
            -- COUNT 과목별 본인보다 점수가 높거나 같은 건수를 COUNT하는 over절 PARTITION BY로 구하기 [WINDOWING절 활용]
             select
                 STUDENT_NAME,
                 SUBJECT,
                 SQLD.SCORE,
                COUNT(*) over ( PARTITION BY SUBJECT order by SQLD.SCORE desc range UNBOUNDED PRECEDING ) as HIGHER_COUNT
            from SQLD;

            -- COUNT 과목별 본인보다 점수가 5점이하로 차이(+-)가 나거나 같은 건수를 COUNT하는 over절 PARTITION BY로 구하기 [WINDOWING절 활용]
             select
                 STUDENT_NAME,
                 SUBJECT,
                 SQLD.SCORE,
                COUNT(*) over ( PARTITION BY SUBJECT order by SQLD.SCORE desc range BETWEEN 5 PRECEDING AND 5 FOLLOWING ) as SIMILAR_COUNT
            from SQLD;
            ```

- 행 순서 함수
    1. FIRST_VALUE

        [MSSQL 미지원]

        파티션 별 가장 선두에 위치한 데이터를 반환

        - 예시

            ```sql
            -- FIRST_VALUE
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   first_value(SQLD.SCORE) over (order by SQLD.SCORE) as FIRST_VALUE
            from SQLD;

            -- FIRST_VALUE 과목별로 오름차순으로 정렬후 가장 첫번째 숫자를 over절 PARTITION BY로 구하기
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   first_value(SQLD.SCORE) over (PARTITION BY SUBJECT order by SQLD.SCORE desc) as FIRST_VALUE
            from SQLD;
            ```

    2. LAST_VALUE

        [MSSQL 미지원]

        파티션별 가장 끝에 위치한 데이터 반환

        - 예시

            ```sql
            -- LAST_VALUE
            -- 77로 되지 않는 이유는 WINDOWING절 default가 RANGE UNBOUND PRECEDING이라 매 행의 맨 윗끝행부터 현재행까지를 지정하기 때문
            -- 매번 LAST_VALUE를 지정할 때마다 현재 행이 맨 끝행이니 그냥 현재 행이 적히는 것이다.
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   last_value(SQLD.SCORE) over (order by SQLD.SCORE) as LAST_VALUE
            from SQLD;
            -- WINDOWING절을 손봐 전체 행을 기준으로 전환
            -- UNBOUND FOLLOWNING까지 범위를 넓혀 매 행의 맨 끝줄을 땡겨오게끔 수정한 버전
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   last_value(SQLD.SCORE) over (order by SQLD.SCORE RANGE BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING ) as LAST_VALUE
            from SQLD;

            -- LAST_VALUE 과목별로 내림차순으로 정렬후 가장 마지막 숫자를 over절 PARTITION BY로 구하기
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   last_value(SQLD.SCORE) over (PARTITION BY SUBJECT order by SQLD.SCORE RANGE BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING) as LAST_VALUE
            from SQLD;
            ```

        - 주의점

            윈도우를 지정해주지 않으면 제대로된 값을 반환하지 않는다!!!!

    3. LAG

        [MSSQL 미지원]

        파티션 별 특정 수 만큼 윗 Row의 데이터를 반환

        특정 수를 파라미터로 넣지 않으면 1을 default로 넣는다.

        - 예시

            ```sql
            -- LAG
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   lag(SQLD.SCORE,3) over (order by SQLD.SCORE) as LAG
            from SQLD;

            -- LAG 숫자 생략 버전
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   lag(SQLD.SCORE) over (order by SQLD.SCORE) as LAG
            from SQLD;

            -- LAG 과목별로 현재 행보다 2만큼 윗 row의 점수를 over절 PARTITION BY로 구하기
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   lag(SQLD.SCORE,2) over (Partition By SUBJECT order by SQLD.SCORE desc) as LAG
            from SQLD;
            ```

    4. LEAD

        [MSSQL 미지원]

        파티션 별 특정 수 만큼 아래 Row의 데이터를 반환

        특정 수를 파라미터로 넣지 않으면 1을 default로 넣는다.

        - 예시

            ```sql
            -- LEAD
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   lead(SQLD.SCORE,3) over (order by SQLD.SCORE) as LEAD
            from SQLD;

            -- LEAD 숫자 생략 버전
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   lead(SQLD.SCORE) over (order by SQLD.SCORE) as LEAD
            from SQLD;

            -- LEAD 과목별로 현재 행보다 2만큼 윗 row의 점수를 over절 PARTITION BY로 구하기
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   lead(SQLD.SCORE,2) over (Partition By SUBJECT order by SQLD.SCORE desc) as LEAD
            from SQLD;
            ```

- 비율 함수
    1. RATIO_TO_REPORT

        [MSSQL 미지원]

        목표 컬럼의 총 합계에서 비율반환

        → col1/sum(col1)

        - 예시

            ```sql
            -- RATIO_TO_REPORT
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   sum(SQLD.SCORE) over ()             as SUM,
                   SQLD.SCORE / sum(SQLD.SCORE) over ()     as "SCORE/SUM",
                   RATIO_TO_REPORT(SQLD.SCORE) over () as RATIO_TO_REPORT
            from SQLD;
            -- RATIO_TO_REPORT 과목별 총합 점수 대비 비율을 over절 PARTITION BY로 구하기
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   sum(SQLD.SCORE) over (partition by SUBJECT)             as SUM,
                   SQLD.SCORE / sum(SQLD.SCORE) over (partition by SUBJECT)     as "SCORE/SUM",
                   RATIO_TO_REPORT(SQLD.SCORE) over (partition by SUBJECT) as RATIO_TO_REPORT
            from SQLD;
            ```

    2. PERCENT_RANK

        [MSSQL 미지원]

        특정 컬럼의 맨 위 끝 행을 0, 맨 아래 끝 행을 1로 놓고 현재 행이 위치하는 백분위 순위값을 반환

        → 현재 순위 /전체 순위

        - 예시

            ```sql
            -- PERCENT_RANK
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   rank() over (order by SQLD.SCORE)                                   as RANK,
                   count(*) over ()                                                    as COUNT,
                   ((rank() over ( order by SQLD.SCORE) - 1) / (count(*) over () - 1)) as "(RANK-1)/(COUNT-1)",
                   PERCENT_RANK() over (order by SQLD.SCORE)                           as PERCENT_RANK
            from SQLD;

            -- PERCENT_RANK 과목별 점수 랭크 비율(0~1)을 over절 PARTITION BY로 구하기
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   rank() over (partition by SUBJECT order by SQLD.SCORE)                                                      as RANK,
                   count(*) over (partition by SUBJECT)                                                                        as COUNT,
                   ((rank() over (partition by SUBJECT order by SQLD.SCORE) - 1) /
                    (count(*) over (partition by SUBJECT) - 1))                                                                as "(RANK-1)/(COUNT-1)",
                   PERCENT_RANK() over (partition by SUBJECT order by SQLD.SCORE)                                              as PERCENT_RANK
            from SQLD;
            ```

    3. CUME_DIST

        [MSSQL 미지원]

        특정 파티션의 누적 백분율을 반환

        → 현재 로우 위치/전체 로우 수

        → 0이 나올수 없다.

        - 예시

            ```sql
            -- CUME_DIST
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   count(*) over (order by SQLD.SCORE)                                   as COUNT,
                   count(*) over ()                                                    as TOTAL_COUNT,
                   (count(*) over ( order by SQLD.SCORE) / count(*) over ()) as "COUNT/TOTAL_COUNT",
                   CUME_DIST() over (order by SQLD.SCORE)                           as CUME_DIST
            from SQLD;

            -- CUME_DIST 과목별 누적 백분율을 over절 PARTITION BY로 구하기
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   count(*) over (partition by SUBJECT order by SQLD.SCORE)                                                      as COUNT,
                   count(*) over (partition by SUBJECT)                                                                        as TOTAL_COUNT,
                   (count(*) over (partition by SUBJECT order by SQLD.SCORE) /
                    count(*) over (partition by SUBJECT))                                                                as "COUNT/TOTAL_COUNT",
                   CUME_DIST() over (partition by SUBJECT order by SQLD.SCORE)                                              as CUME_DIST
            from SQLD;
            ```

    4. NTILE

        [MSSQL 미지원]

        주어진 수만큼 row들을 n등분한뒤 현재 행에 해당하는 임의의 등급을 반환

        - 예시

            ```sql
            -- NTILE
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   NTILE(1) over (order by SQLD.SCORE DESC )                           as NTILE1,
                   NTILE(3) over (order by SQLD.SCORE DESC )                           as NTILE3,
                   NTILE(5) over (order by SQLD.SCORE DESC )                           as NTILE5
            from SQLD;

            -- NTILE 과목별 전체 N등분후 랭크를 over절 PARTITION BY로 구하기
            select STUDENT_NAME,
                   SUBJECT,
                   SQLD.SCORE,
                   NTILE(1) over (partition by SUBJECT order by SQLD.SCORE DESC )                           as NTILE1,
                   NTILE(3) over (partition by SUBJECT order by SQLD.SCORE DESC )                           as NTILE3,
                   NTILE(5) over (partition by SUBJECT order by SQLD.SCORE DESC )                           as NTILE5
            from SQLD;
            ```

        - 주의점

            **N등분이 딱 나눠 떨어지지 않는 경우 맨 앞의 ROW 그룹부터 하나씩 늘린다.**

- WINDOWING 절

    집계하려는 데이터의 양을 지정하는 절

    |  | BETWEEN UNBOUND PRECEDING AND n PRECEDING |
    | --- | --- |
    |  | BETWEEN UNBOUND AND CURRENT ROW |
    |  | BETWEEN UNBOUND PRECEDING AND n FOLLOWING |
    |  | BETWEEN UNBOUND PRECEDING AND UNBOUND FOLLOWING |
    |  | BETWEEN n PRECEDING AND n PRECEDING |
    |  | BETWEEN n PRECEDING AND CURRENT ROW |
    | RANGE ROWS | BETWEEN n PRECEDING AND n FOLLOWING |
    |  | BETWEEN n PRECEDING AND UNBOUND FOLLOWING |
    |  | BETWEEN CURRENT ROW AND n FOLLOWING  |
    |  | BETWEEN CURRENT ROW AND UNBOUND FOLLOWING |
    |  | BETWEEN n FOLLOWING ROW AND n FOLLOWING  |
    |  | BETWEEN n FOLLOWING ROW AND UNBOUND FOLLOWING |
    |  | UNBOUND PRECEDING [*RANGE UNBOUND PRECEDING이 default] |
    |  | n PRECEDING |
    |  | CURRENT ROW |
    - 범위
        - UNBOUND PRECEDING

            위쪽 끝 행

        - UNBOUND FOLLOWING

            아래쪽 끝 행

        - CURRENT ROW

            현재 행

        - n PRECEDING

            현재 행에서 위로 n만큼 이동

        - n FOLLOWING

            현재 행에서 아래로 n만큼 이동

    - 기준점
        - ROWS

            행 자체가 기준이 된다

        - RANGE

            행이 가지고 있는 데이터 값이 기준이 된다.

    - 예시

        RANGE BETWEEN UNBOUND PRECEDING AND CURRENT ROW

        → 처음부터 현재 행까지, RANGE UNBOUNDED PRECEDING과 같은 의미

        RANGE BETWEEN 10 PRECEDING AND CURRENT ROW

        → 현재 행이 가지고 있는 값보다 10만큼 적은 행부터 현재 행까지, RANGE 10 PRECEDING과 같은 의미

        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

        → 현재 행부터 끝까지

        ROWS BETWEEN CURRENT ROW AND 5 FOLLOWING

        → 현재 행부터 아래로 5만큼 이동한 행까지

    - 주의점

        **n PRECEDING의 의미는 본인 로우를 포함하고 중복된 컬럼까지 포함해서 카운트한다!**


### Top - N 쿼리

- ROWNUM

    일종의 슈도 컬럼(Pseudo Column)

    임의의 순번을 매기는 컬럼

    - 예시

        ```sql
        -- ROWNUM TOP-N 쿼리 [인라인뷰 활용]
        select ROWNUM,
               이름,
               국어,
               영어,
               수학
        from (select 이름, 국어, 영어, 수학
              from EXAM_SCORE
              order by 국어 desc, 영어 desc, 수학 desc)
        where ROWNUM <= 5;
        -- ROWNUM TOP-N 불가능 버전 쿼리
        -- order by는 where문 보다 나중에 수행되기 때문에 불가능하다.
        select ROWNUM,
               이름,
               국어,
               영어,
               수학
        from EXAM_SCORE
        where ROWNUM <= 5
        order by 국어 desc, 영어 desc, 수학 desc;
        ```

- 윈도우 함수의 순위 함수
    - 예시

        ```sql
        -- 윈도우 함수의 순위 함수 TOP-N 쿼리 [ROW_NUMBER in InlineView]
        select *
        from (select ROW_NUMBER() over (order by 국어 desc, 영어 desc, 수학 desc) as RNUM,
                     이름,
                     국어,
                     영어,
                     수학
              from EXAM_SCORE)
        where RNUM <= 5;

        -- 윈도우 함수의 순위 함수 TOP-N 쿼리 [RANK in InlineView]
        select *
        from (select RANK() over (order by 국어 desc, 영어 desc, 수학 desc) as RANK,
                     이름,
                     국어,
                     영어,
                     수학
              from EXAM_SCORE)
        where RANK <= 5;

        -- 윈도우 함수의 순위 함수 TOP-N 쿼리 [DENSE_RANK in InlineView]
        select *
        from (select DENSE_RANK() over (order by 국어 desc, 영어 desc, 수학 desc) as DENSE_RANK,
                     이름,
                     국어,
                     영어,
                     수학
              from EXAM_SCORE)
        where DENSE_RANK <= 5;
        ```

- **주의점**

    ROWNUM은 단순히 번호지정에 불가능하다. **특정 번호의 row를 지정하거나 이후의 row를 지정하는 것은 불가능**하며 **특정 row의 이전 row들만 출력하는 것만 가능**하다.


### 셀프 조인 [Self Join]

나 자신과의 조인

FROM절에 같은 테이블이 2번, 3번씩 나오기 때문에 명확한 별칭 지정이 중요하다.

가장 좋은 예시는 카테고리, 대댓글등이 있는데 카테고리로 진행하겠다.

- 예시

    ```sql
    -- Self Join [대분류만 출력]
    select A.CATEGORY_TYPE,
           A.CATEGORY_NAME,
           B.CATEGORY_TYPE,
           B.CATEGORY_NAME
    from CATEGORY A,
         CATEGORY B
    where A.CATEGORY_NAME = B.PARENT_CATEGORY
      and A.CATEGORY_TYPE = '대';

    -- Self Join [대중소 분류 다 출력]
    select A.CATEGORY_TYPE,
           A.CATEGORY_NAME,
           B.CATEGORY_TYPE,
           B.CATEGORY_NAME,
           C.CATEGORY_TYPE,
           C.CATEGORY_NAME
    from CATEGORY A,
         CATEGORY B,
         CATEGORY C
    where A.CATEGORY_NAME = B.PARENT_CATEGORY
      and B.CATEGORY_NAME = C.PARENT_CATEGORY;
    ```

- 주의점

    Depth가 깊어질수록 조인이 늘어난다. 계속 늘어날 기미가 보인다면 계층쿼리를 사용해야한다.


### 계층 쿼리

계층 구조를 이루는 Recursive한 쿼리가 존재한다면 이를 계층 쿼리로 데이터를 반환 가능하다

- 예시

    ```sql
    -- 계층 쿼리 [순방향]
    select LEVEL,
           CATEGORY_TYPE as TYPE,
           CATEGORY_NAME as NAME,
           PARENT_CATEGORY as PARENT,
           SYS_CONNECT_BY_PATH('[' || CATEGORY_TYPE || ']' || CATEGORY_NAME, '-') as PATH
    from CATEGORY
    start with PARENT_CATEGORY is null
    connect by prior CATEGORY_NAME = PARENT_CATEGORY;
    -- 계층 쿼리 [CATEGORY_TYPE 기준,역방향]
    select LEVEL,
           CATEGORY_TYPE as TYPE,
           CATEGORY_NAME as NAME,
           PARENT_CATEGORY as PARENT,
           SYS_CONNECT_BY_PATH('[' || CATEGORY_TYPE || ']' || CATEGORY_NAME, '-') as PATH
    from CATEGORY
    start with CATEGORY_TYPE = '소'
    connect by CATEGORY_NAME = PRIOR PARENT_CATEGORY
    order by LEVEL;
    -- 계층 쿼리 [CATEGORY_NAME 기준,역방향]
    select LEVEL,
           CATEGORY_TYPE as TYPE,
           CATEGORY_NAME as NAME,
           PARENT_CATEGORY as PARENT,
           SYS_CONNECT_BY_PATH('[' || CATEGORY_TYPE || ']' || CATEGORY_NAME, '-') as PATH
    from CATEGORY
    start with CATEGORY_NAME = '노트북/PC'
    connect by CATEGORY_NAME = PRIOR PARENT_CATEGORY
    order by LEVEL;

    -- 계층 쿼리 응용 버전 [순방향]
    select LEVEL,
           CATEGORY_TYPE as TYPE,
           CATEGORY_NAME as NAME,
           PARENT_CATEGORY as PARENT,
           CONNECT_BY_ROOT  CATEGORY_NAME as ROOT_NAME,
           CONNECT_BY_ISLEAF AS IS_LEAF
    from CATEGORY
    start with PARENT_CATEGORY is null
    connect by prior CATEGORY_NAME = PARENT_CATEGORY;

    -- 계층 쿼리 같은 이름끼리 정렬 [순방향]
    select LEVEL,
           CATEGORY_TYPE as TYPE,
           CATEGORY_NAME as NAME,
           PARENT_CATEGORY as PARENT,
           SYS_CONNECT_BY_PATH('[' || CATEGORY_TYPE || ']' || CATEGORY_NAME, '-') as PATH
    from CATEGORY
    start with PARENT_CATEGORY is null
    connect by prior CATEGORY_NAME = PARENT_CATEGORY
    order siblings by NAME;
    ```

- 주의점
    1. 역방향 배열은 `start with` 구문 조건을 리프 노드로 잡고 `connect by` 조건을 현재 이름 = 상위 부모 이름으로 잡으면 된다.

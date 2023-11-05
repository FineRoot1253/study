# SQL 기본

### 관계형 데이터베이스 개요

- 데이터베이스

    데이터를 저장하는 공간

- 관계형 데이터베이스

    RDB[Relational Database], 관계형 데이터 모델에 기초를 둔 데이터베이스

- Table

    관계형 데이터베이스는 모든 데이터를 2차원 테이블 형태로 표현한다.

    컬럼 [Column] - 속성

    로우 [Row] - 인스턴스

- SQL [Structured Query Language]

    RDB에서 데이터를 다루기 위해 사용하는 언어

- SQL 수행순서
    1. 파싱 [Parsing]

        SQL 문법 확인후 구문 분석

        구문 분석을 완료한 SQL은 Library Cache에 저장한다.

    2. 실행 [Execution]

        옵티마이저가 수립한 실행 계획에 따라 SQL을 실행한다.

    3. 인출 [Fetch]

        데이터를 읽어서 전송한다.


### SELECT 문

저장된 데이터를 조회하는 명령어

```sql
SELECT 컬럼1, 컬럼2, ... FROM 테이블 WHERE 컬럼1 = '아무개';
```

- **SELECT문 논리 수행 순서**


    | 구문 | 수행순서 |
    | --- | --- |
    | SELECT | 5 |
    | FROM | 1 |
    | WHERE | 2 |
    | GROUP BY | 3 |
    | HAVING | 4 |
    | ORDER BY | 6 |
- 산술 연산자


    | 연산자 | 의미 | 우선순위 |
    | --- | --- | --- |
    | () | 괄호로 우선순위 선정 | 1 |
    | * | 곱하기 | 2 |
    | / | 나누기 | 2 |
    | + | 더하기 | 3 |
    | - | 빼기 | 3 |
    - 주의점

        연산중 컬럼에 NULL이 존재하면 그 결과는 NULL이 된다.

- 합성 연산자

    문자와 문자를 연결할 때 사용하는 연산자

    - 예시

        ```sql
        SELECT 'S'||'Q'||'L'||'개'||'발'||'자' AS SQLD FROM DUAL;

        # 결과
        # SQLD
        # --------
        # SQLD개발자
        ```


### 함수

- 문자 함수
    1. CHR(ASCII 코드)

        <aside>
        💡 MSSQL은 CHAR(ASCII 코드)이다.

        </aside>

        총 128개의 문자를 숫자로 표현해 놓은 코드가 ASCII 코드이다.

        숫자로된 ASCII 코드를 입력하면 해당하는 문자가 반환된다.

    2. LOWER(문자열)

        문자열을 소문자로 변환해주는 함수

    3. UPPER(문자열)

        문자열을 대문자로 변환해주는 함수

    4. LTRIM(문자열[,특정문자])

        <aside>
        💡 MSSQL은 공백제거만 가능하다.

        </aside>

        문자열 인수와 특정 문자를 또 다른 인수로 넣게 되면 해당 특정 문자를 **왼쪽부터** 찾아서 제거한다.

        특정 문자를 넣지 않으면 공백 문자를 **왼쪽부터** 찾아서 제거한다.

    5. RTRIM(문자열[,특정문자])

        <aside>
        💡 MSSQL은 공백제거만 가능하다.

        </aside>

        문자열 인수와 특정 문자를 또 다른 인수로 넣게 되면 해당 특정 문자를 **오른쪽부터** 찾아서 제거한다.

        특정 문자를 넣지 않으면 공백 문자를 **오른쪽부터** 찾아서 제거한다.

    6. TRIM([위치 조건] [특정문자] [FROM] 문자열)

        <aside>
        💡 MSSQL은 공백제거만 가능하다.

        </aside>

        옵션을 넣지 않으면 공백 문자를 **양쪽 끝부터** 찾아 제거한다.

        - 위치 조건
            - LEADING

                왼쪽부터 검색한다는 의미

            - TRAILING

                오른쪽부터 검색한다는 의미

            - BOTH

                양쪽 끝부터 검색한다는 의미

        - **TRIM류 함수의 주의 사항**

            **특정 문자가 문자열일 경우 그 문자열의 일부라도 포함한다면 해당하는 일부분을 제거해버린다.**

    7. SUBSTR(문자열, 시작위치 ,[길이])

        <aside>
        💡 MSSQL는 SUBSTRING(문자열)이다.

        </aside>

        문자열의 특정 부분을 잘라서 반환한다.

        길이를 넣지 않으면 맨 끝(오른쪽)까지 탐색한다.

        - 주의점

            일반적인 배열 탐색과 다르게 1부터 시작한다.

            - 예시

                SUBSTR(’mssql’,2,3)

                → ‘ss’

    8. LENGTH(문자열)

        <aside>
        💡 MSSQL는 LEN(문자열)이다.

        </aside>

        문자열의 길이를 반환한다.

    9. REPLACE(문자열, 변경 전 문자열, [변경 후 문자열])

        문자열에서 변경 전 문자열을 찾아 변경 후 문자열로 바꿔준다.

        변경 후 문자열을 넣지 않으면 변경 전 문자열을 찾아 제거한다.

- 숫자 함수
    1. ABS(숫자)

        수의 절대값을 반환한다

    2. SIGN(숫자)

        수의 부호를 반환한다.

        다음과 같이 반환한다.

        양수 → 1

        음수 → -1

        0 → 0

    3. ROUND(숫자, [자릿수])

        숫자를 지정된 소수점 자릿수까지 반올림하여 반환한다.

        자릿수를 넣지 않으면 0으로 넣은 결과를 반환하며 자릿수로 음수를 넣게 되면 정수부 부분을 반올림하여 반환한다.

    4. TRUNC(숫자, [자릿수])

        숫자를 지정된 소수점 자릿수까지 버리고 반환한다.

        자릿수를 넣지 않으면 0을 넣은 결과를 반환하며 자릿수가 음수일 경우 정수부 부분에서 버리고 반환한다.

    5. CEIL(숫자)

        소수점 이하의 숫자를 올림한 정수로 반환한다.

        - 주의점

            음수인 경우는 그냥 버린다. 양수인 경우에만 올림 처리한다.

            **→ 숫자보다 크거나 같은 최소 정수를 반환하게 된다.**

    6. FLOOR(숫자)

        소수점 이하의 숫자를 버림한 정수로 반환한다.

    7. MOD(숫자1, 숫자2)

        숫자1을 숫자2로 나눈 나머지를 반환한다.

        - 주의점
            1. **숫자1과 숫자2 둘다 음수를 넣으면 결과는 음수 나머지가 도출된다.**

                **만약 둘중 하나만 음수이면 양수 결과가 나온다.**

            2. **숫자2에 0이 들어가면 결과는 숫자1이다.**
- 날짜 함수
    - SYSDATE

        <aside>
        💡 MSSQL는 GETDATE()이다.

        </aside>

        현재 년, 월, 시, 분, 초를 반환한다. (nls_date_format에 따라 출력 형태가 달라진다.)

    - EXTRACT(특정 단위 FROM 날짜 데이터)

        <aside>
        💡 MSSQL는 DATEPART(특정 단위, 날짜 데이터)이다.

        </aside>

        날짜 데이터에서 특정 단위만을 출력해 반환한다.

        - 특정 단위
            - YEAR
            - MONTH
            - DAY
            - HOUR
            - MINUTE
            - SECOND
    - ADD_MONTHS(날짜 데이터, 특정 개월 수)

        <aside>
        💡 MSSQL는 DATEADD(MONTH, 특정 개월 수, 날짜 데이터)이다.

        </aside>

        날짜 데이터에 특정 개월 수를 더한 결과를 반환한다.

        날짜의 이전 달이나 다음 달에 기준 날짜의 일자가 존재하지 않으면 해당 월의 마지막 일자가 반환된다.

- 변환 함수
    - 명시적 형변환

        변환 함수를 이용해 명시적으로 형변환

        <aside>
        💡 MSSQL는 CONVERT나 CAST 함수가 있다.

        </aside>

        1. TO_NUMBER(문자열)

            문자열을 숫자로 변환한다.

        2. TO_CHAR(숫자 OR 날짜, [ 포맷])

            숫자 또는 날짜를 포맷 형식의 문자열로 변환한다.

        3. TO_DATE(문자열, [ 포맷])

            포맷 형식의 문자를 날짜로 변환한다.

    - 암시적 형변환

        데이터베이스 내부적으로 자동으로 형변환

        → 컬럼의 데이터 타입을 고려하지 않으면 예상하지 못한 형변환을 시도하게된다.

        → 예를 들면 돈과 같은 VARCHAR 컬럼에 생각없이 NUMBER 타입 연산을 시도하는 경우가 있다.

        → 암시적 형변환이라 휴먼 에러가 나오기 십상이며 예상치 못한 성능저하와 에러가 나올 가능성이 크다.

        → 타입과 다른 연산을 시도할 때에는 명시적 형변환을 시도하는 것이 바람직하다.

- NULL 관련 함수
    1. NVL(인수1, 인수2)

        인수1의 값이 NULL일 경우 인수2를 반환하고 NOT NULL일 경우 인수1을 반환한다

    2. NULLIF(인수1, 인수2)

        인수1과 인수2가 같으면 NULL을 반환하고 같지 않으면 인수1을 반환한다.

    3. COALESCE(인수1, 인수2, 인수3, …)

        NULL이 아닌 최초의 인수를 반환한다

- CASE

    CASE문은 전형적인 SWITCH … CASE ~, CASE ~와 같은 문구이다.

    이때 SQL에서는 일반적으로 CASE … WHEN ~, WHEN ~ … 이런식으로 사용하며

    Oracle에서는 DECODE 함수를 이용해 함수를 사용하기도 한다.


### WHERE 절

Insert문을 제외한 모든 DML에 Predicate를 하여 특정 로우를 선택하게 만드는 탐색 조건문이다.

주로 Predict 동작, 구문 등등으로 말하곤 한다.

- 비교 연산자


    | 연산자 | 의미 | 예시 |
    | --- | --- | --- |
    | = | 같다 | where col = 10 |
    | < | 작다 | where col < 10 |
    | ≤ | 작거나 같다 | where col ≤ 10 |
    | > | 크다 | where col > 10 |
    | ≥ | 크거나 같다 | where col ≥ 10 |
- 부정 비교 연산자


    | 연산자 | 의미 | 예시 |
    | --- | --- | --- |
    | != | 같지 않다 | where col != 10 |
    | ^= | 같지 않다 | where col ^= 10 |
    | <> | 같지 않다 | where col <> 10 |
    | not 컬럼명 = | 같지 않다 | where not col = 10 |
    | not 컬럼명 > | 크지 않다 | where not col > 10 |
- SQL 연산자


    | 연산자 | 의미 | 예시 |
    | --- | --- | --- |
    | BETWEEN A AND B | A와 B사이 [A와 B또한 포함한다] | where col between 1 and 10 |
    | LIKE ‘비교 문자열’ | 비교 문자열을 포함하면 참 | where col like ‘홍%’ |
    | IN (LIST) | LIST 중 하나와 일치하면 참 | where col in (1, 3, 5) |
    | IS NULL | NULL이면 참 | where col is null |
- 부정 SQL 연산자


    | 연산자 | 의미 | 예시 |
    | --- | --- | --- |
    | NOT BETWEEN A AND B | A와 B사이에 없으면 참
    [A와 B또한 포함하지 않는다.] | where col not between 1 and 10 |
    | NOT IN (LIST) | LIST 중 어느 것도 일치 하지 않으면 참 | where col not in (1, 3, 5) |
    | IS NOT NULL | NULL이 아니면 참 | where col is not null |
- 논리 연산


    | 연산자 | 의미 | 예시 |
    | --- | --- | --- |
    | AND | 모두 참이여야 참 | where col > 1  and col < 10 |
    | OR | 하나라도 참이면 참 | where col = 1  or col = 10 |
    | NOT | 참이면 거짓, 거짓이면 참 | where not col > 10 |
    - 주의점
        1. AND 연산자와 OR 연산자는 NOT 적용시 서로 치환된다.

            → AND = NOT OR

            → OR = NOT AND

        2. 연산 순서가 존재한다.

            ( ) → NOT → AND → OR


### GROUP BY, HAVING 절

- GROUP BY

    데이터를 그룹별로 묶는 절이다.

    BY 뒤에 오는 기준으로 묶게 되며 해당 기준을 식별자로써 묶이게 된다.

- 집계 함수

    집계 함수는 컬럼값이 NULL인 Row(인스턴스)를 기본적으로 무시한다 (Count(*)제외)

    - COUNT(*)

        전체 ROW를 Count하여 반환

    - COUNT(컬럼)

        컬럼 값이 NULL인 Row를 제외하고 Count하여 반환

    - COUNT(DISTINCT 컬럼)

        컬럼 값이 NULL이 아니며 중복또한 제거한 Count를 반환

    - SUM(컬럼)

        컬럼 값들의 합계를 반환

    - AVG(컬럼)

        컬럼 값들의 평균을 반환

    - MIN(컬럼)

        컬럼 값들중 최솟값을 반환

    - MAX(컬럼)

        컬럼 값들중 최댓값을 반환

- HAVING

    GROUP BY를 통해 새로이 그룹을 묶을 때 WHERE절 처럼 적용하는 조건절

    그룹핑 이후 특정 그룹만 선택하기 위해 사용되는 편이다.

    GROUP BY는 비교적 비용이 많이 드는 작업이기 때문에 수행 전에 데이터량을 최소한으로 줄이는 것이 좋다.

    - **주의점**
        1. 집계함수에 대한 조건절은 HAVING절을 사용해야한다.
        - 예시

            SELECT절 특정 컬럼이 집계함수이며 여기에 조건을 걸어야 하는 경우 HAVING절로 조건을 줘야한다.

            → SELECT절의 수행순서는 HAVING절보다 뒤이기 때문이다.

        1. 특정 컬럼의 별칭(alias)는 WHERE문이나 HAVING절에 사용할 수 없다.

### ORDER BY 절

SELECT문에서 맨 마지막에 수행되는 정렬 조건문이다.

BY 뒤에는 정렬의 기준이 되는 컬럼이 배치된다.

따로 순서를 명시 하지 않으면 오름차순(ASC)가 디폴트이다.

- ASC [Ascending]

    오름차순

- DESC [Descending]

    내림차순

- 주의점
    1. 정렬 기준 컬럼중 컬럼값이 NULL인 Row는 DB마다 다르게 처리한다.
        - Oralce

            NULL인 컬럼은 최댓값으로 처리한다.

            → 오름차순 : 맨 끝 배치

            → 내림차순 : 맨 앞 배치

        - MSSQL

            NULL인 컬럼은 최솟값으로 처리한다.

            → 오름차순 : 맨 앞 배치

            → 내림차순 : 맨 끝 배치

        - NULL 순서 변경

            NULLS FIRST, NULLS LAST 옵션으로 이 위치를 변경해줄 수 있다.


### JOIN

각기 다른 엔티티들을 합친 결과를 반환

- EQUI JOIN

    Equal(=) 조건으로 Join하는 가장 일반적인 조인 방식

    - 예시

        ```sql
        select
            A.PRODUCT_CODE,
            A.PRODUCT_NAME,
            B.MEMBER_UUID,
            B.CONTENT,
            B.REGDATE
            from PRODUCT_SAMPLE_1 A,
                 PRODUCT_REVIEW_SAMPLE_1 B
            where A.PRODUCT_CODE = B.PRODUCT_CODE;
        ```

- Non EQUI JOIN

    Equal(=) 조건이 아닌 다른 조건으로 조인하는 방식

    - 예시

        ```sql
        select
            E.EVENT_NAME,
            (select M.MEMBER_ID from MEMBER_SAMPLE_1 M where MEMBER_UUID = PR.MEMBER_UUID) as MEMBER_ID,
            PR.CONTENT,
            PR.REGDATE
            from EVENT_SAMPLE_1 E,
                 PRODUCT_REVIEW_SAMPLE_1 PR
            where PR.REGDATE BETWEEN E.START_DATE AND E.END_DATE;
        ```

- 3개 이상 TABLE JOIN

    3개 이상 테이블을 조인하는 것도 가능하다.

    - 예시

        ```sql
        select
            P.PRODUCT_NAME,
            (select M.MEMBER_ID from MEMBER_SAMPLE_1 M where MEMBER_UUID = PR.MEMBER_UUID) as MEMBER_ID,
            PR.CONTENT,
            E.EVENT_NAME
            from
                PRODUCT_SAMPLE_1 P,
                EVENT_SAMPLE_1 E,
                 PRODUCT_REVIEW_SAMPLE_1 PR
            where P.PRODUCT_CODE = PR.PRODUCT_CODE AND
                  PR.REGDATE BETWEEN E.START_DATE AND E.END_DATE;
        ```

- OUTER JOIN

    JOIN시 WHERE문 조건에 맞지 않는 행들도 출력되는 형태의 JOIN

    - LEFT(RIGHT) OUTER JOIN

        LEFT TABLE과 RIGHT TABLE의 데이터 중 JOIN에 성공한 데이터와 JOIN에 성공하지 못한 나머지 LEFT(RIGHT) TABLE의 데이터가 함께 출력된다. RIGHT OUTER JOIN은 반대다.

    - Oracle 예시

        이 (+)로 전부 출력되는 테이블을 지정해주는 것인데 사실 이건 사용할때마다 혼동이 오기 때문에 *~~(어디에 (+) 넣더라?)~~* 대부분 비추하는 방식이다.

        그냥 명확하고 공통적으로 사용하는 ANSI 스타일을 고수하는게 좋다.

        ```sql
        select
            P.PRODUCT_CODE,
            P.PRODUCT_NAME,
            (select M.MEMBER_ID from MEMBER_SAMPLE_1 M where MEMBER_UUID = PR.MEMBER_UUID) as MEMBER_ID,
            PR.CONTENT,
            PR.REGDATE
            from
                PRODUCT_SAMPLE_1 P,
                 PRODUCT_REVIEW_SAMPLE_1 PR
            where P.PRODUCT_CODE = PR.PRODUCT_CODE(+);
        ```


### STANDARD JOIN [ANSI JOIN]

ANSI 표준 Standard 조인

- Inner Join

    Join 조건에 충족하는 데이터만 반환

    ![[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-08-28_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_4.58.36.png]]

    - 예시

        ```sql
        select
            P.PRODUCT_CODE,
            P.PRODUCT_NAME,
            PR.MEMBER_UUID,
            PR.CONTENT,
            PR.REGDATE
            from PRODUCT_SAMPLE_1 P
                inner join PRODUCT_REVIEW_SAMPLE_1 PR
                    on P.PRODUCT_CODE = PR.PRODUCT_CODE;
        ```

- OUTER JOIN

    JOIN 조건에 충족하는 데이터와 더불어 충족하지 않는 데이터까지 반환

    - LEFT OUTER JOIN

        ![[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-08-28_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5.24.18.png]]

        SQL에서 왼쪽에 표기된 데이터는 무조건 반환하는 조인

        오른쪽에 조인이 되는 데이터가 있는지 없는지는 무시하고 반환한다.

        → 일반적으로 이럴땐 오른쪽 테이블 컬럼은 NULL이 채워진다.

        - 예시

            ```sql
            select
                P.PRODUCT_CODE,
                P.PRODUCT_NAME,
                PR.MEMBER_UUID,
                PR.CONTENT,
                PR.REGDATE
                from PRODUCT_SAMPLE_1 P
                    left outer join PRODUCT_REVIEW_SAMPLE_1 PR
                        on P.PRODUCT_CODE = PR.PRODUCT_CODE;
            ```

    - RIGHT OUTER JOIN

        ![[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-08-28_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5.24.44.png]]

        SQL에서 오른쪽에 표기된 데이터는 무조건 반환하는 조인

        왼쪽에 조인이 되는 데이터가 있는지 없는지는 무시하고 반환한다.

        → 일반적으로 이럴땐 왼쪽 테이블 컬럼은 NULL이 채워진다.

        - 예시

            ```sql
            select PR.MEMBER_UUID,
                   PR.CONTENT,
                   PR.REGDATE,
                   P.PRODUCT_CODE,
                   P.PRODUCT_NAME
            from PRODUCT_REVIEW_SAMPLE_1 PR
                     right outer join PRODUCT_SAMPLE_1 P
                                      on PR.PRODUCT_CODE = P.PRODUCT_CODE;
            ```

    - FULL OUTER JOIN

        ![[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-08-28_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.33.21.png]]

        오른쪽, 왼쪽 테이블의 데이터를 남김 없이 모두 반환한다.

        - 예시

            ```sql
            select R.CAST as R_CAST,
                   I.CAST as I_CAST
            from RUNNING_MAN R
                     full outer join INFINITE_CHALLENGE I
                                     on I.CAST = R.CAST;
            ```

    - NATURAL JOIN

        LEFT와 RIGHT 테이블 **둘 다 같은 이름을 가진 컬럼이 전부 동일한 데이터**를 지니고 있다면 JOIN을 하여 반환

        → 이때 **ON절은 사용하지 않는다.**

        - 예시

            ```sql
            select *
            from RUNNING_MAN R
                     natural join INFINITE_CHALLENGE I;
            ```


    USING절을 사용하여 특정 컬럼만 동일 이름 컬럼, 동일 데이터 조건을 걸 수 있다.

    단, SELECT절에서 USING 절로 정의된 컬럼 앞에는 별도의 ALIAS나 테이블 명을 적지 않아야 한다.

    - USING 절 활용 예시

        ```sql
        select CAST,
               GENDER,
               R.JOB as R_JOB,
               I.JOB as I_JOB
        from RUNNING_MAN R
                 join INFINITE_CHALLENGE I using (cast, gender);
        ```

    - CROSS JOIN [Cartesian Product, 세타 조인]

        LEFT와 RIGHT 테이블 사이 아무런 JOIN 조건이 없는 경우 조합 가능한 모든 경우를 반환

        - 예시

            ```sql
            select
                E.NAME,
                E.JOB,
                E.BIRTHDAY,
                D.DRINK_CODE,
                D.DRINK_NAME
                from ENTERTAINER E cross join DRINK D;
            ```

        - 주의점

            EQUI JOIN시 WHERE문 조건 또는 ANSI JOIN시 ON절 조건 등등 조인 컬럼 조건이 없으면

            무조건 크로스 조인으로 인식한다.

            다음과 같은 예제도 동일하게 동작한다.

            ```sql
            select
                E.NAME,
                E.JOB,
                E.BIRTHDAY,
                D.DRINK_CODE,
                D.DRINK_NAME
                from ENTERTAINER E, DRINK D;
            ```

    - 주의점
        1. **WHERE문 사용시 최종 결과에 적용되므로 주의할 것**

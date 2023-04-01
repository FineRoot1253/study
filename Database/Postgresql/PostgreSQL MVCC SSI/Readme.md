# PostgreSQL MVCC/SSI

### 목차

1. MVCC
2. MGA 방식 MVCC 특징
3. MGA 방식 MVCC 구현방식
4. MVCC/SSI
5. SSI의 필요성
6. SSI 구현
    1. 구현 목표
    2. S2PL, OCC와의 차이점
    3. SIREAD
    4. READ ONLY 최적화
        1. Safe Snapshot
        2. Deferrable Transaction
    5. 충돌 감지
        1. 충돌 복구 [Safe Retry]
    6. 메모리 사용 최적화
        1. Aggresive Cleanup
        2. Summarizing Committed Transactions

# PostgreSQL MVCC

## PostgreSQL의 MGA 특징

1. Postgresql은 단일 명령, 복합 그룹 명령(BEGIN-COMMIT) 전부 트랜잭션으로 다룬다.
2. Postgresql의 튜플의 로우들을 여러버전의 로우가 존재한다.

## 동작 원리

1. 트랜잭션 시작시 XID를 증가 시키고 현재 트랜잭션에 적용한다.
- Insert의 경우
    1. Commit;또는 단일행 명령이 완료되면 현재 XID를 **시스템 컬럼인 xmin**에 저장한다.
    2. xmin보다 작은 XID를 가진 Row만 현재 트랜잭션에서 볼수 있다.
- Update, Delete의 경우
    1. Commit;또는 단일행 명령이 완료되면 **시스템 컬럼인 xmax**를 저장한다.

        ⇒ Postgresql의 update 동작은 사실 delete와 똑같이 동작한다.

        ⇒ 이때 가시성을 결정한다고 하는데 이 의미는 xmin ~ xmax까지의 범위에서 지닌 가시적인 값이라는 것이다. (그리고 이전 버전임을 암시한다.)

        예를 들면 xmin이 10, xmax가 30이면 xid 10~30까지의 가시성을 지녔다고 의미하는 것이다.

        ⇒ 이 이후 xmin이 30(xmax와 동일한 값)인 값으로 추가된 튜플은 xid 30부터 가시적인 살아 있는 튜플(현재 버전이며 액티브 버전)이다.

        (xmax가 들어왔지만 액티브 버전인 경우도 있다. 이 경우는 row level lock을 통해 select를 했을 경우이다.(ex. select … for update) 이 경우는 의미상 row level lock이라는 것을 힌트 비트와 함께 보면 알수 있기 때문에 암묵적으로 액티브튜플로써 동작한다.)

    2. update OR delete 진행중인 트랜잭션의 로우가 잠금 상태이면 대기한다.

        ⇒ 이때 실행한 처음 실행 했던 Where문의 결과로 xmax가 0이 아니여서 대기를 했던 것이다. [잠금 상태]

        ⇒ 이때 커밋이 되어 잠금이 해제되고 배타 잠금이 현재 트랜잭션으로 넘어온 상태된 경우의 로직은 다음과 같다.

        1. 다시 where문을 통해 적용 시킬 로우들을 탐색한다.

            **⇒ 이때의 결과 로우와 처음 조회 했던 결과 로우와 비교해 부분집합의 로우에 이 Update or Delete를 적용시킨다.**

            ⇒ 이 부분이 MySQL이나 OracleDB와 확실히 다른 차이점을 보인다.



## MGA식 MVCC 장점

1. DBMS 제품군 특유의 Lock Table의 오버플로우를 방지 할수 있다.

    ⇒ 이는 보통 MS-SQL, DB2등의 Lock 매니저를 통해 동적으로 Lock Escalate를 통해 동적으로 사용된다.

    ⇒ Lock Escalate는 동적으로 테이블을 늘리는 것이 아니라 락의 범위를 넓히는 것이다.  이는 MGL에 따라 트리구조로 시스템을 바라보고 락킹범위를 정하는 것이다.

    ⇒ (multi granularity locking 다중 세분성 락킹, MGL은 특정 개체의 락킹이 다른 개체를 포함하여 락하는 것을 의미하는데 트리구조를 기반하여 한 노드를 락하면 하위 노드들이 전부 락되는 계층적 특성을 이용한 잠금 방법이다, 특히 락킹 에스컬레이션에서 세분성(granularity)를 결정하는 방법은 최대한 하위 노드의 락을 하고 다음 상위 노드로 락킹을 확대하는 것인데 이는 **한 트랜잭션의 특정 노드의 락킹에 따라 타 트랜잭션의 상위 노드의 락킹의 종류를 제한하여(락킹 호환성을 이용하여) 락킹되는 특성을 이용하는 것이다.** 락킹에 따라 호환되는 락킹을 작성한 락킹 호환성 매트릭스(테이블)에 따라 락끼리 호환된다.)

    [https://yruby.tistory.com/40](https://yruby.tistory.com/40)

    [https://www.geeksforgeeks.org/multiple-granularity-locking-in-dbms/](https://www.geeksforgeeks.org/multiple-granularity-locking-in-dbms/)

    ⇒ 일반적으론 이 Lock Table은 서버가 시작될 때 고정 크기로 할당되는 게 일반적이고 이를 온전히 방지할 수 있는 방법으로써 MGA 방식이 쓰이는 것이다.


## 단점

1. I/O 수행에 악영향을 미친다.

    ⇒ 이 이유때문에 Oracle DB나 MySQL에 비해 CUD 성능이 떨어지는 단점은 명백히 존재한다.

2. **VACUUM FULL 현상이 발생한다.**

    [https://www.postgresql.org/docs/14/sql-vacuum.html](https://www.postgresql.org/docs/14/sql-vacuum.html)

    ⇒ 튜플의 업데이트된 옛날 버전 로우 & 삭제된 옛날 로우는 삭제되지 않고 남아 있다.

    ⇒ 그래서 Postgresql은 VACUUM을 통해 테이블을 정리하는 동작이 필요하다.

    ⇒ 이로 인해 Postgresql은 자바의 FULL GC와 비슷한 VACUUM FULL 현상이 발생한다.

    ⇒ Vacuuming 루틴은 VACUUM 데몬에 의해 동작을 하고 있으며 세부 설정을 통해 I/O과정중 발생하는 오버헤드를 줄여 줄수도 있다.

    ⇒ 이는 페이지를 따로 때어서 정리해보면 좋을 것 같다.


## xmax 상세 정보 확인 방법

이 xmax는 상당히 독특하게 동작을 한다. 특히 row lock을 저장한다는 의미를 해석하기 위해선 이 아래의 방법을 사용해야 명백히 확인할 수 있다.

### **contrib**

Postgresql은 자체적으로 contrib이라는 모듈의 pageinspect를 제공한다.

- 사용법

    [https://www.postgresql.org/docs/current/pageinspect.html](https://www.postgresql.org/docs/current/pageinspect.html)

    참고로 이 여러 메타데이터, 테이블 상세 정보를 뜯어보기에 필수인 모듈이며 이를 자세히 알고 싶다면 여기서 검색해서 찾아 쓰면 된다.

    1. 아래의 extension을 생성하자.

        ```sql
        CREATE EXTENSION pageinspect;
        ```

    2. 다음과 같이 명령어를 사용해 조회하면 테이블 raw 블럭이 나온다.

        ```sql

        SELECT lp,
        			 t_ctid AS ctid,
               t_xmin AS xmin,
               t_xmax AS xmax,
               (t_infomask & 128)::boolean AS xmax_is_lock,
               (t_infomask & 1024)::boolean AS xmax_committed,
               (t_infomask & 2048)::boolean AS xmax_rolled_back,
               (t_infomask & 4096)::boolean AS xmax_multixact,
               t_attrs[1] AS member_id,
               t_attrs[2] AS money
        FROM heap_page_item_attrs(
                get_raw_page('member', 0),
                'member'
             );
        ```

- 특징
    1. xmax가 변경되었어도 이 테이블 블록 분석으로는 아쉽게도 커밋 로그를 알수가 없다.

        ⇒ xmax가 만들어진 이유를 알수가 없는 것이다.

        ⇒ 이는 트랜잭션이 종료될때, 이 힌트 비트가 업데이트 되지 않기 때문이다.

        ⇒ 이 힌트 비트는 xmas_is_lock ~ xmax_multixact까지의 컬럼을 의미한다.

    2. 이를 위해선 각 트랜잭션의 State를 보관하는 커밋로그를 봐야하지만 SQL를 통한 방법으로는 DB 트랜잭션이 튜플을 읽고(SELECT) 커밋로그를 조회하게 되면 이때, Reader가 이 결과를 튜플에 유지하게 된다.

        ⇒ 이것을 힌트 비트를 세팅한다. 라고 한다.

        ⇒ Vacuum이 하는 역할이기도 하다.

        ⇒ 이는 단순히 Read 즉, 조회만 했는데도 불구하고 **Write I/O가 발생했음을 의미한다.**

        ⇒ **이로 인해 Postgresql 진영에서는 COPY를 사용해 데이터를 벌크로 쑤서 넣은 후 조회시 생기는 Write I/O를 줄이기위해 COPY를 함과 동시에 힌트 비트를 세팅하는 COPY FREEZE 연산을 종종 이용하곤 한다.**

        [https://pgsqlpgpool.blogspot.com/2021/03/speeding-up-pgbench-using-copy-freeze.html](https://pgsqlpgpool.blogspot.com/2021/03/speeding-up-pgbench-using-copy-freeze.html)


## Row Lock, Multiple Locks

### Row level Lock

`SELECT ~ FOR UPDATE;`

- 동작 원리
    1. xmax에 현재 xid를 넣는다.
    2. 현재 X-Lock이기 때문에 xmax_is_lock에 true를 넣는다.
- 특징

    커밋 이후 vacuum의 힌트 비트 업데이트를 기대하고 해당 테이블에 대한 select를 날리면 힌트 비트는 되지 않는다.

    ⇒ 이 경우에는 Row Level Lock이 X-Lock이 되었다는 의미를 구분하기 위해 락킹 트랜잭션의 상태와 상관없이 활성화됩니다.


해당 SQL을 입력하고 테이블 로우 블럭을 뽑아보면

xmax_is_lock에 true 값이 들어와있다.

기본적으로 이 경우에는 따로 힌트 비트를 세팅하지 않습니다.

### Multiple Locks

`FOR KEY SHARE` lock

- 동작 원리
    1. 두개의 세션에서 같은 키값에 대해 외래키를 참조하여 Insert를 진행한다.
    2. 이때, 참조되는 외래키에 해당하는 로우는 lock이 걸린다.

        ⇒ 참조되는 동안 해당 키의 값이 변경되지 않아야하기 때문이다.

- 특징
    1. 진행도중에 xmax를 찍어보면 xid가 들어있지않고 0부터 카운팅된 ID가 나온다.

    ⇒ 이 xmax는 계속 점진적으로 증가한다.

    ⇒ 이 ID는 “multiple transaction object”의 ID, mulitxact라고 부른다.

    1. 이 해당 트랜잭션이 아닌 다른 트랜잭션에서 `select * from pg_get_multixact_members('[mulitxact]');` 이 명령어를 통해 현재 연동된 lock transaction xid를 알 수 있다.

# PostgreSQL MVCC/SSI

## **Isolation level history**

- 9.0 이전 버전

    SQL-92 Isolation Level의 4단계 레벨과 달리 2 단계 레벨 밖에 없었습니다.

    1. Read Commited
    2. Snapshot Isolation

        ⇒ 이 단계는 SQL-92 Isolation level의 Repeatable Read ~ Serializable 중간 정도 격리 레벨입니다.

- 9.1 이후 버전

    계속되는 온전한 직렬화 필요성과 SQL-92 Isolation level에 맞춰 한단계가 추가되었습니다.

    1. Read Commited
    2. Repeatable Read
    3. Serializable

### 기존 Snapshot Isolation의 이상현상(anomaly)

- Write 왜곡 현상[Simple Write Skew]

    ![[PostgreSQL MVCC SSI/Untitled.png]]

    - 배경 및 요구사항

        현재 한 병원의 근무표인 doctor 테이블을 수정하려는데 발생한 상황,

        이 테이블에는 단 한명만 on-call 컬럼이 `true` 여야하며 나머지 의사들은 `false` 이여야한다.

    - $T_1$ 동작
        1. 현재 on-call인 의사가 있는지 확인한다.
        2. 만약 2명이상인 경우 이름이 Alice인 의사의 on-call 컬럼을 false로 돌려 놓는다.
    - $T_2$ 동작
        1. 현재 on-call인 의사가 있는지 확인한다.
        2. 만약 2명이상인 경우 이름이 Bob인 의사의 on-call 컬럼을 false로 돌려 놓는다.
    - 결론

        $T_1$에서 이미 업데이트를 진행하여 on-call인 컬럼이 1개로 줄어 $T_2$의 update는 필요 없지만 $T_2$의 update에서 이 결과를 알지 못해 그냥 업데이트를 해버리는 상황이다.

        이런 결과로 늘 on-call이 true 인 컬럼이 2개 이상이 되버려서 요구사항을 충족하지 못하는 것이다.

        심지어 베타락이 걸려야하는 Update는 where 결과인 튜플에만 걸리니 기존 락으로도 충족하지 못한다.

- 일괄 처리 이슈

    ![[PostgreSQL MVCC SSI/Untitled 1.png]]

    - 배경 및 요구사항

        결제 결과를 기록하는 영수증 테이블, 이 영수증 테이블의 인덱스를 관리하는 제어 테이블 2개의 테이블이 있다.

        - $T_1$

            현재 영수증 테이블 가장 최신 인덱스를 확인하고 영수증 테이블을 처음부터 가장 최신 인덱스 -1 의 영수증의 amount 컬럼의 합을 구합니다.

        - $T_2$

            현재 영수증 테이블 가장 최신 인덱스를 조회하고 해당 인덱스를 사용해 영수증 데이터를 넣습니다.

        - $T_3$

            현재 영수증 테이블 인덱스 제어용 제어 테이블에서 인덱스를 증가시킵니다.

    - $T_1$ 동작
        1. 현재 영수증 테이블 가장 최신 인덱스를 제어 테이블에서 확인한다.
        2. 영수증 테이블을 처음부터 가장 최신 인덱스 -1 의 영수증의 amount 컬럼의 합을 구합니다.
    - $T_2$ 동작
        1. 현재 영수증 테이블 가장 최신 인덱스를 제어 테이블에서 확인한다.
        2. 해당 인덱스를 사용해 영수증 데이터를 넣습니다.
    - $T_3$ 동작
        1. 현재 영수증 테이블 인덱스 제어용 제어 테이블에서 인덱스를 증가시킵니다.
    - 결론

        T1 동작은 결과 조회용, T2는 새 데이터 추가용, T3는 인덱스 증가용 트랜잭션들이다.

        T1의 결과에 T2의 결과가 반영되도록 T2가 T1, T3보다 우선적으로 실행되거나 T3뒤에 와야한다.

        이 상황은 T2가 T3보다 먼저 동작해 이전 배치 번호를 가지고 삽입을 하게 되지만 이 삽입은 T1실행 이후에 실행되어 T1의 결과에는 또 보이지 않는다.

        이 현상은 Read-Only 트랜잭션인 T1이 없으면 발생하지 않는 이상현상이다.

        이를 해결하기 위해선 **완전한 직렬화를 구현하던가** **저 트랜잭션의 동작 일부를 합치던가 아님 Select … For Update 구문으로 명시적인 로우락을 걸어야한다.**

        **사실 무엇보다도 PostgreSQL 팬텀 이상 현상이 발생하면 이를 감지하고 에러를 터트리기 때문에 애플리케이션 단에서 이를 처리를 해야한다.**


    ### SSI의 등장

    결론에 적었듯 이 이상현상은 애플리케이션 단에서 막을 수 있긴하지만 완전한 Serializable한 트랜잭션을 구현해 이를 디비단에서 해소하고자 하는 움직임이 있었다. 그리하여 Serializable Snapshot Isolation이 등장하였고 이를 통해 현재의 PostgreSQL의 Isolation 레벨 처럼 3 단계의 구조를 가지게 되었다.

    - 정리
        1. Read Commited
        2. Snapshot Isolation[SI,Repeatable Read]
        3. Serializable Snapshot Isolation [SSI, Serializable]

        이름을 보면 알겠지만 기본적으로 2, 3단계는 스냅샷을 사용한다. 즉, 완전한 직렬화 이지만 2단계 잠금과 같은 명시적인 락킹을 사용하지 않고 “*Read는 Write를 블로킹하지 않고 Write는 Read를 블로킹하지 않는”*(아예 안하진 않지만) 이 기본 MVCC 룰을 지키고자 하였다. 여튼 이 이상현상을 해소하기 위해 PostgreSQL 개발자분들은 Multiversion Serialize History Graph를 만들어 해소하기로 하였다.


    ### Multiversion Serialize History Graph

    ![[PostgreSQL MVCC SSI/Untitled 2.png]]

    앞에서 소개한 이상현상을 각각 그래프로 표현한 것이다.

    - 다중버전 직렬화 히스토리 그래프

        다중버전 직렬화 히스토리 그래프는 **동시 트랜잭션** 사이에서 이미 발생한 직렬 우선 순위로 종속성을 구분하여 각각 화살표 그래프를 그리게 된다.

        - WR-종속성 (rw - dependency)

            T1이 Write, T2가 해당 튜플을 Read한다면 T1이 T2보다 먼저 실행된 것으로 보이는 것을 의미한다.

        - WW-종속성 (ww - dependency)

            T1이 write, T2가 해당 튜플의 다음 버전을 write한다면 T1이 T2보다 먼저 실행된 것으로 보이는 것을 의미한다.

        - RW-반종속성 (rw - anti dependency, rw-충돌, rw-conflict)

            T1이 Write, T2가 해당 튜플의 이전 버전을 read한다면 T2가 T1의 write한 튜블의 버전을 Read하지 않았기 때문에  T1이 T2보다 먼저 실행된 것으로 보이는 것을 의미한다. (이 의미는 T1의 결과가 T2의 Read 결과에 보이지 않아 생기는 결과를 의미한다.)

        - 예시

            예시 1 ) T1이 x =1 인 행을 검색하고, T2가 이 predict[where문]와 일치하는 행을 업데이트를 하면 이를 rw-반종속성을 띈다고 칭한다.

            예시 2) 이상현상 첫번째를 보면 T1은 Alice를 포함하는 행을 업데이트 하지만 이 결과가 T2의 select에서는 보이지 않는다. T2가 T1보다 먼저 실행된 것으로 보이는 것이다.

            예시 3) 배치 인덱스를 증가 시키는 T3은 이전 버전을 읽는 T2보다 이전에 실행되는 것처럼 보인다.

            T2에서 삽입한 영수증은 T1 결과에 나타나지 않아 T2가 T1이후에 실행되는 것으로 보인다.  마지막으로 T3는 T1보단 먼저 커밋되어 T3의 결과를 T1에서 읽을 수 있었기 때문에 Wr 종속성을 나타낸다. 이때 왜 락킹이 안걸리나 생각을 곰곰히 해보면 지금 베타락이건 공유락이건 블로킹이 일어날 곳이 없다. 그저 **write의 커밋 이전에 타 트랜잭션이 read(Predict)를 해버려 이전 버전을 읽어 들이는 것이 원인이다. 이것이 rw-반종속성이며 사실 이것만으로 충돌이라고 완전히 확정 짓기엔 무리가 있어 충돌이라고 가정할 만한 조건이 필요하다**


    ### rw-충돌 가정 조건

    A → B wr-종속성은 A의 write한 변경사항이 B에 표시되기 위해 A가 커밋되야 한다는 의미

    ww-종속성또한 X-lock으로 인해 마찬가지이다.

    허나, rw-반종속성 만큼은 동시 트랜잭션에서 발생한다.

    무엇보다 rw-반종속성은 직렬화 그래프를 보았을 때 매우 중요한 규칙이 있다.

    - 규칙

        2개 이상의 rw-반종속성이 존재해야 SI anomaly이다.

    - 결론

        **이 규칙을 활용해 충돌 감지 로직을 구현하였는데 이것이 타 DBMS Serializable 구현과 중요한 차이점이다.**


## SSI 구현

- 주요 목표

    잠재적인 스냅샷 anomaly를 예측해서 사전에 rw-conflict를 막는 것

    특정 반종속성을 만들어내는 트랜잭션을 중단 시키는 동작이 필요했으며 직렬화 그래프를 기반으로 동시성 제어 프로토콜과 유사하며 이 종속성 관계를 추적하며 반종속성 사이클이 형성되는 것을 막는다.

    이 반종속성만 추적해 트랜잭션을 중단시키는 게 목표이지만 오탐이 있을수 있다.

    다만 이를 활용하면 S2PL 이나 OCC보다 더 좋은 동시성을 제공한다.

    이를 위해 PostgreSQL에선 SIREADLock을 얻어 종속성을 식별하는 수단을 구현하였다.

- S2PL, OCC와의 차이점
    - S2PL

        2-Phase-Locking

        락킹 기반 동시성 제어에 해당하며 명시적으로 튜플에 락킹을 걸어 **성장, 수축 단계로 나눠 동작**

        **필연적으로 동시 트랜잭션에 블로킹이 발생해 이로 인한 오버헤드가 상당히 크다.**

    - OCC

        낙관적 동시성 제어 컨트롤

        튜플에 락킹을 걸지 않고 튜플 조회시 버전을 확인해 최신인 경우에만 업데이트를 하는 방식

        이때 트랜잭션을 여러 단계에 걸쳐 구성해야하며 검사 단계는 필수이다.

        - 구성
            1. 트랜잭션 시작

                트랜잭션 시작시 타임스탬프를 기록한다.

            2. 변경 단계

                이전 버전(커밋이 완료된)의 데이터를 읽어 들이고 로컬 캐시 버전 레코드에 변경을 적용한다.

            3. 검사 단계

                동시 트랜잭션이 이 검사단계를 거쳐 현재 다른 트랜잭션보다 먼저 접근한 트랜잭션이 있는지 판별해야한다.

                이 단계에서 보장해야할 것이 2가지가 있다.

                1. 초기 일관성
                2. 동시 트랜잭션 무충돌
                - 검증 구성

                    트랜잭션 T가 커밋하는 상황

                    1. 동시 트랜잭션들은 T가 수정하기 전에 커밋을 완료 했는가? [Backward tx 검사]
                    2. T는 동시 트랜잭션의 커밋이 완료 한뒤 커밋을 시도하는 것이며 동시 트랜잭션의 WriteSet과 T의 ReadSet이 분리 되었는가? [Backward tx 검사]
                    3. ReadSet T, WriteSet T 모두 동시 트랜잭션 WriteSet과 분리 되어있고 동시 트랜잭션은 수정을 완료했는가? [Forward tx 검사]

                이때 모든 검증을 차례로 통과하면 트랜잭션 T는 작성해야 할 레코드에 베타 락을 걸게 되며 다른 동시 활성 트랜잭션은 대기를 하게된다.

                - 문제

                    **이 단계에서 결국 전역의 동시 트랜잭션 Read/Write set를 검사해야하는 것이며 이로 인한 오버헤드가 존재한다.**

            4. 커밋 단계

                검사결과가 참이면 캐시가 아닌 디스크에 영속화를 시도하며

                거짓일 경우 트랜잭션을 restart

                **TOCTTOU 문제가 발생하지 않도록 보장해야한다.[i/o 도중 Race Condition 발생을 의미]**

                **트랜잭션은 레코드에 락을 풀고 이 변경사항을 다른 동시 활성 트랜잭션에 전파한다.**

- PostgreSQL에서의 구현

    타 DBMS는 기존에 존재하는 predicate locking을 활용해 구현을 했지만

    PostgreSQL은 Snapshot Isolation 상태에서의 Serializable Tx를 구현하기 위해 새로운 lock Manager를 구현해야했다.

    다음과 같은 잠금 메커니즘을 지원한다.

    - Locking Mechanism
        - Lightweight-Lock [latch]

            공유 메모리 구조 및 버퍼 캐시 페이지에 대한 엑세스를 동기화 하기 위한 표준 reader/writer Locking

            **보통 래치 락, latch라고 표현한다.**

        - Heavyweight-Lock []

            장기간 잠금에 사용되며 데드락 감지를 지원한다.

            다양한 잠금 모드 사용이 가능하며 select - update 같은 일반적인 작업은 충돌하지 않는 모드(non-conflict mode)에서 잠금을 획득한다.

            주로 Drop Table, REINDEX와 같은 스키마 변경 작업이 동일한 테이블에서 다른 작업과 동시에 실행되는 것을 방지하고자 사용한다.

            ⇒ 보통 이럴땐 LOCK TABLE을 사용한다.

        - Tuple-Lock

            동일한 튜플에 대한 동시 수정을 방지한다 일반적으로 xmax 시스템 컬럼을 사용해 구현한다.

            SELECT…FOR UPDATE 가 대표적인 로우락(튜플 락)이다.


### SIREAD

PostgreSQL에선 SIREAD-LOCK을 사용해 종속성을 식별한다.

- 구현
    - SIREAD-Lock중 동시 트랜잭션의 X-Lock을 시도한다면 rw-반종속성 플래그를 지정해 트랜잭션을 중단할 수 있다.
    - Read 커밋 이후 충돌 발생이 가능하기 때문에 (이상 현상 2번째) SIREAD-Lock은 커밋 이후에도 유지한다.
- 결론

    **SIREAD-Lock은 동시 트랜잭션의 X-Lock시도를 방지하며**

    **Read 커밋 이후에도 모든 동시 트랜잭션이 커밋할 때까지 해당 락을 유지한다.**

    *즉, 오탐(Positive abort)으로 인해 결국 트랜잭션이 중단될 가능성이 여전히 유지하며 PostgreSQL은 이 오탐률을 낮출 방지 로직을 커밋 순서 최적화를 통해 구현할 수 있었지만(PSSI, Precisely Serializable Snapshot Isolation) 이로 인한 오버헤드를 막고 싶어서 9.1 구현 당시에 추가하지 않았다고 한다.*


### READ-ONLY 최적화

Read-Only 최적화에는 다음과 같은 조건이 기반되어야한다.

- 필요조건
    - read-only 최적화를 이루기 위해서는 스냅샷 순서 최적화를 우선 구현해야한다.
    - SSI 오버헤드나 중단 위험없이 안전하게 실행 가능한 Safe Snapshot에서 실행 되도록 Deferrable Transaction을 도입해야한다.
- 구현

    이상현상 2번과 같이 $T_1$ rw→ $T_2$ rw→ $T_3$ 구조의 직렬화 그래프에서 $T_1$이  Read-Only 일 경우

    $T_1$의 Read Snapshot을 만들기 전에 T3가 커밋되어야 $T_1$에서 올바르게 ReadSet을 구할 수 있다.

    여기서 **T3와 동일한 동작을 하는 T0를 도입한다고 가정**해보자.

    - 가정 1

         T3는 Write 동작을 하는 트랜잭션이다. 그러므로 $T_1$보다 먼저 커밋하는 T0와 $T_1$과의 관계는 rw 혹은 ww 일수 없고 wr에 해당한다.

        T0의 변경사항은 $T_1$에 표시 되므로 T0와의 관계는 WR-종속성 관계를 가진다.

        **이러한 방식 사용해 positive abort 비율을 줄이는 것이다.**

    - 예시

        $T_1$이 Read-Only인 특정 위험한 사이클 구조가 감지가 되면 T3가 커밋 될때 까지 $T_1$의 스냅샷은 무시된다.

        이 상황에서 트랜잭션이 명시적으로 선언이 된 경우나 데이터를 수정하지 않고 커밋하는 경우 트랜잭션은 ReadOnly로 간주된다.

    - 결론

        **즉 커밋시기가 아닌 스냅샷을 뜨는 시기(**$T_1$**이 Read하는 시점)가 ReadOnly가 위험한 구조의 파츠인지를 결정한다. 변경 사항이 다른 트랜잭션에 표시되는 시점이기 때문이다.**


    ### Safe Snapshots

    - 특징
        1. 안전한 스냅샷에서 실행되는 Read-Only Tx는 serialize 실패 위험 없이 모든 데이터를 읽을 수 있다.

            ⇒ MVCC 목표에 부합한다.

        2. 중단할 수 없고 SIREAD-Lock이 필요가 없다.

        Read-Only 트랜잭션은 RW-반종속성의 타겟이 될 수 없다는 것을 위에서 증명하였다.

        즉, 동시 트랜잭션이며 R/W 트랜잭션인 T2가 T1과 충돌이 있으며 T1이 스냅샷을 뜨기전에 동작한 동시 R/W 트랜잭션인 T3와 T2가 충돌하는 경우에만 T1이 위험한 구조의 파츠가 된다.

        Read-Only 트랜잭션 T가 안전한 스냅샷을 가진다고 표현하는 경우는 다음과 같다.

    - 예시

        T(T1)의 스냅샷 이전에 커밋된 트랜잭션(T3)에 대해

        Read/Write 동시 트랜잭션(T2)이 rw-반종속성으로 커밋 되지 않았거나 커밋되지 않을 가능성이 있는 경우[위의 이상현상 2번의 예제는 경우에 완벽하게 벗어났기 때문에 예제 2번의 T1은 안전한 스냅샷을 가지지 못했다고 볼수 있다.]

    - 결론

        안전한 스냅샷은 결과론적으로 커밋까지 완료되어 안전하다는 판단이 내려진 버전의 스냅샷을 의미한다.

        이상현상 예시 2번은 T1의 스냅샷이 생성되는 시점에 이 스냅샷이 안전한지의 여부를 알수 없다는 것이 가장 큰 이슈이다. 동시 R/W가 커밋이 되어야 안전한지 않은지의 여부를 알수 있기 때문이다.

        **이로 인해 PostgreSQL은 동시 트랜잭션 리스트를 만들어 관리한다.**

        Read-Only 트랜잭션이 시작되면 커밋될 때까지 SIREAD 잠금 및 SSI 상태를 유지하면서 정상적으로 실행되며

        커밋 이후 스냅샷이 안전하다고 간주되면 SIREAD를 해제 할 수 있고

        **본질적으로 이 상태를 REPEATABLE READ(SI) 트랜잭션이라고 한다.**

        *특히 활성화된 동시 R/W Tx가 없다면 이 Read-Only Tx의 스냅샷은 이 즉시 안전한 스냅샷으로 간주하며 SSI 오버헤드 또한 발생하지 않는다.*


    ### Deferrable Transactions

    - 장기 실행 Read-Only 트랜잭션 문제
        1. 백업 같은 워크로드의 경우 SIREAD-Locking을 더 많은 데이터에 사용하고 이로 인해 동시에 돌고 있는 트랜잭션이 충돌할 가능성이 크다.
        2. 다른 Read-Only Tx에 의해 걸린 SIREAD-Locking을 정리 워크로드 또한 잠시 멈춰야한다.

            ⇒ 모든 동시 트랜잭션이 완료 될때 까지 유지해야하기 때문


        ⇒ 결론적으로 이 때문에 메모리 고갈이 발생한다.

        허나 이 트랜잭션이 안전한 스냅샷 안에서 동작한다면? 이건 상당한 이점이 있다.

    - 안전한 스냅샷에서 장기 실행 Read-Only 트랜잭션 사용시
        1. 안전한 스냅샷은 SIREAD-Locking이 필요없다.
        2. 동시 트랜잭션이 잠금 정리를 방해하지도 않는다.
    - 방법

        명령어 BEGIN TRANSACTION READ ONLY, DEFERRABLE 을 사용한다.

        이렇게 하면 읽기 전용 Serializable 트랜잭션이 지연 가능한 트랜잭션인 것으로 동작한다.

    - 동작구조
        1. 이 트랜잭션은 항상 안전한 스냅샷에서 실행되며 첫 쿼리전에 차단될 수 있다.

            ⇒ 이 트랜잭션이 시작되면 스냅샷을 획득한 뒤 우선 트랜잭션 실행을 지연시킨다.

            ⇒ 동시 R/W 트랜잭션이 완전히 완료될 때까지 기다려야 하기 때문이다.

        2. 현재 얻어온 스냅샷 기준으로 이 스냅샷 이전에 커밋된 트랜잭션에 대한 rw-conflict가 있는 커밋이 있었다면 이 스냅샷은 안전하지 않다고 판단하고 새 스냅샷을 다시 획득하여 재시도를 한다.
        3. 모든 R/W 동시 트랜잭션이 이런 충돌 없이 커밋되어야 획득한 스냅샷이 안전하다고 간주되어 이 트랜잭션이 실행된다.

            ⇒ **즉, 이 트랜잭션은 언제 실행될지 아무도 보장을 못한다는 소리다.**


        이론상 지속적으로 충돌이 일어나는 상황이면 아예 진행이 되지 않고 멈춰있을 수도 있다는 이야기다.

        그러나 벤치마크 결과 일반적으로 1~6초 이내에 Deferrable Tx가 실행되는 것을 볼 수 있다.


### 충돌 감지

위에서 서술한 rw-conflict 방지 방법은 SIREAD-Lock을 걸고 충돌이 감지되면 RW-반종속성 플래그를 넣는 것이다.

이는 기존의 PostgreSQL에선 이것만으로 적용하기 어려워 기존의 MVCC 구현을 가지고 활용하는데

XMIN과 XMAX를 활용한 방법이다.

허나 이것 만으로는 모자르기 때문에 SIREAD-Lock을 사용해 Read 종속성을 확인해야한다.

- SSI Lock Manager

    SIREAD-Lock만 저장하며 다른 Lock mode를 지원하지 않아 차단이 불가능하다.

    - 주요 작업
        1. Relation, Page, Tuple에 대한 Lock을 건다.
        2. Tuple write시 충돌하는 SIREAD-Lock 확인한다.
    - 특징
        - indexrange lock을 사용해 Predicate read을 처리한다.

            ⇒ B+tree Index 같은 경우는 페이지 단위로 SIREAD-Lock을 획득한다.

        - MGL을 사용하지만 IS-Lock (Intention-Share Lock)이 필요하지 않다.
        - RECLUSTER 또는 ALTER TABLE과 같은 물리적인 c-id를 변경하는 ddl 동작은 SIREAD-Lock을 무용지물로 만들기 때문에 이와 같은 일이 있으면 Tuple 레벨 Lock에서 Relation 레벨 Lock으로 Lock 범위를 격상시킨다.

            ⇒ 이런 경우에 MGL을 사용하는 것이다.

        - 인덱스가 제거되는 경우에도 물리적인 변경이 일어난 것이기 때문에 Tuple 레벨 Lock에서 Relation 레벨 Lock으로 Lock 범위를 격상시킨다.

### 충돌 복구: Safe Retry

- Safe Retry

    트랜잭션이 중단된 경우 동일한 트랜잭션을 즉시 재시도해도 동일한 serialize 실패로 또 다시 실패하지 않는다.

- 트랜잭션 중단 시나리오
    1. rw-반종속성 리스트에서 위험한 구조를 발견 [ex: T1 rw → T2 rw → T3]
    2. 커밋 순서 조건 충족
    3. 일부 트랜잭션 중단
- Safe Retry 규칙

    이상 현상 2번과 같은 상황일 때,

    1. T3가 커밋될 때까지 아무것도 중단하지 말 것

        ⇒ 이 조건은 커밋 순서 최적화 + Safe Retry까지 제공한다.

    2. 아직 커밋 되지 않은경우 항상 이상 현상을 제공하던 동시 트랜잭션 T2를 중단할 것

        ⇒ 1번 조건에 의해 T3가 항상 먼저 커밋되고 T2가 그 다음 재시도를 하게 만든다.

        ⇒ 이러면 RW-반 종속성이 사라져 동일한 오류를 방지하게 되므로 safe retry가 가능하게 만든다.

    3. 위험한 구조 감지시 이미 T2, T3가 커밋된 경우엔 유일한 방안으로 T1이라도 중단할 것

        ⇒ 이미 T2, T3가 이미 커밋된 경우이지만 Read-Only Tx인 T1은 T2, T3 커밋 이후 재시도 될 경우엔 동시적이지 않고 순차적으로 레코드를 안전하게 온전히 얻을 수 있어 safe retry에 해당한다.

- 특징

    1의 규칙에서 즉시 동시 트랜잭션을 중단하지 않는 이유는 즉시 중단하게 될때 T3가 커밋을 하고보니 딱히 상관도 없었을 동시 트랜잭션의 작업이 중단되는 남용을 방지하기 위해서이다.


### 메모리 사용 최적화

일반적으로 가변 공유 메모리 세그먼트[페이지]의 동적할당 오버 엔지니어링을 피하기 위해

DBMS 제품들 대부분 공유 메모리 세그먼트[페이지]를 고정 크기로 잡고 서버를 올리게 된다.

- PostgreSQL SSI Lock manager 메모리 제한 기술
    - Safe Snapshot 및 Deferrable Transaction을 통해 장기 실행 Read-Only 트랜잭션의 영향 줄이기[Read-Only 최적화에 구현된 기술]
    - Granularity promotion을 통해 여러 개의 세분화된 Lock을 하나의 굵은 Lock으로 결합해 공간 확보하기 [SSI Lock Manager에 구현된 기술]
    - 커밋 완료된 트랜잭션을 공격적으로 정리하기 [Aggressive Cleanup]
    - 커밋 완료된 트랜잭션의 상태 표현을 간결하게 묶어서 통합하기

    ### Aggressive Cleanup

    커밋된 트랜잭션의 정보를 제때 지워 메모리 공간을 확보해야한다.

    이때 각 트랜잭션의 정보에 따라 유효기간이 달라진다.

    - SIREAD-Lock의 유효기간

        동시 활성 트랜잭션의 모든 커밋이 완료된 시점

        ⇒ SIREAD-Lock은 충돌 감지 목적으로 실효성이 있으며 동시 트랜잭션의 커밋에 따라 유효성이 결정된다.

    - conflict graph의 유효기간

        다른 동시 활성 트랜잭션에서 race가 발생한 가장 먼저 커밋 완료된 트랜잭션의 xid를 기록이 필요하다. 그래서 **이런 경우에는 해당 동시 활성 트랜잭션이 진즉에 커밋이 된 트랜잭션이여도 이 기록을 더 오래 들고 있어야 한다**. 나머지 활성 트랜잭션이 Read-Only만 남게 되는 경우에 SIREAD-Lock을 안전하게 삭제할 수 있다.


    ### Summarizing Committed Transactions

    - 요약시 확인해야하는 사항
        1.  튜플을 수정하는 활성 트랜잭션은 커밋된 트랜잭션이 해당 튜플을 읽는지 확인해야한다.

            ⇒ [T committed rw → T active rw → T3]

            ⇒ SIREAD-Lock을 유지해야한다

            ⇒ 요약된 트랜잭션의 SIREAD-Lock은 단일 더미 트랜잭션에 재할당하여 다른 요약 트랜잭션의 Lock과 합체한다. **[요약된 Tx Lock 재할당→ 더미 트랜잭션 + 요약된 다른 Tx Lock]**

            **이 더미 트랜잭션의 각  Lock에는 Lock을 유지한 가장 최근 Tx 커밋 시퀀스 번호까지 기록한다.**

            ⇒ 더 낮은 레벨(ex: 튜플 → Page, 개념상 낮은 레벨일 수록 루트에 가깝다.)의 Lock으로 승격할 수 있어 각 Lock이 여러 커밋이 완료된 동시 트랜잭션에 의해 유지되어도 한 번만 기록하면된다. [요약시켜서 통합하기 때문]

        2. 활성 트랜잭션의 튜플 읽기는 해당 튜플이 동시 serializable 트랜잭션에 의해 작성되었는지 여부를 알아야한다.

            ⇒ 이를 위해 종속성 그래프에서 이 정보를 빼와야하지만 요약된 트랜잭션은 이 그래프에 없다.

            ⇒ 대신 요약된 Tx의 xid를 충돌이 발생했던 가장 오래된 Tx의 시퀀스 번호로 매핑하는 표를 유지한다.

    - 결론

         지속적으로 커밋된 트랜잭션 리스트를 요약하여 유지하고 LRU메커니즘으로 지속적으로 필요 없는 트랜잭션 정보를 지우기 때문에(Disk로 스왑) 무제한으로 테이블을 사용하게 되는 원리이다.


## 출처

[https://www.cybertec-postgresql.com/en/whats-in-an-xmax/](https://www.cybertec-postgresql.com/en/whats-in-an-xmax/)

[https://devcenter.heroku.com/articles/postgresql-concurrency](https://devcenter.heroku.com/articles/postgresql-concurrency)

[https://pgsqlpgpool.blogspot.com/2021/03/speeding-up-pgbench-using-copy-freeze.html](https://pgsqlpgpool.blogspot.com/2021/03/speeding-up-pgbench-using-copy-freeze.html)

[https://www.cs.princeton.edu/courses/archive/fall19/cos418/docs/L16-occ.pdf](https://www.cs.princeton.edu/courses/archive/fall19/cos418/docs/L16-occ.pdf)

[https://drkp.net/papers/ssi-vldb12.pdf](https://drkp.net/papers/ssi-vldb12.pdf)

[https://www.vldb.org/pvldb/vol10/p781-Wu.pdf](https://www.vldb.org/pvldb/vol10/p781-Wu.pdf)

[https://faculty.cc.gatech.edu/~jarulraj/courses/4420-s19/slides/18-occ.pdf](https://faculty.cc.gatech.edu/~jarulraj/courses/4420-s19/slides/18-occ.pdf)

[https://docs.google.com/document/d/1pMsMiv7oS1mlXMG4Al8vWR20KAvLlrdkK4Lp6B1bluc/edit?usp=sharing](https://docs.google.com/document/d/1pMsMiv7oS1mlXMG4Al8vWR20KAvLlrdkK4Lp6B1bluc/edit?usp=sharing)

### 블로그 배포용 페이지

[[[page]PostgreSQL MVCCSSI]]

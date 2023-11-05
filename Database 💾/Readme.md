# Database

[[2. Area 🔥/Database 💾/1. Resource/Postgresql/Readme]]

[[2. Area 🔥/Database 💾/1. Resource/SQLDeveloper/Readme]]

[PostgreSQL 기본강좌](http://www.gurubee.net/postgresql/basic)

[Dashboard](http://wiki.gurubee.net/dashboard.action)

# Index

[[MySQL] 인덱스(Index table) , 뷰(View table)](https://victorydntmd.tistory.com/140)

B-tree 자료구조를 활용한 목차용 테이블을 의미한다.

일반적으로 pk를 생성하면 기본적으로 pk용 B-tree가 생성된다.

보통 링크드 리스트 지원을 위해 B+Tree로 구축되는 것이 좀 더 최근 방식이라고 한다.

이 방식이 pk를 기준으로 정렬하는데에는 좀 더 수월 하기 때문이다.

만약 정렬 조건이 좀 더 복잡하다면 그때부터는 조금씩 의미가 없어지긴한다.

그래도 이 베이스로 시작하는 것이 훨씬 낫긴하다.

# Buffer Pool

## DataBase Storage

### Type

File - Page - Table - Tuple - Cardinality

- 데이터베이스 파일을 분할하는 이유

    휘발성 메모리인 RAM의 크기는 HDD나 디스크의 크기보다 월등히 작다.

    분할하여 메모리에 적재하기 위함이다.

    이때, 이 과정을 전담하는 프로세스(프로그램)가 **Buffer Pool Manager**이다.

    DBMS마다 다 들어있는 이 프로세스를 사용함으로써 **OS에 의존하지 않고 Disk에 I/O 처리를 진행**한다.

    일반적으로 DBMS마다 이 페이지를 말하지 않고 추상적으로 Cache로 표현하기도 하고 그렇다.

    또한 적재 알고리즘 또한 DBMS 별로 다르다.

    - **I/O를 OS에 의존 하지 않는 이유**

        **DBMS에게는 이 저장소를 Page 개념으로 저장이 되고 적재 또한 Page를 메모리에 적재해야하나 OS는 그것을 모른다.**

        당연히 효율이 OS에 의존하는 쪽이 떨어짐으로 DBMS에서 Buffer Pool Manager가 담당하는 것이다.

- 동작 구조
    1. Page Directory라는 자료구조로 DBMS File(저장 파일)을 Page단위로 분할하여 구성
    2. DBMS는 디스크에서 이 Page Directory를 찾아 여기서 원하는 페이지를 메모리에 Load한다.

## File Organization

[[File Organization]]

## Page

[[Page]]

# Connection pool

다수의 커넥션을 미리 연결을 확보하여 관리하는 풀

## Connection

### 연동 원리

1. 애플리케이션 로직은 DB 드라이버를 통해 커넥션을 조회
2. DB 드라이버는 DB와 tcp/ip 커넥션을 연결
3. 3 way handshake등 절차 이후 id, pwd등을 던짐
4. DB에서 내부 인증 절차를 거친뒤 세션을 맺음
5. DB는 커넥션 생성이 완료되었다는 응답을 반환
6. DB드라이버는 커넥션 객체를 생성하고 클라이언트에 반환

### 기존 커넥션의 문제점

매번 새로 커넥션을 생성하면 네트워크 리소스를 추가로 잡아먹고 시간도 더 소모된다.

⇒ 전체적인 응답속도가 느려진다.

⇒ UX에 악영향을 준다.

- 해결 방법

    커넥션 풀을 사용해 미리 다수의 커넥션을 연결을 해 확보해두고 이 커넥션을 재사용한다.


## Connection Pool

### 연동 방식

1. 커넥션 풀 초기화, [보통 기본값은 10]

    ⇒ 애플리케이션 로딩시 이때 미리 커넥션 풀을 확보한다.

2. 커넥션 연결 확인

    ⇒ 이 커넥션들은 미리 tcp/ip로 연결 되어있다.

3. 커넥션 풀 사용

    ⇒ 요청이 올때마다 커넥션 풀에서 커넥션을 하나 꺼내어 사용하고 반환한다.

    ⇒ 이때, 커넥션이 살아있는 상태로 반환해야한다. 종료시킨뒤 반환하면 안된다.


### 오픈소스 커넥션풀 라이브러리

- commons-dbcp2
- tomcat-jdbc-pool
- HikariCP [스프링 부트 디폴트]

    라이브러리마다 호환성과 퍼포먼스가 다르다.

    아래로 내려갈수록 퍼포먼스는 좋은 CP 지만 대신 호환성은 좀 떨어지는 CP다.


# Transaction

다수의 쿼리를 하나의 연산으로 실행하는 논리적 단위

데이터 영속화를 파일로도 해결 가능하지만 데이터베이스를 이용하는 이유는 이 트랜잭션때문이다. 트랜잭션은 하나의 거래를 뜻하는 단어이다. 이 거래가 안전하게 처리되도록 보장을 해주는 이 기능때문에 데이터베이스를 이용하는 것이다.

## ACID

### Atomicity, 원자성

트랜잭션 내부 쿼리는 하나의 작업 처럼 한번에 실패하거나 한번에 성공해야한다.

One or Nothing 전략

### Consistency, 일관성

모든 트랜잭션은 일관성 있는 데이터베이스 상태를 유지해야한다. 무결성 제약 조건을 항상 만족해야한다.

### Isolation, 격리성

동시에 실행되는 트랜잭션은 서로 영향을 미치지 않게 유지해야한다. 특히 동시에 같은 데이터를 수정하지 못하도록 해야 한다. 격리성은 동시성과 같은 성능 이슈로 인해 트랜잭션 격리 레벨을 선택할 수 있다.

### Durability, 지속성

트랜잭션이 성공하면 결과가 항상 기록되어야 한다. 중간에 문제가 발생해도 DB 로그등을 사용해 성공한 트랜잭션 내용을 복구해야 한다.

## Transaction Isolation Level, 트랜잭션 격리 수준

### READ UNCOMMITED, 커밋되지 않은 읽기

- 특징

    PostgreSQL은 기본적으로 Read Uncommited를 지원하지 않는다.

    표면적으로 선택은 가능하나 내부동작은 Read Commited로 동작한다.

    실제 Dirty Read 현상은 MySQL, MariaDB 같은 DB에서 확인 가능하다.

- 문제점
    1. Dirty Read
    2. Non-Repeatable Read
    3. Phantom Read

### READ COMMITED, 커밋된 읽기

- 특징

    PostgreSQL default

- 문제점
    1. Non-Repeatable Read
    2. Phantom Read

### REPEATABLE READ, 반복 가능한 읽기

- 특징

    MySQL, MariaDB default

- 문제점
    1. Phantom Read

        PostgreSQL은 Phantom Read가 일어나긴 하지만 일어나는 순간 에러를 던진다.


### SERIALIZABLE, 직렬화 가능

무조건 트랜잭션은 순차적으로 실행된다.

## 트랜잭션 문제점

### Dirty Read

다른 세션이 수정 커밋이 완료되지 않아도 도중에 조회를 할수 있다. 이점은 굉장한 데이터 정합성 파괴를 뜻한다. 만약 커밋이 완료되지 않았음에도 불구하고 조회가 된 데이터를 수정중인 세션에서 롤백을 한다면 같은 세션에서 다른 데이터를 받게되는 데이터 정합성이 파괴되는 현상이 발생한다. 이는 엄청난 문제가 될수 있다.

### Non-Repeatable Read

반복해서 조회했을 때 같은 데이터를 읽을 수 없는 상태

한 세션이 조회중에 다른 세션이 조회중인 데이터를 수정&커밋을 하고 다시 한 세션이 조회를 하게 되면 수정된 데이터가 조회되는 것이다. 이렇게 되면 한 세션에서 반복해서 조회했을때 해당 로우의 데이터가 늘 똑같다고 보장하지 못하는 것이다.

- 주의점

    MySQL류 DB와 PostgreSQL DB는 좀 다르게 동작한다.

    예시는 세션1,2 에서 각각 수정 트랜잭션을 진행하는데 세션 1이 좀 더 빨리 접근한 상황이다.

    - MySQL류

        세션 1에서 수정 트랜잭션을 진행을 완료하면 세션 2가 트랜잭션을 수행한다.

        **이때, 세션 2에선 수정이 완료된 상태의 로우결과에 대해 수정을 시도한다.**

    - PostgreSQL

        세션 1에서 수정 트랜잭션을 진행을 완료하면 세션 2가 트랜잭션을 수행한다.

        **이때, 세션 2에선 수정이 완료되기 전 상태의 로우결과에 대해 수정을 시도한다.**


### Phantom Read

반복 조회시 결과 집합이 달라지는 것을 의미한다.

한 세션이 조회중 다른 세션이 회원을 추가하고 커밋하게 되면 다시 한 세션이 조회했을때 결과집합이 갑자기 유령처럼 등장하게 되는 현상이다.

## TransactionManager

JDBC를 사용해 트랜잭션을 사용하면 서비스 레이어에 비즈니스 로직을 순수하게 자바코드만 유지하기 힘들어지는 문제가 발생한다.

이 때문에 **트랜잭션의 커넥션 풀에서의 커넥션 할당, 해제를 도맡아 담당하는 트랜잭션 매니저**를 서비스 레벨에서 주입하여 사용한다.

- 특징
    1. 트랜잭션 매니저의 인터페이스를 보면 DataSource를 그냥 사용하지 않고 **트랜잭션 동기화 매니저에서  ThreadLocal을 사용해 보관하고 해제한다**.

        ⇒ Thread Safe하게 사용하기 위함이다.

        ⇒ `setAutoCommit(true)`로 되돌리는 작업, `con.close()`를 사용해 커넥션을 반납하는 작업, `threadLocal.remove()`또한 자동으로 알아서 해준다.


     2. 트랜잭션 매니저 덕분에 더이상 try…catch…finally중 finally를 사용해 직접 닫아줄 필요가 없어졌다.

    ⇒ 트랜잭션 매니저가 알아서 해제하기 때문이다.

    ⇒ 다만, 레포지터리 레벨에서 `DataSourceUtils.releaseConnection(dataSource);` 를 사용해 직접 정의했던 close()에서 같이 해제 해주어야한다.

    1. close()에서 `DataSourceUtils.releaseConnection(dataSource);` 를 사용해도 트랜잭션이 실행중인 커넥션이 해제 되지 않는 이유는 **내부에서 트랜잭션이 실행중인지 판단하고 트랜잭션이 실행 중인 커넥션이 아닌 경우에만 닫기 때문이다.**

## TransactionTemplate

트랜잭션 매니저를 사용해도 결국은 try 내부에 commit, catch 내부에 rollback()를 넣는 구조가 반복된다.

이런 구조는 **템플릿 콜백 패턴을 사용해 프록시화** 하면 깔끔하게 처리 가능하다. Spring AOP를 생각해보면 된다.

- 적용 방법

    ```java
    execute((status)→{
    	try{
    		bizLogic();
    	}catch(SQLException e){
    		throw new IllegalStateException(e);
    	}
    });
    ```

    여기서 try…catch로 감싸서 다시 런타임 예외를 던지는 이유는 **여기서는 언체크 예외인 SQLException이 발생하기 때문에 예외가 람다 밖을 나가지 못하기 때문이다.**

    ⇒ **이 때문에 여기서 람다를 나갈 수 있는 런타임 예외로 바꾸어 다시 던지는 것이다.**


## Spring Transaction AOP

- 동작구조
    1. 사용자가 프록시 호출
    2. 프록시는 스프링 컨테이너를 통해 빈으로 등록한 트랜잭션 매니저 획득
    3. 이 트랜잭션 매니저를 통해 데이터소스에 접근
    4. 커넥션 생성
    5. conn.setAutoCommit(false);
    6. 트랜잭션 동기화 매니저에 커넥션 보관 ⇒ 트랜잭션 동기화 매니저 내부 ThreadLocal에 보관됨
    7. 서비스 로직 실행
    8. 트랜잭션 동기화, 커넥션 획득
    9. 정상실행시 commit(), 런타임 예외시 rollback()
    10. conn.setAutoCommit(true);
    11. conn.close();
- 선언적 트랜잭션 관리

    99% 실무에서 사용함

    - XML 방식

        data-source.xml 파일에 트랜잭션 aop를 적용할 패키지 위치를 포인트컷으로 걸고

        여기서 트랜잭션 매니저를 빈으로 등록 후 이 트랜잭션 매니저를 어드바이스로 적용하는 방식이다.

    - 어노테이션 방식

        @Transactional같은 어노테이션 하나만 선언해서 트랜잭션을 적용하는 방식

- 프로그래밍 트랜잭션 관리
    - 트랜잭션 매니저, 트랜잭션 탬플릿을 사용해 트랜잭션 관련 코드를 직접 작성하는 방식

## SpringBoot 리소스 등록 방법

- 데이터소스 자동 등록

    application.properties에 각각 데이터소스 속성을 세팅하면 이 속성을 이용해 DataSource 빈을 생성한다.

    기본으로 생성하는 데이터 소스는 HikariDataSource이다. 이 또한 application.properties에서 지정가능하다.

    만약 url이 없으면 내장 데이터베이스를 생성하려고 시도한다.

    - 수동 등록시

        이 자동 등록 프로세스는 동작하지 않는다.

- 트랜잭션 매니저 자동 등록

    등록된 라이브러리를 보고 자동으로 등록한다.

    JPA와 JDBC를 사용한다면 JPATransactionManager를 사용한다.

    대부분 JPATransactionManager가 DataSourceTransactionManager의 기능들 대부분을 지원해주기 때문이다.

    - 수동 등록시

        이 자동 등록 프로세스는 동작하지 않는다.


    [https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql.datasource](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql.datasource)

    [https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html#appendix.application-properties](https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html#appendix.application-properties)


# 무결성 제약조건

데이터베이스에 저장된 데이터의 무결성을 보장하고 데이터베이스의 상태를 일관되게 유지하는 조건

## 종류

### 개체 무결성

기본키는 NULL이 들어올 수 없다.

### 참조 무결성

참조키는 기본키를 제외한 값을 참조할 수 없다.

### 도메인 무결성

각 속성 값은 속성의 조건에 맞는 값만 받을 수 있다.

### 키 무결성

릴레이션(테이블)에는 최소한 하나의 키가 존재해야한다.

### NULL 무결성

특정 속성 값에는 NULL이 들어 갈수 없다.(PK등등)

### 고유 무결성

특정 속성 값에는 중복된 데이터가 들어 갈수 없다.(PK 등등)

# Locking

하나의 트랜잭션이 실행하는 동안 특정 데이터 항목에 대해 다른 트랜잭션이 동시에 접근하지 못하도록 상호배제 기능을 제공하는 기법

## Locking 종류

### 기본 잠금 규칙

1. TX는 데이터 항목에 대해 읽기 연산을 수행하기전 S-lock 혹은 X-lock중 하나를 실행해야 한다.
2. 쓰기 연산을 실행하기 위해선 X-lock을 수행해야 한다.
3. 연산 종료후 unlock 연산을 한다.
4. 처음 S-lock 혹은 X-lock을 적용한 후 unlock 수행이 가능하다.
    - 정리

        하나의 데이터 항목을 여러 TX가 읽는 것은 문제 없다.

        한쪽이라도 쓰는 순간 트랜잭션 상호 간섭이 발생한다.


### 잠금연산

- **Shared Lock, 공유락 [S-lock]**
    - 규칙
        1. S-lock을 설정한 tx는 데이터 항목에 대해 읽기 연산만 가능하다.
        2. 하나의 데이터 항목에 여러 개의 공유 잠금이 가능하다.
        3. 한번 S-lock이 걸린 데이터 항목에 대해 다른 tx도 읽기 연산만 가능하다.
- **Exclusive Lock, 배타락 [X-lock]**
    - 규칙
        1. X-lock을 설정한 tx는 데이터 항목에 대해 읽기 연산과 쓰기 연산 둘다 가능하다.
        2. 하나의 데이터 항목에는 하나의 베타락만 가능하다.
        3. 한번 X-lock이 걸린 데이터 항목에 대해 다른 tx은 읽기 연산과 쓰기 연산 둘다 불가능하다.

### 해제연산

- Unlock

[[MVCC]]

# MVCC

하나의 논리적인 대상에 대해 물리적인 버전을 여러개를 유지하고 있는 기법

대부분의 디비에선 이것을 구현하고 있다.

락킹을 잘못걸어서 데드락이 걸리는 이유는 보통 읽기가 쓰기를 막고있고 쓰기가 읽기를 막는 문제에서 비롯된다.(공유락과 베타락)

이것을 방지하기 위해 하나의 대상마다 버전을 새켜 최신인지 아닌지를 로그를 만들어주는 기법이다.

## MVCC 규칙

- 읽기와 쓰기는 서로를 막을 수 없다.
- 읽기는 가장 최신의 읽을 수 있는 버전을 들고 온다.
- 쓰기는 새 버전을 만들어낸다.

## MVCC 버저닝 구현방식

### MVTO

Timestamp를 활용해 Serialization Order 정하는 방식

### MVOCC

낙천적 동시성 제어기법을 활용해 Serialization Order 정하는 방식

### MV2PL

2-phase-locking 기법을 활용해 Serialization Order 정하는 방식

## MVCC 메타데이터

### Transaction

### Tuple

# DB 세션

클라이언트가 DBMS에 커넥션을 맺게 되면 **DBMS 내부에 해당 커넥션에 대한 세션을 생성**한다.

그리고 이 커넥션을 통한 모든 요청은 이 생성한 세션을 통해 실행하게 된다.

이 세션에서 트랜잭션은 여러번 사용 가능하다

클라이언트가 커넥션을 닫거나 DBA가 강제로 종료하면 세션이 종료된다.

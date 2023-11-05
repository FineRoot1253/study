# Distributed Architecture

# SAGA pattern

### 사가 Transaction 종류

1. Compensatable transaction 보상가능 트랜잭션

    보상 트랜젝션으로 롤백이 가능한 트랜잭션

2. Pivot transaction 피봇 트랜잭션

    사가의 진행 중단 지점

    이 트랜젝션이 커밋되면 사가는 완료될 때까지 실행된다.

    최종 보상 가능 트랜잭션 또는 최초 재시도 가능 트랜잭션이 될 수 있다.

    보통 절때 실패하지 않는 단계라고 하면 이 피봇 트랜잭션 단계라고 칭한다.

    항상 성공하는 것은 또 아니라서 재시도 가능 범주에 들진 않는다.

    다만, **절대로 실패하지는 않겠다 싶으면 피봇**이라고 한다.

3. Retriable Transaction 재시도 가능한 트랜잭션

    피봇 트랜잭션 직후의 트랜잭션.

    반드시 성공하는 트랜잭션이다.(단순하게 확실히 존재하는 엔티티 조회 등등)


**보통 읽기 전용 트랜잭션은 보상이 필요 없어서 피봇혹은 재시도 가능 범주에 들어간다.**

### DDD aggregate

- aggregate 구조
    - 루트 엔티티
    - 기타 엔티티들
    - 벨류 객체

    **정의서에 적힌 명사들로 도메인 모델을 생성해놓으면 그 명사 도메인 모델이 aggregate이다.**

    모든 aggregate는 state를 지니고 있고 이벤트를 받으면 상태가 변화한다.

    구현시 필요한 것은 aggregate의 state, aggregate의 event 등등을 구현해놔야한다.

    그래서 **aggregate의 state를 필드로 가지는(id, 주문 정보 등등) aggregate의 event를 파라미터로 받는 도메인이벤트 publisher에 publish한다. 이게 최소단위 단일 트랜잭션이 상태를 변경, 동작을 하는 일련의 과정이다. (도메인이벤트 publisher에 publish는 aggregate 관련 서비스에 주입된 상태)**

    이 과정들은 각 aggregate의 메서드들이 담당한다. aggregate들은 각 도메인 메서드들이다.

- 규칙
    1. 루트 엔티티로만 접근, 참조 가능
    2. aggregate 간 참조는 Id로만
    3. 1 트랜잭션 : 1 aggregate 로 생성/수정 할것
    4. aggregate는 작게 나눌 수록 좋다

    간단하게 단일 책임 트랜잭션 엔티티 묶음 단위 이라고 보면 된다.

- 도메인 이벤트

    aggregate 변경을 참여자에게 전달하는 장치

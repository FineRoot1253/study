# Java Persistence API [JPA]

[[[dump 파일]]]

- JPA - 기본

    ## 영속성 컨텍스트

    엔티티를 영구저장하는 환경

    EntityManager가 생성될때마다 하나의 영속성 컨텍스트가 생성이 된다.

    - 특성
        1. 1차 캐시

            DataSource와 실제 스프링같은 인 메모리 프로그램 사이에 존재하는 일시적인 저장공간

            그러나 한 트랜잭션 안에서 EntityManager가 생성되고 삭제되기 때문에

            찰나의 순간에만 살아 있는 공간이라 1차 캐시이며 별 의미는 없지만 **아주 복잡한 트랜잭션에서나 성능상의 의미가 있다.**

            그래서 실제로 **이미 영속성 컨텍스트에 추가 되어있는 객체를 find메서드로 찾을땐 디비에 쿼리를 날리지 않고 이 1차 캐시를 뒤지게 되며 없다면, 그때 DB를 날려 1차 캐시안에 담게 된다.**

        2. 영속 엔티티 동일성 보장

            마치 컬렉션에서 바로 꺼낸듯하게 매번 새로 꺼낸 인스턴스의 객체결과가 타입과 pk값만 같아도 ==비교를 하면 항상 같다고 판단한다. 이것덕분에 repeatable read의 트랜잭션 고립성을 디비레벨이 아닌 응용 프로그램 레벨에서 보장해준다. repeatable read는 각기 다른 트랜잭션에서 한 트랜잭션의 커밋 결과가 다른 트랜잭션에서 가져오거나 볼수 없는 read를 의미한다.

            - Isolation Level

                [트랜잭션 격리](https://www.postgresql.kr/docs/9.4/transaction-iso.html)

        3. 쓰기 지연 SQL 저장소

            트랜잭션을 커밋하기 전까지 persist메서드를 호출하는 순간 그 호출마다 insert 전용 저장소에 보관한다. 이것을 이용해 자연스럽게 insert가 Lazy하게 동작하게 된다.

            - 동작순서
                1. 응용 프로그램 레벨 - commit
                2. DB 레벨 - flush
                3. DB 레벨 - commit
        4. 변경 감지 - Dirty Check

            내부적으로 1차 캐시에는 필드로 Id, Entity, snapshot이 있다.

            이 snapshot에는 1차 캐시에 처음 이 row가 올라간 순간의 Entity가 들어간다.

            커밋하는 시점에 현재 엔티티를 의미하는 entity 필드와 비교했을때 변경점이 있다면 이 entity에 대한 update sql을 쓰기지연 SQL 저장소에 추가 저장하고 함께 커밋하게 된다.

    - 엔티티 생명주기

        특정 객체에 대해 영속성 컨텍스트와의 관계에 따라 정해지는 생명상태주기

        - 비영속 [new/transient]

            새로운 객체하나가 생성이 되어있는 상태, 그러나 영속성 컨텍스트와는 별 관계가 없는 상태

        - 영속 [managed]

            새로운 객체 하나가 영속성 컨텍스트안에 포함이 되며 managed 상태가 되는 상태,

            persist메서드에 객체를 넣게되면 이렇게 된다.

            그러나 persist를 쓴다고 해서 쿼리가 날라가는 것이 아닌 일시적으로 영속성 컨텍스트에 담는 것이다.

        - 준영속 [detached]

            persit 메서드로 영속성 컨텍스트에 포함되었던 객체를 꺼낸 상태

            준영속 상태의 객체는 영속성 컨텍스트가 제공하는 기능을 사용 못함

            - 만드는 방법
                1. em.detach(entity)

                    특정 엔티티만 준영속 상태로 전환

                2. em.clear()

                    영속성 컨텍스트를 완전히 초기화

                3. em.close()

                    영속성 컨텍스트 종료

        - 제거 [removed]
    - 플러시

        영속성 컨텍스트의 변경내용(쌓인 쿼리)을 DB에 반영,

        **영속성 컨텍스트(1차캐시)를 지우는 동작이 아님!!!**

        - 실행 방법
            1. em.flush() - 수동 호출

                테스트 할때 사용

            2. 트랜잭션 커밋 - 자동 호출
            3. JPQL 쿼리 실행 - 자동 호출
        - 모드 옵션

            em.setFlushMode를 통해 Auto아님 Commit 모드로 둘수 있다.


    ### 엔티티 매핑

    - 매핑 종류
        1. 객체 - 테이블

            @Entity, @Table

            - @Entity

                이 어노테이션이 클래스 레벨에 붙게 되면 엔티티로써 JPA가 관리한다.

                **테이블과 매핑할 클래스에는 필수**

                - 주의사항
                    1. 기본 생성자 필수 - 파라미터 없이 public 또는 protected 생성자
                    2. final 클래스, enum, interface, inner 클래스등에는 사용불가
                    3. 저장할 필드에 final 사용불가
                - 속성
                    1. name

                        JPA에서 사용할 엔티티 이름 지정

                        가급적 사용 금지

            - @Table
                - 속성
                    1. name

                        매핑할 테이블 이름 - 클래스명이 디폴트

                    2. catalog

                        데이터베이스 catalog 매핑

                    3. schema

                        데이터베이스 schema 매핑

                    4. uniqueConstraints[DDL]

                        DDL 생성 시에 유니크 제약 조건 생성

        2. 필드 - 컬럼

            예시: @Column

            - 종류
                1. @Column

                    일반 컬럼 매핑

                    - 속성
                        1. name

                            컬럼 이름

                        2. insertable/updatable

                            등록, 변경 가능 여부

                        3. nullable

                            Not Null 제약조건 여부

                        4. unique

                            간단히 유니크키 할당, 이상한 랜덤키값이 붙어서 안쓴다.

                            그냥 테이블 어노테이션에 거는게 일반적이다.

                        5. columnDefinition

                            컬럼 정보를 직접 넣는 방법, 특정 디비에 종속적인 정보도 넣을 수 있다.

                        6. length

                            문자 길이 제한, String only

                        7. precision, scale(DDL)

                            BigDecimal(BigInteger) 타입 only,

                            - precision

                                소수점을 포함한 전체 자릿수

                            - scale

                                소수 자릿수 only

                2. @Temporal

                    날짜 타입 매핑

                3. @Enumerated

                    enum 타입 매핑

                    - 주의 사항

                        **ORDINAL 절대 사용 금지, 이게 디폴트 값이므로 항상 EnumType.STRING으로 설정해야한다!!!!**

                4. @Lob

                    blob, clob, text등 매핑

                5. @Transient

                    특정 필드를 컬럼에 매핑하지 않음(해당 필드 매핑 무시)


        3. 필드 - 기본 키
            - @Id

                직접 할당

            - @GeneratedValue

                자동 할당 - auto increment, 등등...

                - strategy
                    - Identity

                        MySQL, PostgreSQL, SQL Server, DB2등 에서 사용

                        **em.persist시 즉시 insert sql을 실행해버리고 DB에서 조회한다.**

                    - sequence

                        Oracle, PostgreSQL, DB2, H2 에서 사용

                        - @SequenceGenerator

                            자동 DDL 기능을 통해 테이블에 직접 만든 시퀀스 옵션을 넣을 수 있다.

                            근데 쓸일은 별로 없다.

                        - 속성
                            1. name

                                식별자생성기 이름

                            2. sequenceName

                                DB에 등록되어 있는 시퀀스 이름

                            3. initialValue

                                DDL 생성 시에만 사용됨, 시퀀스 DDL 생성시 초기값 - 디폴트 1

                            4. allocationSize

                                시퀀스 한번 호출에 증가하는 수(**만약 데이터베이스 시퀀스 값이 하나씩 증가하도록 설정되어 있으면 이 값을 반드시 1로 설정해야한다. 성능 최적화에 사용됨**) - **디폴트 50**

                            5. catalog

                                데이터베이스 catalog 이름

                            6. schema

                                데이터베이스 schema 이름

                    - table

                        키 생성 전용 테이블을 하나 만들어서 데이터베이스 시퀀스를 훔쳐내는 전략

                        - 장점

                            모든 데이터베이스에 적용가능

                        - 단점

                            성능, 그래서 잘 안쓴다.

                        - 속성
                            1. name

                                식별자생성기 이름

                            2. table

                                키 생성 테이블 이름

                            3. pkColumnName

                                시퀀스 컬럼명

                            4. valueColumnName

                                시퀀스 값 컬럼명

                            5. pkColumnValue

                                키로 사용할 값이름

                            6. initialValue

                                초기값

                            7. allocationSize

                                시퀀스 한번 호출에 증가하는 수(성능 최적화에 사용됨) - **디폴트 50**

                                - **동작구조**

                                    **if 여러번 insert를 해야하는 상황**

                                    1. **persist() 호출을 한다.**
                                    2. **식별자값 요청을 먼저 보낸다. - 리턴: 1**
                                    3. **근데 allocate가 50인데 처음 요청했을때 1이 돌아왔으므로 한번 더 요청을 보내서 다음 값을 받는다.  - 리턴 51**
                                    4. **그 다음 persist() 호출을 한다. * 50번**

                                    55. **51번째 persist() 호출**

                                    1. **식별자값 요청을 먼저 보낸다. - 리턴: 101**
                                    2. **그 다음 persist() 호출을 한다. * 50번**
                                    3. **...반복**
                            8. catalog

                                데이터베이스 catalog 이름

                            9. schema

                                데이터베이스 schema 이름

                            10. uniqueConstraints

                                유니크 제약조건 (DDL)

                    - auto - 디폴트

                - 권장하는 식별자 전략
                    - **기본키 제약 조건**
                        1. Not Null
                        2. 유일
                        3. **변하면 안된다.**

                    미래까지 이 조건을 만족하는 자연키는 찾기 어렵다. 대리키(대체키)를 사용하자

                    주민등록번호또한 기본 키로 적절하지 않다.

                    **BEST: Long형 + 대체키 + 키 생성전략 사용**

        4. 연관 관계

            @ManyToOne, @JoinColumn

    - 데이터베이스 스키마 자동 생성 - 개발용

        DDL을 애플리케이션 실행 시점에 자동 생성, 객체 먼저 생성해서 개발 가능

        데이터베이스마다 맞는 DDL을 생성, 운영서버에서는 사용하지 않거나 적절히 다듬어서 사용

        - 사용방법

            [hibernate.hbm2dl.auto](http://hibernate.hbm2dl.auto) value를 넣어준다.

            - value 종류
                1. create

                    기존테이블 삭제 후 다시 생성

                2. create-drop

                    create와 같으나 종료시점에 테이블 drop

                3. update

                    변경분만 반영(운영DB 사용금지), 컬럼 추가만 가능

                4. validate

                    엔티티와 테이브리 정상 매피 되었는지만 확인

                5. none

                    사용하지 않음

            - **주의사항**
                - **운영장비에는 create, create-drop, update 사용 금지**
                - 개발 초기 단계

                    create 또는 update 사용

                - 테스트 서버

                    update 또는 validate 사용

                - 스테이징과 운영서버

                    validate또는 none 사용

    - DDL 생성기능

        DDL 생성시에만 사용되며 JPA 실행로직에는 영향을 주지 않는다.

        - 예시

            @Column(nullable = false, length =10) ← 제약 조건

            유니크 제약 조건이 가장 대표적이다.


    ### 연관관계매핑

    - @JoinColumn

        외래키 매핑시 사용한다.

        - 속성
            1. name

                매핑할 외래키 이름

            2. referencedColumnName

                외래 키가 참조하는 대상 테이블의 컬럼명

            3. foreignKey(DDL)

                외래키 제약 조건 직접 지정, 테이블 생성시에만 사용함

            4. unique

                @Column의 속성과 동일

            5. nullable

                @Column의 속성과 동일

            6. insertable

                @Column의 속성과 동일

            7. updatable

                @Column의 속성과 동일

            8. columnDefinition

                @Column의 속성과 동일

            9. table

                @Column의 속성과 동일

    - @ManyToOne

        N:1 관계 매핑,

        mappedBy가 없다. 이 의미는 이 어노테이션을 쓴 엔티티는 연관관계의 주인이 되어야한다는 의미이다.

        - 속성
            1. optional

                false로 설정시 연관된 엔티티가 무조건 있어야함

            2. fetch

                글로벌 패치 전략 설정

            3. cascade

                영속성 전이 기능 사용 여부 설정

            4. targetEntity

                연관된 엔티티의 타입 정보 설정, 거의 사용하지 않는 기능, 제네릭으로 타입 정보를 다 알수 있기 때문

    - @OneToMany

        1:N 관계 매핑,

        - 속성
            1. mappedBy

                연관관계의 주인 필드를 선택한다.

            2. fetch

                글로벌 패치 전략 설정

            3. cascade

                영속성 전이 기능 사용 여부 설정

            4. targetEntity

                연관된 엔티티의 타입 정보 설정, 거의 사용하지 않는 기능, 제네릭으로 타입 정보를 다 알수 있기 때문

    - 방향

        테이블은 방향성이 없지만 객체는 방향성이 있다. 이것을 고려해 방향을 정해줘야한다.

        단방향, 양방향

        - 단방향 매핑

            @ManyToOne @JoinColumn

            이런식으로 한쪽에만 넣어주는 방식

        - 양방향 매핑

            @ManyToOne @JoinColumn ↔  @OneToMany(mappedBy = “team”)

            이런식으로 양측에 모두 넣어주는 방식

            mappedBy는 반대편 사이드 엔티티의 어떤 필드에 매핑이 되었는지 엮어주는 역할이다.

            **사실 그냥 단방향 매핑을 서로 엮어주는것이다.**

            객체는 가급적이면 단방향이 좋다.

            - 객체와 테이블이 관계를 맺는 방식 차이
                - 객체

                    연관관계 2개

                    - 예시

                        회원 → 팀

                        팀 → 회원

                - 테이블

                    연관관계 1개

                    - 예시

                        회원 ↔  팀

            - 양방향 매핑 정리
                1. 처음 테이블 + 객체 설계시 단방향 매핑만 할 것
                2. JPQL 역방향 탐색시, 반대방향으로 조회를 할 필요가 생긴다면 이때 양방향 매핑을 할 것

                    어차피 자바 코드로 2줄만 추가하면 끝난다.

    - 다중성

        N:1, 1:N, N:M,1:1 관계

        - N:1
            - 예시

                Member - Team

                FK는 항상 N 쪽인 테이블에 존재해야한다.(당연한 소리임)

                - 단방향 매핑의 경우

                    ```java
                    @ManyToOne @JoinColumn(”team_id”)
                    private Team team
                    ```

                    이런식으로 FK를 들고 있을 엔티티 객체인 Member 엔티티 객체의 필드로

                    Team 객체를 넣고 거기에 어노테이션을 넣어주면 끝이다.

                - 양방향 매핑의 경우

                    ```java
                    @OneToMany(mappedBy="team")
                    private List<Member> members = new ArrayList<>();
                    ```

                    이런식으로 반대 엔티티 객체인 Team 객체의 필드로  Many에 해당하는 Member 엔티티 리스트를 넣고 어노테이션을 넣고 mappedBy 속성으로 이 매핑의 연관관계의 주인(필드)인 team을 넣어주면 된다.

        - 1:N

            JPA 표준 스팩상 가능은 하지만 **실무에서는 쓰지 않는 것을 추천**

            - 예시

                Team - Member

                FK는 항상 N쪽인 테이블에 존재한다. 만약 1:N으로 Member에 Team을 넣지 않는 객체 설계가 가능은 하지만 **DB와 실제 엔티티 객체의 관계가 걔념상 뒤바뀌기때문에 매우 헷갈리게 된다.** 그래서 추천하지 않는다.

                - 단방향 매핑의 경우

                    ```java
                    @OneToMany @JoinColumn("team_id")
                    private List<Member> members = new ArrayList<>();
                    ```

                    이런식으로 반대 엔티티 객체인 Team 객체의 필드로  Many에 해당하는 Member 엔티티 리스트를 넣고 어노테이션을 넣고 mappedBy 속성으로 이 매핑의 연관관계의 주인(필드)인 team을 넣어주면 된다.

                    @JoinColumn을 안 넣으면 이 방식에서는 중간 테이블이 생긴다.

                    그리고 update sql을 실행한다.

                    +**굳이 1:N을 구현하겠다고 마음을 먹었다면 양방향을 맺어주는 것이 좋다**.

                - 양방향 매핑의 경우

                    ```java
                    @ManyToOne @JoinColumn(name="team_id", insertable = false, updatable=false)
                    private Team team
                    ```

                    **insertable= false, updatable=false를 넣어서 읽기 전용으로 만든다.**

                    만약 넣어주지 않으면 연관관계의 주인이 동시에 사용되는 것과 마찬가지 이므로 연관관계가 꼬이게 된다. **안 넣으면 망하니깐 꼭 넣어주자**

                    이 방식은 기본적으로 공식적인 방식이 아니다.

                    **왠만하면 N:1 양방향을 사용하자.**

        - 1:1

            외래키를 어디에 넣어도 상관없는 관계

            DB 관점에서보면 **외래키에 데이터베이스 유니크 제약조건을 추가한 상태**

            - 예시

                Member - Locker

                - 주 테이블에 외래키 단방향

                    N:1의 예시와 동일하다.

                    단, 어노테이션만 @OneToOne으로 써주면 된다.

                - 주 테이블에 외래키 양방향

                    N:1의 예시와 동일하다.

                    단, 어노테이션만 @OneToOne으로 써주면 된다.

                - 타겟 테이블에 외래키 단방향

                    **JPA에서 지원 불가**

                - 타겟 테이블에 외래키 양방향

                    주 테이블에 외래키 양방향방식에서 키의 위치만 반대로 걸면 된다.

            - 양자택일을 해야하는 1:1 매핑

                이 외래키의 위치를 어디에 넣어도 상관이 없는 관계이기 때문에 둘중 하나를 택해야한다.

                이 부분은 항상 협의를 충분히 해야한다.

                - 고민
                    - 미래에 N의 입장이 될 테이블에 외래키를 넣는 방식 [타겟 테이블에 외래키]

                        이 방식이 실무에선 좀 더 자주 사용되지만 DBA분들은 싫어한다고 한다.

                        - 장점

                            주 테이블만 조회해도 타겟 테이블에 데이터 존재유무 파악 가능

                        - 단점

                            값이 없으면 외래키에 Null 허용해아한다.

                    - 1:1의 관계가 계속 미래에도 유지되는 상황이며, 주로 쿼리를 자주 때리는 테이블에 넣는 방식 [주 테이블에 외래키]
                        - 장점

                            1:1 → 1:N이 되어도 변경시 테이블 구조 유지 가능

                        - 단점

                            프록시 기능의 한계로 지연 로딩으로 설정해도 항상 즉시 로딩됨

                            **프록시 객체는 타겟 테이블에 값이 있는지 없는지 주 테이블만 가지고는 알수가 없기 때문에 항상 즉시로딩된다.**

        - N:M

            **실무 사용 금지**

            - 이유

                애초에 N:M 관계는 현존하는 RDB로 표현이 불가능하다.

                이 경우에는 정규화를 거쳐 중간 관계 테이블을 만들어야한다.

                물론 컬렉션을 사용하면 애플리케이션 코드레벨에선 가능하다.

                그러나 **JPA가 임의로 관계를 만들어준 테이블로는 실무에서 커버가 불가능하다**

                **보통 이런 관계 테이블에는 좀더 디테일한 관계 데이터를 넣기 마련이다.**

                - 대체 방법

                    N:M → 1:N N:1 관계를 가지는 관계 테이블을 엔티티로 승격시킨다.

                    승격시키고 의미 없는 GenerateValue PK로 물려야 유연성이 증가한다.

                    이렇게 테이블을 짜야 실무에서 효과적으로 운영 할수 있다.

            - 구현 방법

                N:1 구현 방법과 동일하다

                어노테이션만 @ManyToMany를 써주면 된다.

    - **연관관계의 주인**

        객체 방향 연관관계는 관리주인이 필요

        - **양방향 매핑 규칙**

            객체의 두 관계중 하나를 연관관계의 주인으로 지정

            **연관관계의 주인만이 외래 키를 관리(등록, 수정)**

            **주인이 아닌쪽은 읽기만 가능**

            주인은 mappedBy 속성 사용X

            주인이 아니면 mappedBy 속성으로 주인 지정

        - **주인 규칙**

            **외래키(FK)가 있는 곳을 주인으로 정한다.**

            **DB는 항상 FK가 있는 곳은 Many, 없는 곳은 1이였다.**

        - **자주하는 실수 리스트**
            1. 연관관계 주인에 값을 넣지 않음
            2. **양방향 매핑시 양쪽다 값을 넣어주지 않음**

                **양쪽다 값을 세팅해주어야한다.**

                테스트 코드 작성등을 고려하면 이렇게 해야한다.

                - 해결법

                    **연관관계 매핑 편의 메서드를 만들어주자!!**

                    예를 들면 setTeam 세터 메서드에

                    team.addMember().add(this); 이런식으로 넣어주는것이 정석이다.

                    그리고 세터 메서드 이름을 set관례에 맞게 만들지 말고 **특별하게 바꿔주는것**이 중요하다!!

                    다만 이 세터메서드를 주인 객체에 둘지 노예 객체에 둘지 고민해야한다. 이건 상황에 따라 다르다.

                    이때, 순환참조 문제가 발생할수도 있다. toString시 계속 서로 참조 하기때문이다.

                    그렇기 때문에 이 **JPA를 만질때는 lombok과 Jackson 사용을 주의해야한다!!!**

                    **Jackson 사용시 Entity를 그대로 반환하게 되면 문제가 생기게된다.**

                    **항상 DTO로 바꿔주고 DTO를 json으로 반환하게 만들어야한다.**

    - 상속 관계 매핑

        객체의 상속 구조와 RDB의 슈퍼타입, 서브타입 구조를 매핑

        이 상속 관계 매핑이 별로 안좋을 수도있다 **그냥 싱글페이지처럼 만들고 나머지 객체들은 JSON으로 때려 넣는 식으로 운영하는 경우도 허다하다.** 오히려 서비스 관리 측면에서는 복잡도가 더 올라갈수도 있어서 **심히 고민해서 Join 전략이든 싱글페이지 전략이든 상속 관계 매핑 자체를 선택해야**한다.

        - RDB의 상속 구조 구현 방법(상속 논리 모델 → 실제 물리 모델)
            1. Join 전략[클래스 테이블 상속]

                [[Java Persistence API %5BJPA%5D/스크린샷_2022-04-20_오후_4.11.33.png]]

                Insert는 슈퍼테이블에 한번, 서브 테이블에 한번씩 해준다.

                서브테이블과 슈퍼테이블의 PK를 같은 PK로 물려줘 조회를 할때는 Join으로 한번에 조회한다.

                그리고 슈퍼테이블에는 어떤 타입인지 타입 필드를 넣어 조회할때 Join할 테이블을 찾는다.

                **이 방식을 정석이라고 보는게 좋다.**

                - 장점
                    1. 테이블 정규화
                    2. 외래 키 참조 무결성 제약조건 활용가능
                    3. 저장공간 효율화
                - 단점
                    1. 조회시 매번 조인을 사용 → 성능저하를 야기 + 조회 쿼리가 복잡함
                    2. 데이터 저장시 Insert SQL 2번 호출
                - 구현 방법
                    1. 각각 엔티티 객체를 전부 만들어주고 상속 관계도 맺어준다.
                    2. 부모 엔티티 객체에 @Inheritance(strategy=InheritanceType.JOINED)를 넣어준다.
                    3. Dtype 컬럼의 경우 @DiscriminatorColumn을 부모객체에 추가한다.

                        name 속성으로 다른 컬럼명으로도 지정가능하다.

                    4. 만약 Dtype 컬럼의 데이터를 엔티티 명이 아닌 다른 데이터를 넣고싶다면

                        자식 엔티티 객체에 @DiscriminatorValue로 직접 지정해주면된다.

            2. 단일 테이블 전략[단일 테이블 상속: **JPA 기본 전략**]

                [[Java Persistence API %5BJPA%5D/스크린샷_2022-04-20_오후_4.16.12.png]]

                테이블 하나에 모든 데이터를 다 넣어버리고 무슨 타입인지 데이터타입 필드만 넣어주는 전략이다.

                **미래에 확장가능성이 없고 아주 단순한 구조라면 이 방식이 좋다.**

                - 장점

                    조회시 성능이 좋다.

                    조회 쿼리가 단순하다.

                - 단점

                    자식 엔티티가 매핑한 컬럼은 모두 null 허용해야 한다.

                    단일 테이블에 모든 것을 저장하므로 테이블이 커질 수 있다. 이 경우 조회 성능이 역으로 떨어질 수도 있다.

                - 구현 방법
                    1. 각각 엔티티 객체를 전부 만들어주고 상속 관계도 맺어준다.
                    2. 부모 엔티티 객체에 @Inheritance(strategy=InheritanceType.SINGLE_TABLE)를 넣어준다.
                    3. Dtype 컬럼의 경우 @DiscriminatorColumn을 부모객체에 추가한다. **어차피 single table의 경우엔 무조건 디폴트로 들어가긴 한다.**

                        name 속성으로 다른 컬럼명으로도 지정가능하다.

                    4. 만약 Dtype 컬럼의 데이터를 엔티티 명이 아닌 다른 데이터를 넣고싶다면

                        자식 엔티티 객체에 @DiscriminatorValue로 직접 지정해주면된다.

            3. 구현 클래스별로 테이블을 만드는 전략[구현 테이블 상속]

                [[Java Persistence API %5BJPA%5D/스크린샷_2022-04-20_오후_4.19.10.png]]

                구현 클래스 별로 테이블을 만들어 주는 전략이다.

                **매우 비추천, 이런게 있다는것 정도만 알아두자**

                - 구현 방법
                    1. 각각 엔티티 객체를 전부 만들어주고 상속 관계도 맺어준다.
                    2. **추상 부모 엔티티 객체**에 @Inheritance(strategy=InheritanceType.TABLE_PER_CLASS)를 넣어준다.
                    3. 이 경우 @Discriminator관련 어노테이션은 의미가 없기 때문에 넣어도 적용이 안된다.
                - 장점

                    서브타임을 명확하게 구분해서 처리할 때 좋다.

                    Not Null 제약조건 사용가능

                - 단점

                    부모 테이블의 타입으로 검색하면 실제 물리 부모 테이블이 없기 때문에 유니온을 사용해 모든 디비를 다 뒤져본다. → 성능 최악

                    자식 테이블을 통합해서 쿼리때리기가 어렵다.

        - @MappedSuperClass

            전체적으로 공통적으로 사용할 컬럼들을 모아 이 어노테이션을 써주고

            각각 사용할 엔티티에 상속받아 사용하는 방식이다.

            **상속 관계가 일부 컬럼에만 적용**되는 것이다.

            **추상 클래스로 생성해 사용하는것이 좋다.**

    - 프록시

        실제 클래스를 상속 받아 만들어지는 가짜 객체

        이 프록시를 이용해 매핑 되어있는 타 테이블의 데이터는 안들고 오게 만들수도 있고 Not Null 무결성 또한 지켜 줄수도 있다.

        - 구현 방법
            1. em.getReference()를 이용해 데이터베이스 조회를 미루는 가짜(프록시)엔티티 객체 조회

            em.find 대신 em.getReference를 쓰면 자동으로 프록시객체를 생성해 제공해준다.

        - 프록시 객체 값 초기화 동작구조
            1. 프록시 객체  getter 호출
            2. 프록시 객체가 영속성 컨텍스트에 초기화 요청
            3. 영속성 컨텍스트는 DB 조회후 실제 Entity 생성
            4. 프록시 객체는 다시 target 데이터를  getter를 통해 전달
        - 주의사항
            - **프록시 객체는 초기화시 한번만 초기화한다.**
            - **타입 비교시 instanceof를 사용해야한다.**
            - **이미 영속성 컨텍스트에 엔티티 존재시, em.getReference() 호출해도 실제 엔티티가 반환됨**

                JPA는 언제나 == 비교시 늘 보장이 되어야하기 때문에 == 비교시 제일 먼저 비교 하는 타입비교부터 맞아야한다. 그래서 실제 엔티티가 반환된다.

                **역으로 이미 getReference로 프록시를 먼저 만들면 find를 해도 프록시가 반환된다. ==비교 때문이다.**

            - **준영속 상태일때, 프록시 초기화시 예외 발생**
        - 프록시 확인 방법
            1. 프록시 인스턴스 초기화 여부 확인

                emf.getPersistenceUnitUtil.isLoaded();

            2. 프록시 클래스 확인 방법

                entity.getClass().getName();

            3. 프록시 강제 초기화

                org.hibernate.Hibernate.initailze(entity);

            4. 프록시 강제 호출

                member.getName();

    - 즉시 로딩 & 지연 로딩

        이건 비즈니스 로직에 사용 빈도에 따라 정하면 된다.

        **지연로딩만 사용하자**

        - 지연 로딩

            매핑 되어있는 타 엔티티 데이터는 안들고 오게 만드는 방법이다.

            이 타 엔티티 데이터는 엔티티 데이터를 사용할때 영속성 컨텍스트가 DB에 select 쿼리를 날려 실 엔티티를 만들어 낸다.

            member.getTeam()

            ← (X, 이건 그냥 프록시 레퍼런스에 접근하는 것이므로 이땐 실 엔티티를 만들지 않는다.)

            member.getTeam().getName()

            ← (O, 엔티티 데이터를 사용하는 것이나 다름없으므로 이때 실 엔티티 데이터를 만든다.)

            - 구현 방법

                관계성 어노테이션에 fetch속성으로  LAZY를 넣어준다.

                (ex, @ManyToMany, @ManyToOne...)

        - 즉시 로딩

            즉시 매핑 되어있는 타 엔티티 데이터를 한번에 들고와 초기화 하는 방식이다. **디폴트**

            이 즉시로딩은 그냥 바로 실 엔티티 데이터를 붙이는 작업이기 때문에 **프록시를 사용하지 않는다**.

            - 구현 방법

                관계성 어노테이션에 fetch속성으로  EAGER를 넣어준다.

                (ex, @ManyToMany, @ManyToOne...)

        - 주의사항
            - **실무에서는 무조건 지연로딩만 사용해야한다!!!!**

                즉시로딩은 예상하지 못한 쿼리가 튀어나간다.

            - **즉시로딩은 JPQL에서 N+1 문제가 있다.**

                select * from member; 이 요청을 한번하면 엮여있는 매핑 객체 만큼 나간다.

                전체 조회 1번, 그리고 엮여있는 매핑 데이터의 총 개수 N번, 합쳐 1+N만큼 쿼리가 나가게 된다.

                JPQL에서는 fetch join 키워드를 통해 조인된 데이터를 동적으로 한방 쿼리로 다 들고오게 만들 수도 있다. 아니면 엔티티 그래프 기능을 사용해야한다.

            - **@ManyToOne @OneToOne → LAZY로 직접 수정해줘야한다.**
            - @OneToMany @ManyToMany → 직접 수정할 필요 없음 기본이 LAZY
    - 영속성 전이 - CASCADE

        특정 엔티티를 영속화 할때 다른 엔티티도 동시에 영속화 시키고 싶을때 사용하는 속성

        - 주의사항

            연관관계와는 아무 관련이 없다.

            그냥 영속화 할때 연관된 엔티티도 같이 영속화를 하는 편의성말곤 아무 의미가 없다.

        - 종류
            1. **ALL**

                **모두 적용, 라이프사이클을 같이 가져야할 경우에만 사용**

            2. **PERSIST**

                **영속, 저장할 때만 같이 생성 되어야한다면 사용**

            3. **REMOVE**

                **삭제, 삭제할 때만 같이 삭제 되어야한다면 사용**

            4. MERGE

                병합

            5. REFRESH

                refresh

            6. DETACH

                준영속화

        - 사용 시기

            제일 좋은 사용하기 시기: 게시판, 게시글등등

            1. 관련 엔티티들이 완전히 다같이 살리고 다같이 죽어야되는 부모 엔티티 일경우
            2. 단일 소유자일 경우, 부모 엔티티와 자식 엔티티간의 사이가 유일해야함.

                다른 엔티티에서 자식엔티티를 연관된다면 절때 안된다.

    - 고아 객체

        orphan 엔티티

        부모 엔티티와의 연관관계가 끊어진 자식 엔티티

        - 고아 객체 삭제 방법

            **orphanRemoval속성을 true**로 주면 된다.

            이러면 **부모의 자식 컬랙션에서 자식을 지울경우 지워진 자식에 대해 자동으로 DELETE 쿼리가 나간다**.

        - 주의 사항
            - 사용시기가 CASCADE 사용 시기와 같다.
            - 참조하는 곳이 하나이고 부모 엔티티가 개인 소유할때만 사용해야한다.
            - 부모를 삭제할때 CASCADE.REMOVE 처럼 동작한다.
            - **@OneToOne, @OneToMany**만 사용 가능하다.
        - **CascadeType.ALL + orphanRemovel = true를 동시에 준다면?**
            - **자식 엔티티는 온전히 부모 엔티티에 의해 생명주기를 관리하게 된다.**
            - **DDD의 Aggregate Root 개념을 구현할때 유용하다.**

                **부모를 통해서만 자식을 관리하는 개념이기 때문이다.**

                **자식엔티티에 관한 레포지터리를 따로 만들지 않아도 된다는 의미이다.**

                **부모 엔티티에 대한 레포지터리 하나로 나머지 자식 엔티티들을 관리할 수 있기 때문이다.**

    - 값 타입
        - JPA 데이터 타입
            - 엔티티 타입

                @Entity로 정의하는 객체

                - 특징

                    데이터가 변해도 식별자로 추적가능

            - 값 타입

                int, Integer, String 처럼 단순히 값으로 사용하는 자바 기본타입이나 값 객체

                - 특징

                    값만 있으므로 추적 불가능

                - 종류
                    1. 기본 값 타입

                        생명주기를 엔티티에 의존함

                        공유 금지

                        1. 자바 기본 타입

                            절대 공유가 안된다. 항상 값을 복사하기 때문이다. 선언 즉시 데이터를 메모리에 얹어버리고 다른 곳에 대입하면 값만 복사해서 넘긴다.

                            - int
                            - double
                        2. 래퍼 클래스

                            주소 값이 공유가 되는 클래스이다. 다만 변경은 되지 않는 애들이다.

                            - Integer
                            - Long
                        3. String
                    2. 임베디드 타입

                        클래스안에 복합적으로 기본 값 타입들을 섞어서 만든 타입

                        - 구현 방법
                            1. @Embeddable을 값타입 정의 클래스에 넣는다.
                            2. @Embedded를 값타입을 사용하는 클래스(엔티티 클래스)에 넣는다.
                            3. **값 타입 정의 클래스는 항상 기본 생성자가 있어야한다!!!!**
                        - 장점
                            - 재사용
                            - 높은 응집도
                            - 해당 값 타입만이 지닌 메서드 사용가능
                            - 소유된(포함된) 엔티티 생명주기를 의존
                            - 세밀한 매핑이 가능하다
                            - **잘 설계한 ORM 애플리케이션은 매핑한 테이블 수보다 클래스의 수가 더 많다**
                        - 주의사항
                            - 내부에 필드로 타 엔티티를 가질수도 있다.
                            - 중복 사용시 @AttributeOverrides, @AttributeOverride등을 사용해야한다.
                            - 값이 NULL이면 매핑한 컬럼도 모두 NULL이 된다.
                    3. 컬렉션 값 타입

                        자바 컬렉션등등

        - 값 타입과 불변 객체

            **임베디드 타입 같은 값 타입을 여러 엔티티에서 공유하면 위험하다.**

            **컴파일 레벨에서 막을 방법이 없다!!!**

            스위프트나 코틀린은 이 값 객체 전용 클래스가 존재할 정도이다.

            좀 심층깊게 다뤄야할 주제이다.

            - 불변 객체

                값 타입은 불변하게 설계해야한다.

                **생성자로만 값을 설정, 수정자를 만들지 않아야한다.**

            - 인스턴스 값(동등성) 비교 메서드 유무

                값 타입은 인스턴스 이외에도 내부의 값들을 비교해 같은지 비교하는 비교 메서드가 있어야한다.

                **즉, 값 객체들은 기본적으로 equals를 사용해 비교를 해야한다.**

            - VO 컬렉션

                값 벨류 하나 이상 저장할때 사용

                **DB는 별도로 fk를 들고 있는 테이블을 만들어 저장하게 된다**.

                - 구현 방법
                    1. @ElementCollection, @CollectionTable 사용
                    2. @CollectionTable에 지정할 테이블 명, 외래키값을 넣는다.
                    3. 예외적으로 String같은 레퍼로된 클래스는 컬럼명을 지정해줄수 있다.

                        컬럼이 하나이기 때문이다.

                - 주의사항
                    - **영속성 전의 - CASCADE + orphanRemoval 기능이 기본 장착되있다.**
                    - **LAZY Loading이 기본이다.**
                    - **실무에서 사용 금지**
                    - 실무에서는 값 타입 컬렉션 대신 1:N 매핑을 고려할것
                - 실무 적용 방법
                    1. VO 객체를 필드로 가지는 엔티티 객체를 만든다.
                    2. 이 엔티티 객체와 소유 객체는 1:N 관계로 만들어준다.
                    3. 이때, 소유객체쪽에는 OneToMany, 그리고 Cascade.All, orphanRemoval=true로 만들어준다.

- JPQL

    ### JPA의 쿼리 수단

    - **JPQL**
    - JPA Criteria

        JPQL 빌더

        권장하지 않음 복잡함

    - **QueryDSL**

        JPQL 빌더

        쉽고 SQL에 가깝고 컴파일타임에 오류가 잡힌다. **실무 사용 권장**

    - 네이티브 SQL
    - JDBC API 직접 사용
    - MyBatis, SpringJdbcTemplate 함께 사용

    ### JPQL

    **JPQL은 엔티티 객체를 대상으로 쿼리를 날린다**.

    - 문법
        - select, update, delete
            - select ,,, from ...

                [ where, groupby, having, orderby ]

            - update ,,, set ...

                [ where ]

            - delete from ,,,

                [ where ]

        - 규칙
            1. 별칭 필수
            2. 엔티티와 속성은 대소문자 구분을 한다.
            3. JPQL 키워드는 대소문자 구분을 안한다.
            4. 엔티티 이름을 사용한다
        - 집합과 정렬
            - count()

                rows 갯수

            - sum()

                rows value 총 합

            - avg()

                rows value 총 평균 값

            - max()

                rows value 중 max 값

            - min()

                rows value 중 min 값

            - groupby, having
            - orderby
        - TypeQuery, Query
            - TypeQuery

                반환 타입이 명확할 때 사용

            - Query

                반환 타입이 명확하지 않을 때 사용

        - 결과 조회 API
            - query.getResultList()

                결과가 하나 이상일때, 없으면 빈리스트

            - query.getSingleResult()

                결과가 정확히 하나일때, 둘 이상이거나 없으면 예외를 던짐

                진짜 하나일때만 써야함!!

                Spring Data JPA에서는 Null또는 Optional로 반환해 버린다.

                예외 극혐

        - 파라미터 바인딩
            - 사용법
                1. where문에 :parameter 이런식으로 넣어준다.

                    ?1,?2 이런식으로 순서로 지정할수도 있다.← 쓰지말것

                2. 이렇게 넣고 query.setParameter(”parameter”,”Hong”) 이렇게 세팅한다.
                3. 메시지 체이닝으로 만들어줘야 편하다.
        - 프로젝션

            SELECT 조회할 대상을 지정하는 것이다.

            - 예시
                - SELECT **m** FROM Member m

                    SELECT **m.team** FROM Member m

                    → 엔티티 프로젝션

                - SELECT **m.address** FROM Member m

                    → 임베디드 타입 프로젝션

                - SELECT **m.username, m.age** FROM Member m

                    → 스칼라 타입 프로젝션,

                    **DISTINCT로 중복을 제거해야한다.**

            - 여러 값 조회[**스칼라 타입 조회시**]
                1. Query 타입으로 조회
                2. Object[] 타입으로 조회
                3. new 명령어로 조회

                    **제일 깔끔한 방법,**

                    DTO를 미리 만들어 두고 이 DTO타입으로 꺼내 오는 방법
                    QuertDSL로 더 단순하게 만들어주는게 좋다.

        - 페이징
            - 사용법
                1. setFirstResult(), setMaxResults()

                    조회 시작위치, 조회할 데이터수 이 두가지 API를 지정해 들고 오면 끝

        - 조인
            - 내부 조인

                SELECT m FROM Member m [INNER] JOIN m.team t

                데이터가 있는 경우에만 들고 온다.

            - 외부 조인 [왼쪽 기준]

                SELECT m FROM Member m LEFT [OUTER] JOIN m.team t

                데이터가 없는 경우에는 Null을 넣는다.

            - 세타 조인 [크로스 조인]

                SELECT count(m) FROM Member m, Team t WHERE m.username= t.name

                딱히 연관관계가 없을때 사용하는 조인, 새로운 릴레이션을 만들어 낸다.

            - on 절 조인
                - 조인 대상 필터링
                    - 예시

                        회원과 팀을 조인할때 팀이름이 A인 팀만 조인

                        SELECT m, t FROM Member m LEFT JOIN m.team t **on** t.name = 'A'

                - 연관 관계 없는 엔티티 외부 조인
                    - 예시

                        회원과 팀을 조인할때 팀이름이 A인 팀만 조인

                        SELECT m, t FROM Member m LEFT JOIN Team t **on** m.username = t.name

                        별도의 테이블끼리의 조인 이기 때문에 Team t 이런 식으로 조인한 것

        - 서브 쿼리
            - 주의사항

                **FROM절 서브쿼리는 지원 불가 → 조인으로 풀어서 해결**

                **SELECT절 서브쿼리는 하이버네이트에서만 지원**

            - 예시
                - 나이가 평균보다 많은 회원

                    SELECT m FROM Member m WHERE m.age > **(SELECT avg(m2.age) FROM Member m2)**

                    m을 따로 m2쪽 서브 쿼리에서 사용하지 않았다. 이렇게 해야 성능이 잘 나온다.

                - 한 건이라도 주문한 고객

                    SELECT m FROM Member m WHERE **(SELECT count(o) FROM Order o WHERE m = o.member) > 0**

                    m을 따로  서브 쿼리에서 사용했다. 이땐 성능이 잘 나오지 않는다.

            - 지원 함수
                - [NOT] EXIST (subquery)

                    {ALL | ANY | SOME} (subquery)

                    all: 모두 만족해야 참

                    any,some: 조건중에 하나라도 만족하면 참

                - [NOT] IN (subquery)

                    서브쿼리의 결과 중 하나라도 같은 것이 있으면 참

        - JPQL 타입 표현
            - 문자

                ‘HELLO’, ‘She’’s’

            - 숫자

                10L, 10D, 10F

            - 불리언

                TRUE,FALSE (소문자도 됨)

            - ENUM

                jpabook.MemberType.Admin (패키지명 필요,)

                이렇게 쓰기 싫으면 파라미터로 넣어줘야한다.

            - 엔티티 타입

                type(m) = Member

                상속 관계에서만 사용된다.

        - CASE식
            - 예시
                - 기본

                    ```sql
                    select
                    	case
                    		when m.age <= 10 then '학생요금'
                    		when m.age >= 60 then '경로요금'
                    		else '일반요금'
                    	end
                    from Member m
                    ```

                - 단순

                    ```sql
                    select
                    	case t.name
                    		when '팀A' then '인센티브110%'
                    		when '팀B' then '인센티브120%'
                    		else '인센티브105%'
                    	end
                    from Team t
                    ```

                - COALESCE

                    ```sql
                    select coalesce(m.username,'이름 없는 회원') from Member m
                    ```

                - NULLIF

                    ```sql
                    select NULLIF(m.username, '관리자') from Member m
                    ```

        - JPQL 함수
            - CONCAT
            - SUBSTRING
            - TRIM
            - LOWER, UPPER
            - LENGTH
            - LOCATE
            - ABS, SQRT, MOD
            - SIZE, INDEX(JPA 용)

                컬렉션 값을 뽑아준다.

            - 사용자 정의 함수

                직접 Dialect 클래스를 상속 받아 커스텀해 만들고 registerFunction으로 등록한다.

                → 실무에서 생각보다 많이 쓰는 기능이다.

                ```sql
                #JPA 기본 사용자 정의함수 호출 방법
                select function('group_concat', i.name) from Item i

                #하이버네이트 스니펫 적용시 가능한 문법
                select group_concat(i.name) from Item i
                ```

        - 경로 표현식

            .을 찍어 객체 그래프를 탐색하는 것

            ```sql
            select m.username # -> 상태 필드
            	from Member m
            	join m.team t # -> 단일 값 연관 필드
            	join m.orders o # -> 컬렉션 값 연관 필드
            where t.name = '팀A'
            ```

            - 상태 필드

                단순히 값을 저장하기 위한 필드

                추가 탐색이 **불가능하다**.

            - 연관 필드

                연관 관계를 위한 필드

                **묵시적 이너 조인 발생**

                - 단일 값 연관 필드

                    대상이 엔티티 일 경우

                    추가 탐색이 **가능하다**.

                - 컬렉션 값 연관 필드

                    대상이 컬렉션일 경우

                    추가 탐색이 **불가능하다**.

                    From 절 이후 명시적 조인을 추가하여 별칭을 얻어야한다.

            - **주의사항**

                **묵시적 조인 사용 금지**

                **명시적 조인만 사용할 것**

        - **Fetch Join**

            **미칠듯이 실무에서 중요함**

            JPQL에서 성능 최적화를 위한 기능

            **연관된 엔티티나 컬렉션을 SQL 한 번에 함께 조회하는 기능**

            **JPA 실무에서 최적화의 대부분 문제는 fetch join이 적용되지 않아 N+1문제가 발생하는 원인이 제일 주된 원인이다.**

            - Fetch join 사용불가시 적용해야하는 방법
                1. DTO를 적용해 직접 쿼리로 들고온다.
                2. 오퍼레이션을 등록해 DTO로 들고온다.
            - Fetch Join 기본

                지연로딩을 쓰던 즉시 로딩을 쓰던 **조인된 데이터를 접근하는 순간 N+1 select 이슈가 터진다**.

                이때는 `select m from Member m join fetch m.team` 이런식으로 연관된 필드를 한번에 가져와 버린다.

            - 컬렉션 Fetch Join

                컬렉션을 Fetch join하면 로우가 뻥튀기 된다. 주의해야한다.

                - 중복 로우 제거 방법

                    **select 절에 distinct를 추가한다.**

                    sql에서의 distinct는 원래 불가능하지만 **JPQL에서는 id가 중복이면 지워버린다.**

            - 일반 조인과 Fetch join의 차이
                - 일반 조인

                    일반조인은 연관된 테이블을 select 할때 연관된 테이블의 나머지 컬럼을 들고 오지 않는다.

                    ```sql
                    select
                            distinct t
                        From
                            Team t
                        join
                            t.members */ select
                                distinct team0_.id as id1_3_,
                                team0_.name as name2_3_
                            from
                                Team team0_
                            inner join
                                Member members1_
                                    on team0_.id=members1_.team_id
                    ```

                - fetch join

                    조인 결과에 연관된 테이블 데이터를 포함시킨다.

                    ```sql
                    select
                            distinct t
                        From
                            Team t
                        join
                            fetch t.members */ select
                                distinct team0_.id as id1_3_0_,
                                members1_.member_id as member_i1_0_1_,
                                team0_.name as name2_3_0_,
                                members1_.age as age2_0_1_,
                                members1_.memberType as memberTy3_0_1_,
                                members1_.team_id as team_id5_0_1_,
                                members1_.username as username4_0_1_,
                                members1_.team_id as team_id5_0_0__,
                                members1_.member_id as member_i1_0_0__
                            from
                                Team team0_
                            inner join
                                Member members1_
                                    on team0_.id=members1_.team_id
                    ```

            - 주의사항
                1. **fetch join 대상에 alias 부여 불가능**

                    만약 별칭 m을 부여하고 where m.age > 10

                    이런식으로 일부 데이터만 객체 그래프로 들고 오는 행위는 해선 안된다.

                    객체 그래프는 기본적으로 모든 대상을 다 들고 오는것을 목표로 하기 때문에

                    이 방식 자체가 맞지가 않다. **데이터 정합성이 맞지 않는다.**

                    만약 저런 행위를 하고싶다면 **반대편 테이블에서 저 옵션을 넣고 조회하는 것이 옳다.**

                    그래서 이 별칭은 단계적으로 fetch를 해야하는 복잡한 상황을 제외하고는 쓸일이 없다.

                2. **둘 이상의 컬렉션은 fetch join 불가능**

                    **컬렉션 자체가 이미 중복이 되면서 들고와지는 특성**이 있기때문에

                    둘이상 fetch join을 하면 정합성이 맞지 않게 된다.

                3. **컬렉션 fetch join은 페이징이 불가능하다.**

                    컬렉션 자체의 중복으로 들고 오는 특성 때문에 그렇다.

                    **페이징 적용은 되지만 경고가 띄워준다. 그리고 모든 컬렉션의 로우를 다들고와버린다. 백만줄이면 백만줄을 들고 와버린다. → 서버 뻑나기 딱좋다.**

                    굳이 컬렉션을 페이징을 해야하겠다면 다음처럼 이용하면 된다.

                    - **컬렉션 페이징시 LAZY Loading 최적화**
                        1. join fetch절을 전부 날려서 Lazy하게 패이징 리스트 들고오게 만든다.
                        2. 이렇게 페이징을 한 리스트에서 컬렉션에 접근을 하게되면 각각 Lazy로드를 하게된다.

                            이 상태에서 페이징한 리스트가 1000개면 1000번씩 추가적으로 select쿼리를 날리게된다.

                        3. **BatchSize를 설정해준다.**

                            이렇게되면 만약 100으로 설정한다면 1000번씩 들고와야할 쿼리를 100명씩 나눠서 들고오게되며 이런 경우에는 부담이 훨씬 덜게된다.

                            **실무에서는 기본적으로 배치사이즈를 글로벌하게 지정해줘야한다.**

        - 다형성 쿼리
            - 활용 방법
                1. type()을 이용해 특정 타입만 들고 오게 하기
                2. treat()를 부모 타입을 특정 자식 타입처럼 사용하기
        - 엔티티 직접 사용

            엔티티를 직접 쿼리안에 넣어서 조회할수도 있다.

            자동으로 id값이 넘어간다.

        - **Named 쿼리**

            정적 쿼리 → 어노테이션 OR XML에 정의

            애플리케이션 로딩시점에 초기화후 재사용 → **로딩 시점에 쿼리 검증**

        - 벌크 연산

            쿼리 한번으로 여러 테이블의 로우를 변경하거나 삭제하기 위한 기능

            Insert into도 하이버네이에서는 가능하다.

            - 주의사항

                **영속성 컨텍스트를 무시하고 데이터베이스에 직접 쿼리를 때린다.**

                - 해결법
                    1. 벌크 연산을 먼저 수행하고 영속성 컨텍스트 관련 연산을 수행
                    2. 영속성 컨텍스트가 사용이 되었다면 벌크 연산 이후 영속성 컨텍스트 초기화

                        → 이러면 값을 다시 조회한다.

- JPA - DDD 활용
    - Test시 팁
        - @Transactional

            @Transactional을 테스트 메서드 레벨에 넣어주게 되면 실행후 롤백을 해버린다.

            테스트 용이기 때문에 강제롤백이 기본 옵션이다.

            @Rollback(false)를 넣어주면 강제 롤백을 해제할 수 있다.

        - 쿼리 파라미터 까지 로그를 확인 하고 싶을때

            [https://github.com/gavlyukovskiy/spring-boot-data-source-decorator](https://github.com/gavlyukovskiy/spring-boot-data-source-decorator)

            이 외부 라이브러리를 써야 로그에 쿼리파라미터 → 이런 애들 (?,?)까지 제대로 찍어준다.

- 엔티티 설계시 팁
    - @XToOne

        이 놈들은 기본이 EAGER이기 때문에 다 찾아서 LAZY로 바꿔줘야한다.

    - List 같은 컬렉션

        컬렉션은 초기화를 해주지 않으면 하이버네이트가 알아서 내부에 구현해둔 컬렉션으로 초기화를 하지만 이것을 다시 수정을 해주게 되면 하이버네이트가 원하는 동작을 구동시키지 못하기 때문에 **무조건 초기화를 해주고 손대지 말자**

    - SpringPhysicalNamingStrategy

        스프링 부트 기본 테이블 네이밍 전략이다. 자동으로 언더 스코어로 변환해준다.

    - cascade

        All로 세팅하면 각각 엔티티를 persist할 필요 없이 하나만 persist해주면 엮인 엔티티도 persist해준다

        **엮여있는 엔티티로 persist가 전파되는 것이다.**

    - 연관관계 매핑 메서드

        서로 연관관계를 맺어 주는 메서드는 컨트롤을 하는 주체가 되는 클래스에 만들어 주는 것이 좋다.

    - **도메인과 직접 연관된 비즈니스 로직**

        도메인과 직접 연관된 비즈니스 로직은 도메인 엔티티에 직접 넣어줘야 응집도가 올라간다.

        특히 setter를 만들면 안된다! 이 비즈니스 로직은 도메인의 액션에 해당하는 비즈니스 로직이기 때문에 한 메서드당 하나의 변경 로직만 들어가야하며 보통 이런 로직은 루트 애그리거트가 제공을 해야한다.

    - **생성 로직[정적 펙토리 메서드]**

        기본 생성자를 protected로 두면 JPA 스펙상 기본 생성자를 통해 객체를  만드는 순간 막아버린다.

        이러면 개발자 입장에서는 “*static으로 만든 생성 로직을 써야하는 구나 “*하고 인식하게 만들어줘서 휴먼에러를 방지해주며 JPA가 리플랙션을 이용할수 있게끔 만들어 주는 것이다.

        **롬복을 통해 @NoArgConstructor(access = AccessLevel.PROTECTED)를 추가**하면 따로 저 protected 기본 생성자를 생성할 필요 없다.

        private 생성자만 이용해도 되지만 JPA쪽에 에러가 생긴다. 사실 JPA는 JAVA Reflection API 활용해서 엔티티를 매핑하는데 이때 JPA는 기본생성자를 통해 객체 생성 이후 값을 매핑 하기때문에 public, protected 기본 생성자가 있어야한다. 그래서 에러가 발생한다. 여기 더불어 em.getReference()를 통해 얻는 프록시 객체 또한 활용이 불가능하다 이 프록시 객체 또한 엔티티 클래스 상속을 통해 만들어지는 객체이기 때문에 기본 생성자 또한 활용 불가능해지기 때문이다. 이를 방지하기 위해 protected 기본 생성자를 만들어두는 것이다.

- 레포지터리 설계시 팁
    - @PersistenceContext

        EntityManager를 주입해주는 어노테이션이다. JPA를 사용해 레포지터리를 만든다면 이것이 필수이다.

- 서비스 설계시 팁
    - @Transcational

        이 어노테이션을 클래스 레벨에 넣어주면 하위의 public 메서드들은 트랜잭션을 타고 동작하게 된다.

        이것을 사용해야 EntityManager의 각종 영속성 컨텍스트 기능들을 사용 할 수 있다.

        **클래스 레벨에 클래스 내부에서 쓰이는 글로벌한 트랜잭션 옵션을 넣어주는게 일반적이다. 예를 들면 특정 서비스는 조회하는 서비스가 많다면 readOnly=true 옵션을 클래스 레벨에 걸어주고 CUD에 해당하는 서비스 메서드들만 따로 메서드 레벨에 @Transactional을 다시 걸어준다. 다시 걸게되면 이쪽에 우선순위가 더 높아서 이 메서드에 걸어둔 트랜잭션 어노테이션이 우선적으로 걸리게 된다.**

        - **readOnly = true**

            더티체킹을 안하는 이점이 있어서 조회만 하는 트랜잭션은 읽기 전용 옵션을 켜주는게 좋다.

            **플러시모드가 수동으로 바뀌기 때문에 더티체킹, 다시말해 변경 감지기능이 동작하지 않게 되는데 이 의미는 스냅샷을 따로 저장하지 않는다는 의미이며 이는 곧 성능 향상으로 이어진다. (스냅샷 저장을 위한 메모리를 차지하지 않게된다.) → 역으로 말하면 CUD로직이 하나라도 섞여있는데 이걸 켜주면 절대 안된다는 의미이기도 하다. DB쪽으로 Flush가 날라가지 않기 땜시롱…**

            드라이버마다 차이가 있지만 이 옵션을 켜주게 되면 조회를 할때에는 트랜잭션 리소스를 덜 먹게 된다.

        - **영속성 컨텍스트**

            이 @Transactional 안에서의 컨텍스트 끼리는 같은 영속성 컨텍스트 이다. **이 내부에서 같은 PK를 들고 있는 객체 끼리 비교를 하면 true를 반환한다.**

        - **Test는 무조건 롤백**

            flush가 동작하기 전에 전부 롤백을 하기 때문에 **@Rollback(false)를 해줘야 flush가 동작한다.**

            아니면 EntityManager를 따로 주입 받아 em.flush를 직접 강제로 호출해주면 된다.

            근데 어차피 테스트는 TC 안에서 반복적으로 이뤄져야하기 때문에 이렇게 자동 롤백해야 옳다

    - **중복 검사시 주의사항**

        **이메일이나, 아이디, 닉네임등은 동시성 문제가 있기 때문에 중복을 허용하지 않는다면 유니크 제약조건을 엔티티 레벨에 걸어주어야한다.**

- **OSIV**

    open session in view 옵션은 기본이 True이다.

    이 옵션은 트랜잭션 영역인 서비스 계층까지만 데이터베이스 커넥션을 살릴지 말지 결정하는 것이다.

    이 옵션 덕분에 **컨트롤러 계층에서 엔티티 객체에 지연로딩을 통해 쿼리를 불러와 영속화를 시키는 작업이 가능**하다.

    - **주의사항**

        **커넥션을 너무 오래 물고 있어서 커넥션 풀이 말라버리는 치명적인 단점이 있다.**

    - **해결법**

        **이 옵션을 종료하고 서비스 계층에 모든 영속성 컨텍스트를 사용하는 로직을 몰빵해야한다.**

        **그렇기 때문에 거의 필수로 CQRS를 적용해줘야한다.**

        다만 프로젝트의 규모에 따라 작으면 그냥 켜놓는게 나을 수도 있다.

- **BigInt + Auto Increment를 사용하지 못하는 상황에 직접 ID를 넣어줘야하는 경우**

    엔티티를 Persistable로 Implements하면 된다.

# QueryDSL

동적쿼리, 복잡한 쿼리를 자바코드로 해결하여 컴파일타임에 오류체크까지 해낼 수 있는 라이브러리

[Querydsl Reference Guide](http://querydsl.com/static/querydsl/5.0.0/reference/html_single/)

## 설치 방법

1. QueryDSL 플러그인 추가
2. QueryDSL 의존성 추가
3. gradle refresh
4. gradle querydsl 컴파일 세팅 추가
5. 기본적인 엔티티 및 도메인 설계
6. gradle창을 열고 build-clean, other-compileQuerydsl 차례대로 실행

### 사용시 주의 사항

- JPAQueryFactory 생성시
    1. 빈으로 등록하기
    2. 생성자안에서 초기화 해주기

## 기본적인 쿼리

기본적으로 querydsl은 q-type 엔티티를 활용하는데 이때 PreparedStatement로 자동으로 파라미터를 바인딩한다. 성능상에 이점도 있으며 파라미터 인젝션 공격 방어에도 좋다.

### JPAQueryFactory

이 펙터리 객체를 사용해 쿼리를 만들고 내용을 넣을땐 Q-Type 객체를 넣어준다.

이 펙터리 객체는 필드로 넣어도 동시성 문제는 없기 때문에 필드로 넣어주는것이 편하다.

이 펙터리 객체는 EntityManager를 주입 받아야하는데 이때 동시성 문제가 없는 이유는 EntityManager 또한 어차피 빈으로 등록된 싱글톤이며 이 싱글톤 객체는 CGLIB으로 생성된 프록시 객체이다. 즉, 어차피 세션(트랜잭션)마다 각기 다른 프록시 객체가 바인딩되도록 스프링이 라우팅하기 때문에 동시성 문제가 없는 것이다.

### Q-Type 활용

- 인스턴스 생성 방법
    - 직접 아이디를 String으로 넣어서 생성
    - Q-Type 관련 구현코드 생성시 static final로 미리 만들어둔 인스턴스를 사용하는 방법

        이 방식을 사용할 때 Q-Type.type이런식으로 사용한다.

        **이때 Q-Type을 static member로 지정하면 엄청 깔끔하게 쓸수 있다.**

        - 주의점

            같은 테이블을 조인해야하는 상황이 오면 이땐 따로 직접 아이디를 넣는 방식으로 생성해줘야한다.

- 검색조건 쿼리

    JPQL에서 지원하는 조건은 다 지원해준다.

    ```java
    member.username.eq("hong jun-geun"); // member = 'hong jun-geun'
    member.username.ne("hong jun-geun"); // member != 'hong jun-geun'
    member.username.eq("hong jun-geun").not(); // member != 'hong jun-geun'

    member.username.isNotNull(); // 이름이 is not null

    member.age.in(10,20); // age in (10, 20)
    member.age.notIn(10,20); // age not in (10, 20)
    member.age.between(10,20); // between 10, 20

    member.age.goe(10,20); // age >= 30
    member.age.gt(10,20); // age > 30
    member.age.loe(10,20); // age <= 30
    member.age.lt(10,20); // age < 30

    member.username.like("hong%"); // like 검색
    member.username.contains("hong"); // like '%member%' 검색
    member.username.startsWith("hong"); // like 'member%' 검색

    ```

    **queryFactory의 where 파라미터는 …으로 여러개를 넘겨주게 되면 자동으로 and연산으로 합친다.**

- 결과 조회 메서드
    - fetch()
    - fetchOne()
        - 주의점

            결과 없을시 : null

            결과 둘 이상일시 : com.querydsl.core.NonUniqueResultException 발생

            **옵셔널로 처리되지 않는다!!!**

    - fetchFirst()
    - ~~fetchResults()~~

        group by 사용시 성능 이슈로 마이그레이션 예제를 통해 마이그레이션해야한다.

    - ~~fetchCount()~~

        group by 사용시 성능 이슈로 마이그레이션 예제를 통해 마이그레이션해야한다.

- 정렬과 페이징
    - 정렬

        orderBy()

        파라미터로 조건을 하나씩 넣어주면 된다. spread 연산을 허용한다.

    - 페이징

        offset()

        limit()

        두 메서드를 사용하면 끝이다.

    - counting

        Q-Type 변수.count()

        이러면 Q-Type 변수의 id를 기준으로 카운팅을 한다.

        전체를 기준으로 카운팅을 하고싶다면 WildCard.count를 사용한다.

- 집합
    - 집합 결과 데이터, Tuple

        쿼리의 결과가 임의로 만들어진 일명 튜플은 querydsl 자체 패키지에서 지원하는 데이터 객체이다.

        여기서 각 컬럼을 Q-Type 변수의 프로퍼티으로 만들면 이를 키처럼 사용해

        tuple.get(Q-Type 변수의 프로퍼티)

        이렇게 데이터를 꺼낼수 있다.

        그러나 어차피 실무에선 프로젝션을 활용한 DTO로 가져오는 방식을 더 많이 사용한다.

    - groupBy()

        특정 컬럼들을 기준으로 그룹화할 목적으로 사용되는 그룹 함수이다.

        만약 특정 팀의 안에서 직업별 인원수를 알고 싶다면

        groupBy(team.id, job.id)이런식으로 잡고 join도 넣고 하는 것이다.

        각 결과는 team과 job은 1:N관계이므로

        teamA,1,20
        teamA,2,11

        이런식으로 중복되지 않게 마치, pk를 일부로 이렇게 잡은 것과 같은 결과를 반환한다.

        이런식으로 집합(집계)함수와 함께 쓰이는 목적으로 사용되는 함수가 groupBy이다. 이건 DB 쪽에 북마크를 넣어놨으니 같이 보면 좋다.

    - having()

        groupBy 이후 결과에 대한 조건식이다.


### 조인

- 사용법

    첫 번째 파라미터에 조인 대상, 두 번째 파라미터에 별칭으로 사용할 Q 타입 지정

- join()

    join(member.team,team)

    이런식으로 넣는다

- leftJoin()

    left outer join이다. 실무에서 자주 쓴다.

- 세타 조인

    기존 join()을 사용하지 않고 from()내부에 세타 조인할 Q 타입을 나열하면 된다.

    - 예시

        from(member, team)


    on절을 활용하면 left join까지 가능하다

    - on()절 활용시

        from에는 left 기준이 되는 Q타입, left join에는 쑤셔 넣을 대상인 Q타입을 넣고 on절에 조인시 비교할 타입을 정한다.

        그냥 leftJoin(member.team, team) 이렇게 넣으면 Id로 매칭해서 조인하지만 on절을 활용해 leftJoin(team).on(team.name.eq(”team_a”)) 이런식으로 특정 컬럼을 기준으로 넣을 수 있다.

    - 예시코드

        ```java
        // 세타조인 join() 사용 X
        List<Member> members = query.select(member)
                        .from(member, team)
                        .where(member.username.eq(team.name))
                        .fetch();

        // left outer join
        // sql에 id 비교 구문 있음
        List<Tuple> tuples = query.select(member,team)
                        .from(member)
                        .leftJoin(member.team, team)
                        .on(team.name.eq("team_a"))
                        .fetch();

        // 세타조인 leftJoin() + on() 활용
        // sql에 id 비교 구문 없음
        List<Tuple> tuples = query.select(member, team)
                        .from(member)
                        .leftJoin(team)
                        .on(member.username.eq(team.name))
                        .fetch();
        ```

- on()

    leftJoin시 조인할 연관 대상에 필요한 컬럼만 필터링할 조건을 넣는 함수이다.

    - 주의점

        그냥 join()을 사용할때, where()나 on()이나 쿼리 결과는 다를게 없다.

        **외부조인이 필요한 경우에는 on(), 그냥 조인을 쓸 경우에는 where()를 쓰자**

- **Fetch Join**

    join()문뒤에 fetchJoin()을 추가해서 넣어주면 EAGER하게 동작하는 페치 조인이 된다.

    실무에서 많이 쓴다.


### 서브쿼리

`com.querydsl.jpa.JPAExpressions` 이 패키지를 활용해 서브 쿼리를 넣을 수 있다.

- 예시

    ```java
    List<Member> members = query.selectFrom(member)
                    .where(member.age.eq(
                            JPAExpressions.select(subMember1.age.max()).from(subMember1)
                    )).fetch();
    ```

- **주의점**
    1. 네이티브 sql를 작성할때도 마찬가지지 지만 subquery 작성시 alias 충돌을 방지해야한다!!!
    2. static import를 사용해도 된다!
    3. 인라인 뷰 서브쿼리(from절 서브쿼리)는 불가능하다!!!
        - 대안
            1. **서브쿼리를 join으로 변경한다!**

                90% 상황은 이걸로 해결된다!

            2. **서비스레벨에서 쿼리를 2번 실행하고 온 메모리에서 거른다!**
            3. **네이티브 SQL을 사용한다!**

        <aside>
        ⚠️  영한 가라사대… “*중첩적인 인라인 뷰는 보통 90프로 이상이 View에 맞는 데이터 포멧을 한번에 긁어서 맞춰 보내려는 노력 때문에 생긴다”*

        </aside>

        **View에 맞는 포멧은 View단 애플리케이션(ex: SPA나 Presentation 레벨)에서 조절해 직접 바인딩 하도록 협약해야 쿼리에 확장성이 생긴다!**


### 기타 자주 쓰는 문법들

- case 문

    Select절, Where절 사용가능한 조건

    - 단순 조건

        Q-Type 변수의 When 사용

    - 복잡 조건

        CaseBuilder를 사용해 빌더패턴 내부에 조건 삽입

    - 주의점

        거의 쓸일 없다.

- 상수, 문자 더하기
    - 상수

        Expressions.constant()

        이걸 사용하면 된다

    - 문자 더하기

        Q-Type변수의 concat을 사용하면된다.

        - 주의점

            String으로 타입을 맞춰주지 않으면 런타입에러가 난다.

            **concat 대상이 String이 아니면 stringValue()를 꼭 써주자!**


    ### 프로젝션

    - 반환 타입
        - 프로젝션 대상이 하나 인경우

            해당 컬럼의 타입

        - 프로젝션 대상이 둘 이상인 경우

            Tuple

            - 주의점

                Tuple 타입을 Repository 계층을 넘겨서 사용하는 것은 좋은 설계가 아니다. **반드시 특정 타입(DTO)으로 변환을 해서 반환해야한다.**

    - DTO 조회
        - 순수 JPA 사용시
            - DTO의 생성자로만 데이터를 넣을 수 있다.
            - new Operation의 제약 때문에 너무 번거롭다.
        - QueryDsl 사용시
            - 프로퍼티 접근법을 이용한 방법 [Setter]

                Projections.bean()

                파라미터로 DTO 객체 타입, Q 타입의 원하는 프로퍼티들을 나열하면 된다.

            - Fields을 이용한 방법 [Getter, Setter 필요 없다]

                Projections.fields()

                파라미터로 DTO 객체 타입, Q 타입의 원하는 프로퍼티들을 나열하면 된다.

            - Constructor을 이용한 방법 [public 생성자 필요]

                Projections.constructor()

                파라미터로 DTO 객체 타입, Q 타입의 원하는 프로퍼티들을 나열하면 된다. **단, public 생성자 시그니처의 파라미터 타입이 정확히 일치해야한다.**

            - 프로퍼티 접근법과 Fields 활용법의 주의점
                1. DTO 프로퍼티 명과 Q 타입 프로퍼티 명이 다르다면

                    Q-Type 변수.Q-Type 프로퍼티.as(”[DTO 프로퍼티명]”)

                    - 예시 1

                        ```java
                        QMember.member.username.as("name");
                        ```

                    - 서브쿼리 활용시 예시 2

                        ```java
                        ExpressionUtils.as(select(subMember1.age.max()).from(subMember1),"age")
                        ```


                    ExpressionUtils는 서브쿼리, 필드 둘다 적용 가능하다.

            - QueryProjection을 이용한 방법

                Q-Type DTO를 만들어 활용하는 방식

                - 사용법
                    1. DTO 클래스의 public 생성자에 @QueryProjection 어노테이션을 추가한다.
                    2. complieQuerydsl을 돌린다.
                - 장점
                    1. 컴파일 시점에 에러를 확인 할 수 있다.
                    2. 런타임 동작 구조를 확인해보면 실제 DTO 객체의 생성자를 거쳐 실제 DTO 인스턴스까지 제대로 생성이 된다.
                - **주의점**

                    DTO 클래스가 QueryDSL에 의존적으로 변하게 된다.

                    이렇게 되면 **모든 레이어에 걸쳐서 사용하게 되는 DTO가 QueryDSL에 의존하게 된다면 나중에 QueryDSL을 빼게 되는 날이 온다면 큰 문제가 되는 것이다.**

                    만약 QueryDSL의 하부기술들의 변동성이 거의 없을 것으로 판단되고 “이미 프로젝트 전체적으로 QueryDSL에 의존적으로 가져갔으니 의존적으로 만들자” 라고 생각해서 팀 단위로 약속을 했다면 사용해도 좋지만 **이런 전반적인 레이어 전체에 사용되는 객체는 그 만큼 고민을 해서 적용해야한다.**

    - 동적 쿼리 [Dynamic Query]
        - BooleanBuilder 사용
        - **Where 다중 파라미터 사용 [실무 사용 권장]**

            where() 조건에 null이 들어가면 그 조건은 무시되는 점을 이용한 방식

            - 사용법
                1. Predicate를 반환하는 조건 전용 메서드를 만든다.
                2. where문에 들어갈 조건을 넣는다.
                3. 이때 null을 반환하면 무시되게끔 만들면 동적인 쿼리가 완성된다.
            - 장점
                1. where문에 들어갈 조건 재사용성이 극대화된다.
    - 수정, 삭제 벌크 연산
        - 예시

            ```java
            long count = query.update(member)
                            .set(member.username, "비회원")
                            .where(member.age.lt(28))
                            .execute();
            ```

            update 쿼리를 바로 날리는 동작은 execute이다.

        - **주의점**
            1. **영속성 컨텍스트를 거치지 않아 기존의 영속화된 객체에 다시 select로 조회를 해도 변경된 부분은 바뀌지 않는다. 영속성 컨텍스트가 항상 우선권을 가지기 때문이다.**

                ⇒ **이것이 바로 JPA 만의 Repeatable Read 기능이다.**

                **다른 세션(트랜잭션)의 변경, 삭제등의 결과가 현재 세션(트랜잭션)에 반영되지 않는 점을 의미한다.**

                ⇒ **이 점이 데드락을 야기 할 수도 있다. 주의해야한다.**

            2. **update, delete execution 이후엔 항상 영속성 컨텍스트를 flush & clear를 해줘서 비워줘야한다.**
    - SQL Function
        - 사용법
            1. Expressions.stringTemplate를 이용한다
                - 주의점

                    Dialect를 타는 경우에 주로 사용해야하며 이 Dialect에도 없으면 직접 커스텀 Dialect를 구현해서 DB 네이티브 함수를 넣어야한다.

            2. 간단한 경우(ANSI 표준 함수일 경우)면 querydsl이 구현해놓은 함수를 이용하면 된다.

### 스프링 DATA JPA와 함께 사용하기

- 사용법

    커스텀 인터페이스를 만들고 커스텀 구현체를 만든뒤 커스텀 인터페이스를 기존 레포지터리에 추가로 extends한다.

    기존 레포지터리도 인터페이스 이기 때문에 여러개를 상속 받을  수 있기 때문이다.

- **페이징**
    - querydsl과 스프링 DATA JPA 페이징과 연동
        - 사용법
            1. List<DTO>가 아닌 Page<DTO>로 반환하며 Pageable을 추가로 받는 인터페이스를 만든다.
            2. **커스텀 구현체에서 페이징 쿼리, 카운트 쿼리를 둘로 나눠 따로 보낸다.**
            3. **PageableExcutionUtils.getPage()를 반환**해야한다.
            4. 이때 페이징쿼리 결과, Pageable 객체, 카운트쿼리결과를 파라미터로 넣어주며 **카운트 쿼리 결과는 람다로 넘겨야한다.**
        - 주의점

            **sort 정보는 따로 넘겨 직접 적용해야한다**. Pageable의 sort 정보를 전환하는 유틸을 Spring Data JPA가 제공하긴 하지만 그냥 따로 파라미터로 받아서 직접 짜 넣는게 낫다. **조인을 하는 순간 이 유틸이 적용 안되기 때문이다.**

- QuerydslPredicateExecutor

    실무에선 사용할 수 없다. 조인 여러개 들어가면 동작하지 않는다.

- Querydsl Web 지원

    실무에선 사용할 수 없다. 이 기능은 커스텀이 너무 복잡하고 조인이 동작하지 않는다.

- QuerydslRepositorySupport

    실무에서 사용은 가능하나 기존 코드 스타일과 너무 달라지는 문제도 있으며 Sort를 직접해야하기때문에 굳이 사용할 이유는 없다.

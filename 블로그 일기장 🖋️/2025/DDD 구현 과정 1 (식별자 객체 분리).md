# DDD 구현 과정 1

<br><br><br>

## 식별자 객체 분리

&emsp;&emsp;

- 개요
	- 식별자 객체란
	- 식별자 객체를 분리하려는 이유
	- 식별자 객체 분리의 여정 1: 지피티 선생의 오판단
	- 식별자 객체 분리의 여정 2: 시작된 연쇄 구글링
	- 식별자 객체 분리의 여정 3: 분리 결과


<br><br><br>


## 식별자 객체란

&emsp;&emsp;

- 정의
	- 엔티티간 식별을 위해 존재하는 고유한 데이터 객체
- 특징
	- 충돌 내성을 지녀야한다. (고유해야한다는 의미)
	- 엔티티간 구분되는 주요 객체로써 동작한다.
		- 만약 모든 데이터가 동일해도 이 id가 다르면 다른 객체이다.
	- 이 객체는 내부적으로 동등성을 비교할 수 있는 매개체가 반드시 존재해야한다.
	- 주로 JPA에서는 단순히 `@Id`  이 어노테이션으로 표현된다.

<br><br><br>

## 식별자 객체 분리의 필요성

&emsp;&emsp;

- JPA기준 연관관계를 식별자 객체로 풀어내야한다.
	- 연관 관계를 식별자 객체 풀어내야 하는 이유
		- 강결합 문제
			- 주인관계 매핑 구조에는 강력한 강결합 문제를 가지고 있다.
			- 기능과 주인 관계가 점점 더 많아지는 경우 이 강결합 문제는 더 많은 의존성 문제를 야기한다.
				- 강결합 구조를 유지하는 경우 보통 이를 위해 같은 테이블을 기준으로 엔티티를 여러 개를 만들어 해결한다.
				- 여러 개의 엔티티는 당연하게도 여러 유지보수 문제를 야기한다.
					- CQRS 구조에서도 엔티티를 두 종류로 만들 뿐 여러 개로 만들진 않는다.
- 추후 분산 환경에 열린 구조로 만들어야 하는 경우, 빠른 식별자 객체 생성 방식을 채택하기 위해서 분리하는 것이 좋다.
	- 내 주관적인 생각은 이렇다.
		- 결국 아키텍쳐 구조는 다양한 요구조건에 열린 구조를 가져야한다고 생각한다.
		- 초기 MVP에는 DB에 의존적이고, 트랜잭션 스크립트에 의존적이고, 절차지향식으로 짜는 것이 빠르긴 한 것이 맞긴하지만 역으로 분산환경으로 만들어낼 경우 가장 고통스럽다.

<br><br><br>

## 식별자 객체의 분리 여정 1: 지피티 선생의 오판단

&emsp;&emsp;

- 구현시 직면한 문제 1
	-  `@EmbeddedId`와 `@Embeddable`로 분리하고 싶지만 `@GeneratedValue`어노테이션은 함께 사용이 불가능하다.
- 지피티 선생이 제공해준 문제 1의 해결방법
	- AttributeConverter 만들고 Long형 객체를 Id 객체로 변경할 것
- 지피티 선생의 해결방법 적용 결과
	- 문제 발생
- 구현시 직면한 문제 2
	- AttributeConverter를 적용해 값객체로 식별자를 대체하였더니 QueryDSL DTO 프로젝션이 제대로 동작하지 않는다.
- 지피티 선생이 제공해준 문제 2의 해결방법
	- NumberExpression을 사용하거나 따로 RawId를 반환하는 프로퍼티를 하나 만들 것
		- QueryDSL의 DTO 프로젝션의 경우 NumberExpression을 사용하면 제대로 매핑이 되긴하지만 엔티티 객체 자체를 조회하는 경우 변환이 되진 않는다.
			- 이 방식의 경우에는 모든 구현코드를 다 수정해줘야하니 프로퍼티 방식을 채택하였음
		- 프로퍼티의 경우에는 `@Access(AccessType.Property)`와`@Column("pk 컬럼명")`을 추가한 게터를 추가하고 더미용 setter까지 만들어줘야한다.
- 지피티 선생의 해결 방법 
	- 문제 발생
		- AttributeConverter를 적용해 JPA API 레벨에서는 동작하지만, QueryDSL에서는 제대로 엔티티를 제대로 프로젝션하지 못하는 문제가 발생
		- 중복 매핑 문제도 발생중이다.
- 구현시 직면한 문제 3
	- QueryDSL의 DTO 프로젝션을 프로퍼티로 해결해도 엔티티 자체의 프로젝션이 멀쩡히 동작하지 않는다.
	- 중복 매핑이 발생중이다.
- 지피티 선생이 제공해준 문제 3의 해결방법
	- `@Formula`를 적용해볼 것
		- 읽기 전용 매핑으로 변환하는 것이다. 어차피 고유값이니 변환될 일도 없긴하다.
- 지피티 선생의 해결방법 적용 결과
	- 문제 발생
		- 중복 매핑문제도 해결이 안되었고 지피티 선생 본인도 감을 못잡고 아무것도 해결이 되지 않고 있다.
- 내가 판단 내린 결론
	- 일단 구글링을 해보고 문서도 찾아보자

<br><br><br>

## 식별자 객체의 분리 여정 2: 시작된 연쇄 구글링

&emsp;&emsp;

- 내가 발견한 해결 방법 1: @GeneratedValue 연동 문제 관련
	- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#configurations-mapping
	- 구글링을 한 결과 useNewIdGeneratorMappings 이 친구가 JPA 2.0, Hibernate 5.x부터 도입된 친구로 이는 true로 선택이 되어있는데 Id 생성기 매핑 전략을 고르는 플래그 옵션이다.
		- Auto가 기본전략인데, MariaDB나 Mysql에서 native에 맞는 생성 전략을 시도하게 만드는데 사실 기본은 Sequence 전략이다.
		- Sequence가 지원되지 않는 DBMS의 경우 Fallback 매커니즘이 동작하며 Table 생성 전략을 시도하게 된다.
			- Hibernate 6버전 이상에는 이런 설명이 없지만 5.4버전의 경우 설명이 자세히 적혀있다.
		- 따라서 처음에 MariaDB/Mysql의 경우 엔티티 생성을 시도하는 경우 실패하는 이유는 Id 테이블을 명시하지 않았기 때문에 실패하는데 이를 겪어본 사람은 당연히 많을 것이다.
		- 그리고 놀랍게도 지피티 o3-mini 선생은 이 사실을 내가 하나하나 지적해줘야 겨우 본인이 틀렸다는 것을 인정했다.
		- 실제로 지피티 선생이 알려준 방식을 직접해보면 안되는게 생각보다 많다		
- 지피티 선생님에게 제안한 내 해결 방법 1
	- useNewIdGeneratorMappings 이것을 false로 두고 `@EmbeddedId`와 `@Embeddable`로 구현하면 어떤지?
		- 지피티 선생님은 좋다고 말했지만 이것도 구현해보면 불가능하다.
		- `@Embeddable`은 `@GeneratedValue`를 허용하지 않고 있다.
- 내가 직접 찾아본 방식
	- https://discourse.hibernate.org/t/when-generatedvalue-uses-idclass-it-works-and-why-doesnt-it-work-when-using-embeddedid/8730
	- `@IdClass`를 이용하면 `@GeneratedValue` 를 허용하고 있어 이용해볼 수 있다.
	- 위의 레퍼런스에도 찾아보면 나오는 내용이지만 이를 영어로 직접 하이버네이트에 질문한 선배님도 있다.
- 내가 찾아본 해결방법 2: QueryDSL 엔티티 프로젝션 관련
	- 이 결과는 아쉽게도 불가능 판정을 내렸다.
- 내가 생각하기론 이렇다.
	- QueryDSL은 도메인 객체(Entity)를 테이블 그 자체로 바라보려는 성향이 매우 강하다.
		- JPA와 오히려 반대되는 성향이다.
	- JPA는 도메인 객체를 테이블 자체로 바라보지 않고 다양하게 바라볼 수 있도록 지원한다.
		- 여기에 하이버네이트 API를 좀 더 섞는다면 더 다양한 바리에이션을 구현해볼 수 있을 것으로 보인다.
	- 그러므로 동적 쿼리를 잘 짜고 싶지만 DDD는 포기하기 힘든 것이 내 입장이므로 결국 FK 프로퍼티는 자바 기본 레퍼런스타입을 가져가기로 정했다.

<br><br><br>

## 식별자 객체의 분리 여정 3

&emsp;&emsp;

- 시도 1
	- `@IdClass`를 사용하는 방법을 적용해보기로 하였다.
		- 지피티선생님은 원래 두가지 방식이 다 된다고 제안하였고 내가 지적을 하자 매번 말을 바꾸는 전통적인 문제를 다시 보여주셨다.
- 시도 1 결과
	- 잘된다.
- 시도 2
	- FK로 가지는 계정 테이블에서 값 객체를 가지도록 만들었다.
- 시도 2 결과
	- 잘 안된다. 아무리 찾아봐도 FK 관련으로 제대로 지원해주는 방법이 없다.
	- 제대로 지원해주는 것은 `Embeddable` - `Embedded` 관계 뿐이다.

<br><br><br>

## 식별자 객체 분리의 여정 마무리

&emsp;&emsp;

- 아무리 용을 써도 QueryDSL은 DDD에 맞춰서 제대로 쓰기 어렵다.
	- 특히 프로젝션 관련으로는 애매한 부분들이 많다.
	- 결국 엔티티를 하나하나 테이블로 바라보는 것이 기본 컨셉이기 때문에 전통적인 방식과의 공존을 고수하고 싶어 적당히 타협했다.

<br><br><br>

## 규칙 정리

&emsp;&emsp;

- ~~식별자 객체는 `@IdClass`로 빼서 구현 할 것~~
	- ~~만약 추후 식별자 생성 관련 애그리거트나 외부 서비스를 이용한다면 `Embeddable` - `EmbeddedId`로 구현해도 좋다. 이것이 가장 이상적인 구조이다.~~
- ~~실제 Id 값은 Long, 외부에 노출할 프로퍼티(Getter-Setter)는 식별자 객체를 노출해야한다.~~
	- ~~Setter는 private으로 만들어주자.~~
- ~~식별자 객체와 연관관계인 객체는 Long형으로만 두고 연관관계를 걸지 말 것~~
	- ~~DB에서 보장하는 다양한 관계 제약조건을 포기하는 것이지만 이렇지 않으면 애그리거트간 강결합 의존성은 해결하기 힘들다.~~
- ~~`@Id + @CustomSequence(sequenceName = "시퀀스 이름") + 식별자 객체`로 구현한다.~~
	- ~~`@CustomSequence`는 직접 만든 시퀀스로 시퀀스 이름과 Id 객체를 확인하고 처리하는 용으로 사용된다.~~
	- `SimpleJpaRepository<T, ID>`를 implement한 `BaseRepository`를 만들어 모든 save 메서드들을 override한다.
	- 기존 AppConfig에서 JPA 기능을 분리해 JPAConfig 설정 컴포넌트를 따로 만들어 여기에 `@EnableJpaRepositories(basePackages = "com.geekos.littok.v1",repositoryBaseClass = BaseRepository.class)` 이런식으로 구현한다.
		- 이렇게 따로 분리하지 않으면 컨트롤러 테스트시 entityManager 관련 문제가 발생한다. 
		- 시큐리티와 개발하는 경우 제대로 분리를 해야한다.
			- 테스트에 혼선이 발생할 가능성이 높다. 이건 테스트 작성법에서 이어서 설명해보겠다.
- `BaseRepository`에서 활용하기 위해 공통 추상 클래스에 식별자 객체를 공통적으로 추출했다.
	- 공통 추상 클래스에서는 이 객체를 생성할 방법인 `Function<Long, T> idFactory`를 `@Transient`로 만들었다.
	- `private T id;`를 필드로 두고 `@Id @Getter`를 붙여뒀다.
	- 이 공통 추상 클래스의 `protected`생성자와 `idFactory`를 이용해 id를 세팅하는 setter 메서드를 만들었다.
	- `id`를 이용한 `equals`와 `hashCode`를 만들어준다.
	- 마지막으로 이 클래스를 상속받아 사용할 클래스에서는 이 클래스를 상속 받고, `@AttributeOverride(name = "id.value", column = @Column(name = "id 컬럼 명"))` 이 오버라이드 애너테이션을 붙여준다.
	- `super(UserId::new)`이런식으로 생성자마다 `idFactory`를 초기화해준다.
	- 이렇게 구현하면 `BaseRepository`에서 정상적으로 id도 세팅하고 접근할 수 있다.
	- 이 방식으로 시퀀스를 통해 생성하는 식별자를 밖으로 분리하는 작업을 구현했다.


<br><br><br>

## 추가 문제 발생 및 해결 방법


&emsp;&emsp;


### 현재 도메인 엔티티

&emsp;&emsp;

``` java
package com.geekos.littok.v1.app.user.domain.command;

import static java.util.Objects.isNull;
import static org.springframework.util.Assert.state;

import com.geekos.littok.base.LogTable;
import com.geekos.littok.base.AbstractBaseEntity;
import com.geekos.littok.common.exceptions.ErrorMessage;
import com.geekos.littok.common.identifier.UserId;
import com.geekos.littok.common.vo.Email;
import com.geekos.littok.common.identifier.RoleId;
import com.geekos.littok.v1.app.user.adapter.web.dto.UserInfoModifyRequest;
import com.geekos.littok.v1.app.user.domain.vo.AsyncProcessStatus;
import com.geekos.littok.v1.app.user.domain.vo.BirthDate;
import com.geekos.littok.v1.app.user.domain.vo.EmailAuthenticationStatus;
import com.geekos.littok.v1.app.user.domain.vo.Gender;
import com.geekos.littok.v1.app.user.domain.vo.Nickname;
import com.geekos.littok.v1.app.user.domain.vo.ProfileImageLink;
import com.geekos.littok.v1.app.user.domain.vo.UserManageAssignments;
import com.geekos.littok.v1.app.user.domain.vo.UserStatus;
import com.geekos.littok.v1.app.user.domain.vo.Username;

import jakarta.persistence.AttributeOverride;
import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;

import java.time.LocalDateTime;

import lombok.AccessLevel;
import lombok.Getter;

import org.springframework.lang.Nullable;

@Getter
@Entity
@Table(name = "user_tb")
@LogTable(name = "user_log_tb")
@AttributeOverride(name = "id.value", column = @Column(name = "user_id"))
public class User extends AbstractBaseEntity<User, UserId> {

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "profile_img_link"))
    @Nullable
    private ProfileImageLink profileImgLink;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "username"))
    private Username username;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "nickname"))
    private Nickname nickname;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "email"))
    private Email email;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "birth_date"))
    private BirthDate birthDate;

    @Enumerated(EnumType.STRING)
    private UserStatus status;

    @Enumerated(EnumType.STRING)
    private EmailAuthenticationStatus emailAuthenticationStatus;

    @Enumerated(EnumType.STRING)
    private AsyncProcessStatus asyncProcessStatus;

    @Embedded
    @Getter(value = AccessLevel.NONE)
    private UserManageAssignments userManageAssignments;

    protected User() {
        super(UserId::new);
    }

    public User(final UserId userId, final Username username, final Email email, final Gender gender, final ProfileImageLink profileImgLink,
                final Nickname nickname, final UserStatus status, final EmailAuthenticationStatus emailAuthenticationStatus, final AsyncProcessStatus asyncProcessStatus,
                final BirthDate birthDate, final RoleId roleId) {
        super(userId, UserId::new);
        this.username = username;
        this.email = email;
        this.gender = gender;
        this.profileImgLink = profileImgLink;
        this.nickname = nickname;
        this.status = status;
        this.emailAuthenticationStatus = emailAuthenticationStatus;
        this.asyncProcessStatus = asyncProcessStatus;
        this.birthDate = birthDate;
        this.createdBy = 0L;
        this.userManageAssignments = new UserManageAssignments(roleId, createdBy);
        this.createdDate = LocalDateTime.now();
        this.lastModifiedBy = createdBy;
        this.lastModifiedDate = this.createdDate;
    }

    public User(final Username username, final Email email, final Gender gender, final ProfileImageLink profileImgLink,
                final Nickname nickname, final UserStatus status, final BirthDate birthDate, final RoleId roleId) {
        super(UserId::new);
        this.username = username;
        this.email = email;
        this.gender = gender;
        this.profileImgLink = profileImgLink;
        this.nickname = nickname;
        this.status = status;
        this.emailAuthenticationStatus = EmailAuthenticationStatus.NEED_EMAIL_AUTHENTICATION;
        this.asyncProcessStatus = AsyncProcessStatus.IDLE;
        this.birthDate = birthDate;
        this.createdBy = 0L;
        this.userManageAssignments = new UserManageAssignments(roleId, createdBy);
        this.createdDate = LocalDateTime.now();
        this.lastModifiedBy = createdBy;
        this.lastModifiedDate = this.createdDate;
    }
	// ... 이하 도메인 로직
}
```


&emsp;&emsp;

- `@GeneratedValue(strategy = GenerationType.IDENTITY)`는 적용되지 않는다.
	- 이를 위해 `@GeneratedValue(strategy = GenerationType.SEQUENCE)`로 변경해야한다.
	- 즉, 테이블마다 시퀀스를 생성해줘야한다.
	- 테이블마다 시퀀스를 만드는건 큰 단점이지만, 제대로 적용하기 위해서는 시퀀스 세팅을 해줘야한다. (마리아DB 10.3이후 버전에서만 제대로 적용된다.)
		- 마리아 DB의 시퀀스는 다른 DB와 비슷하게 미리 구성해둔 DDL 테이블을 다른 키워드로 등록해둔게 다이긴하다.

&emsp;&emsp;

- `@GeneratedValue(strategy = GenerationType.SEQUENCE)`도 안된다.
	- 정확히는 객체를 생성해서 집어넣는 과정 자체가 안된다.
		- https://docs.jboss.org/hibernate/orm/6.1/userguide/html_single/Hibernate_User_Guide.html#identifiers-composite-generated
		- 이 공식 문서에 나와있듯, 어떤 방식으로도 공식적으로 식별자 객체를 커스텀으로 만드는 경우에는 값을 생성해주는 그 어떤 구현체를 이용해볼 수가 없다.
		- 그리하여 나의 경우에는 레포지터리 자체를 직접 오버라이드해서 해결하였다.
	- 6.x.x버전 기준, `BeforeExecutionGenerator,  AnnotationBasedGenerator<IdGenerator>` 직접 이것들을 구현하여 생성을 해보아도 객체 생성전에 식별자는 삽입되지 않는다.

&emsp;&emsp;

- 모든 값 객체마다 `@AttributeOverride(name = "value", column = @Column(name = "컬럼 명"))`을 적어줘야한다.
	- 모든 값 객체들은 공통 값 객체를 상속받고 이 공통 값 객체에 값을 저장하게 하고 그리고 `BaseRepository`에서는 스냅샷을 저장해야하는 엔티티의 경우에 이 공통 값 객체를 통해 클래스에서 값을 하나씩 꺼내 저장한다.
	- 이렇다 보니 실제로 스냅샷을 저장하지 않는 엔티티까지도 이걸 붙여주고 앉아있는 상태이다.
	- 결론은 스냅샷을 공통적으로 저장하는 로직이 primitive 타입을 다뤄야하니 이 사단이 난 것이다.
	- JSONB를 지원하는 데이터베이스를 따로 사용하거나 다른 로그를 다루는 데이터베이스를 사용했다면 이런 행동은 안해도 된다...
	- Postgresql을 로그용 DB로 만들어두고 매 스냅샷을 json으로 저장한다는 생각을 이땐 하지 못했다.
	- 시간이 있다면 이것을 해주면 코드가 역할 분리가 제대로 되서 보기 좋아질 것이다.
		- 현재 스냅샷 저장도 하는 `BaseRepository`에서는 오직 식별자에 대해서만 책임을 다하게 만드는 것이다.
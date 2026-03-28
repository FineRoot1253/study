# 주의 사항
>[!info]
> 이미 시큐리티는 5버전에서 6버전으로 넘어가면서 대부분 람다식으로 설정 방식이 변경되는 등 약간 격변에 가까운 업데이트를 진행했다.

+ 설명
	+ 스프링 시큐리티나 스프링 관련 프로젝트를 사용할 때에는 다음을 주의해야한다.
		+ 버전업이 됨에 따라 확실하게 관련 언어나 서드파티 라이브러리를 버전업을 하기 시작했다.
		+ 버전업을 이젠 다른 기업 눈치 보지 않고 올리고 있다.
	+ 정리
		+ 스프링 관련 프로젝트 이름 + milestone을 검색해 깃허브에 있는 마일스톤을 확인하면 업데이트 될 프로젝트에서 빠지는 클래스나 추가되는 기능들을 확인할 수 있다.
			+ 언젠가 업데이트를 하지 않으면, 현재의 정리가 분명 레거시가 될것이지만 이 마일스톤을 확인하면서 계속 내용을 업데이트 해가면 문제 없이 학습정도를 유지할 수 있게 된다.


<br><br>


# 목차

1. 초기화 과정 이해
2. 인증 프로세스
3. 인증 아키텍처
4. 인증 상태 영속성
5. 세션 관리
6. 예외 처리
7. 악용 보호
8. 인가 프로세스
9. 인가 아키텍처
10. 이벤트 처리
11. 통합하기
12. 고급 설정
13. 실전 프로젝트


<br><br>


# 초기화 과정 이해

&emsp;&emsp;

## 의존성

``` groovy

dependencies {  
implementation 'org.springframework.boot:spring-boot-starter-security' implementation 'org.springframework.boot:spring-boot-starter-web' testImplementation 'org.springframework.boot:spring-boot-starter-test' testImplementation 'org.springframework.security:spring-security-test'
}

```



<br><br>


## Configuration

&emsp;&emsp;

+ 설명
	+ 서버 기동시 스프링 시큐리티 초기화 작업 및 보안 설정 진행
	+ 별도의 설정, 추가 코딩없이 기초 웹 보안 기능이 현재 시스템에 연동되어 동작하게 된다.
	+ 기본 규칙
		1. 모든 요청에 대해 인증 여부를 검증하고 인증이 승인되어야 자원에 접근 가능
		2. 인증 방식은 폼 로그인, httpBasic 로그인을 제공
		3. 인증을 시도할 수 있는 로그인 페이지가 자동적으로 생성되어 렌더링 됨 (오 이건 좀 편한듯)
		4. 인증 승인이 이뤄질 수 있도록 한 개의 계정이 기본적으로 제공함
			- SecurityProperties 설정 클래스에서 생성된다.
				- username
					- user
				- password
					- 랜덤 문자열
		- 기본 세팅에서 모든 자원 접근은 인증이 승인되어야 접근이 가능하도록 되어있다.
		- SpringBootWebSecurityConfiguration 클래스가 자동 설정에 의한 기본 보안 설정 클래스이다.
			- pdf에는 설정 관련 코드가 적혀있지만 저 코드가 없어도 자동으로 세팅된다는 의미이다.
	- 기본 세팅의 문제점
		- 계정 추가와 권한 추가 불가능
		- 시스템에서 필요하는 세부적이고 추가적인 보안기능 추가 불가능 문제
	- 기본 세팅 추가 정보
		- InMemoryUserDetailManager 클래스에서 유저 정보를 등록하는데 이 매니저 클래스를 UserDetailServiceAutoConfiguration 클래스(설정 클래스)에서 InMemoryUserDetailManager를 빈으로 등록한다.
			- 그래서 자동으로 디비 연동을 안해도 메모리에 유저정보가 딱 하나는 등록되어있는 것이다.
		- 이 세팅은 어노테이션인 ConditionalOnDefaultWebSecurity의 조건이 참이여야 실행된다.
			- 조건 내용
				- SecurityFilterChain, HttpSecurity가 존재하고 SecurityFilterChain 빈이 없어야한다.

&emsp;&emsp;

### SecurityBuilder

&emsp;&emsp;

+ 설명
	+ 역할
		+ 웹 보안을 구성하는 빈 객체, 설정 클래스들을 생성하는 빌더 클래스
	+ 특징
		+ SecurityConfigurer를 참조하고 있으며 인증 및 인가 초기화 작업은 SecurityConfigurer에 의해 진행된다.
			+ 참고로 SecurityConfigurer 구현체는 여러 개를 가지고 있다.
		+ 스코프는 prototype으로 싱글톤이 아니다.
			+ 따라서 **Http가 생성될때마다 생성되고 사라지는 빈 객체**이다.
	+ 대표 구현체
		+ HttpSecurity
		+ WebSecurity
		+ AuthenticationManagerBuilder

&emsp;&emsp;

### SecurityConfigurer

&emsp;&emsp;

- 설명
	- 역할
		- HTTP 요청과 관련된 보안처리를 담당하는 필터들을 생성하고 여러 초기화 설정에 관여한다.
	- 특징
		- 각각의 구현체마다 각각의 필터가 존재하고 이 필터를 통해 상세한 구현을 할 수 있다.
	- 대표 구현체
		- SecurityContextConfigurer
		- HttpBasicConfigurer
		- FormLoginConfigurer
		- CsrfConfigurer
		- ExceptionHandlingConfigurer
		- AnonymousConfigurer

&emsp;&emsp;

### 자동 설정 과정

1. AutoConfiguration에서 build() invoke
2. SecurityBuilder에서 SecurityConfigurer 생성
3. SecurityBuilder에서 init() invoke
4. SecurityConfigurer에서 configure() invoke


- 결론
	- 최종 목적으로 완성되는 클래스는 FilterChainProxy를 생성하는 것이고 이 클래스를 생성하는데 필요한 필수 인자인 SecurityFilterChain 리스트인데, 이건 WebSecurity의 필드인SecurityBuilder 리스트에서 순환하여 build()하여 만들고 이것을 인자로 넘기게 된다.
		- **SecurityBuilder 리스트에서 하나씩 build()하여 만든 체인 리스트를 넘기는 것이다.**

<br><br>


## Security

&emsp;&emsp;

### WebSecurity

&emsp;&emsp;

- 설명
	- 역할
		- WebSecurityConfiguration에서 WebSecurity를 생성하고 초기화를 진행
		- HttpSecurity에서 생성한 SecurityFilterChain 빈을 SecurityBuilder에 저장
		- WebSecurity가 build() invoke시, SecurityBuilder에서 SecurityFilterChain을 꺼내 FilterChainProxy 생성자에게 전달


&emsp;&emsp;

### HttpSecurity

&emsp;&emsp;

- 설명
	- 역할
		- HttpSecurityConfiguration에서 HttpSecurity를 생성하고 초기화를 진행
		- 보안에 필요한 각 설정 클래스와 필터들을 생성하고 최종적으로 SecurityFilterChain 빈을 생성
	- SecurityFilterChain
		- 역할
			- 필터들을 가지고 있는 빈
		- 보유 메서드
			- `boolean matches(HttpServletRequest request)`
				- 설명
					- 요청이 현재 SecurityFilterChain에 의해 처리 가능한지 여부를 결정
					- true의 경우 현재 요청이 지금 필터체인이 처리해야하고 false의 경우 다른 필터 체인이나 처리 로직이 처리해야 함을 의미
					- 이를 통해 특정 요청에 적절한 보안 필터링이 적용될 수 있게 한다.
			- `List<Filter> getFilters()`
				- 설명
					- 현재 SecurityFilterChain에 포함된 Filter 객체의 리스트를 반환한다.
					- 이 메서드를 통해 어떤 필터들이 현재 필터 체인에 포함되어 있는지 확인할 수 있고 각 필터는 요청 처리 과정에서 특정 작업(인증, 권한 부여, 로깅 등)을 수행한다.

<br><br>

## Proxy

&emsp;&emsp;

### Filter

&emsp;&emsp;

- 설명
	- 역할
		- 서블릿 필터는 웹 애플리케이션에서 클라이언트의 요청과 서버의 응답을 가공하거나 검사하는데 사용되는 구성 요소
	- 특징
		- 클라이언트 요청이 서블릿에 도달하기 전이나 서블릿이 응답을 클라이언트에게 보내지 건에 특정 작업을 수행할 수 있다.
			- 이러한 특징으로 인해 Servlet에 도달하기 전에 공격을 방어하기 위해서 Filter에 보안 정책을 설정하는 것이다.
		- WAS에 의해 생성되고 실행되고 종료된다.


&emsp;&emsp;

### DelegatingFilterProxy

&emsp;&emsp;

- 설명
	- 역할
		- 서블릿 컨테이너와 스프링 애플리케이션 컨텍스트 간의 연결고리 역할을 하는 필터
	- 특징
		- 스프링에서 사용되는 특별한 서블릿 필터
		- 서블릿 필터의 기능을 수행함과 동시에 스프링의 의존성 주입 및 빈 관리 기능과 연동되도록 설계된 필터
		- springSecurityFilterChain 이름으로 생성된 빈을 ApplicationContext에서 찾아 요청을 위임함
		- **실제 보안 처리를 수행하지 않는다.**
		- **springSecurityFilterChain 이 빈의 실제 구현체는 FilterChainProxy이다.**
	- 추가 설명
		- 컨테이너는 ServletContainer, Spring IOC Container 두 가지가 존재한다.
		- **Filter는 본래 ServletContainer에서 생성되는 존재이기 때문에 Spring IOC Container에서 생성된 빈과 DI, AOP 기능등을 사용할 수 없다.**
			- 따라서 이를 연동시켜주기 위해서 Spring이 DelegatingFilterProxy를 사용하는 것이다.
	- 실제 동작
		1. 요청이 도착하면 Spring IOC Container에서 springSecurityFilterChain 빈을 찾는다.
		2. springSecurityFilterChain 빈은 필터를 구현하여 해당 요청을 필터 처리를 한다.
			1. 이렇게 함으로써 Spring의 기능을 전부 사용 가능하게 된다.

&emsp;&emsp;

### FilterChainProxy

&emsp;&emsp;

- 설명
	- 역할
		- DelegatingFilterProxy로부터 요청을 위임 받고 보안 처리
	- 특징
		- 실제 빈의 이름은 springSecurityFilterChain이다.
		- 내부적으로 하나 이상의 SecurityFilterChain을 들고 있다.
		- HttpSecurity를 통해 API 추가시, 관련 필터들도 추가된다.
		- 사용자의 요청을 순서대로 호출함으로서 보안 기능을 동작시키고 필요 시 직접 필터를 생서해서 기존의 필터 전, 후로 추가 가능함
<br><br>

## Custom 세팅

&emsp;&emsp;

 - 설명
	 - 특징
		 - 한 개 이상의 SecurityFilterChain 타입의 빈을 정의한 후 인증 API 및 인가 API를 설정한다.
	 - 사용자 추가 설정
		 - 유저를 내가 원하는만큼 설정 클래스나 application.yml 파일에 설정하여 추가할 수 있다.
			 - 단, InMemory에 저장되는 방식이다.
			 - 자바 클래스 방식이 우선순위가 더 높다.

&emsp;&emsp;

- 구현 방법
	1. SecurityConfig 클래스를 만든다.
	2. 이 클래스에 EnableWebSecurity 어노테이션을 선언해준다.
	3. SecurityFilterChain 클래스를 생성하는 빈을 만들어준다.
		1. 참고로 이때 인증과 인가 각각 따로 api를 사용해서 구현해주면 된다.
		2. 그리고 람다 형식으로 만들어야한다. 7부터는 람다만 호환 가능하다.


<br><br>

## 인증 프로세스

&emsp;&emsp;

### FormLogin - formLoin()

&emsp;&emsp;

- 설명
	- 역할
		- 폼 로그인 인증 매커니즘을 활성화하는 API
	- 특징
		- 사용자 인증을 위한 사용자 정의 로그인 페이지를 쉽게 구현할 수 있다.
		- 기본적으로 스프링 시큐리티가 제공하는 기본 로그인 페이지를 사용한다.
			- 사용자 이름, 비밀번호 필드가 포함된 간단한 로그인 양식
		- 사용자는 웹 폼을 통해 자격 증명(사용자 이름과 비밀번호)를 제공하고 SpringSecurity는 HttpServletRequest에서 이 값을 읽고 처리한다.
		- API는 FormLoginConfigurer 설정 클래스를 통해 설정할 수 있다.
			- 내부적으로 UsernamePasswordAuthenticationFilter가 생성되어 폼 방식 인증 처리를 담당한다.
	- 폼 인증 흐름
		1. 권한 검사 필터인 AuthorizationFilter에 접근하여 검사한다.
		2. 권한이 없어 접근 예외인 AceesDeniedException이 발생하면 예외 처리 필터인 ExceptionTranslationFilter로 넘긴다.
		3. 인증 시작을 위해 AuthenticationEntryPoint로 넘긴다. 여기서는 로그인 페이지로 리다이렉트된다.
		4. 이를 통해 유저가 인증을 시도할 수 있는 방법이 마련된다.
	+ api 종류
		+ `loginPage(String path)`
			+ 역할
				+ 사용자 정의 로그인 페이지로 전환
			+ 특징
				+ 기본 로그인 페이지 무시
		+ `loginProcessingUrl(String path)`
			+ 역할
				+ 사용자 이름과 비밀번호 검증 url 지정
			+ 특징
				+ Form Action을 받을 수 있어야 한다.
		+ `defaultSuccessUrl(String path, boolean isAlwaysUse)`
			- 역할
				- 로그인 성공 이후 이동 페이지
			- 특징
				- alwayUse가 참이면 무조건 지정된 위치로 이동한다.
					- default는 false
				- 인증 전에 보안이 필요한 페이지를 방문하게 되면, 인증이 성공한 다음 방금 방문하던 이전 위치로 리다이렉트된다.
		+ `failureUrl(String url)`
			+ 역할
				+ 인증에 실패할 경우 보내지는 url
			+ 특징
				+ 기본값은 '/login?error'이다.
		+ `usernameParameter(String username)`
			+ 역할
				+ 인증 수행시 사용자 이름을 찾기 위해 확인하는 HTTP 매개변수 설정
			+ 특징
				+ 기본값은 username
		+ `passwordParameter(String password)`
			+ 역할
				+ 인증 수행시 비밀번호을 찾기 위해 확인하는 HTTP 매개변수 설정
			+ 특징
				+ 기본값은 password
		+ `failureHandler(AuthenticationFailureHandler)`
			+ 역할
				+ 인증 실패시 사용할 AuthenticationFailureHandler를 등록
			+ 특징
				+ 기본값은 SimpleUrlAuthenticationFailureHandler를 사용해 '/login?error'으로 리다이렉션한다.
		+ `successHandler(AuthenticationSuccessHandler)`
			+ 역할
				+ 인증 성공시 사용할 AuthenticationFailureHandler를 등록
			+ 특징
				+ 기본값은 SavedRequestAwareAuthenticationFailureHandler를 사용한다.
		+ `permitAll()`
			+ 역할
				+ failureUrl(), loginPage(), loginProcessingUrl()에 대한 URL에 모든 사용자의 접근을 허용한다.

&emsp;&emsp;

#### 폼 인증 필터 -  UsernamePasswordAuthenticationFilter

&emsp;&emsp;

- 설명
	- 역할
		- HttpServletRequest에서 제출된 사용자의 이름과 비밀번호로부터 인증을 수행한다.
	- 특징
		- 부모로 AbstractAuthenticationProcessingFilter를 가지는데 이 클래스는 스프링 시큐리티에서 사용자의 자격 증명을 인증하는 기본 필터이다.
		- 인증 프로세스가 초기화 될 때 로그인 페이지와 로그아웃 페이지 생성을 위한 DefaultLoginPageGeneratingFilter 및 DefaultLogoutPageGeneratingFilter가 초기화된다.
	- 인증 실행 흐름
		1. 사용자가 get방식으로 login 요청
		2. UsernamePasswordAuthenticationFilter에서 필터 처리 시작
		3. 요청정보가 매핑되는지 검사
			1. 아니라면 chain.doFilter invoke
		4. 검사 후 인증 구현체인 UsernamePasswordAuthenticationToken 생성, 이때 username과 password를 필수인자로 받음
		5. AuthenticationManager에 UsernamePasswordAuthenticationToken 전달 후 AuthenticationManage이 인증을 수행
			1. 인증 성공시
				1. 인증객체에 또다른 정보를 다시 담기 위해UsernamePasswordAuthenticationToken 생성, 이때 유저정보인 UserDetails와 권한 정보인 Authorities를 필수인자로 받음
				3. SessionAuthenticationStrategy 새로운 로그인을 알리고 세션 관련 작업을 수행함
				4. 인증 상태를 세션에 저장하기 위해 Authentication을 SecurityContext에 설정하고 세션에 SecurityContext가 저장된다. (SecurityContextHolder, DelegatingSecurityContextRepository에 저장됨) 
				5. Remember-me가 설정된 경우, RememberMeServices.loginSucess를 invoke(RememberMeServices)
				6. 인증 성공 이벤트를 게시한다.(ApplicationEventPublisher)
				7. 인증 성공 핸들러를 호출한다. (AuthenticationSuccessHandler)
			2. 인증 실패시
				1. 혹시나 존재하는 기존의 있던 인증 정보를 날리기 위해 SecurityContextHolder가 삭제된다.
				2. 기억하기 기능도 기존에 저장되어있었다면 이를 실패 처리하여 날리기 위해 RememberMeServices.loginFail() invoke (RememberMeServices)
				3. 스프링 시큐리티 예외처리는 따로 존재하지만 인증 실패의 경우에는 인증 필터에서 예외 처리 해야하는데 이를 위해 인증 실패 핸들러 호출 (AuthenticationFailureHandler)

&emsp;&emsp;

### HttpBasic

&emsp;&emsp;

- 설명
	- 특징
		- HTTP 기본 엑세스 제어와 인증을 위한 프레임워크로 제공되는 인증 방식
		- RFC 7235 표준으로 인증 프로토콜은 HTTP 인증 해더에 기술되어 있음
		- HttpBasicConfigurer 설정 클래스를 통해 여러 API들 설정 가능
			- 내부적으로 BasicAuthenticationFilter가 생성되어 기본 인증 방식의 인증 처리를 담당한다.
	- 인증 절차
		1. 클라이언트는 인증 정보 없이 서버로 접속을 시도한다.
		2. 서버가 클라이언트에게 인증요구를 보낼 때 401 Unauthorized 응답과 함께 WWW-Authenticate 해더에 기술해서 realm(보안영역)과 Basic 인증 방법을 보냄
		3. 클라이언트가 서버로 접속할 때 Base64로 username과 password를 인코딩하고 Authorization 헤더에 담아서 요청
		4. 성공적으로 완료시 정상적인 상태 코드를 반환
	- 주의점
		- base 64 인코딩 값은 디코딩이 누구나 가능하므로 인증 정보가 노출되는 방식이므로 반드시 HTTPs와 같이 TLS 기술이 기반이 되어야 하는 방법이다.
			- 따라서 개발단계에서 TLS를 걸지 않은 상태라면 내부망에서만 수행되어야하는 인증 방식이며 개발단계에서 수행하고 싶다면 tls 보안이 우선적으로 선행되어야 한다.
		- 요즘 현업에서는 전혀 사용되지 않는 인증 방식이다.
	- api 종류
		- `realmName(String name)`
			- 역할
				- HTTP 기본 영역을 설정한다.
		- `authenticationEntryPoint(AuthenticationFailureHandler)`
			- 역할
				- 인증 실패시 호출되는 AuthenticationEntryPoint
			- 특징
				- 기본값은 Realm 영역으로 BasicAuthenticationEntryPoint 사용된다.

&emsp;&emsp;

#### BasicAuthenticationFilter

&emsp;&emsp;

- 설명
	- 역할
		- 기본 인증 서비스를 제공하는데 사용된다.
	- 특징
		- BasicAuthenticationConverter를 사용해서 요청 헤더에 기술된 인증정보의 유효성을 체크하며 Base64 인코딩된 username과 password를 추출한다.
		- 인증 이후 세션을 사용하는 경우와 사용하지 않는 경우에 다라 처리되는 흐름에 차이가 있다.
			- 세션을 사용하는 경우 매 요청마다 인증 과정을 거치치 않는다.
			- 세션을 사용하지 않는 경우 매 요청마다 인증과정을 거쳐야한다.(세션 레포가 아닌 RequestAttributeSecurityContextRepository에 저장됨)
		- 요즘 개발 방식에서는 세션을 버리고 JWT에 유저정보를 담는 추세이다.
	- 인증 흐름 과정
		1. 사용자가 로그인을 요청한다.
		2. BasicAuthenticationFilter에 요청이 도달해 요청을 처리한다.
		3. UsernamePasswordAuthenticationToken을 username과 password를 인자로 생성한다.
		4. 인증 처리를 위해 AuthenticationManager에 UsernamePasswordAuthenticationToken를 전달한다.
		5. 인증 성공시 
			1.  전부 기존 폼로그인 방식과 동일하지만 SessionAuthenticationStrategy 저장 및 이벤트 호출은 하지 않고 진행한다.
			2. chain.doFilter를 사용해 계속 로직을 실행한다.
		6. 인증 실패시
			1. 폼로그인 방식과 동일하다.
			2. WWW-Authenticate를 보내도록 AuthenticationEntryPoint를 이용한다.

&emsp;&emsp;

### RememberMe

&emsp;&emsp;

- 설명
	- 역할
		- 웹 사이트나 애플리케이션에 로그인할 때 자동으로 인증 정보를 기억하는 기능
	- 특징
		- UsernamePasswordAuthenticationFilter와 함께 사용된다.
			- AbstractAuthenticationProcessingFilter 슈퍼클래스에서 훅을 통해 구현된다.
		- 인증 성공시 RemeberMeServices.loginSuccess()를 통해 RememberMe 토큰을 생성하고 쿠키로 전달한다.
		- 인증 실패시 RemeberMeServices.loginFail()를 통해 쿠키를 지운다.
		- LogoutFilter와 연계해서 로그아웃 시 쿠키를 지운다.
	- 토큰 생성시 특징
		- 기본적으로 암호화된 토큰으로 생성되어 브라우저에 쿠키를 보내고, 향후 세션에서 이 쿠키를 감지하여 자동 로그인이 이루어지는 방식으로 달성된다.
			- base64(username+":"+expirationTime + ":"+algorithmName + ":" algorithmHex(username+":"+expirationTime +":"+password+":"key))
				- username
					- UserDetailsService로 식별 가능한 사용자 이름
				- password
					- 검색된 UserDetails에 일치하는 비밀번호
				- expirationTime
					- remember-me 토큰이 만료되는 날짜와 시간
					- ms로 표현
				- key
					- remember-me 토큰의 수정을 방지하기 위한 개인 키
				- algorithmName
					- remember-me 토큰 서명을 생성하고 검증하는 데 사용되는 알고리즘
					- default는 SHA-256
	- RemeberMeServices 구현체
		- TokenBasedRememberMeServices
			- 쿠키 기반 토큰의 보안을 위해 해싱을 사용
			- 메모리에 저장된다.
		- PersistentTokenBasedRememberMeServices
			- 생성된 토큰을 저장하기 위해 데이터베이스나 다른 영구 저장 매체를 사용
			- 데이터베이스나 파일에 저장된다.
		- 위 둘다 사용자 정보 검색을 위한 UserDetailsService를 필요로 한다.
	- API 종류
		- `alwaysRemember(boolean alwaysRemember)`  
			- 역할
				- 기억하기 매개 변수 설정이 없어도 쿠키가 항상 있어야하는가? 에 대한 여부
		- `tokenValiditySeconds(int tokenValiditySeconds)`  
			- 역할
				- 토큰이 유효한 시간(초 단위)를 지정할 수 있다.
		- `userDetailsService(UserDetailsService userDetailsService)`  
			- 역할
				- UserDetails를 조회하기 위해 사용되는 UserDetailsService를 지정한다.
		- `rememberMeParameter(String rememberMeParameter)`  
			- 역할
				- 로그인 시 사용자를 기억하기 위해 사용되는 HTTP 매개변수
			- 특징
				- 기본값은 'remember-me'
		- `rememberMeCookieName(String rememberMeCookieName)`  
			- 역할
				- 기억하기(remember-me) 인증을 위한 토큰을 저장하는 쿠키 이름
			- 특징
				- 기본값은 'remember-me'
		- `key(String key)`
			- 역할
				- 기억하기(remember-me) 인증을 위해 생성된 토큰을 식별하는 키를 지정

&emsp;&emsp;

#### RememberMeAuthenticationFilter

&emsp;&emsp;

- 설명
	- 역할
		- SecurityContextHolder에 Authentication이 포함되지 않은 경우 실행되는 필터
	- 특징
		- 세션이 만료되었거나 어플리케이션 종료로 인해 인증 상태가 소멸된 경우 토큰 기반 인증을 사용해 유효성을 검사하고 토큰이 검증되면 자동 로그인 처리를 수행한다.
	- 인증 실행 흐름
		1. 사용자가 user를 요청
		2. 만약 사용자의 세션이 만료되거나 인증상태가 소멸된 경우 RememberMeAuthentication Filter에서 처리 수행
		3. Authentication이 null이 아닌 경우 chain.doFilter invoke
		4. Authentication이 null인 경우
			1. 클라이언트의 쿠키와 서버에 저장된 쿠키를 서로 비교하고 일치하게 되면 최종 인증 토큰을 생성한다. 이때 그 비교를 위해 RemeberMeServices.autoLogin() invoke
			2. UserDetail과 Authorities를 인자로 넘겨 RememberMeAuthenticationToken 생성
			3. AuthenticationManager에 RememberMeAuthenticationToken 전달 후 인증 수행
				1. 인증 성공시
					1. 폼 로그인 인증과 동일하게 수행된다.
				2. 인증 실패시
					1. 폼 로그인 인증과 동일하게 수행된다.
 
&emsp;&emsp;

### Anonymous

&emsp;&emsp;

- 설명
	- 역할
		- 스프링 시큐리티에서 익명으로 인증된 사용자와 인증되지 않은 사용자 간에 실제 개념적 차이는 없으며 단지 엑세스 제어 속성을 구성하는 더 편리한 방법을 제공한다.
	- 특징
		- SecurityContextHolder가 항상 Authentication 객체를 포함하고 null을 포함하지 않는다는 것을 규칙으로 세우게 되면 클래스를 더 견고하게 작성할 수 있다.
		- 인증 사용자와 익명 인증 사용자를 구분해서 어던 기능을 수행하고자 할 때 유용할 수 있으며 익명 인증 객체를 세션에 저장하지 않는다.
		- 익명 인증 사용자의 권한을 별도로 운용할 수 있다.
			- 즉 인증된 사용자는 접근 불가능 하도록 구성도 가능하다.
		- 익명사용자도 마찬가지로 관리를 하겠다는 방식이며 SecurtiyContext에 저장하는 것도 똑같은 흐름을 가진다.
			- 대신 익명의 상태를 굳이 세션에 저장할 필요 자체가 없으므로 세션에 저장하지 않는다.
	- API 종류
		- `principal(Object principal)`
			- 역할
				- 익명 사용자의 이름을 설정
		- `authorities(String... authorities)`
			- 역할
				+ 익명 사용자의 권한을 설정
	+ 스프링 MVC에서 익명 인증 사용하는 경우
		+ 특징
			+ 스프링 MVC에서는 HttpServletRequest에서 getPrincipal()을 사용해 Authentication 객체를 들고 오는데 **요청이 익명이면 null이라 익명 객체 토큰인지 아닌지 타입을 알 수 없다.**
			+ 익명 요청에서 Authentication을 얻고 싶으면 @CurrentSecurityContext 어노테이션을 사용해 SecurityContext 객체를 가져와 꺼내쓰면 된다.
				+ CurrentSecurityContextArgumentResolver에서 요청을 가로채어 처리한다.

&emsp;&emsp;

#### AnonymousAuthenticationFilter

&emsp;&emsp;

+ 설명
	+ 역할
		+ SecurityContextHolder에 Authentication 객체가 없을 경우 감지하고 필요한 한 경우 새로운 Authentication 객체를 저장한다.
	+ 인증 실행 흐름
		1. 유저가 요청을 한다.
		2. 익명인증필터에 도달해 인증 처리를 수행한다.
		3. 만약 Authentication 객체가 null이 아닌 경우 chain.doFilter()를 수행한다.
			1. 만약 Authentication 객체가 null인 경우 익명인증토큰을 생성해 SecurityContext에 설정한다.
			2. SecurityContextHolder에 SecurityContext를 저장한다.

&emsp;&emsp;

### Logout

&emsp;&emsp;

- 설명
	- 특징
		- 스프링 시큐리티는 DefaultPageGeneratingFilter를 통해 로그아웃 페이지를 기본적으로 제공함
			- Get method, /logout url로 접근 가능하다.
		- 로그아웃 실행은 POST method, /logout으로 가능하지만 CSRF 기능을 비활성화하거나, RequestMatcher를 사용하는 경우 Get, Put, Delete method 모두 사용가능하다.
		- 로그아웃 필터를 거치치 않고도 스프링 MVC에서 커스텀하게 구현도 가능하다.
			- 단, 로그아웃 기능도 커스텀하게 구현해야한다.
	- API 종류
		- `logoutUrl(String logoutUrl)`
			- 역할
				- 로그아웃 발생 URL 지정
			- 특징
				- default는 /logout
		- `logoutRequestMatcher(RequestMatcher logoutRequestMatcher)`
			- 역할
				- 로그아웃이 발생하는 RequestMathcher를 지정
			- 특징
				- logoutUrl보다 우선순위가 높다.
				- Method를 지정하지 않으면 logoutURL이 어떤 HTTP method 이던지 요청될 때 로그아웃될 수 있다. 따라서 지정해줘야한다.
		- `logoutSuccessUrl(String logoutSuccessUrl)`
			- 역할
				- 로그아웃이 발생한 후 리다이렉션 될 URL
			- 특징
				- 기본값은 "/login?logout"이다.
		- `logoutSuccessHandler(LogoutSuccessHandler logoutSuccessHandler)`
			- 역할
				- 사용할 LogoutSuccessHandler를 설정한다.
			- 특징
				- logoutSuccessUrl()보다 우선순위가 높다.
		- `deleteCookies(String... cookieNamesToClear)`
			- 역할
				- 로그아웃 성공 시 제거될 쿠키의 이름을 지정
		- `invalidateHttpSession(boolean invalidateHttpSession)`
			- 역할
				- HttpSession을 무효화해야하는 경우 true, 아니면 false
			- 특징
				- default는 true이다. 그래야 로그인 세션 쿠키가 지워지기 때문
		- `clearAuthentication(boolean clearAuthentication)`
			- 역할
				- 로그아웃 시 SecurityContextLogoutHandler가 Authentication을 삭제해야하는지 여부를 명시 한다.
			- 특징
				- default는 true이다. 그래야 기존 인증 객체를 지울 수 있기 때문이다.
				- invalidateHttpSession과 더불어 굳이 손댈 필요는 딱히 없는 메소드이다.
		- `addLogoutHandler(LogoutHandler logoutHandler)`
			- 역할
				- 기존의 로그아웃 핸들러 뒤에 새로운 핸들러를 하나 더 추가한다.
		- `permitAll()`
			- 역할
				- logoutUrl(), RequestMatcher()의 url에 대한 모든 사용자의 접근을 허용함

&emsp;&emsp;

#### LogoutFilter

&emsp;&emsp;

- 설명
	- 실행 흐름
		1. 사용자가 /logout 요청
		2. LogoutFilter는 들어온 사용자의 요청을 처리함
		3. RequestMatcher가 요청 정보를 확인하고 아닐 경우 chain.doFilter를 수행
		4. RequestMatcher의 검사가 맞는 경우 LogoutHandler가 로그아웃 작업을 수행함
			1. 로그아웃 핸들러는 사전에 등록된 여러가지의 핸들러가 차례대로 돌아가면서 수행된다. 즉, 여러 개의 로그아웃 핸들러가 동작하게 된다.
		5. 로그아웃이 성공적이면 LogoutSuccessHandler가 수행됨
			1. 디폴트는 login 페이지로 이동한다.


&emsp;&emsp;

### 요청 캐시

&emsp;&emsp;

#### RequestCache

&emsp;&emsp;

- 설명
	- 역할
		- 인증 절차 문제로 리다이렉트 된 후에 이전에 했던 요청 정보를 담고 있는 SavedRequest 객체를 쿠키 혹은 세션에 저장하고 필요시 다시 가져와 실행하는 캐시 매커니즘
	- API 종류
		- `getRequest(HttpServletRequest, HttpServletResponse)`
			- 역할
				- 현재 SavedRequest를 가져온다.
		- `getMatchingRequest(HttpServletRequest, HttpServletResponse)`
			- 역할
				- 현재 HttpServletRequest를 가져온다.
		- `saveRequest(HttpServletRequest, HttpServletResponse)`
			- 역할
				- 현재 요청을 저장한다.
		- `removeRequest(HttpServletRequest, HttpServletResponse)`
			- 역할
				- 현재 캐시를 삭제한다.
	- 대표적인 구현체
		- HttpSessionRequestCache

&emsp;&emsp;

#### SavedRequest

&emsp;&emsp;

- 설명
	- 역할
		- 로그인과 같은 인증 절차 후 사용자를 인증 이전의 원래 페이지로 안내하며 이전 요청과 관련된 여러 정보를 저장한다.
	- API 종류
		- `getLocales()`
			- 역할
				- 현재 언어를 가져온다.
		- `getMethod()`
			- 역할
				- 현재 요청 방식을 가져온다.
		- `getParameterValues(String)`
			- 역할
				- 현재 파라미터를 들고 온다.
		- `getCookies()`
			- 역할
				- 현재 쿠키를 가져온다.
		- `getParameterMap()`
		- `getRedirectUrl()`
		- `getHeaderValues(String)`
		- `getHeaderNames()`
	- 대표적인 구현체
		- DefaultSavedRequest
	- 캐시 흐름
		1. 유저가 요청을 보냄
		2. 인증을 받지 않았을 경우
			1. HttpSessionRequestCache에 현재 요청을 저장하기 위해 saveRequest() invoke
			2. HttpSession에 DefaultSavedRequest가 인증 이전의 요청 정보를 저장하게 된다.
			3. 로그인 화면으로 리다이렉트한다.
			4. 로그인 화면에서 로그인을 시도하고 성공하는 경우 이를 AuthenticationSuccessHandler가 HttpSessionRequestCache를 통해 리다이렉트할 기존 경로를 받아 리다이렉트한다.
	+ requestCache() API
		- 역할
			- 별도의 RequestCache 구현체를 등록하는 api
		- 특징
			- 요청을 저장하지 않으려면 NullRequestCache를 넣으면 된다.
			-  요청 url에 customParam = y라는 이름의 매개 변수가 있는 경우에만 HttpSession에 저장된 SavedRequest를 꺼내도록 설정하기 위해서 setMatchingRequestParameterName()을 통해 설정할 수 있다.
				- 기본 값은 continue이다.

&emsp;&emsp;

#### RequestCacheAwareFilter

&emsp;&emsp;

- 설명
	- 역할
		- 이전에 저장했던 웹 요청을 다시 불러오는 역할 (저장된 캐시 요청 객체로 바꿔치기를 함)
	- 특징
		- SavedRequest가 현재 Request와 일치하면 이 요청을 필터 체인의 doFilter 메소드에 전달하고 SavedRequest가 없으면 필터는 원래 Request를 그대로 진행시킨다.
	- 캐시 흐름도
		1. 유저가 요청을 한다.
		2. SavedRequest가 쿠키나 세션에 있는지 확인한다.
			1. SavedRequest가 없으면 chain.doFilter invoke
		3. SavedRequest가 쿠키나 세션에 있는 경우 SavedRequest가 현재 Request와 일치하는지 확인한다.
			1. 일치 하지 않으면 chain.doFilter invoke
		4. SavedRequest가 현재 Request와 일치하는 경우 chain.doFilter를 invoke할 때 SavedRequest를 넣고 invoke 한다.


<br><br>


## 인증 아키텍쳐

&emsp;&emsp;

### 핵심 시큐리티 인증 흐름도

1. 사용자가 요청을 보내면 WAS가 요청을 받는다. (Servlet Filter 영역(Servlet Container))
2. DelegatingFilterProxy가 스프링 컨테이너 영역으로 넘겨주기 위해 FilterChainProxy에 있는 SecurityFilterChain로 요청을 넘겨 필터링함 (Servlet Filter 영역(Servlet Container) <-> Spring 영역(SpringContainer))
3. AuthenticationFilter에 도달하면 아이디와 비밀번호를 Authentication 객체에 담아 AuthenticationManager에 인자로 넘긴다. (Spring 영역(SpringContainer))
4. AuthenticationManager에서 컬렉션으로 들어있는 AuthenticationProvider들 중 하나에 인증 처리를 시도하고 인증이 성공하면 유저 데이터, 인증 객체를 만들어 SecurityContext에 저장한다. 이때 유저 데이터는 UserDetailService에서 가져오고 유저 데이터의 비밀번호와 입력한 비밀번호 매칭을 PasswordEncoder를 사용해 시도하여 맞는지 검증한다. (Spring 영역(SpringContainer))

&emsp;&emsp;

### 인증 - Authentication

&emsp;&emsp;

- 설명
	 - 역할
		 - 특정 자원에 접근하려는 사람의 신원을 확인하는 방법
	 - 특징
		 - 사용자 인증 일반적인 방법은 사용자의 이름과 비밀번호를 입력하게 하는 것으로 인증이 수행되면 신원을 알고 권한 부여를 할 수 있다.
		 - Authentication은 사용자의 인증 정보를 저장하는 토큰 개념의 객체로 활용되며 인증 이후 SecurityContext에 저장되어 전역적으로 참조가 가능하다.
		 - Principal을 가지고 있는데 이건 자바에 있는 객체이지 스프링에서 만든 객체가 아니다.
	 - API 종류
		 - `getPrincipal()`
			 - 역할
				 - 인증 주체를 의미하며 인증 요청의 경우 사용자 이름, 인증 후에는 UserDetails 타입의 객체를 의미한다.
		 - `getCredential()`
			 - 역할
				 - 인증 주체가 올바른 것을 증명하는 자격 증명으로 주로 비밀번호를 의미한다.
			 - 특징
				 - 인증 이후에 보안상 null로 두는 경우가 대다수이다.
		 - `getAuthorities()`
			 - 역할
				 - 인증 주체에게 부여된 권한을 나타낸다.
		 - `getDetails()`
			 - 역할
				 - 인증 요청에 대한 추가적인 세부 사항을 저장한다.
			 - 특징
				 - 보통 IP 주소, 인증서 일련 번호 등이 된다.
		 - `isAuthenticated()`
			 - 역할
				 - 인증 상태 반환
		 - `setAuthenciated(boolean)`
			 - 역할
				 - 인증 상태 설정
	 - 인증 절차 상태 흐름
		 1. 유저가 로그인 요청을 보냄
		 2. AuthenticationFilter가 처리함
		 3. Authentication이 만들어짐 (principal: username, cridentials: password, authorities: null, authenticated: false)
		 4. AuthenticationManager가 만들어진 Authentication를 넘겨 받아 인증 처리를 수행한다.
		 5. 기존의 Authentication은 버려지고 Authentication이 다시 만들어진다. (principal: UserDetails, cridentials: null, authorities: ROLL_USER, authenticated:true)
			 1. authorities에는 GrantedAuthority 타입의 컬렉션이다.
		 6. 최종 Authentication을 SecurityContext에 저장한다.


&emsp;&emsp;

### 인증 보안 컨텍스트

&emsp;&emsp;

#### 보안 컨텍스트 구조

- 설명
	- 기본 구조
		- WAS에는 여러 개의 클라이언트가 붙으면 그에 맞는 스레드를 만들게 되고, 인증을 하게 되는 경우 이때 SecurityContextHolder에는 각각의 스레드 별로 ThreadLocal SecurityContext 객체를 만들어 각자 보유하게 만든다.
	- 특징
		- 스레드마다 할당되는 전용 저장소에 SecurityContext가 저장되므로 동시성 문제가 없다.
		- **스레드 풀에서 운용되는 스레드인 경우**, 새로운 요청이더라도 기존의 ThreadLocal이 재사용될 수 있기 때문에 클라이언트로 **응답 직전 항상 SecurityContext를 삭제**하고 있다.

&emsp;&emsp;

#### SecurityContext

&emsp;&emsp;

- 설명
	- 역할
		- 현재 인증된 사용자 정보인 Authentication 객체를 저장한다.
	- 특징
		- SecurityContextHolder를 통해 접근 가능하다.
		- ThreadLocal 저장소를 사용해 각 스레드가 자신만의 보안 컨텍스트를 유지하도록 한다.
		- 애플리케이션 어느 곳에서나 접근 가능하며 현재 사용자의 인증 상태나 권한을 확인하는 데 사용된다.

&emsp;&emsp;

#### SecurityContextHolder

&emsp;&emsp;

- 설명
	- 역할
		- 현재 인증된 사용자 정보인 Authentication 객체를 저장한 SecurityContext 객체를 저장한다.
	- 특징
		- 다양한 저장 전략 지원을 위해 전략 패턴을 이용하므로 SecurityContextHolderStrategy 인터페이스를 사용한다.
		- 기본 전략은 MODE_THREADLOCAL이다.
		- `SecurityContextHolder.setStrategyName(String)` api를 이용해 전략 모드를 직접 지정할 수 있다.
		- `SecurityContextHolder.getContextHolderStrategy().getContext()`를 사용하면 어디에서든 바로 참조 할 수 있다.
		- `SecurityContextHolder.getContextHolderStrategy().clearContext()`를 사용하면 어디서든 바로 삭제할 수 있다.
			- 기존 방식에서는 여러 애플리케이션 컨텍스트에서 전략을 지정하려고 할 때 경쟁 조건이 만들어지는 문제가 존재했기 때문에 위와 같은 방식으로 기존 ContextHolderStrategy를 가져와서 이를 통해 컨텍스트를 저장하게 되면 SecurityContextHolderStrategy를 자동 주입 될 수 있도록 만들었다. 따라서 각 애플리케이션 컨텍스트는 이제 자신에게 가장 적합한 보안 전략을 사용가능하게 되었다.
	- 저장 모드 종류
		- MODE_THREADLOCAL
			- 특징
				- 대부분 서버 환경에 적합하며 각 스레드가 독립적인 보안 컨텍스트를 가진다.
		- MODE_INHERITABLETHREADLOCAL
			- 특징
				- 부모 스레드로부터 자식 스레드로 보안 컨텍스트가 상속되며 작업을 스레드간 분산 실행하는 경우 유용하다.
		- MODE_GLOBAL
			- 특징
				- 전역적으로 단일 보안 컨텍스트만 사용하며 아주 간단한 애플리케이션에만 적합하다.

&emsp;&emsp;

#### SecurityContextHolderStrategy

&emsp;&emsp;

- 설명
	- 구현체 종류
		- ThreadLocalSecurityContextHolderStrategy
		- InheritableThreadLocalSecurityContextHolderStrategy
		- GlobalSecurityContextHolderStrategy
	- API 종류
		- `void clearContext()`
			- 역할
				- 현재 컨텍스트 삭제
		- `SecurityContext getContext()`
			- 역할
				- 현재 컨텍스트 얻기
		- `Supplier<SecurityContext> getDeferredContext()`
			- 역할
				- 현재 컨텍스트를 반환하는 Supplier 얻기
			- 특징
				- 런타임에 사용시 지연하여 받는 효과가 있음
					- 미리 값을 가져와서 메모리를 차지하게 두는 것이 아닌 필요한 순간에만 가져와서 사용하기 위함
		- `void setContext(SecurityContext context)`
			- 역할
				- 현재 컨텍스트를 저장
		- `void setDeferredContext(Supplier<SecurityContext> deferredContext)`
			- 역할
				- 현재 컨텍스트를 반환하는 Supplier를 저장
		- `SecurityContext createEmptyContext()`
			- 역할
				- 새롭고 비어있는 컨텍스트를 생성

&emsp;&emsp;


### 인증 관리자 - AuthenticationManager

&emsp;&emsp;

- 설명
	- 역할
		- 인증 필터로부터 Authentication 객체를 넘겨받아 인증을 시도하고 인증 성공시 사용자 정보, 권한등을 포함한 유저 정보로 채워진 Authentication객체를 반환
	- 특징
		- 여러 AuthenticationProvider를 가지고 있고 이들을 관리한다.
		- 여러 AuthenticationProvider 목록을 순차적으로 순회하며 인증 요청을 처리한다.
		- 여러 AuthenticationProvider 목록 중에서 인증 처리 요건에 맞느 적잘한 AuthenticationProvider를 찾아 인증처리를 위임한다.
		- AuthenticationManagerBuilder에 의해 객체가 생성되며 주로 사용하는 구현체로 ProviderManager가 제공된다.
		- AuthenticationProvider를 추가 변경 하거나 UserDetailsService를 변경하는 등의 작업은 API가 없어서 불가능하고 AuthenticationManagerBuilder를 통해 빌드를 할 때만 가능하다.
		- 각 인증과 매칭되는 AuthenticationProvider는 다음과 같다.
			- Form - DaoAuthenticationProvider
			- HttpBasic - BasicAuthenticationProvider
			- RememberMe - RememberMeAuthenticationProvider
			- OAuth2 - OAuth2AuthenticationProvider
		- 선택적으로 부모 AuthenticationManager를 구성할 수 있고 하위 AuthenticationManager가 처리해내지 못하는 경우 추가적으로 탐색할 수 있다.
		- 일반적으로 AuthenticationProvider로부터 Null이 아닌 응답을 받을 때 까지 차례대로 시도하고 없으면 ProviderNotFoundException을 던져 인증을 실패시킨다.
	- 요청 흐름도
		1. 유저가 인증 요청을 한다.(Form, HttpBasic, RememberMe, Oauth2 등)
		2. AuthenticationManager의 구현체인 ProviderManager가 이에 맞는 AuthenticationProvider를 찾아 인증 처리를 위임한다.
			1. 이때 요청에 맞는 AuthenticationProvider가 없다면 부모격의 ProviderManager를 찾아서 매칭해보고 이때도 없으면 예외를 던진다.

&emsp;&emsp;

#### AuthenticationManagerBuilder

&emsp;&emsp;

- 설명
	- 역할
		- AuthenticationManager 객체를 생성하며 UserDetailsSevice 및 AuthenticationProvider를 추가할 수 있다.
	- 특징
		- `HttpSecurity.getSharedObject(AuthenticationManagerBuilder.class)`를 통해 AuthenticationManagerBuilder 객체를 참조할 수 있다.
			- 저 정적 메서드를 통해서만 해당 객체를 꺼내서 AuthenticationManager를 수정할 수 있다는 의미이다.
		- AuthenticationManagerBuilder의 디폴트로 DaoAuthenticationProvider를 부모 AuthenticationProvider로 가지고, 자식으로는 AnomymousAuthenticationProvider를 가진다.
	- 사용방법 및 주의사항
		- HttpSecurity 방식에서는 `build()`는 한번만 호출해야하고 이후에 `getObject()`로 참조만 해야한다. 이때 해당 커스텀 필터 생성 메서드를 빈으로 등록 할 수 없다.
		- 직접 생성 방식에서는 직접 커스텀 인증 필터를 만들 때 원하는 AuthenticationProvider를 생성하고 컬렉션에 하나씩 추가하여 매니저를 구성하면 된다. 이때는 해당 커스텀 필터 생성 메서드를 빈으로 등록할 수 있다.


&emsp;&emsp;

### 인증 제공자 - AuthenticationProvider

&emsp;&emsp;

- 설명
	- 역할
		- 사용자의 자격 증명을 확인하고 인증 과정을 관리하는 클래스
		- 사용자가 시스템에 엑세스하기 위해 제공한 정보가 유효한지 검증하는 과정을 포함
	- 특징
		- 다양한 유형의 인증 메커니즘을 지원할 수 있다.
		- 성공적인 인증 후에는 Authentication 객체를 반환하여 이 객체에는 사용자의 신원 정보와 인증된 자격 증명을 포함한다.
		- 인증 과정 중에 문제가 발생한 경우 AuthenticationException과 같은 예외를 발생시켜 문제를 알리는 역할을 한다.
	- API 종류
		- `Authentication authentication(Authentication)`
			- 역할
				- AuthenticationManager로부터 Authentication 객체를 전달받아 인증 절차를 수행
		- `boolean supports(Class<?>)`
			- 역할
				- 인증을 수행할 수 있는 Provider인지 확인한다.
	- 인증 수행 흐름도
		1. AuthenticationManager가 자격 증명 제공 정보(아이디, 비밀번호)를 담은Authenication을 전달함
		2. AuthenticationProvider가 Authentication을 전달 받아 `authentication()`invoke
		3. 사용자 유무를 검증한다.
		4. 비밀번호를 검증한다.
		5. 필요하면 보안 강화 처리를 한다.
		6. 3~5번 처리가 성공하면, UserDetails와 Authorities를 담은 Authentication 객체를 AuthenticationManager에게 전달한다.
		7. 3~5번 처리가 실패하면, call stack 상위로 AuthenticationException을 던진다.
	- 사용방법
		- 일반 객체로 생성 하는 방법
			1. securityFilterChain에서 AuthenticationManagerBuilder를 불러 이 객체를 통해 등록하는 방법 
			2. HttpSecurity를 통해서 등록하는 방법 (둘 다 동일하게 동작된다.)
		- 빈으로 생성하는 방법 
			1. AuthenticationManager에 등록할 Provider를 빈으로 등록하게 되면 parent 매니저에 있는 DaoAuthenticationProvider를 자동으로 대체하게 된다. 이와 다르게 아래와 같은 구성도 가능하다.
			2. securitFilterChain 구현시 HttpSecurity 뿐만 아니라 AuthenticationManagerBuilder와 AuthenticationConfiguration까지 3 개를 인자로 구현
			3. http.getSharedObject를 통해 managerBuilder를 불러오고 이곳에 빈으로 등록한 커스텀 AuthenticationBuilder를 등록한다.
			4. configuration에서 ProviderBuilder를 가져온 다음 provider를 비우고 조상 ProviderManager에 원하는 AuthenticationProvider를 등록한다.
	- 주의 사항
		- 빈으로 등록하는 방법에서 2개 이상을 등록하면 이때는 또 parent 매니저에 있는 DaoAuthenticationProvider는 살려두고 하위 매니저에 등록한다.
			- 보통 둘 이상을 등록하지는 않는다. 왠만하면 하나로 해결이 다 가능하기 때문이다.
		- 보통 빈으로 등록하는데 Spring Bean이 가지는 여러 이점들 (PreConstruct, PostConstruct 등)을 이용할 수 있기 때문이다.

&emsp;&emsp;

### 사용자 상세 서비스 - UserDetailsService

&emsp;&emsp;

- 설명
	- 역할
		- 사용자와 관련된 상세 데이터를 로드하여 사용자의 신원, 권한, 자격 증명 등과 같은 정보를 포함할 수 있다.
	- 특징
		- 이 인터페이스를 사용하는 클래스는 보통 AuthenticationProvider이다.
			- 사용자가 시스템에 존재하는지 여부와 사용자 데이터를 검색하고 인증 과정을 수행
	- API 종류
		- `loadUserByUsername(String username) UserDetails`
			- 역할
				- 사용자의 이름을 통해 사용자 데이터를 검색하고 해당 데이터를 UserDetails 객체로 반환한다.
	- 조회 흐름
		1. AuthenticationProvider가 `loadUserByUsername()`을 통해 UserDetails를 조회한다.
		2. UserDetailsService는 UserInfo 객체를 UserRepository로 전달해 DB에서 유저 데이터를 조회한다.
		3. 유저 정보를 찾은 경우, UserDetails를 AuthenticationProvider 스택에 반환
		4. 유저 정보를 못 찾은 경우, UserNotFoundException을 던짐
	- 사용 방법
		- AuthenticationManagerBuilder의 userDetailsService()를 커스텀한 UserDetails를 등록한다.
		- HttpSecurity의 userDetailsService()를 통해 커스텀한 UserDetails를 등록한다.
		- 만약 AuthenticationProvider도 같이 커스텀하고싶다면 AuthenticationProvider에 직접 주입해서 사용하면 된다.
		- AuthenticationProvider를 빈으로 등록할때와 마찬가지로 커스텀UserDetails도 빈으로 등록하면 자동으로 DaoAuthenticationProvider와 같은 AuthenticationProvider에 등록이 된다.
			- 이 방식을 더 많이 사용한다.
			- 실무에서는 UserDetailsService와 AuthenticationProvider를 컴포넌트로 등록하여 서로 연동해서 사용한다.

&emsp;&emsp;

### 사용자 상세 객체 - UserDetails

&emsp;&emsp;

- 설명
	- 역할
		- 사용자의 기본 정보를 저장하는 인터페이스로, Spring Security에서 사용하는 사용자 타입
	- 특징
		- 저장된 사용자 정보는 추후에 인증 절차에서 사용되기 위해 Authentication 객체에 포함되고 구현체로서 User 클래스가 제공된다.
		- **실제 도메인에 저장된 유저관련 데이터는 SpringSecurity가 알 방도가 없으니 UserDetails 인터페이스를 최대한 활용한 객체를 만들어야 한다.**
		- 실무에서는 대게 getter는 전부 구현, isEnable()도 테이블에 활성화 컬럼을 둬서 구현, 나머지는 전부 true를 반환하게 둔다고 한다.
			- 즉, 전부 활용하던 말던 내가 구현하기 나름이라는 것이다.
	- API 종류
		- `boolean isCredentialsNonExpired()`
			- 역할
				- 사용자의 비밀번호가 유효 기간이 지났는지 확인
			- 특징
				- 유효 기간이 지난 비밀번호는 인증할 수 없음
		- `boolean isAccountNonExpired()`
			- 역할
				- 사용자 계정의 유효 기간이 지났는지 확인
			- 특징
				- 기간이 만료된 계정은 인증할 수 없음
		- `String getUsername()`
			- 역할
				- 사용자 인증에 사용된 사용자 이름을 반환
			- 특징
				- NonNull이다.
		- `Collection<GrantedAuthority> getAuthorities()`
			- 역할
				- 사용자에게 부여된 권한을 반환
			- 특징
				- NonNull이다.
		- `boolean isAccountNonLocked()`
			- 역할
				- 사용자가 잠겨 있는지 아닌지를 나타낸다.
			- 특징
				- 잠긴 사용자는 인증할 수 없음
		- `String getPassword()`
			- 역할
				- 사용자 인증에 사용된 비밀번호를 반환
		- `boolean isEnabled()`
			- 역할
				- 사용자가 활성화되었는지 비활성화되었는지 확인
			- 특징
				- 비활성화된 사용자는 인증할 수 없음

<br><br>

## 인증 상태 영속성

&emsp;&emsp;

### SecurityContextRepository

&emsp;&emsp;

- 설명
	- 역할
		- 스프링 시큐리티에서 사용자가 인증을 한 후 요청에 대해 계속 사용자의 인증을 유지하기 위해 사용
	- 특징
		- 인증 상태의 영속 메커니즘은 사용자가 인증을 하게 되면 해당 사용자의 인증 정보와 권한이 SecurityContext에 저장됨
			- 이후 HttpSession을 통해 요청 간 영속이 이뤄진다.
	- 인증 요청 흐름
		1. 사용자가 인증을 요청함
		2. AuthenticationFilter에서 해당 요청을 매칭하여 처리
		3. 중간에 ProviderManger에서 요청 처리 이후 완성된 Authentication 객체를 SecurityContext에 저장
		4. SecurityContext를 SecurityContextRepository에 저장
		5. SecurityContextRepository에서는 SecurityContext를 세션에 저장한다.(HttpSession)
	- 인증 후 요청 흐름
		1. 사용자가 요청을 함
		2. SecurityContextHolderFilter에서 요청을 매칭해 처리
		3. SecurityContextRepository에서 컨텍스트 로드
		4. HttpSession에서 SecurityConetxt를 가져온다.
	- API 종류
		- `containsContext(HttpSevletRequest) boolean`
			- 역할
				- 현재 사용자를 위한 보안 컨텍스트가 저장소에 있는지 여부를 조회
		- `saveContext(SecurityContext, HttpSevletRequest, HttpServletResponse) void`
			- 역할
				- 인증 요청 완료시 보안 컨텍스트를 저장
		- `loadDeferredContext(HttpServletRequest) DeferredSecurityConetext`
			- 역할
				- 로딩을 지연시켜 필요 시점에 SecurityContext를 가지고 옴
	- 대표 구현체
		- HttpSessionSecurityContextRepository
			- 특징
				- 요청 간에 HttpSession에 보안 컨텍스트를 저장한다.
				- 후속 요청에도 컨텍스트 영속성을 유지한다.
		- RequestAttributeSecurityContextRepository
			- 특징
				- ServletRequest에 보안 컨텍스트를 저장한다.
				- 후속 요청시 컨텍스트 영속성을 유지할 수 없음
		- NullSecurityContextRepository
			- 특징
				- 세션을 사용하지 않는 인증(JWT, OAuth2)일 경우 사용하는 구현체
				- 컨텍스트 관련 아무런 처리를 하지 않는다.
		- DelegatingSecurityContextRepository
			- 특징
				- RequestAttributeSecurityContextRepository와 HttpSessionSecurityContextRepository를 동시에 사용할 수 있도록 위임된 클래스
				- 기본 초기화시 기본으로 설정된다.

&emsp;&emsp;

### SecurityContextHolderFilter


&emsp;&emsp;

- 설명
	- 역할
		- SecurityContextRepository를 사용하여 SecurityContext를 얻고 이를 SecurityContextHolder에 설정하는 필터 클래스
	- 특징
		- 요청 처리시 최상위에서 제일 먼저 거치는 필터이다.
			- 이곳에서 SecurityContext를 먼저 캐싱을 해야 그 다음 후순 필터에서 사용할 수 있기 때문이다.
		- `SecurityConetxtRepository.saveContext()`를 강제로 실행시키지 않고 사용자가 명시적으로 호출되어야 SecurityContext를 저장할 수 있는데 이는 SecurityContextPersistenceFilter와는 다르다.
			- ==**이젠 명시적으로 saveContext()를 호출하지 않으면 세션에 저장이 되지 않는다.**== 예전 SecurityContextPersistenceFilter에서는 명시적으로 호출하지 않아도 세션에 저장을 했다고 한다.
		- 인증이 지속되어야 하는지 각 인증 메커니즘이 독립적으로 선택할 수 있게 하여 더 나은 유연성을 제공하고 HttpSession에 필요할 때만 저장함으로써 성능을 향상시킨다.
		- 저장된 SecurityContext를 불러올때 Deferred 방식을 사용한다.
			- 디버깅해서 보는 방법은 복잡하지만 아래에서 설명한 것과 동작은 동일하다.
	- 상황 별 Security 생성, 저장, 삭제
		- 익명 사용자
			- SecurityContextRepository를 사용해 새로운 SecurityContext 객체를 생성해 SecurityContextHolder에 저장 후 다음 필터로 전달
				- **익명 사용자의 경우 무조건 새로 생성해서 넘긴다.**
			- AnonymousAuthenticationFilter에서 AnonymousAuthenticationToken 객체를 SecurityContext에 저장
		- 인증 요청
			- SecurityContextRepository를 사용하여 새로운 SecurityContext 객체를 생성하여 SecurityContextHolder에 저장 후 다음 필터로 전달
			- UsernamePasswordAuthenticationFilter에서 인증 성공 후 SecurityContext에 UsernamePasswordAuthentication 객체를 SecurityContext에 저장
			- SecurityContextRepository를 사용하여 HttpSession에 SecurityContext를 저장
		- 인증 후 요청
			- SecurityContextRepository를 사용하여 HttpSeesion에서 SecurityContext를 꺼내어 SecurityContextHolder에서 저장 후 다음 필터로 전달
			- SecurityContext 안에 Authentication 객체가 존재하면 계속 인증을 유지
		- 클라이언트 응답 시 공통 동작
			- SecurityContextHolder.clearContext()로 컨텍스트를 삭제한다. ==**(스레드 풀의 경우 반드시 필요함)**==
	- 요청 처리 흐름
		1. 사용자가 요청을 함
		2. SecurityContextHolderFilter에서 SecurityContextRepository에서 SecurityContext 객체를 찾는다.
		3. SecurityContextRepository에서 HttpSession을 조회한다.
			1. SecurityConetxt가 존재하면 
				1. SecurityContextHolder에 SecurityContext를 저장킨다.
				2. chain.doFilter() invoke
				3. 요청이 처리되고 나면 컨텍스트는 삭제된다
			2. SecurityContext가 존재하지 않으면
				1. SecurityContextHolder에 새로운 SecurityContext를 생성해 저장한다. (이때 Authentication 필드는 null이다.)
				2. AuthenticationFilter에서 요청을 처리한다.
				3. SecurityContext에 Authentcation을 저장한다. 
				4. SecurityContext를 SecurityContextRepository에 저장한다. (만약 세션에 저장할 필요가 있는 경우에만 진행)
				5. SecurityContextRepository는 HttpSession에 SecurityContext를 저장한다. (만약 세션에 저장할 필요가 있는 경우에만 진행)
	- SecurityContextHolderFilter vs SecurityContextPersistanceFilter
		- SecurityContextHolderFilter
			1. SecurityContextRepository.loadContext()를 호출해 현재 SecurityContext를 로드
			2. SecurityContextHolder에 SecurityContext 저장
			3. 요청 처리
		- SecurityContextPersistanceFilter
			1. SecurityContextRepository.loadContext()를 호출해 현재 SecurityContext를 로드
			2. SecurityContextHolder에 SecurityContext 저장
			3. 요청 처리
			4. SecurityConetxtRepository.saveContext()로 응답 직전에 SecuritContext를 세션에 저장한다.
		+ 추가 설명
			+ 사이드 이펙트 우려가 존재하기 때문에 SecurityContextPersistanceFilter를 deprecate 했다
	+ API 종류
		+ `requireExplicitSave(true)`
			+ 역할
				+ SecurityContext를 명시적으로 저장할 것인지 아닌지 여부
			+ 특징
				+ 기본값은 true
				+ true이면 SecurityContextHolderFilter, false이면 SecurityContextPersistanceFilter
				+ 따라서 커스텀 필터 사용시 명시적으로 false를 해주지 않으면 로그인을 한다고 해도 세션에 저장되지 않는다.
				+ 현재 SecurityContextPersistanceFilter는 레거시 시스템에서만 사용된다.
	+ CustomAuthenticationFilter + SecutiryContextRepository
		+ 커스텀한 인증 필터를 구현할 경우 인증이 완료된 후 SecurityContext를 SecurityContextHolder에 설정한 후 저장하기 위한 코드를 명시적으로 작성해 주어야 한다.
			+ 예시
				+ `securityContextHolderStrategy.setContext(context);`
				+ `securityContextRepository.saveContext(context, request, response);`
		+ securityContextRepository는 HttpSessionSecurityContextRepository 혹은 DelegatingSecurityContextRepository를 사용하면 된다.\
		+ 당연한 이야기 이지만 커스텀 인증 필터클래스는 AbstractAuthenticationProcessingFilter를 직접 구현해야하는 클래스이다.

&emsp;&emsp;

### 스프링 MVC 인증 구현

&emsp;&emsp;

- 설명
	- 특징
		- 스프링 시큐리티 필터에 의존하지 않고 대신 수동으로 사용자를 인증하는 경우 스프링 MVC 컨트롤러 엔드포인트를 사용할 수 있다.
			- 필터는 건너뛰고 컨트롤러에서 처리하는 방식
		- 요청 간에 인증을 저장하고 싶다면 HttpSessionSecurityContextRepository를 사용하여 인증 상태를 저장할 수 있다.
		- **UsernamePasswordAuthenticationFilter가 미리 검증하기 때문에 Post 방식의 특정 컨트롤러를 매핑해놔도 요청이 거부된다.**
			- 따라서 이 필터를 비활성화하거나 추가자체를 하지 말아야한다.
	- 인증 구현 흐름
		1. UsernamePasswordAuthenticationToken.unauthenticated(loginRequest.getUsername(), loginRequest.getPassword()); 사용자 이름, 비밀번호를 담은 Authentication 객체를 생성한다.
		2. authenticationManger.authenticate(token) 주입받은 매니저에게 인증을 요청한다.
		3. SecurityContextHolder.getContextHolderStrategy().createEmptyContext(); 인증 결과를 컨텍스트에 저장한다.
		4. securityContextHodler.getContextHolderStrategy().setContext(securityContext); 컨텍스트를 ThreadLocal에 저장한다.
		5. securityContextRepository.saveContext(securityContext, request, response); 컨텍스트를 세션에 저장해서 인증 상태를 영속한다.(securityContextRepository은 HttpSessionSecurityContextRepository()를 생성해서 주입받았다.)


<br><br>


## 세션 관리

&emsp;&emsp;

### 동시 세션 제어

&emsp;&emsp;

- 설명
	- 정의
		- 사용자가 동시에 여러 세션을 생성하는 것을 관리하는 전략
	- 특징
		- 사용자의 인증 후에 활성화된 세션의 수가 설정된 `maximumSessions` 값과 비교하여 제어 여부를 결정함
		- 같은 유저가 다른 클라이언트를 이용해 여러개의 세션을 가지는 것을 방지하는 것과 같다.
			- 이런 이유로 보통 1개 내지 3개로 제한한다.
		- **`maximumSessions`을 설정해주지 않으면 동시 세션 제어 자체가 기동하지 않는다.**
			- 세팅 자체를 안하게 되면 init 과정중 SessionManagementFilter 생성 함수가 null을 반환하여 생성 자체를 시도하지 않는다.
	- 동시 세션 제어 2가지 유형
		- 사용자 세션 강제 만료
			- 특징
				- 최대 허용 개수만큼 동시 인증이 가능하고 **그 외 이전 사용자의 세션을 만료**시킨다.
		- 사용자 인증 시도 차단
			- 특징
				- 최대 허용 개수만큼 동시 인증이 가능하고 **그외 사용자의 인증 시도를 차단**한다.
	- API 종류
		- `SessionManagementConfigurer<H>.ConcurrencyControlConfigurer maxSessionsPreventsLogin(boolean maxSessionsPreventsLogin)`
			- 역할
				- 동시 세션 제어 유형을 결정한다.
			- 특징
				- true이면 새 인증하는 사용자가 접근 시도시 인증 시도를 차단
				- false이면 새 인증하는 사용자 접근 시도시 기존 사용자의 세션을 만료
		- `SessionManagementConfigurer<H> invalidSessionUrl(String invalidSessionUrl)`
			- 역할
				- 이미 만료된 세션으로 요청하는 사용자를 특정 엔드포인트로 리다이렉션할 URL을 지정한다.
		- `SessionManagementConfigurer<H>.ConcurrencyControlConfigurer expiredUrl(String expiredUrl)`
			- 역할
				- 세션 만료후 리다이렉션할 URL을 지정
		- `SessionManagementConfigurer<H>.ConcurrencyControlConfigurer maximumSessions(int maximumSessions)`
			- 역할
				- 사용자당 최대 세션수를 제어한다.
			- 특징
				- 기본값은 무제한 세션을 허용한다.
	- API 조합에 따른 리다이렉션 전략
		- 제어 전략 종류
			- This session has been expired
				- `maxSessionsPreventsLogin()`
					- false
				- `invalidSessionsUrl()`
					- 설정 혹은 미설정 (단, expiredUrl은 반드시 미설정)
				- `expiredUrl()`
					- 미설정
			- invalidSessionUrl()에 설정된 url로 리다이렉션
				- `maxSessionsPreventsLogin()`
					- false
				- `invalidSessionsUrl()`
					- 설정
				- `expiredUrl()`
					- 설정
			- expiredUrl()에 설정된 URL로 리다이렉션
				- `maxSessionsPreventsLogin()`
					- false
				- `invalidSessionsUrl()`
					- 미설정
				- `expiredUrl()`
					- 설정
			- 인증 차단
				- `maxSessionsPreventsLogin()`
					- true
				- `invalidSessionsUrl()`
					- 설정 혹은 미설정 상관 없음
				- `expiredUrl()`
					- 설정 혹은 미설정 상관 없음
		- 결론
			- 사용자 세션 강제 만료시 리다렉션을 원한다면, expiredUrl() 반드시 제공해야하고 invalidSessionUrl()세션을 같이 적는 경우 invalidSessionUrl()이 더 우선된다.
			- 사용자 세션 강제 만료시 리다이렉션을 원하지 않는다면, expiredUrl()를 제공하지 않으면 된다.
			- 사용자 인증 시도 차단의 경우 설정의 의미가 없다.

&emsp;&emsp;

### 세션 고정 보호

&emsp;&emsp;

- 설명
	- 정의
		- 세션 고정 공격은 악의적인 공격자가 사이트에 접근하여 세션을 생성한 다음 다른 사용자가 같은 세션으로 로그인하도록 유도하는 위험을 말하며 이를 방지하는 방법을 세션 고정 보호라고 부른다.
	- 특징
		- 스프링 시큐리티는 사용자가 로그인할 때 새로운 세션을 생성하거나 세션 ID를 변경함으로써 이러한 공격에 자동으로 대응한다.
	- API 종류
		- `SessionManagementConfigurer<H> changeSessionId()`
			- 역할
				- 기존 세션을 유지하며 세션 ID만 변경하여 인증 과정에서 고정 공격을 방지함
			- 특징
				- 이 api가 기본값임
		- `SessionManagementConfigurer<H> newSession()`
			- 역할
				- 새로운 세션을 생성하고 기존 세션 데이터를 복사하지 않는 방식
			- 특징
				- 단, "SPRING_SECURITY_"로 시작하는 속성은 복사한다.
		- `SessionManagementConfigurer<H> migrateSession()`
			- 역할
				- 새로운 세션을 생성하고 모든 기존 세션 속성을 새 세션으로 복사한다.
		- `SessionManagementConfigurer<H> none()`
			- 역할
				- 기존 세션을 그대로 사용함

&emsp;&emsp;

### 세션 생성 정책

&emsp;&emsp;

- 설명
	- 정의
		- 스프링 시큐리티에서 세션 생성에 대한 정책을 설정할 수 있고 이를 통해 어떻게 세션을 관리할지 결정할 수 있다.
	- 특징
		- SessionCreationPolicy로 설정된다.
	- 세션 생성 정책 전략 종류
		- SessionCreationPolicy.ALWAYS
			- 역할
				- 인증 여부에 상관없이 항상 세션을 생성한다.
			- 특징
				- ForceEagerSessionCreationFilter 클래스를 추가 구성하고 세션을 강제로 생성시킨다.
				- 쓸일이 없다.
		- SessionCreationPolicy.NEVER
			- 역할
				- 스프링 시큐리티가 세션을 생성하지 않지만 애플리케이션이 이미 생성한 세션은 사용할 수 있다.
			- 특징
				- WAS에서 생성한 세션을 사용하겠다는 것이다.
				- 쓸일이 없다.
		- SessionCreationPolicy.IF_REQUIRED
			- 역할
				- 필요한 경우에만 세션을 생성한다.
			- 특징
				- 인증이 필요한 자원에 접근하는 경우를 예시로 들 수 있다.
				- 이 값이 기본값이다.
		- SessionCreationPolicy.STATELESS
			- 역할
				- 세션을 전혀 생성하거나 사용하지 않는다.
			- 특징
				- 인증 필터는 인증 완료 후 SecurityContext를 세션에 저장하지 않으며 JWT와 세션을 사용하지 않는 방식으로 인증을 관리하는 경우 유용할 수 있다.
				- SecurityContextHolderFilter는 세션 단위가 아닌 요청 단위로 항상 새로운 SecurityContext 객체를 생성하므로 컨텍스트 영속성이 유지되지 않는다.
				- 스프링 시큐리티에서 CSRF 기능이 활성화되어 있고 CSRF 기능이 수행 될 경우 세션을 생성된다. 즉, 생성을 전혀 생성되지 않는 것이 아닌 인증을 위한 세션이 생성되지 않는 것이다. 
					- 사용자의 세션을 생성해서 CSRF 토큰을 저장하게 된다.
					- 세션은 생성되지만 CSRF 기능을 위해 사용될 뿐 인증 프로세스의 SecurityContext 영속성에 영향을 끼치지는 않는다.
	- API 종류
		- `SessionManagementConfigurer<H> sessionCreationPolicy(SessionCreationPolicy sessionCreationPolicy)`
			- 역할
				- 세션 생성 정책을 지정한다.


&emsp;&emsp;

### SessionManagementFilter

&emsp;&emsp;

- 설명
	- 역할
		- 요청 시작 이후 사용자가 인증되었는지 감지, 인증된 경우 세션 고정 보호 메커니즘 활성화 혹은 동시 다중 로그인을 확인하는 등의 세션 관련 활동을 수행하기 위해 설정된 세션 인증 전략(SessionAuthenticationStrategy)을 호출하는 필터 클래스
	- 특징
		- 스프링 시큐리티 6 이상에서는 SessionManagementFilter가 기본적으로 설정되지 않고 세션관리 API를 설정을 통해 생성할 수 있다.
	- SessionAuthenticationStrategy 구현체 종류
		- ChangeSessionIdAuthenticationStrategy
			- 역할
				- 세션 아이디 변경
			- 특징
				- 세션 고정 보호에 사용되는 전략클래스 구현체다.
		- ConcurrentSessionControlAuthenticationStrategy
			- 역할
				- 동시 세션 제어
			- 특징
				- 세션 만료, 인증 시도 차단에 사용되는 전략클래스 구현체다.
		- RegisterSessionAuthenticationStrategy
			- 역할
				- 세션 정보 관리
			- 특징
				- 사용자 정보, 인가 정보등을 세션에 등록 및 관리를 담당하는 전략 클래스 구현체다.
		- SessionFixationProtectionStrategy
			- 역할
				- 세션 고정 보호
			- 특징
				- 세션 고정 보호 방법을 정의하는 전략 클래스 구현체이다.
				- ChangeSessionIdAuthenticationStrategy와 사용처는 동일하지만 역할이 다르다.

&emsp;&emsp;

### ConcurrentSessionFilter

&emsp;&emsp;

- 설명
	- 역할
		- 각 요청에 대해 SessionRegistry에서 SessionInformation을 검색하고 세션이 만료로 표시되었는지 확인하고 만료로 표시된 경우 로그아웃 처리를 수행한다.(세션 무효화)
		- 각 요청에 대해 SessionRegistry.refreshLastRequest(String)을 호출하여 등록된 세션들이 항상 **마지막 업데이트** 날짜 시간을 가지도록 한다.
	- 특징
		- 동시 세션 제어에 밀접한 관련이 있는 필터이다.
		- 동시 세션 제어를 위해 검증 및 세션 최신화를 도맡아 처리한다.
		- SessionRegistry를 빈으로 주입받으면 각 계층에서 세션에 대한 정보에 대해 접근할 수 있다.
	- 기초 흐름도
		1. 사용자가 인증 요청을 한다.
		2. SessionManagementFilter가 세션 허용 개수를 초과하는지 검증한다.
		3. 초과하는 경우 기존 사용자의 세션을 만료 시킨다.
		4. 기존 사용자가 다시 재 접속한다.
		5. ConcurrentSessionFilter가 기존 사용자의 세션이 session.isExpired()를 통해 만료되었는지 확인한다.
			1. 만약 만료된 경우 로그아웃 처리한다. 이때, SessionInformationExpiredStrategy가 처리한다.
			2. 만약 만료되지 않는 경우 세션의 날짜/시간을 업데이트 한다.
	+ 인증시 흐름도
		1. 1번 사용자가 인증 요청을 한다.
			1. SessionManagementFilter에서 ConcurrentSessionControlAuthenticationStrategy를 통해 현재 1번 사용자가 동일한 계정으로 로그인하였는지 `session.count()`를 invoke해 확인한다.
			2. ChangeSessionIdAuthenticationStrategy로 세션의 아이디를 바꾼다.
			3. RegisterSessionAuthenticationStrategy로 세션 정보를 등록한다.
		2. 2번 사용자가 1번 사용자와 동일한 계정으로 인증을 시도한다.
			1. SessionManagementFilter에서 ConcurrentSessionControlAuthenticationStrategy를 통해 세션 개수를 확인한다.
				1. 만약 인증 시도 차단 전략인 경우 
					1. ConcurrentSessionControlAuthenticationStrategy를 통해 SessionAuthenticationException을 던지고 차단한다.
				2. 만약 세션 만료 전략인 경우
					1. ConcurrentSessionControlAuthenticationStrategy를 통해 1번 사용자를 만료시킨다. (session.expireNow() invoke)
					2. ChangeSessionIdAuthenticationStrategy로 세션의 아이디를 바꾼다.
					3. RegisterSessionAuthenticationStrategy로 2번 사용자를 세션에 등록한다.
					4. 만약 다시 1번 사용자가 접근시 ConcurrentSessionFilter에서 세션이 만료었는지 검증하고 로그아웃 처리한다.


<br><br>


## 예외 처리

&emsp;&emsp;

- 설명
	- 정의
		- SecurityFilterChain에서 던져진 예외를 처리하는 방법
	- 특징
		- 크게 인증 예외와 인가 예외로 나뉜다.
		- ExceptionTranslationFilter를 통해 예외를 처리하며 사용자의 인증 및 인가 상태에 따라 로그인 재시도, 401, 403 코드 등으로 응답할 수 있다.
	- 예외 클래스 종류
		- AuthenticationException (인증 예외)
			- ExceptionTranslationFilter의 역할
				- SecurityContext에서 인증 정보 삭제
					- 기존의 Authentication이 더 이상 유효하지 않다고 판단해 초기화
				- AuthenticationEntryPoint 호출
					- 인증 실패를 이 과정을 통해 공통적으로 처리할 수 있다.
					- 보통 인증을 시도할 수 있는 화면으로 이동한다.
				- 인증 프로세스의 요청 정보를 저장하고 탐색
					- RequestCache & SavedRequest
						- 인증 프로세스 동안 전달되는 요청을 세션 혹은 쿠키에 저장
					- 사용자가 인증을 완료한 후 요청을 검색하여 재 사용할 수 있다.
						- 기본 구현은 HttpSessionRequestCache이다.
		- AccessDeniedException (인가 예외)
			- ExceptionTranslationFilter의 역할
				- AccessDeniedHandler 호출
					- 필터는 사용자가 익명 사용자인지 여부를 판단하고 익명 사용자인 경우 인증 예외처리를 실행하고 익명사용자가 아닌 경우에 이후 역할을 AccessDeniedHandler에게 위임한다.
					- 익명사용자는 인증이 필요하니 당연히 인증예외를 던져 실행흐름을 돌리는 것이다.



&emsp;&emsp;

### exceptionHandling()

&emsp;&emsp;

- 설명
	- API 종류
		- `ExceptionHandlingConfigurer<H> authenticationEntryPoint(AuthenticationEntryPoint authenticationEntryPoint)`
			- 역할
				- 커스텀하게 사용할 AuthenticationEntryPoint 설정
			- 특징
				- AuthenticationEntryPoint는 인증 프로세스마다 기본적으로 제공되는 클래스들이 설정된다.
					- UsernamePasswordAuthenticationFilter - LoginUrlAuthenticationEntryPoint
					- BasicAuthenticationFilter - BasicAuthenticationEntryPoint
				- 아무런 인증 프로세스가 설정되지 않으면 Http403ForbiddenEntryPoint가 사용된다.
				- 사용자 정의 AuthenticationEntryPoint 구현이 우선순위가 가장 높아 기본 로그인 페이지 생성이 설정되어도 무시된다.
		- `ExceptionHandlingConfigurer<H> accessDeniedHandler(AccessDeniedHandler accessDeniedHandler)`
			- 역할
				- 커스텀하게 사용할 AccessDeniedHandler를 설정
			- 특징
				- AccessDeniedHandler는 기본적으로 AccessDeniedHandlerImple 클래스가 사용된다.

&emsp;&emsp;

### ExceptionTranslationFilter

&emsp;&emsp;

- 설명
	- 특징
		- 이 필터는 오직 AuthorizationFilter에서 발생한 예외를 처리하기 위한 필터이다.
			- 앞에서 발생한 예외는 맨 마지막 앞에 있기 때문에 처리하지 못한다.
		- 내부 구현을 보면 그저 다음 체인으로 요청을 넘기고 있다.
			- 예외처리만 하면 그만인 필터이기 때문이다.
		- 인증, 인가 예외를 처리하기 위해 존재하는 필터이지만 스프링 MVC에서 처리하지 못한 예외까지 다 받을 수는 있다.
			- 다만 처리할려면 인증이나 인가 예외이여야 한다.
	- 처리 흐름
		1. 사용자가 인증을 해야 접근 가능한 경로로 요청을 보냄
		2. AuthorizationFilter가 요청을 처리함, 이때 AuthorizationManager에게 위임한다.
			+ 이 필터는 모든 필터에서 가장 마지막에 위치한다.
			+ 이 필터에서는 인증 예외를 던지지 않고 인가 예외만을 던진다.
		1. 2번 과정중 예외가 발생하였고 ExceptionTranslationFilter가 예외를 처리함
			1. 인가 예외의 경우 익명 사용자이거나 미리 로그인 사용자인지 검증한다.
				1. 만약 익명 사용자이거나 미리 로그인 사용자인 경우 
					1. 인증 예외를 던진다.
				2. 만약 익명 사용자이거나 미리 로그인 사용자가 아닌 경우
					1. 인증된 사용자임으로 AccessDeniedHandler를 호출한다.
					2. 접근 거부 페이지로 리다이렉트한다.
			2. 인증 예외의 경우
				1. 인증 실패 이후의 예외인 경우
					1. 인증 엔트리 포인트에 구현한 로그인 페이지로 리다이렉트한다.
				2. 


<br><br>


## 악용 보호

&emsp;&emsp;

### CORS

&emsp;&emsp;

- 설명
	- 동일 출처 정책 (Same-Origin Policy)
		- 정의
			- 웹에서 보안을 위해 기본적으로 한 웹 페이지(도메인)에서 다른 웹페이지(타 도메인)의 데이터를 불러오는 것을 제한하는 것
		- 특징
			- 만약 다른 출처의 리소스를 안전하게 사용하고자 하는 경우 CORS, Cross Origin Resource Sharing (교차 출처 리소스 공유)가 필요하다.
	- 정의
		- 웹 애플리케이션이 다른 출처의 데이터를 사용하고자 할 때, 브라우저가 그 요청을 대신해서 해당 데이터를 사용해도 되는지 다른 출처에게 물어보는 것
	- 특징
		- 특별한 HTTP 해더를 통해 한 웹 페이지가 다른 출처의 리소스를 접근해도 될지 허가를 구하는 방법이다.
		- 출처를 비교하는 로직은 서버에 구현된 스펙이 아닌 브라우저에 구현된 스펙 기준으로 처리되며 브라우저는 클라이언트의 요청 헤더와 서버의 응답 헤더를 비교해서 최종 응답을 결정한다.
		- 두 개의 출처를 비교하는 방법은 ==**URL의 구성요소 중 Protocol, Host, Port 이 세가지가 동일한지 확인**==하면 되고 나머지는 틀려도 상관없다.
		- A 도메인의 프론트엔드 JS코드가 XMLHttpRequest를 사용해 B 도메인의 리소스에 접근하는 경우 보안상의 이유로 브라우저는 스크립트에서 시작한 교차출처 HTTP 요청을 제한한다.
		- XMLHttpRequest와 Fetch API는 동일 출처 정책을 따르기 때문에 이 API를 사용하는 웹 애플리케이션은 자신의 출처와 동일한 리소스만 불러올 수 있으며, 다른 출처의 리소스를 불러오려면 그 출처에서 올바른 CORS 헤더를 포함한 응답을 반환해야 한다.
	- 종류
		- Simple Request
			- 특징
				- 예비 요청(preflight) 과정 없이 자동으로 CORS가 작동해 서버에 본 요청을 한 후, 서버가 응답의 해더에 Access-Control-Allow-Origin과 같은 값을 전송하면 브라우저가 서로 비교 후 CORS 정책 위반 여부를 검사하는 방식
			- 제약사항
				- 사용가능한 메소드
					- GET, POST, HEAD
				- 사용 가능한 해더
					- Accept
					- Accept-Language
					- Content-Language
					- Content-Type,
					- DPR
					- Downlink
					- Save-Data
					- Viewport-Width Width
				- 사용가능한 Content-Type
					- application/x-www-form-urlencoded
					- multipart/form-data
					- text/plain
		- Preflight Request
			- 특징
				- 브라우저에서는 요청을 한 번에 보내지 않고 예비 요청, 본 요청으로 나누어 서버에 전달하는데 브라우저가 예비요청을 보내는 것을 Preflight라고 하며 메소드는 OPTIONS이다.
			- 예비 요청
				- 역할
					+ 본 요청을 보내기 전에 브로우저 스스로 안전한 요청인지 확인하는 것
				+ 특징
					+ ==**요청 사양이 Simple Request에 해당하지 않을 경우 브라우저가 Preflight Request를 보낸다.**==
						+ 대부분의 경우에 저 제약사항에 걸리기 때문에 이 방식을 사용한다.
					+ 브라우저가 보낸 요청을 보면 Origin에 대한 정보 뿐만 아니라 예비 요청 이후 전송할 본 요청에 대한 다른 정보들도 함께 포함되어 있다.
					+ 브라우저는 예비요청에 Access-Control-Request-Headers 를 사용해 자신이 본 요청에서 Content-type 헤더를 사용할 것을 알려주거나, Access-Control-Request-Method를 사용해 Get 메소드를 사용할 것을 서버에게 미리 알린다.
					+ 서버가 보내준 응답헤더에 포함된 `Access-Control-Allow-Origin: https://도메인명 `의 의미는 해당 URL 외의 다른 출처로 요청할 경우에는 CORS 정책을 위반했다고 판단하고 오류 메시지를 내고 응답을 버리게 된다.
	+ 동일 출처 기준
		+ 특징
			+ 프로토콜(스킴), 호스트, 포트가 동일해야한다.
			+ 단, 포트만 다를 경우는 브라우저마다 다르지만 explorer의 경우 포트 자체를 무시한다고 한다.
	+ 헤더 Access-Control-Allow-x 의 세팅
		+ 정의
			+ CORS 허용을 위해 서버측에서 필요한 헤더 세팅
		+ 종류
			+ Access-Control-Allow-Origin
				+ 역할
					+ 헤더에 작성된 출처만 브라우저가 리소스를 접근할 수 있게 허용
			+ Access-Control-Allow-Methods
				+ 역할
					+ preflight request에 대한 응답으로 실제 요청중에 사용할 수 있는 메서드를 표현
				+ 특징
					+ 기본값은 GET, POST, HEAD, OPTIONS, *
			+ Access-Control-Allow-Headers
				+ 역할
					+ preflight request에 대한 응답으로 실제 요청중에 사용할 수 있는 헤더 필드 이름을 표현
				+ 특징
					+ 기본값은 Origin, Accept, X-Requestd-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, Custom Header, *
			+ Access-Control-Allow-Credentials
				+ 역할
					+ 실제 요청에 쿠키나 인증 등의 사용자 자격 증명이 포함될 수 있음을 표현
				+ 특징
					+ Client의 credentials:include 옵션일 경우 True는 필수이다.
			+ Access-Control-Allow-Age
				+ 역할
					+ preflight 요청 결과를 캐시할 수 있는 시간을 나타내는 것
				+ 특징
					+ 적혀 있는 시간 동안은 preflight 요청을 다시 하지 않게 된다.

&emsp;&emsp;

#### cors()

&emsp;&emsp;

- 설명
	- 특징
		- ==**CORS 사전 요청에는 쿠키(JSESSIONID)가 없기 때문에 Spring Security 이전에 처리되어야한다.**==
			- 사전 요청에 쿠키가 없고 Spring Security가 가장 먼저 처리되면 요청은 사용자가인증 되지 않은 사용자라고 판단하고 거부할 수 있다.
		- 보통 CorsConfigurationSource를 빈으로 등록해서 넣는다.
	- API 종류
		- cors()
			- `CorsConfigurer<H> configurationSource(CorsConfigurationSource configurationSource)`
				- 역할
					- 커스텀하게 사용할 CorsConfigurationSource를 설정한다.
				- 특징
					- 설정하지 않으면 Spring MVC의 CORS 구성을 사용한다.
		- CorsConfiguration
			- `void addAllowedOrigin(@Nullable String origin)`
				- 역할
					- 허용할 출처를 추가
			- `void addAllowedMethod(String method)`
				- 역할
					- 허용할 메소드를 추가
			- `void addAllowedHeader(String allowedHeader)`
				- 역할
					- 허용할 해더를 추가
			- `void setAllowCredentials(@Nullable Boolean allowCredentials)`
				- 역할
					- 자격 증명을 허용할지 말지를 설정
			- `void setMaxAge(@Nullable Long maxAge)`
				- 역할
					- 최대 유효 시간을 초 단위로 설정함
		- UrlasedCorsConfigurationSource
			- `void registerCorsConfiguration(String pattern, CorsConfiguration config)`
				- 역할
					- 어떤 경로에 CORS 정책을 설정할지 결정한다.
		



&emsp;&emsp;


#### CorsFilter

&emsp;&emsp;

- 설명
	- 특징
		- CORS가 먼처 처리 되도록 보통 CorsFilter를 앞단계에 둔다.
		- CorsFilter에 CorsConfigurationSource를 제공함으로 Spring Security와 통합할 수 있다.
		- preflight인지 확인하고 맞으면 그냥 리턴하고(예비요청), 아니면 chain.doFilter() invoke한다.(본요청)

&emsp;&emsp;

### CSRF

&emsp;&emsp;

- 설명
	- 정의
		- 사이트간 요청 위조, 웹 애플리케이션의 보안 취약점으로 공격자가 사용자로 하여금 이미 인증된 다른 사이트에 대해 원치 않는 작업을 수행하게 만드는 기법
	- 공격 흐름
		1. 사용자가 공격 대상 웹 사이트에서 세션 쿠키를 발급받고 인증 받음
		2. 공격자가 공격자 본인의 링크를 사용자에게 전달한다.
		3. 사용자는 공격자의 링크를 클릭해 공격용 웹페이지를 가진다.
			1. 공격용 HTML 페이지는 다음과 같은 이미지 태그를 가진다.
				`<img src=공격 대상 웹 사이트 주소/address=공격자주소>`
			2. 웹 페이지를 열면 브라우저는 이미지 파일을 받기 위해 공격용 URL을 연다.
			3. 사용자의 승인이나 인지 없이 배송지가 공격자의 주소로 등록됨으로써 공격이 완료된다.
	 + Spring Security CSRF 기능 특징
		 + 토큰은 서버에 의해 생성되어 클라이언트의 세션에 저장된다.
		 + 클라이언트에서 폼을 통해 서버로 전송되는 모든 변경 요청에 토큰이 포함되어야 한다.
		 + 서버는 토큰을 검증하여 요청의 유효성을 확인함
		 + 실제 CSRF 토큰이 ==**브라우저에 자동으로 포함되지 않는 요청 부분**==에 위치해야 한다.
			 + ==**HTTP 매개 변수나 헤더(자동으로 포함되지 않는 요청의 파트)**==에 실제 CSRF 토큰을 요구하는 것이 CSRF 공격을 방지하는데 매우 효과적이다.
			 + ==**쿠키(자동으로 포함되는 요청의 파트, 별 효과 없음)**==에 토큰을 요구하는 것은 브라우저가 쿠키를 자동으로 요청에 포함시키기 때문에 효과적이지 않다.
		 + 기본 설정
			 + GET, HEAD, TRACE, OPTIONS 토큰 검사 패스
			 + POST, PUT, DELETE와 같은 변경 요청 메서드에 대해서 CSRF 토큰 검사 수행
			+ 아무 설정 없이 기본 설정만 사용하면 CSRF 토큰을 세션에 저장시킨다.
		+ 토큰 저장 방식
			+ CookieCsrfTokenRepository 
				+ 특징
					+ 쿠키로 저장되지만 **httpOnly가 true로 되어있는 경우에는 js에서 읽어올 수는 없다.**
			+ HttpSessionCsrfTokenRepository
				+ 특징
					+ 이것이 기본값이다.
					+ HTTP 요청 헤더인 `"X-CSRF-TOKEN"` 또는 요청 매개변수인 `"_csrf"`에서 토큰을 읽는다
		+ 토큰 처리 방식
			+ XorCsrfTokenRequestAttributeHandler
				+ 특징
					+ 기본값
					+ 기본적으로 ServletRequest에 저장된 토큰 값을 읽어 토큰의 유효성 비교 및 검증을 해결한다.
					+ 클라이언트의 ==**매 요청마다 CSRF 토큰값에 난수를 인코딩**==하기 때문에 만약 쿠키를 통해 확인한다면 ==**매번 인코딩된 토큰값이 달라지는 것을 확인**==할 수 있지만 이는 ==**원본 값이 달라지는 것이 아님**==을 명심하고 알아야한다.
					+ `setCsrfRequestAttributeName()`이것을 null로 두면 지연 로딩을 위해 함수를 리턴하던 구조를 바로 값을 가져올 수 있도록 할 수 있다.
						+ 이 이름이 null인 경우에는 `csrfToken.getParmeterName()`을 invoke 하여 파라미터 이름을 채워 넣는데 문제는 이때 내부의 init() 메서드가 실행되어 값이 저장된다.
							+ csrfToken은 내부적으로 값이 null이면 생성 메서드를 반환하게끔 되어있지만 이젠 null이 아니기 때문에 값을 반환하는 것이다.
						+ 물론 이걸 쓸 일은 없다고 보면 된다.
			- CsrfTokenRequestAttributeHandler
				- 특징
					- 보호를 위한 XOR 인코딩, 디코딩과 같은 기능은 없고 단순히 토큰의 유효성을 비교및 검증만 한다.
					- XorCsrfTokenRequestAttributeHandler가 CsrfTokenRequestAttributeHandler를 상속받아 구현한 클래스이다.
	 + 동작 흐름
		 1. 사용자가 요청을 보낸다.
		 2. CsrfFilter가 DeferredCsrfToken을 생성하고, requestHandler에 get()메서드를 등록하는데 이름부터 알 수 있듯 생성할 때 초기화를 하지 않고 get() 메서드와 같은 메서드를 사용했을 때에만 생성을 시도한다.(성능을 위해) 따라서 requestHandler에 get()메서드를 등록하는 것으로 invoke를 하지는 않고 이 메서드를 따로 다시 invoke를 하는 경우에만 생성된다.(최대한 지연)
			 1. 이 과정에 request에 `"_csrf"`라는 이름으로 토큰값이 저장되므로 필터를 모두 통과한 Spring MVC 단에서도 이 토큰 값을 꺼내서 사용할 수 있다.
		 3. 요청의 method 종류를 검사한다.
			 1. post, patch 와 같은 수정 method가 아니면 반환한다.
			 2. post, patch 와 같은 수정 method가 이면 다음 검증으로 넘긴다.
		4. 비인증 유저가 들어갈 수 있는 페이지이면 넘어가고 못들어가는 페이지면 인증 검사한다.
			1. 인증 검사가 실패하면 로그인 페이지로 넘긴다.
				+ 이때 로그인 페이지를 Spring Security에 의존하여 생성하는 경우 스프링은 알아서 csrf 토큰을 hiden 태그로 만들어서 넣으며 로그인 시도때 csrf 검증 시 파싱하여 처리한다.
			2. 인증 검사가 통과하면 csrf 검증을 시도한다.
		 5. 생성 했던 DeferredCsrfToken 객체의 메서드인 get()을 호출해 토큰을 생성한다.
			 1. 실제 내부에서는 지연 로딩이 3겹이상 쌓여있는데 그게 전부 실행되는 구조이다.
			 2. 생성 전에 세션에 존재하는지 먼저 로딩을 해보고 없으면 생성하는 구조이다.
			 3. 생성시 UUID를 사용해 생성하며 이 값이 나중에 쿠키로도 사용된다.
				 1.  실제로 클라이언트에게 저장을 한다면 Xor 연산을 통해 인코딩한다.
			 4. 생성 후 세션에 저장한다.
		6. csrf 인증을 위해 실제 요청에 존재하는 csrf 토큰을 꺼낸다.
			1. 실제 csrf 토큰이 존재하지 않으면 403 예외를 던진다.
			2. 실제 csrf 토큰이 존재하면 5번 과정에 꺼낸 csrf와 토큰을 비교한다.
				1. 비교 후 같지 않으면 접근을 거부하기 위해 accessDeniedHandler에게 요청과 던질 예외를 넘겨준다.
				2. 비교 후 같으면 filterChain.doFilter() invoke 하여 다음 필터에게 요청을 넘겨 통과한다.
	 + API 종류
		 + `HttpSecurity http, http.csrf(Customizor.withDefault())`
			 + 역할
				 + csrf 기능을 활성화
			 + 특징
				 + 활성화를 굳이 하지 않아도 자동으로 활성화 된다.
		 + `HttpSecurity http, http.csrf(csrf -> csrf.disabled())`
			 + 역할
				 + csrf 기능을 비활성화 할 수 있다.
			 + 특징
				 + 쿠키나 세션을 사용하지 않는 곳에서 주로 사용하는 방식이다.
				+ 왠만하면 거의 사용하지 않는 기능이다.
		 + `HttpSecurity http, http.csrf(csrf -> csrf.ignoringRequestMathchers("/api/*")`
			 + 역할
				 + csrf 보호가 필요하지 않는 특정 엔드포인트만 비활성화 할 수 있다.

&emsp;&emsp;

#### HTML Forms

&emsp;&emsp;

- 설명
	- 정의
		- CSRF 토큰을 HTML 폼에 담아서 서버에 제출 하는 방법
	- 특징
		- hidden 값으로 Form에 포함시켜야함
	- 폼에 실제 csrf 토큰을 자동으로 포함하는 뷰 종류
		- Thymeleaf
			- 대부분 어차피 타임리프를 쓰기 때문에 타임리프를 쓰면 아래의 예시 구성을 직접해줄 필요는 없어서 신경을 꺼도 좋다.
		- Spring의 폼 태그 라이브러리 - `<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>`
	- 예시
		- 실제 구성
			- `<form action="/memberJoin" method="post">\/<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>\/</form>`
		- 구성 결과
			- `<input type="hidden" name="_csrf value="4h4kjh4uhasdf331jg"/>`

&emsp;&emsp;

#### JavaScript Application

&emsp;&emsp;

- 설명
	- Single Page Application
		- 구현 방식
			- CookieCsrfTokenRepository.withHttpOnlyFalse를 사용해 클라이언트가 서버가 발행한 쿠키로부터 토큰을 읽게 하기
			- 사용자 정의 CsrfTokenRequestHandler를 만들어 클라이언트가 요청 헤더나 요청 파라미터로 CSRF 토큰을 제출할 경우 이를 검증하게 하기
			- 클라이언트의 요청에 대해 CSRF 토큰을 쿠키에 렌더링해서 응답할 수 있도록 필터를 구현하기
				- 특징
					- 굳이 직접 구현을 하지 않아도 CookieCsrfTokenRepository 이걸로 세팅만해도 기본적으로 쿠키에 렌더링해서 응답을 한다.
	- Multi Page Application
		- 특징
			- JavaScript가 각 페이지에서 로드되는 멀티 페이지 애플리케이션의 경우 CSRF 토큰을 쿠키에 노출시키는 대신 HTML 메타 태그 내에 CSRF 토큰을 포함시킬 수 있다.
		- 구현 방식
			- HTML 메타 태그에 CSRF 토큰 포함
				- 예시
					- `<meta name="_csrf" th:content="${_csrf.token}"/>`
					- `<meta name="_csrf_header" th:content="${_csrf.headerName}"/>`
			- AJAX 요청에서 CSRF 토큰 포함
				- 예시
					- ``` function login(){ fetch('/api/login', {method:'POST', headers:{[csrfHeader]:$('meta[name="_csrf"]').attr('content')}}) }```



&emsp;&emsp;

### SameSite

&emsp;&emsp;

- 설명
	- 정의
		- 서버가 쿠키를 설정할 때 SameSite 속성을 지정하여 크로스 사이트 간 쿠키 전송에 대한 제어를 핸들링하는 최신 CSRF 공격 방어 방법
	- 특징
		- Spring Security는 세션 쿠키의 생성을 직접 제어하지 않기 때문에 SameSite 속성에 대한 지원을 제공하지 않지만 Spring Session은 SameSite 속성을 지원한다.
		- CSRF 공격 흐름에서 공격자가 이미지 태그에 본인의 주소를 넣어 주문을 하게끔 공격을 해도 method가 post이면, samesite 규칙에 의해 막히게 된다.
			- 이런 구조로 CSRF 공격을 방어한다.
		- 오래된 브라우저는 지원 안할 수도 있다.
		- 유일한 방어 수단이 아닌 추가 보완 대책이라고 보면 된다.
		- spring-session을 당연히 의존성을 추가해야한다.
			- CookieSerializer를 빈으로 등록해야하며 이 는 SessionRepository 빈을 주입받는 구조로 되어있다.
	- 속성 종류 및 특징
		- Strict
			- 정의
				- 동일한 사이트에서 오는 모든 요청에 쿠키가 포함되고 크로스 사이트간 HTTP 요청에 쿠키가 포함되지 않는다.
		- Lax
			- 정의
				- 동일 사이트에서 오거나 Top Level Navigation에서 오는 요청 및 메소드가 읽기 전용인 경우 쿠키가 전송되고 그렇지 않으면 HTTP 요청에 쿠키가 포함되지 않는다.
			- 특징
				- 사용자가 링크를 클릭하거나(a 태그) window.location.replace, 302 리다이렉트 등의 이동을 포함한다.
				- iframe, img를 문서에 삽입, ajax 통신 등은 쿠키가 전송되지 않는다.
		- None
			- 정의
				- 동일 사이트 및 크로스 사이트 요청에도 쿠키가 전송된다.
			- 특징
				- 단, HTTPS에 의한 secure 쿠키로 설정되어야 한다.
	- API 종류
		- DefaultCookieSerializer
			- `setUseSecureCookie(true)`
				- 역할
					- HTTPS의 보호를 받는 쿠키를 설정한다.
			- `setUseHttpOnlyCookie(true)`
				- 역할
					- HTTP만 사용하는 쿠키로 설정한다.
			- `setSameSite("Lax")`
				- 역할
					- SameSite의 속성을 설정한다.

<br><br>

## 인가 프로세스

&emsp;&emsp;

### 요청 기반 권한 부여

&emsp;&emsp;

- 설명
	- 특징
		- `HttpSecurity.authorizeHttpRequests()`가 대표적인 api이다.
		- 권한 부여는 Request Base Authorization, Method Based Authorization 둘로 나뉜다.
		- 요청 기반 권한 부여는 클라이언트의 요청, 즉 HttpServletRequest에 대한 권한 부여를 모델링하는 것이며 이를 위해 HttpSecurity 인스턴스를 사용하여 권한 규칙을 선언할 수 있다.
		- ==**스프링 시큐리티는 클라이언트의 요청에 대해 위에서부터 아래로 나열된 순서대로 처리하며 요청에 첫번째 일치만 적용되고 다음순서로 넘어가지 않는다.**==
			- 넓은 범위를 만약 먼저 적용한다면 좁은 범위는 검사 자체가 되지 않기 때문에 ==**반드시 좁은 범위를 먼저 설정하고 넓은 범위를 나중에 설정해야한다!!**==
	- API 종류
		- HttpSecurity
			- `authorizeHttpRequests()`
				- 역할
					- 사용자의 자원 접근을 위한 요청 엔드포인트와 접근에 필요한 권한을 매핑시키기 위한 규칙을 설정하는 것
				- 특징
					- 서블릿 기반 엔드포인트에 접근하려면 `authorizeHttpRequests()` 에 해당 규칙들을 포함해야한다.
					- `authorizeHttpRequests()`을 통해 요청과 권한 규칙이 설정되면 내부적으로 AuthorizationFilter가 요청에 대한 권한 검사 및 승인 작업을 수행한다.
			- `requestMatchers()`
				- 역할
					- HTTP 요청의 URI 패턴, HTTP 메소드, 요청 파라미터등을 기반으로 어떤 요청에 대해서는 특정 보안 설정을 적용하고 다른 요청에 대해서는 적용하지 않도록 세밀하게 제어할 수 있다.
				- 특징
					- 특정 경로에만 CSRF 보호를 적용하거나 특정 경로에 대해 인증을 요구하지 않게끔 설정할 수 있다.
					- 이를 통해 애플리케이션의 보안 요구사항에 맞춰 유연한 보안 정책을 구성할 수 있다.
					- 엔드 포인트 특징으로 ant 패턴, 정규 표현식을 사용할 수 있다.
				- 기본 규칙
					- 엔드 포인트와 `hasRole()`을 이용해 권한 규칙을 설정
					- 엔드 포인트와 hasAuthority를 이용해 권한을 설정
					- 엔드 포인트와 hasAnyAuthority를 이용해 복수 개의 권한을 설정
				- 파라미터 별 동작 차이
					- 문자열 배열
						- 보호가 필요한 자원 경로를 한 개 이상 정의한다.
					- RequestMatcher 배열
						- 보호가 필요한 자원 경로를 한 개 이상 정의한다.
						- AntPathRequestMatcher, MvcRequestMatcher등의 구현체 사용 가능
						- ==**MvcRequestMatcher를 사용하기 위해서는 HandlerMappingIntrospector를 주입받아서 사용**==해야한다.
					- HttpMethod, 문자열 배열
						- Http 메소드와 보호가 필요한 자원 경로를 한 개 이상 정의한다.
	- 권한 규칙 종류
		- API
			- authenticated
				- 역할
					- 인증된 사용자의 접근을 허용
			- fullyAuthenticated
				- 역할
					- 아이디와 패드워드로 인증된 사용자의 접근을 허용 (rememberMe 인증은 제외)
			- anonymous
				- 역할
					- 익명사용자의 접근을 허용
			- rememberMe
				- 역할
					- 기억하기를 통해 인증된 사용자의 접근을 허용
			- permitAll
				- 역할
					- 요청에 승인이 필요하지 않는 공개 엔드포인트이며 세션에서 Authentication을 검색하지 않음
			- denyAll
				- 역할
					- 요청은 어떠한 경우에도 허용되지 않으며 세션에서 Authentication을 검색하지 않음
			- access
				- 역할
					- 요청이 사용자 정의 AuthorizationManager를 엑세스를 결정 (표현식 문법 사용)
			- hasAuthority
				- 역할
					- 사용자의 Authentication에는 지정된 권한과 일치하는 GrantedAuthority가 있어야한다.
			- hasRole
				- 역할
					- hasAuthority의 단축키로 ROLE_ 또는 기본접두사로 구성된다.
				- 특징
					- ==**ROLE_을 제외해야한다**==.
			- hasAnyAuthority
				- 사용자의 Authentication에는 지정된 권한들 중 하나의 일치하는 GrantedAuthority가 있어야한다.
			- hasAnyRole
				- 역할
					- hasAnyAuthority의 단축키로 ROLE_ 또는 기본접두사로 구성된다.
				- 특징
					- ==**ROLE_을 제외해야한다.**==

&emsp;&emsp;

#### 표현식 및 커스텀 권한 구현

&emsp;&emsp;

- 설명
	- WebExpressionAuthorizationManager
		- 역할
			- 스프링 시큐리티에서 표현식을 사용해 권한 규칙을 설정
		- 특징
			- 표현식은 시큐리티가 제공하는 권한 규칙을 사용하거나 사용자가 표현식을 커스텀하게 구현해서 설정 가능
			- `requestMathers()`의 `access()`로 사용해서 설정가능하다.
			- `requestMatchers("/resource/{name}").access(new  WebExpressionAuthorizationManager("#name==authentication.name"))`
				- 특징
					- 요청으로부터 값을 추출할 수 있음
					- 현재 경로의 name과 인증 객체의 name이 일치해야 접근 가능하다는 의미이다.
					- 인텔리제이에서 자동으로 인식되서 편하게 사용가능
			- `requestMatchers("/resource/db").access(new  WebExpressionAuthorizationManager("hasAuthority('DB') or hasRole('ADMIN')"))`
				- 특징
					- 여러개의 권한 규칙을 조합할 수 있음
					- `requestMatchers("/admin/db").access(anyOf(hasAuthority('DB'),  hasRole('ADMIN')))` 이것과 세팅은 같은 세팅이다.
					- DB의 권한이 있던지, 관리자 역할을 한다면 접근이 가능하다는 의미이다.
	- 커스텀 권한 표현식 구현 방법
		1. SecurityFilterChain 빈에서 ApplicationContext를 파라미터로 주입받는다.
		2. DefaultHttpSecurityExpressionHandler()를 생성하고 주입받은 ApplicationContext를 세팅한다.
		3. WebExpressionAuthorizationManager에 빈 이름 + 빈의 메서드 조합으로 접근 제어 로직을 수행하는 로직을 집어 넣는다.
			1. 예시 "@customWebSecurity.check(authentication, request)" (빈 이름이 정의 되면 인텔리제이에서 바로 미리보여준다.) 
			2. customWebSecurity의 이름을 가지는 컴포넌트 클래스에 check의 메서드를 구현해둔다.
		4. 3번 흐름에서 구현한 WebExpressionAuthorizationManager에 DefaultHttpSecurityExpressionHandler를 세팅한다.
		5. WebExpressionAuthorizationManager를 원하는 경로에 세팅한다.
	- 커스텀 RequestMatcher 구현
		1. RequestMatcher 인터페이스를 오버라이딩하는 커스텀 구현체를 만든다.
		2. `requsetMatchers()`에 파라미터로 커스텀 구현체를 생성해 넘긴다.
	+ RequestMatcher API 종류
		+ `MatcherResult matcher(HttpServletRequest)`
			+ 특징
				+ 디폴트 메서드라 구현이 필수는 아니다.
		+ `boolean matches(HttpServletRequest)`

&emsp;&emsp;

#### HttpSecurity.securityMatcher(), securityMatchers() 

&emsp;&emsp;

- 설명
	- 역할
		- 특정 패턴에 해당하는 요청에만 보안 규칙을 적용하도록 설정한다. 
	- 특징
		- 중복으로 정의할 경우 마지막에 설정한 것으로 대체한다.
		- 문자열 배열 혹은 RequestMatcher 배열 두 가지 메서드로 오버로딩 되어있다.
			- 둘 다 특정 자원의 보호가 필요한 경로를 정의하며 AntPathRequestMatcher, MvcRequestMatcher 등 의 구현체도 사용가능하다.
				- Spring MVC 가 클래스 경로에 있으면 MvcRequestMatcher, 아니면 AntPathRequestMatcher가 사용된다.
		- securityMatchers()를 사용하면 중복 정의가 가능해 현재 규칙이 이전 규칙을 대체하지 않고 다중 설정으로 구성해서 규칙을 설정할 수 있다. 
		- ==**securityFilterChain 빈을 여러개를 설정해서 각각 다르게 securityMatchers()설정한다면, 보통 우선순위 애너테이션인 @Order로 우선순위를 세워주어야 한다.**==
	- 동작원리
		- FilterChainProxy는 URL을 확인하고 여러개의 SecurityFilterChain들 중 일치하는 RequestMatcher를 가진 SecurityFilterChain을 찾아 매칭한다.
		- securityMatcher()에 어떤 파라미터를 넘겨서 저장하면 해당하는 RequestMatcher를 지닌 SecurityFilterChain을 구성한다.
	- 예시
		- HttpSecurity를 /api/로 시작하는 URL에만 적용하도록 구성
			- `http.securityMatcher("/api/**").authorizeHttpRequests(auth -> auth.requestMatchers(...))`

&emsp;&emsp;

### 메서드 기반 권한 부여

&emsp;&emsp;

- 설명
	- 개요
		- Spring Security는 메서드 수준의 권한 부여도 지원한다.
			- 설정 클래스에 @EnableMethodSecurity 어노테이션을 추가하면 활성화 된다.
		- SpEL 표현식을 사용해 다양한 보안 조건을 정의할 수 있다.
	- @EnableMethodSecurity
		- API
			- boolean prePostEnabled() 
				- 역할
					- @PreAuthorize, @PostAuthorize, @PreFilter, @PostFilter 활성화
				- 특징
					- 기본값은 true
			- boolean securedEnabled()  
				- 역할
					- Secured 옵션 활성화
				- 특징
					- 기본값은 false
			- boolean jsr250Enabled()  
				- 역할
					- JSR-250 관련 어노테이션들을 활성화 한다.
				- 특징
					- @RolesAllowed, @PermitAll, @DenyAll 등이 있다.
					- 기본값은 false

&emsp;&emsp;

#### PreAuthorize, PostAuthorize

&emsp;&emsp;

- 설명
	- PreAuthorize
		- 역할
			- 메소드가 실행되기 전에 특정한 보안 조건이 충족되는지 확인하는데 사용되는 어노테이션
		- 특징
			- 서비스, 컨트롤러 레이어의 메소드에 적용되어 해당 메소드가 호출되기 전에 사용자 인증 정보와 권한을 검사한다.
	- PostAuthorize
		- 역할
			- 메소드가 실행된 후에 특정한 보안 조건이 충족되는지 확인하는데 사용되는 어노테이션
		- 특징
			- 특정 조건을 만족하는 경우에만 사용자가 결과를 받을 수 있게 한다.

&emsp;&emsp;

#### PreFilter, PostFilter

&emsp;&emsp;

- 설명
	- PreFilter
		- 역할
			- 메소드가 실행되기 전에 메소드에 전달된 컬렉션 타입의 파라미터에 대한 필터링을 수행
		- 특징
			- 주로 사용자가 보낸 컬렉션 내의 객체들을 특정 기준에 따라 필터링하고 그 중 보안 조건을 만족하는 객체들에 대해서만 처리하도록 할 때 사용
	- PostFilter
		- 역할
			- 메소드가 반환하는 컬렉션 타입의 결과에 대해 필터링을 수행
		- 특징
			- 반환시 반환되는 각 객체가 특정 보안 조건을 충족하는지 확인하고 ㅗ건을 마녹하지 않는 객체들을 결과에서 제거한다.


&emsp;&emsp;

#### Secured, JSR-250 및 부가기능


&emsp;&emsp;

- 설명
	- @Secured
		- 역할
			- 지정된 권한을 가진 사용자만 해당 매소드를 호출할 수 있다.
		- 특징
			- 이것보단 풍부한 표현이 가능해 확장성이 좋은 PreAuthorize를 더 많이 사용한다.
			- 시큐리티 설정에서 EnableMethodSecurity 어노테이션의 필드인 securedEnabled를 true로 설정해주면 된다.
	- JSR-250
		- 역할
			- RolesAllowed, PermitAll, DenyAll 어노테이션 기능이 활성화된다.
		- 특징
			- 시큐리티 설정에서 EnableMethodSecurity 어노테이션의 필드인 jsr250Enabled를 true로 설정해주면 된다.
	- 메타 주석
		- 역할
			- 애플리케이션의 특정 사용을 위해 편리성과 가독성을 높여주는 메타 주석
		- 예시
			- PreAuthorize("hasRole('ADMIN')")이런 어노테이션을 IsAdmin 이런식의 어노테이션으로 사용할 수 있게 된다.
	- 특정 주석 활성화
		- 특징
			- EnableMethodSecurity에 prePostEnable를 false로 설정하고나서 특정 옵션만 따로 빈으로 등록해서 설정을 넣어줄 수 있다
			- prePostEnable를 꺼주는 경우가 거의 없어서 쓸일이 없지만 알아 두기만 하자
	- 커스텀 빈을 사용해 표현식 구현
		- 역할
			- 특정 표현식을 구현하는 빈을 등록하고 해당 빈을 이용해 PreAuthorize, PostAuthorize와 같은 곳에 어노테이션을 표현식으로 사용하는 것
		- 특징
			- 요청 기반 역할 부여 방식의 커스텀 표현식 방식을 등록하는 것과 방식이 동일하다.
				- 그저 사용하는 위치가 다를 뿐이다.
	- 클래스 레벨 역할 부여
		- 특징
			- 클래스의 모든 메서드에 클래스 레벨의 권한 처리 동작으로 전체 적용한다.
			- 만약 클래스에도 설정하고 메서드에도 설정했다면, 메서드가 우선순위가 더 높아서 우선 적용된다.

&emsp;&emsp;

### 정적 자원 관리

&emsp;&emsp;

- 설명
	- RequestMatcher 인스턴스
		- 역할
			- 무시해야할 요청을 지정하여 정적 자원을 관리
		- 특징
			- 기존의 HttpSecurity.authorizeHttpRequest()에 넣어서 사용하는 것과 별반 차이는 없다.
			- 보통 ==**특정 경로 에 대해 permitAll()**==하는 방식을 더 많이 사용한다.
			- ==**예전에는 모든 요청마다 세션을 확인해서 성능 저하가 있었지**==만 스프링 시큐리티 6 부터는 ==**권한 부여 규칙에서 필요한 경우를 제외하고 세션을 확인하지 않는다**==.
			- 성능 문제가 없기 때문에 ==**모든 요청에서 permitAll()을 사용하는 것을 권장**==하며 정적 자원에 대한 요청일지라도 안전하게 해더를 작성할 수 있어 더 안전함
			- 시큐리티 6 이전 버전에서는 ignore라는 api를 통해서 구현하였는데 ==**타켓 경로에 대한 요청인 경우 아예 어떠한 시큐리티 로직에 흐르지 않게 무시하는 방식**==이기 때문에 이러면 xss 공격을 방어하기 애매하다는 문제가 존재했었다.
		- ignore 방식 설정 시 요청 처리 흐름
			1. ignore 설정을 했다면 filterChainProxy에는 ignore 경로가 등록된 requestMatcher가 들어있으며 필터는 텅 빈 필터체인과 보안이 필요한 경로에 각각 맞는 requestMatcher와 함께 보안처리를 제대로 하는 기초 필터체인까지 ==**총 2개의 필터체인이 생성**==되게 된다.
			2. 만약 유저가 보낸 요청이 ignore 처리 필터체인에 적합하는 경우
				1. 필터가 텅 빈 필터체인이므로 그대로 통과하여 Spring MVC에 도달한다.
			3. 만약 유저가 보낸 요청이 ignore 처리 필터체인에 적합하지 않는 경우
				1. 제대로 초기화한 필터체인이므로 각종 필터에서 알맞는 필터 과정을 처리한 후 통과하여 Spring MVC에 도달한다.
		- permitAll 방식 설정 시 요청 처리 흐름
			1. permitAll 설정을 했다면 인가 처리 위임 객체로 permitAllAuthorizationManager를 사용하게된다.
			2. permitAllAuthorizationManager는 인가 처리시 필요한 동작인 세션에서 필요한 데이터를 불러오는 동작 자체를 시도하지 않게 된다. 따라서 추가적인 비용없이 무조건 인가 허가를 하게 된다.
				1. 시큐리티 6에서는 디버깅은 좀 힘들어졌지만 이러한 로딩 동작들이 다 함수형으로 바뀌어 지연처리 되어있기 때문에 이 방식이 좀 더 권장되는 것이다.

&emsp;&emsp;

### 계층적 권한

&emsp;&emsp;

- 설명
	- 역할
		- 역할 간 계층 구조를 정의하고 관리하는데 사용되고 간편하게 역할 간의 계층 구로를 설정하고 이를 기반으로 사용자에 대한 엑세스 규칙을 정의할 수 있음
	- 특징
		- 스프링 시큐리티는 기본적으로 역할 상호 간의 계층 구조나 더 우열을 나눠 다른 역할만 접근 가능한 자원을 같이 접근 가능하게 만들 수는 없었지만 설정으로 이를 가능하게 할 수 있다.
		- 이를 사용하면 엑세스 규칙이 크게 줄어들고 더 간결하고 우아현 형태로 규칙 표현이 가능함
		- RoleHierachy 빈을 등록하면 설정이 가능하고 기본적으로 ROLE_A > ROLE_B 이렇게 표현하면 A가 B보다 상위 계층임을 표현하며 이를 여러개 등록도 가능하다.
		- 내부적으로 인가를 위해 부여된 현재 경로에 도달 가능한 모든 ROLE(권한)을 가져와 해당 권한과 일치하는지의 검증 처리를 하고 있다.
	- API
		- `Collection<? extends GrantedAuthority> getReachableGrantedAuthorities(Collection<? extends GrantedAuthority> authorities)`
			- 역할
				- 모든 도달 가능한 권한의 배열을 반환
				- 도달 가능한 권한은 직접 할당된 권한에 더해 역할 계층에서 이들로부터 도달 가능한 권한을 의미
					- 예시 ROLE_A > ROLE_B > ROLE_C 인 경우
						- 직접 할당된 권한이 ROLE_B인 경우
							- 도달 가능한 권한
								- ROLE_B, ROLE_C
		- `void setHierarchy(String roleHierarchyStringRepresentation)`
			- 역할
				- 역할 계층을 설정하고 각 역할에 대해 해당 역할의 하위 계층에 속하는 모든 역할 집합을 미리 정해 놓는다.
			- 특징
				- 역할을 할당할 때는 한 줄로 적지 않고 한 관계씩 끊어서`\n`로 구분하여 표현한다.

<br><br>

## 인가 아키텍처

&emsp;&emsp;

### 인가 - Authorization

&emsp;&emsp;

- 설명
	- 역할
		- 권한 부여를 의미하며 특정 자원에 접근 가능한 사람을 결정 짓는 것을 의미한다.
	- 특징
		- 스프링 시큐리티는 GrantedAuthority 클래스를 통해 권한 목록을 관리하고 있다.
			- 사용자의 Authentication 객체와 연결한다.

&emsp;&emsp;

#### GrantedAuthority

&emsp;&emsp;

- 설명
	- 역할
		- 스프링 시큐리티에서 Authentication 객체에 GrantedAuthority 권한 목록을 저장시키고 이를 통해 인증 주체에게 부여된 권한을 사용하도록 한다.
	- 특징
		- GrantedAuthority 객체는 AuthenticationManager에 의해 Authentication 객체에 삽입된다.
		- 내부적으로 SimpleGrantedAuthority라는 단일 문자열을 지니는 값 객체를 컬렉션을 지니고 있고 이 컬렉션을 Authentication에 가지고 있는 구조이다.
		- AuthenticationManager는 스프링 시큐리티가 인가 결정을 내릴때 사용하며 Authentication으로 부터 GrantedAuthority를 읽어 들여 처리한다.
	- API
		- `getAuthority() String`
			- 역할
				- AuthenticationManager가 GrantedAuthority의 정확한 문자열 표현을 얻기 위해 사용
	- 사용자 정의 역할 접두사 ROLE
		- 특징
			- 역할 기반 인가 규칙으로써 접두사 ROLE_을 사용하며 스프링 시큐리티 내부적으로 이 접두사가 붙은 권한을 찾게 된다.
			- GrantedAuthorityDefaults 빈을 등록해 커스텀 지정도 가능하다.
			- 이를 사용할 때 roles로 지정할 수 없고 authorities를 사용해 권한을 등록해야한다.
				- roles는 접두사로 ROLE이 붙을 때 사용하는 것이고 그게 아닌 경우에는 authorities를 사용해 특정 유저를 등록할 때 저 api를 사용해야한다.


&emsp;&emsp;

### 인가 관리자 - AuthorizationManager

&emsp;&emsp;

- 설명
	- 역할
		- 인증된 사용자가 요청 자원에 접근할 수 있는지 여부를 결정하는 인터페이스
	- 특징
		- 인증된 사용자의 권한 정보와 요청 자원의 보안 요구 사항을 기반으로 권한 부여 결정을 내린다.
		- 스프링 시큐리티의 요청 기반, 메소드 기반의 인가 구성 요소에서 호출되고 최종 엑세스 제어 결정을 내리는데 수행된다.
		- 스프링 시큐리티의 필수 구성 요소로 권한 부여 처리는 AuthorizationFilter를 통해 이루어지며 AuthorizationFilter는 AuthorizationManager를 호출하여 권한 부여 결정을 내린다.
	- API
		- `verify(Supplier <Authentication>, T) void`
			- 역할
				- check()를 invoke해 반환된 값이 false를 가진 AuthorizationDecision인 경우 AccessDeniedException을 던진다.
			- 특징
				- 디폴트 메서드로 구현되어 굳이 구현체쪽에서 구현하지 않아도 상관은 없다.
		- `check(Supplier <Authentication>, T) AuthorizationDecision?`
			- 역할
				- 권한 부여 결정을 내릴 때 필요한 모든 관련 정보(인증 객체, 체크 대상(권한 정보, 요청정보, 호출 정보 등))가 전달된다.
			- 특징
				- 엑세스가 허용되며 true를 포함하는 AuthorizationDecision 거부되면 false를 포함하는 AuthorizationDecision 결정을 내릴 수 없는 경우 null을 반환한다.
	- 구현체 계층 구조
		- 요청 기반 권한 부여 관리자
			- RequestMatcherDelegatingAuthorizationManager
				- 역할
					- 여러가지 AuthorizationManager를 가지고 있다가 요청이 들어오면 알맞는 AuthorizationManager 클래스를 찾아 처리하도록 위임처리한다.
				- 특징
					- 내부적으로 mappings라는 RequestMatcher 리스트를 들고 있고 각 RequestMatcher가 가지고 있는 권한과 일치하는지 체크를 하는 과정을 거친다.
				- 참조하고 있는(가지고 있는) 구현체 클래스 종류
					- AuthenticatedAuthorizationManager
						- 역할
							- 인증된 사용자에게 접근을 허용
						- 특징
							- 사용자가 시스템에 로그인 했는지 여부를 기준으로 권한 부여를 결정함
					- AuthorityAuthorizationManager
						- 역할
							- 특정 권한을 가진 사용자에게만 접근을 허용
						- 특징
							- 주로 사용자의 권한을 기반으로 접근을 제어함
					- WebExpressionAuthorizationManager
						- 역할
							- 웹 보안 표현식을 사용하여 권한을 관리함
						- 특징
							- 위에서 구현한 PreAuthorize 애너테이션에 넣던 그런 표현식들을 사용가능하게 해준다.
		- 메서드 기반 권한 부여 관리자
			- PreAuthorizeAuthorizationManager
				- 역할
					- 메소드 실행 전 권한을 검사함
				- 특징
					- PreAuthorize 어노테이션과 함께 사용된다.
					- 메서드 실행 전에 사용자의 권한을 확인한다.
			- PostAuthorizeAuthorizationManager
				- 역할
					- 메소드 실행 후 권한을 검사함
				- 특징
					- PostAuthorize 어노테이션과 함께 사용된다.
					- 메서드 실행 결과에 따라 접근을 허용하거나 거부한다.
			- Jsr250AuthorizationManager
				- 역할
					- JSR-250 어노테이션을 사용해 권한 관리
			- SecuredAuthorizationManager
				- 역할
					- Secured 어노테이션을 사용하여 메서드 수준의 보안을 제공
				- 특징
					- 특정 권한을 가진 사용자만 메서드에 접근할 수 있게 한다.

&emsp;&emsp;

### 요청 기반 인가 관리자

&emsp;&emsp;

- 설명
	- 역할
		- 요청 기반의 인증된 사용자 및 특정 권한을 가진 사용자의 자원 접근 허용 여부를 결정하는 인가 관리자 클래스
		- 초기화 과정에 RequestMatcher : Manager 조합으로 구성된 리스트를 만든다.
	- 내부 구조 정리
		1. 유저가 요청을 보내면 AuthorizationFilter가 요청을 받아 처리함
		2. SecurityContextHolder에서 Authentication 객체를 꺼내고 여기에서 GrantedAuthority 객체를 꺼내 부여된 역할을 확인한다.
		3. 2번에서 꺼낸 정보를 인가관리자인 RequestMatcherDelegatingAuthorizationManager에게 넘기고 RequestMatcherDelegatingAuthorizationManager는 요청 패턴을 기준으로 적절한 인가 관리자를 호출한다. (AuthenticatedAuthorizationManager, AuthorityAuthorizationManager, WebExpressionAuthorizationManager 중 하나)
		4. 각 관리자들은 요청 자원에 대한 접근에 대해 최종 승인 혹은 거부 결과를 반환한다.
			1. 만약 결과가 최종 승인이면 Spring MVC로 요청을 전달한다.
			2. 만약 결과가 거부 결과이면 AccessDeniedException을 던진다.

&emsp;&emsp;

#### AuthenticatedAuthorizationManager

&emsp;&emsp;

- 설명
	- 특징
		- 내부적으로 4 가지의 인증 전략(AbstractAuthorizationStrategy 구현 클래스)을 이용해 인증 여부 확인을 진행한다.
	- 인증 전략
		- FullyAuthenticatedAuthorizationStrategy
			- 역할
				- 익명 인증 및 기억하기 인증이 아닌지 검사
		- RememberMeAuthorizationStrategy
			- 역할
				- 기억하기 인증인지 검사
		- AuthenticatedAuthorizationStrategy
			- 역할
				- 인증된 사용자인지 검사
		- AnonymousAuthenticatedAuthorizationStrategy
			- 역할
				- 익명 사용자인지 검사

&emsp;&emsp;

#### AuthorityAuthorizationManager

&emsp;&emsp;

- 설명
	- 특징
		- 내부적으로 AuthoritiesAuthorizationManager를 사용하여 권한 여부 결정을 위임한다
		- 특정 권한 설정에 대해서 인가 검사를 진행하는 클래스 이므로 실제 가장 내부적으로 많이 사용되는 클래스이다.
		- 구현 자체는 요청 패턴과 매핑할 권한 정보를 설정하는 API 위주이다.
			- 실제 검사는 AuthoritiesAuthorizationManager가 진행한다.
		- 내부에 매핑하는 과정을 보게 되면 엔드 포인트 별로 나누어 권한이 매핑되어있다.


&emsp;&emsp;

#### 요청 기반 커스텀 인가 관리자

&emsp;&emsp;

- 설명
	- 특징
		- 선언적 방식이 아닌 프로그래밍 방식으로 구현하는 방식
		- access(AuthorizationManager) API 를 사용한다.
		- access()에는 `AuthorizationManager<RequestAuthorizationContext>` 타입의 객체를 전달할 수 있고 사용자 요청에 대한 권한 검사를 access()에 지정한 AuthorizationManager가 처리한다.
		- access()에 지정한 AuthorizationManager 객체는 RequestMatcherDelegatingAuthorizationManager의 매핑 속성에 저장된다.
		- AuthorizationManager를 구현하여 나만의 커스텀 AuthorizationManager를 만들고 이를 access()에 파라미터로 넘겨 등록하면 된다.
			- 위에서 구현한 요청 기반 인가 처리에 커스텀 표현식을 등록할 때와 방식은 동일하다.

&emsp;&emsp;

#### RequestMatcherDelegatingAuthorizationManager

&emsp;&emsp;

- 설명
	- 특징
		- mappings 속성에 직접 RequestMatcherEntry 객체를 생성하고 추가할 수 있다.
		- 따로 커스텀 RequestMatcherDelegatingAuthorizationManager를 만들고 이를 빈으로 등록해서 access()에 파라미터로 넘겨 등록해줄거면 ==**anyRequest()를 통해서 등록**==하면 된다.
			- 어차피 모든 경로와 권한 매핑을 직접해주는 방식이기 때문이다.
	- RequestMatcherEntry API
		- `getEntry() T`
			- 역할
				- 요청 패턴에 매핑된 AuthorizationManager 객체 반환
		- `getRequestMatcher() RequestMatcher`
			- 역할
				- 요청 패턴을 저장한 RequestMatcher 객체 반환

&emsp;&emsp;

### 메서드 기반 인가 관리자

&emsp;&emsp;

- 설명
	- 특징
		- 내부적으로 AOP 방식으로 인해 초기화 설정이 이뤄지고 메서드 호출을 MethodInterceptor가 가로 채어 처리하고 있다.
	- 초기화 과정
		1. 스프링은 초기화시 생성되는 전체 빈을 검사하면서 빈이 가진 메서드 중에 보안이 설정된 메소드가 있는지 탐색
		2. 보안이 설정된 메소드가 있으면 스프링은 그 빈의 프록시 객체를 자동으로 생성 (Cglib 방식 디폴트)
			1. 이 과정을 InfrastructureAdvisorAutoProxyCreator가 담당한다.(매핑된 Advisor들을 가지고 프록시 객체를 생성한다.)
				1. Cglib 프록시 내부에는 여러개의 콜백을 가지고 있는데 내부적으로 이 콜백들은 순서대로 하나씩 가지고 있는 advice를 호출하게 된다.
		3. 보안이 설정된 메소드에는 인가처리 기능을 하는 Advice를 등록한다.
		4. 스프링은 빈 참조시 실제 빈이 아닌 프록시 빈 객체를 참조하도록 처리
		5. 초기화 과정 종료
		6. 사용자는 프록시 객체를 통해 메소드를 호출하고 프록시 객체는 Advice가 등록된 메서드가 있다면 호출하여 작동시킨다.
		7. Advice는 메소드 진입 전 인가처리를 하게 되고 ==**인가 처리가 승인되면 실제 객체의 메소드를 호출**==, ==**인가 처리가 거부되면 예외를 던짐**==
	- 메소드 인터셉터
		- 특징
			- 처리 구조를 보면 Pre의 경우를 만든 것이고 Post의 경우에는 중간 MethodInvocation이 먼저 invoke되는 구조로 되어있다.
			- 메소드 기반 인가 처리는 등록하는 과정이 AOP라 복잡할 뿐, ==**Spring AOP의 영역을 벗어나면 요청 기반 인가 처리와 다를게 없는 동작 구성**==을 가지고 있다.
			- 인터셉터 호출 순서가 매우 중요한 이유는 만약 ==**다른 AOP 동작을 담당하는 Transactional과 같은 어노테이션의 실행이 항상 우선되어야 하는데 인가 프로세스의 인터셉터가 먼저 호출되어 예외의 경우 롤백의 처리등이 잘 적용되지 않음**==
				- 따라서 ==**EnableTransactionManagement 어노테이션을 사용해 메서드 인가 어드바이스가 실행되기 전에 트랜잭션을 열게 설정해야한다. (@EnableTransactionManagement(order = 0)으로 설정하면 됨)**==
				- @EnableTransactionManagement(order = 0) 이 설정은 PreFilter보다 적게 설정해 항상 트랜잭션이 먼저 열리게 된다는 것을 의미한다.
		- 구현체 종류
			- AuthorizationManagerBeforeMethodInterceptor
				- 역할
					- 지정된 AuthorizationManager를 사용해Authentication이 보안 메서드를 호출할 수 있는지 여부를 결정
			- AuthorizationManagerAfterMethodInterceptor
				- 역할
					- 지정된 AuthorizationManager를 사용해 Authentication이 보안 메서드의 반환 결과에 접근할 수 있는지 여부를 결정
			- PreFilterAuthorizationMethodInterceptor
				- 역할
					- @PreFilter 어노테이션에서 표현식을 평가하여 메소드 인자를 필터링
			- PostFilterAuthorizationMethodInterceptor
				- 역할
					- @PostFilter 어노테이션에서 표현식을 평가하여 보안 메서드에서 반환된 객체를 필터링
		- 처리 구조 (PreFilter의 경우)
			1. 유저가 메소드 기반 인가 처리가 적용된 메소드를 invoke
			2. DefaultAdvisorChainFactory에서 해당 클래스와 메소드를 파라미터로 넘겨받고 이에 해당하는 매핑된 Advice를 넘겨준다.
			3. 해당하는 MethodInterceptor를 invoke()
			4. AuthorizationManager가 인가를 검증하고 결과를 반환한다. (check() 결과 AuthorizationDecision)
				1. MethodSecurityExpressionHandler가 MethodSecurityEvaluationContext에서 MethodSecurityExpressionRoot에 들어있는 Authentication과 MethodInvocation중 Authentication을 꺼내 권한이 일치하는지 검사한다.
			5. AuthorizationDecision에서 isAuthorized()를 통해 검증 결과를 확인한다.
				1. 인가 검증이 통과 되었으면 MethodSecurityExpressionRoot에 들어있는 MethodInvocation.proceed()를 invoke한다.(여기에 메소드 기반 인가 처리가 적용된 메소드가 참조되어있고 내부적으로 이게 invoke된다.)
				2. 인가 검증이 통과되지 않았으면 AccessDeniedException을 던진다.
		- ==**인터셉터 순서 (매우 중요)**==
			- FIRST
				- 특징
					- 정수 데이터로 Integer.MIN_VALUE가 할당됨
			- PRE_FILTER
				- 특징
					- 정수 데이터로 100이 할당됨
			- PRE_AUTHORIZE
				- 특징
					- 정수 데이터로 200이 할당됨
			- SECURED
				- 특징
					- 정수 데이터로 300이 할당됨
			- JSR250
				- 특징
					- 정수 데이터로 400이 할당됨
			- POST_AUTHORIZE
				- 특징
					- 정수 데이터로 500이 할당됨
			- POST_FILTER
				- 특징
					- 정수 데이터로 600이 할당됨
			- LAST
				- 특징
					- 정수 데이터로 Integer.MAX_VALUE가 할당됨

&emsp;&emsp;

#### 메서드 기반 커스텀 인가 관리자

&emsp;&emsp;

- 설명
	- 구현 방법
		1. EnableMethodSecurity 어노테이션에 prePostEnabled를 false로 꺼둔다.
		2. 커스텀 AuthorizationManager를 만든다.
			1. AuthorizationManager 구현한다. 이때 Pre의 경우 MethodInvocation을 타입 파라미터로 넘겨야하고 Post의 경우에는 MethodInvocationResult를 타입 파라미터로 넘겨야한다.
			2. 만약 AuthorizationManager를 여러 개 추가한다면 체인 형태로 연결되어 각각 권한 검사를 하게 된다.
		3. Advisor를 빈으로 등록한다.
			1. AuthorizationManagerAfter(Before)MethodInterceptor에 있는 API인 postAuthorize(preAuthorize)에 커스텀 AuthenticationManager를 등록한다.
			2. 각각 빈 어노테이션과 함께 Role 어노테이션에 ROLE_INFRASTRUCTURE를 넣어준다.

&emsp;&emsp;

### 포인트 컷 메서드 보안 구현

&emsp;&emsp;

- 설명
	- 특징
		-  메서드 보안은 AOP를 기반으로 구축되었으므로 어노테이션이 아닌 패턴의 형태로 권한 규칙을 선언할 수 있고 요청 수준의 인가와 유사한 방식이다.
		- 자체 어드바이저를 발행하거나 포인트 컷을 사용해 AOP 표현식을 애플리케이션 인가 규칙에 맞게 매칭도 할 수 있다.
		- 이를 이용하면 어노테이션을 사용하지 않고 메소드 수준에서 보안 정책을 구현할 수 있다.
		- 개인적인 생각
			- 유지 보수가 힘들어져서 현업에서는 사용하기 힘들지 않나 생각한다.
	- 구현 방법
		- 단일 포인터 컷
			1. 어드바이저 빈을 등록한다.
			2. Role 어노테이션에 ROLE_INFRASTRUCTURE를 넣어준다.
			3. AspectExpressionPointCut 객체를 만들어 표현식을 세팅한다.
			4. AuthorityAuthorizationManager 객체를 만들어 매니저를 세팅한다.
			5. 표현식과 매니터를 각각 파라미터로 넘겨 AuthorizationManagerMethodInterceptor를 생성하여 반환한다.
		- 다중 포인터 컷
			1. 포인터컷 객체를 여러개 생성하고 표현식을 세팅한다.
				1. 사실 포인터컷 표현식 구문에 따라 더 다양하게 설정이 가능하다.
			2. ComposablePointCut 객체를 생성하고 이 객체에 세팅하고 반환한다.
			3. 어드바이저 빈을 등록한다.
			4. Role 어노테이션에 ROLE_INFRASTRUCTURE를 넣어준다.
			5. 포인터컷을 넣는 파라미터 자리에 다중 포인터컷 생성 메서드를 넣어주고 인터셉터를 반환한다.


&emsp;&emsp;

### AOP 메서드 보안 구현

&emsp;&emsp;

- 설명
	- 특징
		- MethodInterceptor, PointCut, Advisor, AuthorizationManager 등을 커스텀하게 생성해 AOP 보안 구현이 가능함
	- AOP 요소 정리
		- Advisor
			- Advice + PointCut 를 지닌 기본 인터페이스
		- MethodInterceptor(Advice)
			- 대상 객체를 호출하기 전, 후에 추가 작업을 수행하기 위한 인터페이스
			- 수행 이후 실제 대상 객체의 조인포인트 호출(메서드 호출)을 위해 Joinpoint.proceed() invoke함
				- 단, 스프링 시큐리티에서는 적용 대상을 메서드로 제한한다.
		- Pointcut
			- Advice가 적용될 메서드나 클래스를 정의하는 것, 적용 지적이나 조건을 지칭함
				- 조인포인트에서 또 다시 필터를 거는 것이다.
			- ClassFilter와 MethodMatcher를 사용해 어떤 클래스 및 메서드에 Advice를 적용할 것인지 결정한다.
	- AOP 초기화
		- AnnotaionAwareAspectJAutoProxyCreator
			- 특징
				- 조인포인트 대상을 기준 프록시 생성기
				- 현재 애플리케이션 컨텍스트 내의 모든 AspectJ 어노테이션과 스프링 어드바이저들을 처리
				- 내부적으로는 CGLibAopProxy가 생성해준다.(보통 인터페이스가 아니면 이게 작동하게 되어있다.)
			- 생성 어드바이저 종류
				- Spring Security Advisor
				- Custom Advisor
	- AOP 적용 순서
		1. 커스텀 MethodInterceptor를 생성하고 메소드 보안 검사를 수행할 AuthorizationManager를 커스텀 MethodInterceptor에 전달한다.
			1. 빈으로 등록해야하며 Role을 정해줄 필요는 없다.
		2. 커스텀 포인트컷을 생성하고 프록시 대상 클래스와 대상 메서드를 결정할 수 있도록 표현식 정의
			1. 빈으로 등록해야하며 Role을 정해줄 필요는 없다.
		3. DefaultPointcutAdvisor를 생성하고 커스텀 MethodInterceptor와 커스텀 포인트 컷을 전달한다.
			1. 각각 빈으로 등록된 빈을 넘기면 된다.
		4. 서비스를 호출하면 Pointcut으로부터 대상 클래스와 대상 메서드에 등록된 MethodInterceptor를 탐색하고 결정되면 이를 호출해 AOP를 수행한다.

<br><br>

## 이벤트 처리

&emsp;&emsp;

#### Authentication Events

&emsp;&emsp;

- 설명
	- 역할
		- 인증 성공 혹은 실패시 발생하는 이벤트
	- 특징
		- 성공시 AuthenticationSuccessEvent, 실패시 AuthenticationFailureEvent를 발생시킨다.
			- providerManager가 인증 성공시 AuthenticationSuccessEvent를 발행하도록 구현되어있다. 이를 활용해도 된다.
			- UsernamePasswordAuthenticationFilter 내부에서 인증 성공시 InteractiveAuthenticationSuccessEvent를 발행하고 있다. 이를 활용해도 된다.
		- 이벤트 수신을 위해 ApplicationEventPublisher 혹은 시큐리티에서 제공하는 AuthenticationEventPublisher를 이용하면 된다.
		- AuthenticationEventPublisher의 구현체로 DefaultAuthenticationEventPublisher가 제공된다.
		- 인증 이벤트 수신시 이벤트 클래스 상속 구조를 따라가기 때문에 조상 이벤트를 활용해서 수신하여 처리도 가능하다.
		- httpSecurity 설정에 successHandler, failureHandler를 사용하여 이곳에서 커스텀하게 이벤트를 발행하도록 만들 수 있다.
	- 발행 방법
		- `ApplicationEventPublisher.publishEvent(ApplicationEvent)`
		- `AuthenticationEventPublisher.publishAuthenticationSuccess(Authentication)`
		- `AuthenticationEventPublisher.publishAuthenticationFailure(Authentication)`
	- 수신 방법
		1. 이벤트 처리 컴포넌트를 만든다.
		2. EventListener 어노테이션을 붙인 메서드를 만든다.
			1. 만약 파라미터로 AuthenticationSuccessEvent를 받으면 성공 이벤트를 처리한다.
			2. 만약 파라미터로 AuthenticationFailureEvent를 받으면 실패 이벤트를 처리한다.
	- 인증 이벤트 종류
		- 인증 성공 & 인증 실패 공통 조상 이벤트
			- `AbstractAuthenticationEvent`
		- 인증 실패 이벤트 클래스 조상 이벤트
			- `AbstractAuthenticationFailureEvent`
		- 인증 성공 이벤트
			- `AuthenticationSuccessEvent`
			- `InteractiveAuthenticationSuccessEvent`
		- 인증 실패 이벤트
			- `AuthenticationFailureBadCredentialsEvent`
			- `AuthenticationFailureCredentialsExpiredEvent`
			- `AuthenticationFailureDisabledEvent`
			- `AuthenticationFailureExpiredEvent`
			- `AuthenticationFailureLockedEvent`
			- `AuthenticationFailureProviderNotFoundEvent`
			- `AuthenticationFailureProxyUntrustedEvent`
			- `AuthenticationFailureServiceExceptionEvent`


&emsp;&emsp;

#### AuthenticationEventPublisher 활용

&emsp;&emsp;

- 설명
	- 특징
		- 커스텀 예외와 커스텀 이벤트를 매핑시켜 발행하는 커스텀 eventPublisher를 만들어서 발행할 수 있다.
		-  AuthenticationException 발생시 해당 예외에 매핑 된 이벤트가 발행이 안되어 있는 경우 기본 AuthenticationFailureEvent를 발행 및 수신할 수 있다.
			- DefaultAuthenticationEventPublisher에 기본 이벤트를 설정하여 빈으로 등록하면 된다.
	- 예시
		1. `Map<Class<? extends AuthenticationException>, Class<? extends AbstractAuthenticationFailureEvent>> mapping =  Collections.singletonMap(CustomException.class, CustomAuthenticationFailureEvent.class);  `
			1. 싱글턴 맵으로 예외와 이벤트를 생성한다.
		2. `DefaultAuthenticationEventPublisher authenticationEventPublisher = new DefaultAuthenticationEventPublisher(applicationEventPublisher);  
			1. 빈으로 등록할 인증 이벤트 publisher를 생성한다.
		3. `authenticationEventPublisher.setAdditionalExceptionMappings(mapping);`
			1. 인증 이벤트 publisher에 1번에서 만든 맵을 등록한다.
		4. 매핑외 이벤트에 매핑되는 디폴트 즉, 기본 이벤트를 등록한다.
		5. 인증 이벤트 publisher를 반환한다.

&emsp;&emsp;

### 인가 이벤트

&emsp;&emsp;

- 설명
	- 특징
		- 권한 부여 이벤트 처리를 지원하며 권한이 부여되거나 거부된 경우에 발생하는 이벤트
		- ApplicationEventPublisher, AuthorizationEventPublisher를 사용해서 발행하면 이벤트를 수신할 수 있다.
		- AuthorizationEventPublisher의 구현체로 SpringAuthorizationEventPublisher가 제공된다.
			- SpringAuthorizationEventPublisher로 빈을 등록해야한다.
			- 단, 인가 실패의 경우에만 발행된다.
		- ==**커스텀 AuthorizationEventPublisher를 구현을 하고 등록해야 인가 실패, 성공에도 발행되는 이벤트 publisher로 등록할 수 있다.**==
			- `public void publishAuthorizationEvent(Supplier<Authentication>authentication, T object, AuthenticationDecision decision)` 이 메서드를 구현해야한다.
			- Authentication의 인가 상태와 AuthenticationDecision의 인가 권한에 따라서 허가 이벤트를 발행할지 정해주면 된다.
	- 발행 방법
		- `ApplicationEventPublisher.publishEvent(ApplicationEvent)`
		- `AuthorizationEventPublisher.publishAuthorizationEvent(Supplier<Authentication>, T, AuthorizationDecision)`
	- 수신 방법
		1. 이벤트 처리 컴포넌트를 만든다.
		2. EventListener 어노테이션을 붙인 메서드를 만든다.
			1. 만약 AuthorizationDeniedEvent 인 경우 실패의 이벤트를 처리할 수 있다.
			1. 만약 AuthorizationGrantedEvent 인 경우 성공의 이벤트를 처리할 수 있다.
	- 이벤트 종류
		- `AuthorizationEvent`
			- 공통 조상 이벤트
		- `AuthorizationDeniedEvent`
			- AuthorizationFilter에 인가 실패시 발행되도록 디폴트로 구현되어있다.
		- `AuthorizationGrantedEvent`



<br><br>

## 통합하기

&emsp;&emsp;

### Servlet API

&emsp;&emsp;

- 설명
	- 특징
		- 스프링 시큐리티에서 다양한 프레임워크 및 API 와의 통합을 제공중이다.
		- Sevlet 3, Spring MVC와 통합을 통해 여러 편리한 기능들을 사용할 수 있다.
		- 인증 관련 기능들을 필터가 아닌 서블릿 영역에서 처리할 수 있다.
	- Servlet 3+ 통합 주요 API
		- `SecurityContextHolderAwareRequestFilter`
			- 역할
				- HTTP 요청 처리시 HttpServletRequest에 보안 관련 메소드를 추가적으로 제공하는 레퍼 클래스를 적용
			- 특징
				- 개발자는 이를 통해 서블릿 API의 보안 메소드를 사용해 인증, 로그인, 로그아웃 등의 작업 수행 가능
		- `HttpServlet3RequestFactory`
			- 역할
				- Servlet 3 API 와의 통합을 제공하기 위한 Servlet3SecurityContextHolderAwareRequestWrapper 객체 생성
		- `Servlet3SecurityContextHolderAwareRequestWrapper`
			- 역할
				- HttpServletRequest의 래퍼 클래스
			- 특징
				- Servlet 3.0 기능 제공
				- SecurityContextHolder와의 통합을 제공
				- SecurityContext에 접근이 쉽고 Servlet 3.0 비동기 처리와 같은 기능을 사용하는 동안 보안 컨텍스트를 올바르게 관리할 수 있음
	- 내부 구조
		1.  SecurityContextHolderAwareRequestFilter가 HttpServlet3RequestFactory를 사용해 Request/Response 객체를 생성한다.
			1. Spring에서는 SecurityContextHolderAwareRequestFilter를 제공해 인증 수단을 제공하고 서블릿에서는 Servlet3SecurityContextHolderAwareRequestWrapper를 제공해 서블릿 단에서의 인증 수단을 제공한다.
	- API 종류
		- SecurityContextHolderAwareRequestFilter
			- `rolePrefix()`
			- `authenticationManager()`
			- `trustResolver()`
			- `logoutHandlers()`
			- `securityContextRepository()`
			- `authenticationEntryPoint()`
			- `securityContextHolderStrategy()`
		- HttpServlet3RequestFactory
			- `setLogoutHandlers(List<LogoutHandler>)`
			- `setTrustResolver(AuthenticationTrustResolver)`
			- `setAuthenticationManager(AuthenticationManager)`
			- `setSecurityContextHolderStrategy(SecurityContextHolderStrategy)`
			- `setAuthenticationEntryPoint(AuthenticationEntryPoint)`
			- `create(HttpServletRequest, HttpServletResponse)`
		- Servlet3SecurityContextHolderAwareRequestWrapper
			- `startAsync(ServletRequest, ServletResponse) AsyncContext`
				- 역할
					- 이 메서드를 호출한 스레드에서 발견된 SecurityContext를 Runnable을 처리하는 스레드로 자동복사한다.
			- `logout() void`
				- 역할
					- LogoutHandlers를 사용해 사용자가 로그아웃할 수 있게 한다.
			- `isAuthenticated() boolean`
			- `login(ServletRequest, ServletResponse) void`
				- 역할
					- AuthenticationManager를 이용해 사용자가 인증할 수 있도록 한다.
			- `getAuthentication(ServletRequest, ServletResponse) Authentication`
			- `getAsyncContext(ServletRequest, ServletResponse) AsyncContext`
			- `startAsync() AsyncContext`
			- `authenticate(HttpServletResponse) boolean`
				- 역할
					- 사용자가 인증되었는지 확인 하고 아니면 로그인 페이지로 사용자를 리다이렉트 보낸다.
	- 코드 구현
		- 로그인
			- Spring MVC 단 로직에서 HttpServletRequest를 넘겨받아 login api를 사용해 로그인한다.
		- 인증이 필요한 페이지
			- Spring MVC 단 로직에서 HttpServletRequest를 넘겨받아 authenticate api를 사용해 인증을 확인한다.

&emsp;&emsp;

### Spring MVC

&emsp;&emsp;

- 설명
	- 특징
		- 스프링 시큐리티에서 Spring MVC 파라미터에 대한 현재 ==**Authentication.getPrincipal()을 하게 되면 AuthenticationPrincipalArgumentResolver를 제공함**==
			- 시큐리티 홀더에 들어있는 Authentication 객체에 들어있는 유저 정보를 의미함
		- AuthenticationPrincipal 어노테이션을 메서드 인수에 사용하면 Spring Security와 독립적으로 사용 가능하다.
		- 스프링 시큐리티는 Controller에서 Callable을 실행하는 비동기 스레드에 SecurityContext를 자동으로 설정하도록 지원한다.
			- WebAsyncManager와 통합하여 SecurityContextHolder에서 사용가능한 SecurityContext를 Callable에서 접근 가능하도록 해준다.
			- Callable은 메인 스레드에서 사용가능한 인터페이스가 아닌 자식 스레드에서 사용이 가능하다.
			- ==**메인 스레드의 SecurityContextHolder와 자식 스레드의 SecurityContextHolder를 동기화 시켜주는 작업을 WebAsyncManager가 해준다.**==
		- ==**Async 어노테이션이나 다른 비동기 기술은 스프링 시큐리티와 통합되어있지 않아 비동기 스레드에 같은 SecurityContext가 동기화되지 않는다!**==
			- ==**단, SecurityContext의 저장 모드를 MODE_INHERITABLETHREADLOCAL로 잡아주면 부모 자식 스레드간 공유가 가능해져 사용이 가능하다!**==
	- AuthenticationPrincipal 특징
		- 표현식
			- expression 옵션을 추가해 Principal 내부 필드 혹은 메서드에 접근하고자 할 때 사용 가능하다.
			- 보통 내부에 중첩된 객체가 있는 경우 사용된다.
		- 메타 주석
			- 어노테이션 자체를 메타 주석화 하여 Spring Security에 대한 종속성 제거도 가능하다.
	- WebAsyncManagerIntegrationFilter
		- 역할
			- SecurityContext와 WebAsyncManager 사이 통합을 제공
		- 특징
			- WebAsyncManager 생성
			- SecurityContextCallableProcessingInterceptor를 WebAsyncManager에 등록한다.
	- WebAsyncManager
		- 역할
			- 스레드 풀의 비동기 스레드를 생성
		- 특징
			- Callable을 받아 실행시키는 주체
			- 등록된 SecurityContextCallableProcessingInterceptor를 통해 현재 스레드가 보유하고 있는 SecurityContext 객체를 비동기 스레드의 ThreadLocal에 저장시킨다.
	- 구현 예시
		1. 비동기에서 동작할 메서드의 반환 값을 Callable로 두고 제네릭 타입을 적어준다.
		2. Callable을 리턴할때 구현을 해서 리턴하는데 이때 구현 코드는 비동기 Thread의 영역이다.
	- 동작 흐름
		1. 유저의 요청 흐름이 메인 스레드로 도달
		2. WebAsyncManagerIntegrationFilter가 SecurityContextCallableProcessingInterceptor와 WebAsyncManager를 생성한다.
		3. WebAsyncManager에서 메인 스레드의 SecurityContext를 SecurityContextCallableProcessingInterceptor에 저장한다.
		4. ThreadPoolExecutor가 비동기 작업을 실행하고 비동기 스레드를 생성한다.
		5. SecurityContextCallableProcessingInterceptor가 자식 스레드의 ThreadLocal에 메인 스레드의 SecurityContext를 가지고와 저장한다.
			1. SecurityContextCallableProcessingInterceptor의 preProcess()에서 수행된다.
		6. Callable을 수행하는 비동기 스레드는 자신의 ThreadLocal에 저장되어 있는 SecurityContext를 참조할 수 있다.




<br><br>

## 고급 설정

&emsp;&emsp;

### 다중 보안 설정

&emsp;&emsp;

- 설명
	- 특징
		- 앞서 설명에 보통 SecurityMatcher를 사용해서 이런 구현이 가능했지만 좀 더 추가적으로 구현이 가능하다.
		- Order 지정을 통해 여러 개의 필터 체인 설정에 우선순위를 부여해 줄 수 있다.
		- Order 지정이 없으면 맨 마지막으로 설정된다.
		- 초기화시 여러 개의 SecurityFilterChain을 FilterChainProxy 생성시 전달한다.
		- FilterChainProxy는 요청이 올 때마다 알맞는 SecurityFilterChain을 매치시켜 요청을 전달한다.
			- 이때 앞서 위에서 설명한 바와 같이 각 SecurityFilterChain에 저장된 RequestMatcher 설정을 보고 매칭한다.

&emsp;&emsp;

### Custom DSLs

&emsp;&emsp;

- 설명
	- 역할
		- 스프링 시큐리티에서 커스텀 DSL을 구현하도록 지원한다.
	- 특징
		- 필터, 핸들러, 메서드, 속성 등을 한 곳에 정의해 처리할 수 있는 편리함을 제공한다.
		- `AbstractHttpConfigurer<AbstractHttpConfigurer, HttpSecurityBuilder>`를 상속받아 구현해야한다.
			- `init(B builder)`와  `configure(B builder)` 이 두 메서드를 오버라이딩해야한다.
			- `init(B builder)`
				- 역할
					- HttpSecurity 구성 요소를 설정, 공유하는 작업
			- `configure(B builder)`
				- 역할
					- 공통클래스를 구성, 사용자 정의 필터를 생성
		- 초기화시 여러 설정 클래스들을 가져와 초기화를 하고 마지막으로 직접 구현한 커스텀 DSL 설정 클래스를 들고와 설정을 하는 구조이다.
	- API
		- `HttpSecurity.with(C configurer, Customizer<C> customizer)`
			- 특징
				- configurer에 `AbstractHttpConfigurer`를 상속한 클래스와 DSL을 구현한 클래스를 파라미터로 넘긴다.
				- customizer에 DSL 구현 클래스에서 정의한 여러 API를 커스트 마이징한다.
				- 동일한 클래스를 여러 번 설정하더라도 한번 만 적용된다.

&emsp;&emsp;

### 이중화 설정

&emsp;&emsp;

- 설명
	- 이중화
		- 역할
			- 시스템의 부하분산, SPOF 없는 서비스를 지속 제공하는 기본적인 아키텍처 구현 방법 중 하나
	- 특징
		- 스프링 시큐리티는 세션을 안전하게 관리해 이중화된 환경에서 세션을 공유할 수있는 메커니즘을 제공한다.
		- 레디스와 같은 분산 캐시를 이용해 세션 정보를 여러 서버 간에 공유할 수 있다.
			- MySql이나 Postgresql등 디비의 메모리 테이블을 사용해 올려서 사용해도 충분히 사용은 가능하지만 분산 캐시는 아니기 때문에 초기 사용 이후 레디스로 결국 마이그레이션을 하긴 해야한다.
			- 레디스의 장점
				- 세팅이 편하다.
				- 분산 캐시 세팅이 편하다.
			- 레디스의 단점
				- 새로운 서드파티 캐싱 라이브러리를 도입해야하는 것이 관리 부담이 될 수 있다.
				- 기존 디비에서도 메모리 테이블을 사용하면 캐싱이 가능하다.
		- 이 기능은 스프링 세션 라이브러리를 추가하면 사용이 가능하다.
			- 이 기능을 사용하면 기존 SecurityContextHolderFilter가 아닌 SessionRepositoryFilter를 사용하는데, 세션을 SecurityContextRepository가 아닌 RedisContextRepository에서 가져오는 구현체이다.
				- 따라서 톰캣이 아닌 레디스에서 세션값을 들고 온다.

<br><br>

## 실전 프로젝트 - 회원 인증

&emsp;&emsp;

- 설명
	- PasswordEncoder
		- 역할
			- 비밀번호를 안전하게 저장 하거나 단방향 변환을 수행하는 데 사용됨
		- 특징
			- 사용자의 비밀번호 암호화 후 저장
			- 인증 시 검증을 위해 입력한 비밀번호와 암호화된 비밀번호를 비교
		- API 종류
			- `String encode(CharSequence)`
				- 역할
					- 지정된 암호화 방식으로 인코딩을 수행한다.
			- `boolean matches(CharSequence, String)`
				- 역할
					- 인코딩된 비밀번호와 제출된 원본 비밀번호를 인코딩 한 후 일치하는지 검사
			- `boolean upgradeEncoding(String)`
				- 역할
					- 인코딩된 비밀번호가 보안상의 이유로 다시 인코딩할 필요가 있는지 여부를 반환
	- DelgatingPasswordEncoder
		- 역할
			- {id} 형식의 접두사를 사용해 비밀번호가 어떤 방식으로 인코딩 되었는지 식별하는 클래스
		- 특징
			- 만약 {brypt}인 경우 BCrypt 방식으로 인코딩 되었음을 의미한다.
			- 기본 인코딩 방식을 변경해준다.
			- 새로운 인코딩 방식이 권장되거나 필요한 경우 비밀번호 인코딩 전략을 유연하게 유지할 수 있음
			- 빈등록시 `PasswordEncoderFactories.reateDelgatingPasswordEncoder();`를 사용함
				- 디폴트는 bcrypt
			- ==**회원가입 구현시 디비 저장때 사용된다.**==
		- 알고리즘 지정 설정 방법
			1. 빈등록 메서드를 구현한다.
				1. 알고리즘의 타입을 표현하는 알고리즘 Id 문자열을 생성한다. 이 문자열은 매핑용으로 사용된다.
				2. 인코더 해시맵을 만들고 알고리즘 ID를 키로, 값으로는 해당 알고리즘에 해당하는 알고리즘 PasswordEncoder를 집어넣는다.
				3. 아이디값과 해시맵을 넘겨 DelgatingPasswordEncoder를 생성하고 반환한다.
	+ 커스텀 UserDetailsService
		+ 구현 방법
			1. 빈 이름을 지정한 userDetailService 만든다.
			2. UserDetailService를 구현한다.
			3. loadUserByUsername 메서드를 구현한다.
			4. 연동할 데이터베이스인 repository를 주입받는다.
			5. repositoy에서 유저 이름을 기반으로 찾아 존재하는 지 찾는 로직을 구현한다.
				1. 유저를 찾는 경우 유저의 권한을 기반으로 권한 객체를 생성하고 Dto에 매핑한다.
				2. 유저를 찾지 못한 경우 UsernameNotFound 예외를 던진다.
			7. 매핑한 유저를 리턴할 때에는 Dto를 반환하는 것이 아닌 생성한 권한 객체와 Dto를 파라미터로 넘겨 생성한 UserDetails 구현체를 유저 객체로 리턴한다.
	- 커스텀 AuthenticationProvider
		- 구현 방법
			1. 이름이 authenticationProvider인 컴포넌트를 만든다.
			2. UserDetailsService와 PasswordEncoder를 주입받는다.
			3. AuthenticationProvider를 구현한다.
			4. authenticate를 구현한다.
				1. authentication 객체에서 유저 이름과 비밀번호를 꺼낸다.
				2. userDetailsService에서 유저를 찾는다.
				3. passwordEncoder를 통해 유저가 맞는지 확인한다.
					1. 유저가 맞으면 구현체 AuthenticationToken을 생성해 반환한다.
						1. ==**첫번째 파라미터로 principal을 받는데 dto를 넘겨 세팅한다.**==
						2. 두번째 파라미터는 credential인데 보통 보안을 위해 null로 세팅한다.
						3. 세번째 파라미터는 권한을 넣으면 된다.
					2. 유저가 아니면 BadCredentialsException 예외를 던진다.
	- 커스텀 로그아웃
		- 구현 방법
			1. 로그아웃을 get 메소드로 처리되게끔 하기 위해 우선 로그아웃 getmapping 메소드 endpoint를 추가하고 구현한다.
			2. authentication 객체를 꺼낸다.
			3. authentication이 null이 아니면 SecurityContextLogoutHandler에 정적 메서드인 logout에 필요한 파라미터를 넘겨 invoke를 한다.
				1. 참고로 로그아웃은 로그아웃 필터가 담당해서 처리하며 주요 처리는 핸들러가 담당하며 핸들러의 구현체는 여러가지 종류가 존재한다.
			4. 원하는 페이지로 리다이렉트한다.
			5. build.gradle에 thymeleaf extras springsecurity6를 추가한다.
			6. 로그아웃 프레그먼트에 thymeleaf extras springsecurity6를 sec라는 이름의 네임스페이스로 추가한다.
			7. 만약 sec:authorize="isAnonymous()" 가 true 이면 로그인 버튼을 보여준다.
			8. 만약 sec:authorize="isAuthenticated()" 가 true이면 로그아웃 버튼을 보여준다.
		- Thymeleaf 보안 표현식 종류
			- `isAuthenticated()`
				- 역할
					- 사용자가 인증되었는지 불리언값 반환
			- `isFullyAuthenticated()`
				- 역할
					- 사용자가 완전히 인증 되었는지(기억되는 사용자 제외) 불리언 값 반환
			- `hasAuthority('ROLE_USER')`
				- 역할
					- 특정 권한을 가진 사용자인지 불리언 값 반환
			- `hasAnyAuthority('ROLE_USER', 'ROLE_ADMIN')`
				- 역할
					- 여러 권한 중 하나라도 가진 사용자인지 불리언 값 반환
			- `hasRole('ADMIN')`
				- 역할
					- 특정 역할을 가진 사용자인지 불리언 값 반환
			- `hasAnyRole('USER', 'ADMIN')`
				- 역할
					- 여러 역할 중 하나라도 가진 사용자인지 불리언 값 반환
			- `principal`
				- 역할
					- 현재 인증된 사용자의 주요 정보 반환
			- `authentication`
				- 역할
					- 현재 인증 객체 반환
		- Thymeleaf 보안 표현식 예시
			- `${#authentication.principal.username}`
			- `${#authentication.authorities}`
	- 커스텀 인증 상세
		- WebAuthenticationDetails
			- 역할
				- HTTP 요청과 관련된 인증 세부 정보를 포함하는 클래스
			- 특징
				- 사용자의 IP 주소, 세션 ID와 같은 정보 보유
				- 특정 인증 메커니즘에서 요청의 추가적인 정보를 인증 객체에 추가할 때 사용가능
				- Authentication 객체와 함께 사용된다.
				- 필터 체인 빈 등록시 `fromLogin()` 세팅시 설정하는 것이다.
		- AuthenticationDetailsSource
			- 역할
				- 인증 과정 중 Authentication 객체에 세부 정보를 제공하는 소스
			- 특징
				- WebAuthenticationDetails 객체를 생성하는 데 사용
				- 인증 필터(AuthenticationFilter)에서 참조되는 객체
				- 세팅 방법은 위의 커스텀 방법들과 마찬가지로 빈으로 등록하면 된다.
				- 이를 활용해 추가로 보낼 정보를 담아서 보낼 경우 찾아서 넣을 수 있다.
			- 사용 예시
				- `String secretKey = (FormWebAuthentication authentication.getDetails()).getSecretKey()`
					- 특징
						- ==**꺼낼때는 Authentication 객체에서 가져올 수 있다.**==
	- 커스텀 인증 성공, 실패 핸들러
		- AuthenticationSuccessHandler
			- 특징
				- SecurityFilterChain 빈 등록시 로그인 세팅때 설정해주면 된다.
				- 빈으로 등록해도 되고 new로 생성해서 바로 넣어도 상관은 없다만 빈으로 등록해야 구현코드를 분리해서 보기 편한 장점은 있다.
				- 필터 체인 빈 등록시 `fromLogin()` 세팅시 설정하는 것이다.
		- 성공 핸들러 구현 방법
			1. SimpleUrlAuthenticationSuccessHandler를 상속 받는다.
			2. 구현체를 컴포넌트로 등록한다.
			3. 구현체에 HttpSessionRequestCache와 DefaultRedirectStrategy를 필드 주입받는다.
			4. `onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication)` 이것을 구현한다.
				1. setDefaultTargetUrl()를 이용해 기본 타겟 URL을 세팅한다.
					1. 참고로 이건 상위 클래스에 구현된 메서드이다.
				2. requestCache에서 캐시를 들고 온다.
					1. 캐시가 null이면 리다이렉트 객체를 이용해 디폴트 TargetURL로 리다이렉트한다.
					2. 캐시가 null이 아니면 캐시에서 리다이렉트 Url 문자열을 꺼낸다.
						1. 리다이렉트 객체를 이용해 캐시에서 꺼낸 리다이렉트 Url로 리다이렉트한다. 
		- AuthenticationFailureHandler
			- 특징
				- SuccessHandler와 동일하게 등록해주면 된다.
		- 실패 핸들러 구현 방법
			1. SimpleUrlAuthenticationFailureHandler를 상속받아 구현한다.
			2. `onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception)`를 구현한다.
				1. 각 예외 상황에 맞는 예외 메시지를 세팅한다.
				2. setDefaultFailureUrl()를 이용해 예외 메시지와 함께 URL을 넣어준다.
					1. 이렇게 사용하기 위해서는 로그인 요청에 대한 추가 쿼리를 넣어도 허가를 해주게끔 "/login*"도 permitAll()을 추가 해주어야한다.
				3. super.onAuthenticationFailure를 호출한다.
	- 커스텀 접근 제한
		- 구현 방법
			1. 필터체인 빈 설정시 `exceptionHandling` 예외 처리 메서드인 `accessDeniedHandler()`를 사용해 접근 제한 핸들러를 등록한다.
				1. 다른 커스텀 세팅과 마찬가지로 빈으로 등록해도 되고 생성해서 객체를 넘겨도 된다.
				2. 폼 로그인에서 설정하는 설정이 아니다.
			2. 접근 제한 핸들러를 구현해야 하는데 AccessDeniedHandler를 구현해야한다.
				1. RedirectStrategy를 필드로 생성해둔다.
				2. errorPage 문자열을 필드로 만들어 두고 생성자를 통해 생성한다.
				3. handle 메서드를 오버라이딩하는데 필드로 HttpServlet 요청, 응답, AccessDeniedException까지 총 3 가지 객체를 파라미터로 받는다.
				4. 알맞는 처리를 한 후 RedirectStrategy를 통해 리다이렉트를 한다.




&emsp;&emsp;

<br><br>


## 비동기 인증


&emsp;&emsp;

- 설명
	- Rest 구성
		- 필터체인 설정시 비동기 인증 방식이 먼저 동작하도록 Order 지정을 해주어야한다.
			- 만약 SSR 세팅이 없다면 넘어가도 된다.
		- Rest 방식 비동기 통신에서 CSRF 토큰은 직접 넘겨야 하므로 개발 초기에는 일단 비활성화 해두자.
		- 클라이언트 구현시 바닐라 통신이라면 'X-Requested-With': 'XMLHttpRequest' 이것을 헤더에 세팅해야 서버측에서 Ajax 비동기 통신임을 바로 파악할 수 있다.
	- 커스텀 RestAuthenticationFilter
		- 특징
			- 스프링 시큐리티는 직접 만든 필터를 addFilterBefore, addFilterAfter, addFilter, AddFilterAt등의 메서드를 사용해 제어할 수 있다.
			- AbstractAuthenticationProcessingFilter를 상속받고 attemptAuthentication을 구현해야한다.
		- 필터 추가 API
			- `addFtilerBefore()`
				- 역할
					- 지정된 필터를 필터 체인의 특정 필터 앞에(이전에) 추가
				- 특징
					- 주로 특정 처리가 다른 필터보다 먼저 처리되어야 하는 경우에 사용됨
			- `addFtilerAfter()`
				- 역할
					- 지정된 필터를 필터 체인의 특정 필터 뒤(이후에) 추가
				- 특징
					- 주로 특정 작업이 다른 필터 처리에 따라야할 때 (다른 필터를 위한 후처리가 필요한 경우) 사용된다.
			- `addFtiler()`
				- 역할
					- 시큐리티 필터 체인에 새로운 필터를 추가하여 필터의 위치를 지정하지 않고 그 필터의 유형에 따라 자동으로 적절할 위치에 필터를 추가
				- 특징
					- 추가하는 필터가 스프링 시큐리티의 필터를 상속받을 경우에 해당하며 그렇지 않을 경우 예외를 던진다.
			- `addFtilerAt()`
				- 역할
					- 지정된 필터를 필터 체인의 특정 필터 위치에 추가
				- 특징
					- 목표 필터를 대체하지는 않는다.
		- 구현방법
			1. 커스텀 Rest 인증 필터 클래스를 만든다.
			2. 인증 필터 클래스는 AbstractAuthenticationProcessingFilter를 상속받아 구현한다.
			3. 요청 데이터 매핑을 위해 ObjectMapper를 필드에 생성해둔다.
			4. attemptAuthentication 메서드를 오버라이딩해 구현한다.
				1. 어차피 추상메서드이므로 구현은 반드시 해줘야한다.
			5. 요청이 Post가 아니거나 Ajax 요청이 아닌지 검사한다.
				1. 만약 아닌게 맞다면 허용되지 않는 인증요청이므로 예외를 던진다.
				2. 만약 아닌게 틀리다면 Dto 클래스에 매핑한다. 이때 필드에 만들어둔 매퍼를 사용하자
			6. 사용자 이름이 문자열이 아니거나 사용자 비밀번호가 문자열이 아닌지 검사한다. 
				1. 만약 아닌게 맞으면 인증 예외를 던진다.
				2. 만약 아닌게 틀리다면 매퍼에서 꺼낸 데이터를 기반으로 Authentication 객체를 생성한다. (토큰도 AbstractAuthenticationToken을 상속받아 구현한 객체이다.)
			7. 생성한 토큰을 이용해 `this.getAuthenticationManager().authenticate(token)`을 시도하고 이 결과를 반환한다.
				1. 이때 이건 상속 받은 클래스에 구현되어있는 메서드이다.
	- 커스텀 Rest AuthenticationProvider
		- 구현 방법
			1. authenticationProvider 컴포넌트를 생성한다.(이름도 짓는다.)
			2. 나머지 구현 과정은 form 방식 커스텀과 동일하지만 마지막 반환시 Rest용 (커스텀) 토큰을 넘겨준다.
	- RestAuthenticationSuccess(Failure)Handler
		- 구현방법
			1. Rest용 커스텀 AuthenticationFilter에 각각 세팅을 하면 된다.
			2. 각 핸들러에는 onAuthenticationSuccess, onAuthenticationFailure 메서드를 구현해준다.
				1. ObjectMapper를 객체로 생성한다.
					1. 성공인 경우 authentication 객체에서 계정 객체를 꺼낸다.
						1. 응답 객체의 상태를 ok로 바꾼다.
						2. content-type을 Application json value로 바꾼다.
						3. 계정 객체에 비밀번호를 null로 비운다.
						4. 매퍼 객체를 이용해 응답객체에 계정객체를 매핑한다.
							1. clearAuthenticationAttributes()를 이용해 request에 인증 객체 속성을 지운다.
					2. 실패인 경우 응답 객체의 상태를 Unauthorized로 바꾼다.
						1. content-type을 Application json value로 바꾼다.
						2. 예외가 만약 BadCredentialsException인 경우 그에 맞는 예외 메시지를 매퍼 객체를 이용해 응답객체에 매핑한다.
						3. 매퍼 객체를 이용해 응답 객체에 인증 실패 메시지를 매핑한다.
	- Rest 인증 상태 영속 - SecurityContextRepository 설정
		- 구현 방법
			1. 커스텀 rest 용 필터 생성자에 setSecurityContextRepository()를 호출해 세팅한다.
				1. 이때 파라미터로 SecurityContextRepository를 넘겨야하는데 `SecurityContext Repository getSecurityContextRepository(HttpSecurity)`이므로 직접 필터 생성자에서 HttpSecurity를 받아서 주입시켜주어야한다.
				2. httpSecurity에서 `getSharedObject(SecurityContextRepository.class)`를 사용해 레포지터리를 꺼내고 null이라면 새로 DelegatingSecurityContextRepository를 생성해준다.
					1. 이때 파라미터로 RequestAttributeSecurityContextRepository와 HttpSessionSecurityContextRepository를 생성해서 넘겨준다.
						1. 이는 인증 필터에서 인증 성공후 인증객체를 세션에 저장할 수 있도록 지정하는 것이다.
						2. RequestAttributeSecurityContextRepository 생존 범위는 요청 범위이며 HttpSessionSecurityContextRepository의 생존 범위는 세션 범위이다.
						3. RequestAttributeSecurityContextRepository는 원래 커스텀 필터가 AbstractAuthenticationProcessingFilter를 상속 받으면 기본 설정된다.
				3. 레포지터리를 반환한다.
	- Rest용 커스텀 AuthenticationEntryPoint
		- 특징
			- 필터가 아닌 exceptionHandling에 사용해야한다.
		- 구현방법
			1. AuthenticationEntryPoint를 구현한다.
			2. 필드에 ObjectMapper를 생성해둔다.
			3. commence 메소드를 오버라이드한다.
				1. 응답객체의 Content-type을 application json type으로 설정한다.
				2. 응답객체의 상태를 unauthorized로 설정한다.
				3. 응답객체에 매퍼 객체를 활용해 unauthorized 상태메시지를 적는다.
	- Rest용 커스텀 AccessDeniedHandler
		- 특징
			- 필터가 아닌 exceptionHandling에 사용해야한다.
		- 구현방법
			1. AuthenticationDeniedHandler를 구현한다.
			2. 필드에 ObjectMapper를 생성해둔다.
			3. handle 메소드를 오버라이드한다.
				1. 응답객체의 Content-type을 application json type으로 설정한다.
				2. 응답객체의 상태를Forbidden으로 설정한다.
				3. 응답객체에 매퍼 객체를 활용해 Forbidden으로 상태메시지를 적는다.
	- Rest Logout
		- 구현방법
			- Form 로그아웃 방식과 동일하다
	- Rest CSRF
		- 구현방법
			1. 클라이언트에서는 요청 헤더에 토큰을 세팅한다.
				1. 이때 Post 방식인 경우에만 실어서 보내면 된다. 어차피 값을 변경하는 요청에 대한 공격이니 보통 post의 경우에 검사한다.
				2. `_csrf`의 이름으로 세팅해서 넣어야한다.
	- Rest용 DSLs
		- 구현 방법
			1. with 메서드를 사용해서 Rest용 DSL 클래스를 등록한다.
				1. 이곳에서 성공, 실패 핸들러를 등록할 수 있다.
			2. Dsl 클래스는 AbstractAuthenticationFilterConfigurer를 상속받는다.
			3. 생성자에는 커스텀 필터를 넘겨 슈퍼 클래스를 초기화한다.
			4. configure 메소드를 오버라이딩한다.
				1. authenticationManager를 꺼낸다.
				2. getAuthenticationFilter()로 현재 authenticationFilter를 가져오고 authenticationManager를 세팅한다.
				3. getAuthenticationFilter()로 현재 authenticationFilter를 가져오고 성공 실패 핸들러를 둘다 세팅한다.
				4. 이후 추가로 필요한 설정들을 해주면 된다.
					1. 레포지터리 설정, 리멤버미 설정 등등이 있다.
				5. 


<br><br>

## 실전 프로젝트 - 회원 관리

&emsp;&emsp;

- 설명
	- 특징
		- 스프링 시큐리티에서 회원, 권한, 자원 관리 기능을 연동할 수 있다.
		- 설정 클래스에서 권한 규칙 코드를 모두 제거하고 프로그래밍에 의한 동적 권한으로 전환 가능하다.
			- 동적으로 관리 가능하면 무중단 배포 설정 없이도 서비스가 올라간 상태에서 배포가 가능해진다.
		- 회원 관리 시스템 기능
			- 회원 관리
				- 회원 리스트
				- 회원 상세 정보
				- 권한 부여
			- 권한 관리
				- 권한 리스트
				- 권한 생성
				- 권한 수정
				- 권한 삭제
			- 자원 관리
				- 자원 리스트
				- 자원 생성
				- 자원 삭제
				- 자원 수정
				- 자원 권한 매핑
	- 프로그래밍 방식 메모리기반 인가 설정 - Map
		- 특징
			- 프로그래밍 방식에 의한 인가 기능을 위해 DynamicAuthorizationService, AuthorizationManager를 구현한 구현체가 필요하다.
				- 이 구현체는 클라이언트 요청에 대해 동적 인가 검사를 수행한다.
			- 맵 방식으로 권한과 자원을 매핑하기 위해 UrlRoleMapper 인터페이스를 구현한 구현체 클래스가 필요함
			- ==**완전한 동적방식은 DB의 의존성을 부여하고 이를 기반으로 처리하는 것이다.**== 
				- Map을 이용하면 어쨌거나 해당 코드를 수정하면 다시 컴파일하고 반영해야한다.
		- 구현 방법
			1. `AuthorizationManager<RequestAuthorizationContext>` 를 구현한 DynamicAuthorizationService 구현체를 구현한다.
				1. 구현체 빈 생성 이후 동작할 메서드인 mapping() 메서드를 구현한다.
					1. MapBasedUrlRoleMapper를 가지고 `List<RequestMatcherEntry> mappings`를 내부에 생성한다. 
						1. MapBasedUrlRoleMapper는 미리 구현한 문자열 경로와 권한 문자열 세트 맵 데이터 제공자이다.
						2. RequestMatcherEntry는 RequestMatcher와 AuthorizationManager 쌍이다.
				2. check 메서드를 구현한다.
					1. 초기화한 mappings를 순회하며 현재 요청와 맞는 requestMatcher가 있는지 찾는다.
						1. 찾았으면 현재 위치의 Entry를 꺼내 매니저를 꺼내고 인가 매니저의 메서드인 check 결과를 반환한다.
					2. 못 찾았다면 Deny를 반환한다.
				3. verify 메서드를 구현한다.
					1. 내부 구현은 super 클래스에 의존시킨다.
	- 프로그래밍 방식 DB 기반 인가 설정
		- 특징
			- 온전한 동적 방식의 인가 설정이므로 다시 컴파일할일 없이 DB만 수정하면 된다.
			- ResourceRepository에서 데이터를 들고와 커스텀 RoleMapper에서 초기화 하는 방식이다.
		- 구현 방법
			1. 커스텀 RoleMapper를 구현한다.
				1. resourceRepository를 구현한다.
					1. getUrlRoleMappings 메서드를 오버라이딩한다.
						1. resourceRepository에서 자원 리스트를 받아온다.
						2. 자원리스트를 순회하여 urlRoleMapping 맵을 세팅한다.
						3. urlRoleMapping 맵을 반환한다.
			2. 인가 매니저는 Map 방식과는 다르게 ACCESS를 기본으로 둔다.
	- 인가 설정 실시간 반영 설정
		- 구현 방법
			1. ResourceService 구현체를 구현한다.
				1. resourceRepository를 주입받는다.
				2. 커스텀 authorizationManager를 주입받는다.
				3. createResources()를 구현한다.
					1. 트랜잭셔널 어노테이션을 추가한다.
					2. resourceRepository를 통해 저장한다.
					3. authorizationManager를 통해 리로드한다.
				4. deleteResources()를 구현한다.
					1. 트랜잭셔널 어노테이션을 추가한다.
					2. resourceRepository를 통해 삭제한다.
					3. authorizationManager를 통해 리로드한다.
			2. 커스텀 authorizationManager에 reload() 메서드를 추가하여 구현한다.
				1. synchronized 키워드를 붙여 레이스 현상을 방지한다.
				2. 매핑 정보가 담긴 객체인 mappings를 비운다. (invoke clear())
				3. mappings에 다시 매핑 정보를 불러와서 담는다. (invoke getUrlRoleMappings())
			3. UrlRoleMapper의 구현체에 구현된 getUrlRoleMappings()를 새로 구현한다.
				1. 매핑 정보가 담긴 객체인 urlRoleMappings를 비운다. (invoke clear())
				2. resourceRepository를 통해 새 리스트를 받아온다.
				3. 새로 세팅된 urlRoleMappings를 반환
	- 계층적 권한 적용
		- 구현 방법
			1. role_hierarchy 테이블을 만들어 id, 역할, 역할의 상위 역할을 표현하는 부모아이디를 컬럼으로 만들어 미리 관계를 추가해둔다.
			2. RoleHierarchyImpl 빈을 정의하고 등록한다.
				1. roleHierachyService를 주입받아 모든 계층 관계 Dto를 받고 String으로 만든다.
				2. RoleHierarchyImpl를 생성한 뒤 문자열 계층 관계를 세팅한다.
				3. RoleHierarchyImpl 객체를 반환한다.
			3. 커스텀 authorizationManager 생성자에서 roleHierachy를 필드 주입을 받던지해서 세팅한다.
	- 프로그래밍 방식 DB 기반 인가 설정 - 필터 설정
		- 특징
			- AuthorizationFilter의 코드를 그대로 복사해서 내가 만든 매니저로 바꾼 뒤 이 필터를 기존 AuthorizationFilter와 바꾸는 것이다.
			- 이 방식을 사용하는 이유는 이중 참조가 되는 AuthorizationManager의 구조를 한번만 참조하게끔 바꾸기 위함이다.
			- 어차피 이 방식은 지나친 하드 코딩 방식이기 때문에 개인적으로는 권장하진 않는다.

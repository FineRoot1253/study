# Spring

- 토이 프로젝트
    - TODOS

        [[TODOS-Spring]]

- 기본 아키텍쳐룰
    1. WEB-INF는 외부에서 접근이 불가능한 리소스를 담는다. 외부에서 .html이나 .jsp로 직접적으로 접근하는 것을 방지할때 사용되며 웹페이지 개발시 무조건 여기에 담는다.
- **Ioc/DI**
    - **Ioc**
        - 전체 코드의 제어흐름을 프레임워크에게 전담하기 위해 사용하는 기법 [ioc]

            대표적으로 **DI**가 이를 위해 사용하는 기법이다.

    - **BeanFactory & ApplicationContext [스프링 컨테이너]**
        - **BeanFactory**를 통해 각종 빈들이 컨테이너에  등록이 된다.
            - 이를 상속하여 좀더 다양한 기능을 구현하고 있는 인터페이스가 **ApplicationContext**이다.
            - 개발자는 **ApplicationContext를 다시 구현하는 구체 클래스**들을 사용한다.
                - **AnnotationConfigApplicationContext**
                    - 자바코드(팩토리메서드, 팩토리 클래스)를 직접 읽어들여 구현하는 ApplicationContext
                - **GenericXmlApplicationContext**
                    - xml파일의 빈 설정정보들을 직접 읽어들여 구현하는 ApplicationContext
- **스프링 빈**
    - 싱글톤 컨테이너

        스프링 빈은 기본적으로 싱글톤으로 관리되어 단 하나의 인스턴스를 가지는 구조로 서비스를 구현한다.

        [스프링 컨테이너 = 싱글톤 레지스트리]

        - 주의점

            **무상태로 설계해야한다.[Stateless]**

            수백 수만의 클라이언트들이 접근하는 서비스 이기 때문에 **반드시 상태를 지니는 객체(서비스, Stateful)로 만들면 안된다**!!!!!

            **금기 필드**

            1. 특정 클라이언트에 의존적인 필드
            2. 특정 클라이언트가 값을 변경할 수 있는 필드

            **필수 조건**

            1. 가급적 읽기만 가능해야한다.[**read-only**]
            2. 필드 대신에 자바에서 공유되지 않는, 지역변수, 파라미터, ThreadLocal 등을 사용해야 한다.
    - @Configuration
        - **기본 설명**

            이 어노테이션을 넣으면 CGLIB이라는 바이트코드 라이브러리를 통해

            이 어노테이션을 사용하는 클래스(ex: AppConfig)의 임의의 자식 클래스(ex: hello.core.AppConfig$$EnhancerBySpringCGLIB$$6323e4d0)를 만들고 이 구현체 또한 빈으로써 등록을 해버리고 이 구현체의 빈들의 싱글톤을 관리해준다. 이 구현체의 빈들은 Lazy Loading을 이용해 동적으로 동작한다. 빈이 있으면 생성했던 빈을 반환하고 없으면 구현체의 빈의 로직을 통해 생성한다.

        - **주의 사항**

            이 어노테이션을 사용해야 하위 빈들이 싱글톤 빈으로써 등록이 된다.

            즉, 이 어노테이션을 뺀 클래스의 빈들은 싱글톤이 아니므로 의존관계또한 존재하지 않게 된다.

            의존 관계를 맺어 줄려면 특정 의존 객체를 필드로 생성하고 @Autowired라는 어노테이션을 넣어주면 해당 의존 객체를 가져다가 자동으로 의존관계를 맺어준다.

            **결론, 스프링 설정 정보는 항상 @Configuration을 사용해야 싱글톤으로써 제대로 사용된다.**

    - @ComponentScan
        - 기본 설명

            위와 같은 방법으로 하나하나 수동으로 설정 정보를 입력하지 않고  @Component가 들어간 모든 클래스에서 @Bean이 들어간 스프링 빈들을 자동으로 등록하고 생성자에 @Autowired 처리가 되어있다면 자동으로 생성자 파라미터 타입에 맞는 스프링을 찾아 자동으로 의존관계를 주입해준다.

        - 기초 세팅

            이 이유는 컴포넌트 스캔은 현재 위치한 패키지부터 조회하여 빈들을 등록하기 때문이다.

            옛날에는 basePackages={"hello.core","hello.service"},  basePackageClasses = AutoAppConfig.class 이런식으로 base 위치를 직접 지정해줬지만 자동으로 package 키워드에 붙은 그 위치부터 조회를 하기 때문에 프로젝트 최상단에 두어야 프로젝트 내부에 있는 모든 빈들을 조회한다.

            스프링 부트에서는 @SpringbootApplication 어노테이션이 엔트리포인트에 붙어서 컴포넌트 스캔을 자동으로 해주고 있기도 하다. 그러기 때문에 main메서드가 붙은 이 파일이 프로젝트 최상단에 있는 것이다.

            이 어노테이션을 사용하는 설정 클래스의 파일의 위치는 프로젝트 최상단에 둔다.

        - 스캔 대상
            - @Component
                - 컴포넌트 스캔에서 사용하는 어노테이션
            - @Controller
                - 스프링 mvc에서 사용하는 어노테이션, 라이브러리를 받아야 볼 수 있다.

                    스프링 mvc 프레임워크가 컨트롤러로 인식을 한다.

            - @Service
                - 스프링 비즈니스 로직에서 사용하는 어노테이션

                    다른 어노테이션들과 달리 별도의 처리 프로세스가 없다. 개발자들이 여기에 핵심 비즈니스 로직이 있겠거니 하고 비즈니스 계층을 인식하는데 도움을 줄 뿐이다.

            - @Repository
                - 스프링 데이터 접근 계층에서 사용하는 어노테이션

                    스프링 데이터 접근 계층으로 인식하고, 데이터 계층의 예외를 스프링 예외로 변환해준다.

            - @Configuration
                - 스프링 설정 정보에서 사용하는 어노테이션
        - 필터
            - includeFilters
                - 컴포넌트 스캔 대상을 추가로 지정하는 필터
                - @Component지정으로 충분하기 때문에 거의 사용을 안한다.
            - excludeFilters
                - 컴포넌트 스캔에서 제외할 대상을 지정하는 필터
                - 간혹가다 수동으로 @Configuration 지정된 클래스를 제외할 때 사용한다.
            - FilterType 옵션
                - *FilterType*.***ANNOTATION***

                    디폴트 값, 애노테이션을 인식해서 동작

                - *FilterType*.**ASSIGNABLE**

                    지정한 타입과 자식타입을 인식해서 동작 [클래스 직접 지정]

                - FilterType.**ASPECTJ**

                    AspectJ 패턴을 사용해서 동작

                - FilterType.**REGEX**

                    정규 표현식을 사용해서 동작

                - FilterType.**CUSTOM**

                    TypeFilter라는 인터페이스를 구현해서 동작

    - 수동 빈등록 VS 자동 빈등록
        - 중복해서 빈을 등록할 경우 수동 빈등록이 우선권을 가진다. @Bean() ← 수동빈등록, @Component ← 자동 빈등록
        - 항상 주의해야한다. 보통은 의도치 않게 꼬여서 나오는 버그일 확률이 굉장히 높다. 그리고 굉장히 찾기 애매한 버그이다. 최근 스프링부트는 애초에 동시에 수동 & 자동 빈등록을 허용하지 않는다.
    - 의존관계 주입방법
        - 생성자 주입을 사용해야하는 이유

            수정자 주입은 setXXX 메서드를 public으로 열어두어야 한다. 즉, 런타입때 주입이 변경될 가능성이 커짐으로 좋은 설계가 아니다. 그러므로 여러 주입이 존재하지만 초기에 모두 정해서 초기 런타입때 딱 생성자 주입을 택하는 것이 좋은 설계 방법이다.(생성자 주입) 그리고 생성자 주입은 딱 한번만 호출되므로 불변하게 설계가 가능한 것이다. + final 키워드를 활용하면 더욱 좋다.

        1. 생성자 주입[constructor]
            - 불변, 필수 의존관계에 대해서만 사용한다.
            - 만약 **스프링 빈 내부에 생성자가 딱 하나만 존재**하는 경우,

                자동으로 @Autowired가 주입 되었다고 판단하여 알아서 의존관계를 맺어준다.

        2. 수정자 주입[setter]
            - setXXX 메서드를 public으로 열어둬야한다.
            - 수정, 변경 가능한 의존관계에 대해서만 사용한다.
            - @Autowired(required = false)를 통해 해당 주입해야되는 스프링 빈이 생성되지 않았을 경우에도 오류 없이 동작가능하게끔 만들어준다. 원래는 주입해야하는 스프링빈이 생성 안되어있으면 오류가 난다.
        3. 필드 주입
            - 의존 관계를 맺는 스프링 빈 필드에 @Autowired를 바로 붙인다.
            - 엄청 간단하지만 자바레벨 유닛테스트가 setter를 따로 만들어줘야 가능하다. 즉, 이럴바엔 그냥  setter 주입을 통해 의존관계를 맺어버리는게 낫다.
            - **결론, DI 프레임워크가 없으면 아무것도 할수 없다. → 그냥 쓰지 말자**
                - **예외 상황**
                    - 테스트 코드 내부에서 사용하는 경우
                    - 사용되는 스프링 빈이 스프링 설정을 목적으로 하는 @Configuration 같은 어노테이션이 사용되고 있는 스프링 빈일 경우
        4. 일반 메서드 주입
            - 일반 메서드에 붙여서 주입받는 방법
            - 여러 필드를 한번에 주입 받을수 있다.
            - 일반적으로 사용하지 않는다.
    - Autowired 옵션
        1. @Autowired(required = false)
            - 주입해야하는 스프링 빈이 생성되지 않은 경우 주입 동작을 무시한다.(수정자 메서드)
        2. @Nullable을 파라미터 타입 앞에 붙여주기
            - 주입해야하는 스프링 빈이 생성되지 않은 경우 null을 주입한다.
        3. 파라미터 타입을 Optional의 제네릭 타입으로 감싸주기
            - 주입해야하는 스프링 빈이 생성 되지 않은 경우 Optional.empty를 주입한다.
    - **의존 관계 주입시 생성된 빈이 2개이상일 경우 에러를 방지하는 방법**
        1. @Autowired의 매칭 기법을 활용한 방법

            빈마다 각기 다른 필드명OR 파라미터명을 사용한다.

        2. @Qualifier를 사용하는 방법

            빈 등록시 @Qualifier를 사용해 추가 구분자를 붙여 유일하게 만들어준다.

            만약 못찾을시 autowired 매칭 기법 처럼 구분자의 이름으로된 빈을 찾는다.

        3. @Primary를 사용하는 방법

            여러 중복된 빈중에 우선순위(디폴트)를 정해주는 방법이다.

            이 어노테이션을 넣은 빈은 중복조회시 최상위의 우선순위를 가지게 된다.(디폴트)


        @Qualifier가 @Primary보다 우선순위가 높다 (@Qualifier > @Primary)

        - **애노테이션을 직접 만들어 활용하는 방법**

            Qualifier를 사용하지 않고 애노테이션을 활용하면 컴파일타임때 나오는 에러를 잡아낼수있다.

    - 여러개의 빈을 동시에 주입받아 사용해야할때
        - String, 주입받은 객체의 타입의 맵으로 필드를 만든다.

            이러면 주입된 여러 객체들을 한번에 사용가능하다.

    - 수동 등록(@Configuration + @Bean) vs 자동등록(컴포넌트 스캔, @ComponentScan + @Component)

        묶어서 빼내야할 애들은 수동, 나머지는 자동등록을 사용하는게 좋다.

        묶어서 빼내는 애들은 aop나 데이터베이스 접근 로직등등 기술 지원 로직들을 의미한다.(여기저기서 공통적으로 쓰일 애들)

    - **빈 생명주기**
        1. 스프링 컨테이너 생성
        2. 스프링 빈 생성
        3. 의존 관계 주입 [생성자 주입은 예외, 2번에서 다 같이 딱 한번 수행됨]
        4. 초기화 콜백
        5. 사용
        6. 소멸전 콜백
        7. 스프링 종료
        - 초기화 콜백과 소멸전 콜백의 장점
            - 객체의 생성과 초기화를 분리해두는 장점이 있다. → 단일 책임 원칙까진 아니지만 이러면 여러 장점들이 있다.
        - 빈 콜백 인터페이스 InitializingBean & DisposableBean

            저 두 인터페이스를 받으면  각각 afterPropertiesSet, destroy 메서드를 오버라이드 해야하며 이를 통해 빈 초기화, 빈 소멸전 콜백을 넣어줄수있지만 단점이 있다.

            - 단점
                - 클래스 타임(컴파일 타임)에 구현을 지정을 해야되는 인터페이스 특성상 구현에서 자유롭지 않다. 그래서 거의 사용하지 않는 방식이다. 요즘은 애노테이션을 이용한 방식을 훨씬 많이 쓴다.
                - 외부 라이브러리에도 이 초기화, 소멸전 콜백을 넣어줄수 없다.
                - 메서드 명이 afterPropertiesSet, destroy로 고정되어있다.
        - 빈 등록 옵션을 사용한 콜백

            @Bean(initMethod=”초기화메서드명”,destroyMethod=”소멸전 메서드 명”)다음 과 같이 넣어주면 초기화메서드, 소멸전 메서드 콜백을 지정해줄수있다.

            - **특별한 destroyMethod 추론 기능**

                다른 외부 라이브러리들도 close, shotdown과 같은 이름으로 종료 메서드를 사용함

                거기에 destroyMethod의 기본값은 “(inferred)”라는 (추론)으로 등록되어있다.

                이 기능은 close, shotdown과 같은 이름의 메서드를 destroyMethod로써 자동으로 호출한다.

                즉, **외부 라이브러리 destroyMethod를 지정하지 않아도 종료 메서드가 호출되는 이유는 디폴트가  “(inferred)”라서 그렇다.**

                **만약 사용하기 싫다면 destroyMethod=”” 이렇게 빈 공백을 넣어주자**

        - 애노테이션 @PostConstruct, @PreDestroy

            그냥 이걸 사용하면 된다.

            스프링에 종속적인 애노테이션이 아니라 JSR-250이라는 자바 표준이므로

            스프링이 아닌 다른 컨테이너에서도 잘 적용된다.

            **결론, 외부라이브러리에 콜백을 건다면 빈등록 옵션, 아니라면 애노테이션 방식을 사용해야한다.**

    - 빈 스코프

        빈이 존재할 수 있는 범위를 뜻한다.

        - 빈 스코프의 종류
            - 싱글톤

                디폴트 스코프, 스프링 컨테이너의 시작과 종료까지 유지되는 가장 넒은 범위의 스코프이다.

            - 프로토타입(prototype)

                스프링 컨테이너는 프로토타입 빈의 생성과 의존관계 주입후 초기화까지만 관여하고 나머지는 관리하지 않는 매우 넒은 범위의 스코프이다.

                클라이언트의 요청이오면 생성을 그때하고 의존관계 주입후 초기화도 해주고 그리고 넘겨준다.

            - **웹 관련 스코프**
                - **request**

                    웹 요청이 들어오고 나갈때까지만 유지되는 스코프

                    요청 딱 하나에 대해서만 스코프가 유지된다.

                    **이 요청마다 별도의 빈 인스턴스가 생성되고 관리된다.**

                - **session**

                    웹 세션이 생성되고 종료될 때까지 유지되는 스코프

                - **application**

                    웹 Servlet Context와 같은 범위로 유지되는 스코프

                - **websocket**

                    웹 소켓과 같은 생명주기를 가지는 스코프

        - **Dependency Lookup**기능의 필요성

            만약 프로토 타입 빈을 주입 받는 싱글톤빈이 계속해서 요청마다 새 프로토타입빈을 생성해서 제공하는 특성을 사용하고 싶다면 프로토타입빈 자체를 주입 받지말고 해당 프로토타입으로 래핑한 **ObjectFactory**나 이를 상속해 좀더 많은 기능을 구현하고 있는 **ObjectProvider**를 주입받아야한다.

            - 장점
                - 기능이 단순해 단위 테스트를 만들거나 mock코드를 만들기 수월해진다.
            - **ObjectFactory vs ObjectProvider**
                - ObjectFactory

                    기능이 단순하며 별도의 라이브러리가 필요없고 스프링에 의존적

                - ObjectProvider

                    ObjectFactory를 상속하며 옵션, 스트림 처리등 편의 기능 다수 존재하고 별도의 라이브러리가 필요없고 스프링에 의존적

            - **JSR-330 Provider**
                - 장점
                    - get()메서드 하나로 기능이 매우 단순하다
                    - 스프링에 의존적이지 않아 스프링이 아닌 다른 컨테이너에서도 사용이 가능하다.
                    - 자바 표준이다.
                - 단점
                    - 별도의 라이브러리 설치가 필요하다.
            - 언제 프로바이더를 사용해야하는가?
                1. 여러 인스턴스를 가져와야할때
                2. lazy 또는 optional하게 인스턴스를 가져와야할때
                3. 순환 참조를 방지해야할때[breaking circular dependencies]

            결론, 프로토타입은 사실 실무에서 쓸일이 전혀없다. 다만 Provider들은 DL이 필요한 순간에는 언제든 사용이 가능하다. @Lookup이라는 어노테이션도 해당 기능을 제공하지만 생략


- **스프링 MVC**
    - **동작순서**
        1. **핸들러 조회**

            핸들러 매핑을 통해 요청 URL에 매핑된 핸들러(컨트롤러)를 조회

        2. **핸들러 어뎁터 조회**

            핸들러를 실행할수 있는 어뎁터가 있는지 조회

            (핸들러 어뎁터는 원하는 핸들러(컨트롤러)를 택해서 요청이 실행되도록 만들기 위함)

        3. **핸들러 어뎁터 실행**

            핸들러 어뎁터 실행

        4. **핸들러 실행**

            핸들러 어뎁터가 실제 핸들러를 실행

        5. **ModelAndView 반환**

            핸들러 어뎁터는 핸들러가 반환하는 정보를 ModelAndView로 변환해서 반환

        6. **viewResolver 호출**

            뷰 리졸버를 찾고 실행, JSP의 경우 InternalResourceResolver가 자동 등록되며 사용됨

        7. **view 반환**

            뷰 리졸버는 뷰의 논리 이름을 물리 이름으로 바꾸고 렌더링 역할을 담당하는 뷰 객체를 반환, JSP의 경우 InteranlRsourceView(JstView)를 반환하는데, 내부에 forward() 로직이 있다.

        8. **뷰 렌더링**

            뷰를 통해서 뷰를 렌더링 한다.

    - **DispatcherServlet 서블릿 등록**

        HttpServlet을 상속 받고있는 서블릿으로 스프링부트는 자동으로 이 서블릿을 urlPatterns=“/“으로 등록한다. 이렇게 되면 모든 경로에 대해서 매핑을 하는 것이다.

        근데 수동으로 등록한 경로가 우선순위가 더 높다 그래서 기존에 등록한 서블릿들도 잘 동작하는 것이다.

        DispatcherServlet에 인터페이스들만 등록하고 나머지만 구현하면 된다.

        - 인터페이스 목록
            - 핸들러 매핑
                1. RequestMappingHandlerMapping

                    어노테이션 기반 @RequestMapping에서 사용, 우선순위 젤 높음

                2. BeanNameUrlHandlerMapping

                    스프링 빈 이름으로 핸들러를 조회 할때 사용

            - 핸들러 어뎁터
                1. RequestMappingHandlerAdapter

                    어노테이션 기반 @RequestMapping에서 사용, 우선순위 젤 높음

                2. HttpRequestHandlerAdapter

                    HttpRequestHandler 처리

                3. SimpleControllerHandlerAdapter

                    Controller 인터페이스 (어노테이션 X)

            - 뷰 리졸버
                1. BeanNameViewResolver

                    빈 이름으로 뷰를 찾아서 반환, 엑셀 파일등 파일 생성 기능에 사용

                2. InternalResourceViewResolver

                    jsp를 처리할 수 있는 뷰를 반환한다.

            - 뷰
    - **@RequestMapping**

        스프링은 애노테이션을 사용하는 컨트롤러

        - @RequestParam

            파싱하려는 파라미터를 미리 지정할수도있다

        - GetMapping

            Get 메서드에 대해서만 매핑한다.

        - PostMapping

            Post 메서드에 대해서만 매핑한다.

        - params 조건

            조건 삽입이 가능하다.

            - *params = "mode"*
            - *params = "!mode"*
            - *params = "mode=debug"*
            - *params = "mode!=debug"*
            - *params = {"mode-debug","data=good"}*
        - headers 조건

            조건 삽입이 가능하다.

            - headers *= "mode"*
            - headers *= "!mode"*
            - headers *= "mode=debug"*
            - headers *= "mode!=debug"*
            - headers *= {"mode-debug","data=good"}*
        - content-type 조건 [consume]

            조건 삽입이 가능하다.

            - *consumes = "application/json"*
            - *consumes = "!application/json"*
            - *consumes = "application/*"*
            - *consumes = "*\/*"*
        - accept 조건 [produce, 클라이언트 측 받는 조건]

            조건 삽입이 가능하다.

            - produce*s = "text/html"*
            - produce*s = "!text/html"*
            - produce*s = "text/*"*
            - produce*s = "*\/*"*
    - **@Controller vs @RestController**
        - @Controller

            @RequestMapping의 리턴이 String이면 뷰의 이름이라고 생각하고 이 스트링을 뷰 리졸버에 던짐

        - @RestController

            @RequestMapping의 리턴이 String이면 그대로 스트링을 Http Body에 넣고 리턴


        **만약 @Contoller사용 도중 @RestController처럼 http body에 바로 데이터를 넣고싶다면**

        **@ResponseBody 이 어노테이션을 해당 메서드에 붙여주면된다.**

    - Logging

        slf4j를 사용한 방법

        @Slf4j를 롬복을 통해 적용

        log.debug(“name={}”,name);

        이런식으로 사용

        다만

        log.trace(“name={}”+name);

        이렇게 쓰면 혼남, 만약 로깅레벨이 debug로걸어놓고서 trace를 하는것 자체가 cpu에 리소스를 소모해서 + 연산까지 해가며 출력하는건데 문제는 출력을 하진 않지만 + 연산은 함 → 쓸때없는 리소스 소모

    - **요청 파라미터**
        - @Controller의 사용가능한 파라미터 목록

            > [https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-arguments)arguments
            >
        - @Controller의 사용가능한 응답값 목록

            > [https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-return-types](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-return-types)
            >
        - @RequestParam
            - 특징
                1. 파라미터 키 값과 파라미터 이름이 같으면 어노테이션 생략 가능
                2. required옵션으로 필수값 지정 가능
                3. defaultValue로 기본값 지정 가능 → 기본 값 지정 시 필수값 지정이 딱히 필요 없음

                    **참고로, 빈 문자까지 null로 인지해서 기본값으로 대체한다.**

                4. Map으로 받을 수도 있다.

                    **참고로, Map 또는 MultiValueMap으로 받을 수 있고 MultiValueMap의 경우는 value가 List이다.**

            - 주의 사항
                - 기본형(ex:int, char…)일때 null삽입시 컴파일 에러 발생하므로 객체형 (ex: Integer, String)으로 넣어서 Nullable하게 만들어줘야 오류방지됨!!!
        - @ModelAttribute
            - 특징
                1. @ModelAttirbute를 넣어 데이터 클래스의 프로퍼티와 동일한 쿼리 파라미터를 넣어주게되면 알아서 데이터가 바인딩 된다. 어노테이션 생략도 된다.
                2. **@ModelAttribute(”itemA”) 이렇게 네임 지정시 자동으로 itemA라는 모델에 @ModelAttribute로 지정한 객체를 자동으로 넣어준다.**
                3. **@ModelAttirbute 그냥 디폴트로 사용시 모델 객체의 앞글자만 소문자로 만든 객체를 자동으로 모델로 지정해 객체를 자동으로 넣어버린다. 디폴트로도 뷰 모델 객체에 바인딩을 해버린다.**
                4. **메서드 레벨에 이름과 같이 넣어주게 되면 이 메서드에서 반환한 값이 자동으로 이름 : 값으로 모델에 담기게 된다.**
                5. **결론: 이 어노테이션 자체도 생략이 가능하기 때문에 그냥 객체를 넣어버리면 알아서 동작하는 것처럼 보이게 된다.**
        - @RequestParam vs @ModelAttribute 생략시 구분법

            기본형을 파라미터로 사용한다면 → @RequestParam

            데이터 객체를 파라미터로 사용한다면 → @ModelAttribute

            참고로, ArgumentResolver에 등록된 객체는 이 처리에서 제외처리된다. (Ex HttpServletRequest, HttpServletResponse…)

    - **메세지 바디 [HttpMessageConverter]**
        - **@ReqeustBody**

            파라미터에 이 어노테이션을 넣어주게되면 알아서 메시지 바디(String)를 파싱해준다.

             String이 아닌 직접 만든 객체도 지정 가능하다 (@ModelAttribute와 비슷)

            그러나 **생략할시 @ModelAttribute로 자동으로 동작하게 되니 절때 생략해서는 안된다.**

        - **@ResponseBody**

            메서드에 이 어노테이션을 붙여주게되면 알아서 메시지 바디에 String을 넣어서 반환해준다.

            String이 아닌 직접 만든 객체도 반환 가능하다.

            클래스 레벨에 붙여서 공통으로 적용도 가능하지만 그냥 @RestController를 사용하자.

            단, **상태코드 지정이 어노테이션을 이용하는 방법 이외에는 없어서 동적으로 리턴하기 위해선 HttpEntity를 이용해야한다.**

    - **메세지 컨버터**

        스프링부트는 메시지 컨버터를 제공한다.HttpMessageConverter

        다음 구현체들은 대상 클래스 타입과 미디어 타입 둘다 체크하여 사용여부를 결정한다.

        - 종류
            1. ByteArrayHttpMessageConverter
            2. StringHttpMessageConverter
            3. MappingJackson2HttpMessageConverter
    - **요청 매핑 핸들러 어뎁터 구조**
        - RequestMappingHandlerAdapter 동작방식
            1. **Argument Resolver호출**

                Argument Resolver에 컨트롤러의 파라미터, 애노테이션 정보를 기반으로 전달 데이터 생성


            (ex: HttpServletRequest, HttpServletResponse, @RequestParam, @ModelAttribute, @RequestBody, HttpEntity…)

            1. 해당하는 파라미터 호출
            2. **ReturnValueHandler 호출**

                컨트롤러의 반환 값을 변환

                (ex: ModelAndView, @ResponseBody, HttpEntity…)


            스프링에는 30가지가 넘는 ArgumentResolver가 존재한다.

            > [https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-arguments](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-arguments)
            >

            ReturnValueHandler도 마찬가지로 여러 ReturnValueHandler가 존재한다.

            > [https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-return-types](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-return-types)
            >

            각 1, 3 과정에서 Resolver와 Handler 내부에서 사용가능한 컨버터를 for문 돌려서 찾아낸다.

            - **확장 방법**

                이 모든 과정들에는 결국 핵심 인터페이스들이 존재한다. 이 확장을 돕는 클래스도 있다.

                 **WebMvcConfigurer를 상속 받아 @Bean을 통해 스프링 빈으로 등록하여 확장**하는 것이다.

    - Http 응답
        - 정적 리소스

            html, css, js등등

        - 뷰 탬플릿

            동적인 html [SSR]

            - 기본 경로

                resources/template

                스프링 부트는 이 경로에 있는 html은 뷰 템플릿으로 제공한다.

            - 뷰 컨트롤러에서 void를 사용하는 경우[권장X]

                @Controller에서 HttpServletResponse나 OutputStream(Writer) 같은 메시지 바디를 처리하는 파라미터가 없을시 요청 url을 논리뷰의 이름으로 사용

        - Http 메시지

            JSON 데이터

    - **로컬라이징**
        - 스프링 부트 기준

            messages.properties파일에 각각 키워드 들을 설정해준다.

            그리고 마지막에 _ko나 _en을 붙여 어느 국가의 키워드인지도 설정해준다.

            총 한국 영어 두 언어를 설정해주고 싶다면 3가지 파일들을 준비한다.

            - messages.properties
            - messages_en.properties
            - messages_ko.properties

            여기서 그냥 messages파일은 기본값에 해당한다.

            http accept-language헤더나 쿠키에 들어있는 값으로 스프링이 자동으로 판단해준다.

            마지막으로 application.properties에 세팅한다.

            `spring.messages.basename=messages,config.i18n.messages`
            처음 messages는 빈네임이고 뒤에 config.i18n.messages는 이 파일의 위치정보이다.

            resource 폴더 기준이다.

        - 스프링 기준

            빈등록이 필요하다.

            ```java
            @Bean
              public MessageSource messageSource() {
                  ResourceBundleMessageSource messageSource = new
              ResourceBundleMessageSource();
                  messageSource.setBasenames("messages", "errors");
                  messageSource.setDefaultEncoding("utf-8");
                  return messageSource;
            }
            ```

            setBeanNames로 설정파일을 지정하는데 룰은 스프링 부트와 동일하다. 스프링부트는 이런 빈등록을 자동으로 해주기 때문에 이 절차가 필요 없다.

        - 타임리프를 이용한 적용

            `#{...}` 표현식을 이용해 th:text로 지정해주면 된다.

            - 파라미터 사용시

                `<p th:text="#{hello.name(${item.itemName})}"></p>`

        - **LocaleResolver**
            - LocaleResolver를 직접 구현체를 변경해서 만들어 쿠키나 세션기반의 locale을 선택하도록 사용할 수 있다.
            - 디폴트

                AcceptHeaderLocaleResolver

    - Validation
        - 검증로직 직접 삽입 방식

            error hashMap을 model attribute에 추가해 다음 페이지에 넣어준다.

        - BindingResult 활용 방식

            매핑 핸들러 파라미터에 **@ModelAttribute Item item 뒤에 바로 BindingResult bindingResult 이렇게 파라미터를 추가해 줘야한다.** **그 이유는 item 객체의 binding결과를 BindingResult가 들고 있기 때문이다. 그리고 이 BindingResult가 있어야 컨트롤러에서 400에러로 바로 리턴하지 않고 핸들러를 통과시켜준다.**

            - 예시

                ```java
                public String addItem(
                						@ModelAttribute Item item,
                						BindingResult bindingResult,
                						RedirectAttributes redirectAttributes,
                						Model model) {

                	....

                }
                ```


            그리고 `bindingResult.addError` 를 활용해 각 에러를 생성해서 넣어주면 된다.

            ```java
            bindingResult.addError(new FieldError("item","itemName","상품 이름은 필수 입니다."));
            ```

            **글로벌 에러는 ObjectError로 만들어서 넣어주면된다.** 각종 에러 객체의 부모 에러 객체이다.

            - 바인딩 **에러시 사용자가 입력한 값 유지하기 [v2]**

                ```java
                bindingResult.addError(new FieldError("item","itemName",item.getItemName(),false,null,null,"상품 이름은 필수 입니다."));

                bindingResult.addError(new ObjectError("item",null,null,"가격 * 수량의 결과가 10,000원 이상이여야 합니다. 현재 값 = "+result));
                ```

            - **errors.properties를 추가해 메시지 소스를 활용하기 [v3]**
                - errors.properties

                    ```yaml
                    #required.item.itemName=상품 이름은 필수입니다.
                    range.item.price=가격은 {0} ~ {1} 까지 허용합니다.
                    max.item.quantity=수량은 최대 {0} 까지 허용합니다.
                    totalPriceMin=가격 * 수량의 합은 {0}원 이상이어야 합니다. 현재 값 = {1}

                    #level 1
                    required=필수값입니다.
                    #level 2
                    required.item.itemName=상품 이름은 필수입니다.
                    ```

                    errors의 properties는 상세한 레벨일 수록 우선순위가 더 높고 먼저 조회하게 된다.

                    에러 메시지의 설계 방식은 보통 이렇다.

                    1. 범용적인 저레벨 메시지 생성
                    2. 전용적인 요구사항이 들어오면 그때 객체명과 프로퍼티 명에 맞는 레벨을 생성한다.

                    그리고 **rejectValue를 사용한 방식으로 사용하면 저레벨메시지 명으로 통일이 가능해 더욱 확장성있게 개발이 가능해진다.**

                    스프링은 이것들을 **MessageCodesResolver**라는 것으로 기능을 지원한다.

                - 예시

                    ```java
                    bindingResult.addError(new FieldError("item","itemName",item.getItemName(),false,new String[]{"required.item.itemName"},null,null));

                    bindingResult.addError(new ObjectError("item",new String[]{"totalPriceMin"},new Object[]{10000,result},null));
                    ```

                    이런식으로 설계해야 문제 없이 확장적으로 받아들인다.

            - **rejectValue(), reject()를 활용하기** **[v4]**

                ```java
                bindingResult.rejectValue("itemName","required");

                bindingResult.reject("totalPriceMin",new Object[]{10000,result},null);
                ```

            - **ValidationUtils 활용하기**

                ```java
                /// 사용전
                if(!StringUtils.hasText(item.getItemName())){
                       bindingResult.rejectValue("itemName","required");
                }

                /// 사용후
                ValidationUtils.rejectIfEmptyOrWhitespace(bindingResult,"itemName","required");

                ```

            - Validator를 이용해 분리하기
                - Validator로직 분리

                    ```java
                    @Component
                    public class ItemValidator implements Validator {

                        @Override
                        public boolean supports(Class<?> clazz) {
                            return Item.class.isAssignableFrom(clazz);
                        }

                        @Override
                        public void validate(Object target, Errors errors) {
                            Item item = (Item) target;

                            // 검증 로직
                            ValidationUtils.rejectIfEmptyOrWhitespace(errors,"itemName","required");
                            if(!StringUtils.hasText(item.getItemName())){
                                errors.rejectValue("itemName","required");
                            }

                            if(item.getPrice() ==null || item.getPrice() < 1000 || item.getPrice() > 1000000 ){
                                errors.rejectValue("price","range",new Object[]{1000,1000000},null);

                            }

                            if(item.getQuantity() ==null || item.getQuantity() >= 9999 ){
                                errors.rejectValue("quantity","max",new Object[]{9999},null);
                            }

                            //특정 필드 검사 이후 특정 룰 추가 검증
                            if (item.getPrice()!= null && item.getQuantity()!= null){
                                int result = item.getPrice() * item.getQuantity();
                                if (result < 10000){
                                    errors.reject("totalPriceMin",new Object[]{10000,result},null);
                                }
                            }

                        }
                    }
                    ```

                - 빈 주입 이후 예시

                    ```java
                    @PostMapping("/add")
                    public String addItemV5(@ModelAttribute Item item, BindingResult bindingResult, RedirectAttributes redirectAttributes, Model model) {

                            // 검증
                            if(itemValidator.supports(Item.class)){
                                itemValidator.validate(item,bindingResult);
                            }

                            // 검증 실패시 다시 입력 폼으로
                            if(bindingResult.hasErrors()){
                                log.info("errors = {}",bindingResult.getAllErrors());
                                model.addAttribute("errors",bindingResult.getAllErrors());
                                return "validation/v2/addForm";
                            }

                            // 성공 로직
                            Item savedItem = itemRepository.save(item);
                            redirectAttributes.addAttribute("itemId", savedItem.getId());
                            redirectAttributes.addAttribute("status", true);
                            return "redirect:/validation/v2/items/{itemId}";
                        }
                    ```

                - WebDataBinder를 활용하기

                    WebDataBinder는 스프링의 파라미터 바인딩 역할을 해준다.

                    - 예시

                        ```java
                        @InitBinder
                        public void init(WebDataBinder dataBinder) {
                             log.info("init binder {}", dataBinder);
                             dataBinder.addValidators(itemValidator);
                        }
                        ...
                        @PostMapping("/add")
                        public String addItemV6(@Validated @ModelAttribute Item item, BindingResult bindingResult, RedirectAttributes redirectAttributes, Model model) {
                        ...
                        }
                        ```

                        이 init은 클라이언트 요청이 init메서드가 들어간 핸들러에 매핑이 될때마다 호출이 되며 WebDataBinder가 계속 새로 만들어져 이 validator를 넣어주게 된다.

                        그리고 Validator가 필요한 메서드의 파라미터로 넣어주면 된다.

                        그리고 Validator의 supports가 이때 사용이 된다. DispatcherServlet의 핸들러어뎁터를 매핑하는 과정과 똑같다

                    - 전역 사용 예시

                        ```java
                        @SpringBootApplication
                          public class ItemServiceApplication implements WebMvcConfigurer {
                              public static void main(String[] args) {
                                  SpringApplication.run(ItemServiceApplication.class, args);
                        }
                              @Override
                              public Validator getValidator() {
                                  return new ItemValidator();
                              }
                        }
                        ```

                        WebMvcConfigurer를 implements로 받아서 구현하면 되는데 이 세팅을 하는 경우는 매우 드물며 **BeanValidator**를 훨씬 많이 사용한다. 그리고 이렇게 등록을 해버리면 **BeanValidator**를 사용할 수 없으니 그냥 안하는게 낫다.

            - **MessageCodeResolver**

                검증 오류 코드로 메시지 코드들을 생성한다.DefaultMessageCodesResolver가 디폴트다

                - DefaultMessageCodesResolver 규칙
                    - 객체 오류

                        총 2개 생성

                        1. code + “.” + obejct name
                        2. code
                        - 예시

                            required.item

                            required

                    - 필드 오류

                        총 4개 생성

                        1. code + “.” + obejct name + “.” + field
                        2. code + “.” + field
                        3. code + “.” + field type [ex: String]
                        4. code
                        - 예시

                            required.item.itemName

                            required.itemName

                            required.java.lang.String

                            required
                            ****

            - 타임리프 활용 예시
                - `#fields`

                    BindingResult에 있는 검증 오류에 접근을 할수 있다.

                - `th:errors`

                    해당 필드에 오류가 있는 경우 소속 태그를 렌더링 해준다. th:if의 편의 버전이다.

                - `th:errorclass`

                    th:field에 지정된 필드에 오류가 있으면 classappend를 해준다.

                - **주의사항**

                    `**#fields` 는 `th:object` 태그 내부에서 써야 커맨드 객체인 item의 바인딩 결과 객체에 접근이 가능하므로 반드시 th:object내부에서 `#fields` 에 접근해야한다.**

                - 예시

                    ```html
                    <form action="item.html" th:action th:object="${item}" method="post">

                    <div th:if="${#fields.hasGlobalErrors()}">
                                <p class="field-error" th:each="err : ${#fields.globalErrors()}" th:text="${err}">전체 오류 메시지</p>
                            </div>
                    <div>
                                <label for="itemName" th:text="#{label.item.itemName}">상품명</label>
                                <input type="text" id="itemName" th:field="*{itemName}" class="form-control" th:errorclass="field-error" placeholder="이름을 입력하세요">
                                <div th:errors="*{itemName}">
                                    <p class="field-error" th:text="${errors['itemName']}">전체 오류 메시지</p>
                                </div>
                            </div>
                    .....
                    ```

    - Bean Validation

        Bean Validation 2.0(JSR-380) 기술 표준

        - 대표적 구현체

            하이버네이트 Validator

            [Hibernate Validator 7.0.4.Final - Jakarta Bean Validation Reference Implementation: Reference Guide](https://docs.jboss.org/hibernate/validator/6.2/reference/en-US/html_single/#validator-defineconstraints-spec)

        - 예시

            ```java
            @Data
            public class Item {

                private Long id;

                @NotBlank
                private String itemName;

                @NotNull
                @Range(min=1000,max=1000000)
                private Integer price;

                @NotNull
                @Max(9999)
                private Integer quantity;

                public Item() {
                }

                public Item(String itemName, Integer price, Integer quantity) {
                    this.itemName = itemName;
                    this.price = price;
                    this.quantity = quantity;
                }
            }
            ```

        - 검증 순서
            1. @ModelAttirbute 각각의 필드에 타입 변환 시도
                1. 성공시 다음으로
                2. 실패시 typeMismatch로 FieldError 추가
            2. Validator 적용

            바인딩에 실패한 필드는 BeanValidation 적용을 하지 않는다.

            - 예시
                - 성공시
                    1. itemName에 “A” 문자입력
                    2. 타입변환 성공
                    3. itemName 필드에 BeanValidation 적용
                - 실패시
                    1. price에 “A” 문자입력
                    2. 타입변환 실패
                    3. typeMismatch FieldError 추가
                    4. price 필드에 BeanValidation 적용 X
        - Bean Validation 전용 에러 메시지 종류
            - @NotBlank 예시

                NotBlank.item.itemName

                NotBlank.itemName

                NotBlank.java.lang.String

                NotBlank


            보면 기존 **DefaultMessageCodesResolver와 규칙은 같다.** 다만 **에러 코드가 어노테이션의 이름**이다.

        - Bean Validation 메시지 조회 순서
            1. messagesource에서 조회
            2. 애노테이션 message 속성 조회
            3. 라이브러리가 제공하는 기본 값 (ex: 공백일 수 없습니다.)
        - Bean Validation 오브젝트 에러
            - @ScriptAssert()를 적용

                ```java
                @Data
                @ScriptAssert(lang = "javascript", script = "_this.price * _this.quantity >= 10000")
                public class Item {
                		//...
                }
                ```

                그러나 이방식은 너무 기능이 빈약하다. 그래서 ObjectError는 따로 BindingResult에 등록하는 방식이 더 자바코드로 표현하기도 좋고 더 복잡한 연산을 수행하기에도 좋고 확장성도 좋다.

                **사용을 권장하지 않는다.**

        - Bean Validation 한계및 해결 방안

            Bean Validation 어노테이션을 적용한 데이터모델의 규칙들을 때에 따라 따로따로 검증룰을 적용해줄수가 없다.

            예를들면 **등록, 수정때 따로따로 규칙을 적용해주는 것이 불가능하다.**

            - 해결방안
                1. **Bean Validation - groups기능**을 사용한다.
                2. Item 모델을 ItemSaveForm, ItemUpdateForm등으로 만들어 사용한다.

                    이러한 모델들을 **폼 데이터 전송객체(DTO의 일종)** 혹은 **커맨드 객체**라고 부른다.

            - **Bean Validation - groups**
                1. 인터페이스를 2개를 만들고 각각 SaveCheck, UpdateCheck로 만든다
                2. Item내부 객체에 각각 groups를 넣어서 둘다 필요한 상황엔 둘다 넣고, 하나만 필요한 상황에는 하나만 넣어준다.
                3. addForm과 editForm 각각 파라미터에 있는 @Validated 애노테이션에 @Validated(SaveCheck.class), @Validated(UpdateCheck.class) 값을 넣어준다.
                - **주의사항**

                    **@Valid는 지원 되지 않는다. 스프링 전용 기능이다. 이기능은 실무에서 사용하지 않는다. 복잡도가 올라가고 자바 전용 기술 표준이 아니기 때문에 한계도 있다.**

            - **폼 데이터 전송객체**
                1. 기존 도메인 모델인 Item에 규칙을 전부 제거한다.
                2. 각각 ItemSaveForm,ItemUpdateForm 폼 전용 DTO 모델을 만들고 규칙을 여기에 옮겨서 넣는다.
                3. 핸들러에 각각 적용한다.
        - Bean Validation Http messageConvertor

            @RequestBody를 이용해 객체에 json을 바인딩을하는데 HttpMessageConvertor에서 한다.

            그런데 이 **HttpMessageConvertor단계에서 예외가 발생하면 핸들러에 넘어가지도 못하고 400에러를 뱉는다! 원하는 모양으로 예외 처리를 하는 것은 따로 지정해야한다.**

    - Session
        - 세션 세팅 방법

            ```java
            #cookie 사용시 url에 sessionId 붙여서 트래킹을 해주는 모드를 꺼줌
            #(쿠키가 없는 브라우저 하위호환을 위해 존재하는 모드)
            #보통 서비스하는 사이트들은 이게 없다.
            server.servlet.session.tracking-modes=cookie
            #글로벌 세션쿠키 타임아웃 설정 (최소 60초)
            server.servlet.session.timeout=1800
            ```

    - Filter & Intercepter

        웹과 관련된 공통관심사를 처리하기 위해 사용하는 웹 요청 수문장 기능

        aop도 있지만 웹과 관련된 기능을 위해 사용할땐 인터셉터를 사용하는게 맞다.

        - Filter

            **스프링 빈으로써 동작, 싱글톤이기 때문에 주의해서 사용해야함**

            **만약 HTTP 요청시 같은 요청 로그에 모두 같은 식별자를 남기게 하고싶다면 logback mdc를 찾아보자**

            - 실행 흐름
                1. HTTP 요청
                2. WAS
                3. **Filter ←**
                4. Servlet
                5. Controller(Handler)
            - 주요 기능
                - 필터 제한

                    적절하지 않는 요청이라고 판단하면 서블릿 호출을 하지 않는 기능

                - 필터 체인

                    필터 앞뒤로 필터를 추가하거나 빼는 기능.

            - 구현 방법
                1. Filter 인터페이스를 구현한다.
                2. @Configuration + @Bean 수동 빈등록 조합으로 `FilterRegistrationBean` 을 반환하는 빈을 등록한다.

                    ```java
                    @Configuration
                    public class WebConfig {

                        @Bean
                        public FilterRegistrationBean logFilter(){
                            FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>();
                            registrationBean.setFilter(new LogFilter());
                            registrationBean.setOrder(1);
                            registrationBean.addUrlPatterns("/*");

                            return registrationBean;
                        }

                    }
                    ```

        - Intercepter

            스프링에서 제공하는 필터 기술이다. 스프링 MVC에 특화된 필터 기능을 구현하고 있다.

            서블릿에서 제공하는 필터와 다르게 동작하니 주의할 것

            - 실행흐름
                1. HTTP 요청
                2. WAS
                3. **Filter ← 위치가 상대적으로 필터가 앞에서 실행된다.**
                4. Servlet
                5. **Spring Intercepter ← 인터셉터는 컨트롤러 들어가기 직전에 실행된다.**
                6. Controller(Handler)
            - 주요 기능
                - 인터셉터 제한

                    필터와 동일하다.

                - 인터셉터 체인

                    필터와 동일하다.

                - 주요 메서드
                    - 컨트롤러에서 예외 발생시

                        postHandle은 호출되지 않지만 afterCompletion은 예외가 터지든 말든 항상 호출됨, 이때 afterCompletion은 파라미터로 예외를 받아 볼 수 있다.(정상일때는 null)

                    - preHandle
                        - 호출시기

                            핸들러 어뎁터 호출전

                        - 파라미터 종류
                            1. HttpServletRequest
                            2. HttpServletResponse
                            3. Object handler
                    - postHandle
                        - 호출 시기

                            핸들러 호출 이후

                        - 파라미터 종류
                            1. HttpServletRequest
                            2. HttpServletResponse
                            3. Object handler
                            4. ModelAndView
                    - afterCompletion
                        - 호출 시기

                            뷰가 렌더링된 이후

                        - 파라미터
                            1. HttpServletRequest
                            2. HttpServletResponse
                            3. Object handler
                            4. Exception
            - 구현 방법
                1. HandlerIntercepter를 구현한다.
                2. @Configuration + @Bean 수동 빈등록 조합으로 `WebMvcConfigurer` 를 implements해 `addInterceptors()` 를 override한다.

                    ```java
                    @Override
                    public void addInterceptors(InterceptorRegistry registry) {
                            registry.addInterceptor(new LogIntercepter())
                                    .order(1)
                                    .addPathPatterns("/**")
                                    .excludePathPatterns("/css/**","/*.ico","/error");
                    }
                    ```

            - 특이 사항

                spring의 pathPattern을 적용하여 인터셉터를 세팅해야한다.

                [PathPattern (Spring Framework 5.3.17 API)](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/util/pattern/PathPattern.html)

                규칙은 다음과 같다.

                - ?

                    한 문자 일치

                - *

                    경로(/) 안에서 0개 이상의 문자 일치

                - **

                    경로 끝까지 0개 이상의 경로(/) 일치

                - {spring}

                    경로(/)와 일치하고 spring이라는 변수로 캡처

                - {spring:[a-z]+}

                    regexp [a-z]+ 와 일치하고, "spring" 경로 변수로 캡처

                - {*spring}

                    경로가 끝날 때 까지 0개 이상의 경로(/)와 일치하고 spring이라는 변수로 캡처

        - ArgumentResolver 활용
            - 실행 흐름
                1. HTTP 요청
                2. WAS
                3. Servlet
                4. Handler Adapter mapping (supports 되는 ArgumentResolver 탐색)
                5. 직접 만든 ArgumentResolver 채택
                6. resolveArgument 실행
                7. 컨트롤러(Handler) 실행
            - 구현 방법
                1. Login 애노테이션 생성및 구현
                2. LoginMemberArgumentResolver 생성 및 구현 (implements `HandlerMethodArgumentResolver`)
                3. WebMvcConfigurer를 구체 클래스에 override추가

                    ```java
                    @Override
                    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
                            resolvers.add(new LoginMemberArgumentResolver());
                    }
                    ```

    - Exception - 에러페이지
        - 예외 발생시 전파 순서
            1. WAS
            2. Filter
            3. Servlet
            4. Intercepter
            5. Controller(Handler) - 예외발생시 ↑로 전파

            기본적으로 WAS(ex: Tomcat)도 오류처리 페이지를 가지고 있다. 예외를 발생시키면 WAS가 지닌 오류 페이지를 올려준다.

        - 주의점

            스프링부트는 예외 페이지 개발시작시 `server.error.whitelabel.enabled=false`

            이 설정 넣어주고 시작해야한다...! 기본 예외 페이지를 꺼주는 설정이다.

        - 예외 발생 방법
            1. exception 스로잉

                기본적으로 WAS(ex: Tomcat)도 오류처리 페이지를 가지고 있다. 예외를 발생시키면 WAS가 지닌 오류 페이지를 올려준다. **이 예외는 보통 무조건 500을 던져버린다.**

            2. response.sendError()

                컨트롤러에서 서블릿으로 오류 발생사실을 넘겨주는 방법이다.

                이때, 상태코드, 메시지를 넘길수있고 이때 이 메시지를 또 국제화해주거나 메시지 소스로 컨트롤 할수 있다.

        - 오류 페이지 설정 방법

            오류페이지를 설정하고 해당하는 오류가 발생하면 오류페이지로 WAS가 자동으로 다시 요청을 보낸다.

            에러가 위로 전파되었다가. 다시 View 요청을 아래로 보내는 구조이다.

            **클라이언트는 이 전파 구조를 모른다. 서버 내부에서만 View를 찾기위해 이렇게 다시 한번 요청을 보낸다. 이때, 필터, 서블릿, 인터셉터, 컨트롤러가 다 다시 호출된다.**

            - 레거시 스프링

                web.xml에 오류페이지를 지정해준다.

            - 스프링부트
                1. `WebServerFactoryCustomizer<ConfigurableWebServerFactory>` 구현체를 만든다.
                2. 오버라이드 메서드 `customize` 에서 각 에러페이지들을 추가해주고 펙터리에 추가한다.
                3. 이 설정용 구현체 클래스를 컴포넌트로 등록한다.

                자바코드로 설정하는 것과 xml로 설정하는 것은 항상 논의가 많다. 사실 xml도 알고보면 자바코드를 통해서 돌아가는 구조이긴하다. 선언형 스타일을 챙겨갈지, 자바 코드로 일관성 있는 어플리케이션 스타일을 가져갈지 이건 솔직히 나도 잘 모르겠다.

        - Filter 활용 방법

            이 2번 요청되는 문제때문에 필터에서는 서버 내부 문제로 발생한 요청인지 정상적으로 클라이언트에서 요청한 요청인지 필터에서 구분을 해주어야한다. 로그인과 마찬가지이다. 이것을 DispatcherType으로 구분하고 있다.

            - DispatcherType
                - 클라이언트 요청시

                    REQUEST

                - 서버 내부 오류로 인한 요청시

                    ERROR

                - 서블릿에서 다른 서블릿이나 JSP 호출시

                    FORWARD

                - 서블릿이나 다른 서블릿이나 JSP 결과를 포함하는 경우

                    INCLUDE

                - 서블릿 비동기 호출시

                    ASYNC

            - 지정 방법
                1. 에러용 필터를 만든다.(필터 구현체)
                2. `WebMvcConfigurer` 구현체를 만들고 설정한다.
                    1. 이때, 필터에 넣어줄  DispatcherType을 enum으로 넣어준다.

                2.a 에서 지정한것처럼 특정 에러일때만 로그를 찍을려면 이렇게 필터를 걸어주면 된다.

        - 인터셉터 활용 방법

            filter와 마찬가지로 특정 요청에 대해 인터셉트를 해주고싶다면 그냥 exclude 매핑에 패턴을 이용해야한다.[springEL] 이 경로 패턴으로 오류 페이지 경로에 대해서 인터셉터를 하여 로깅을 해주는 방식이다.

        - 기본 스프링 부트 활용 방법

            스프링 부트는 BasicErrorController를 기본으로 등록한다.

            굳이 커스텀마이즈를 할 필요는 없다. 자동으로 /error를 기본 요청하게끔 되어있다.

            그냥 에러페이지만 넣어주면 끗이다.

            - BasicErrorController 처리 순서
                1. 뷰 탬플릿
                    - resources/templates/error/500.html
                    - resources/templates/error/5xx.html
                2. 정적 리소스
                    - resources/static/error/400.html
                    - resources/static/error/404.html
                    - resources/static/error/4xx.html
                3. 둘다 없는 경우
                    - resources/templates/error.html
            - BasicErrorController 오류 노출 정보 관련 설정 방법

                일반적으로 이건 보안상 문제가 되므로 아예 노출을 하지 않는 것이 맞다.

                로그로만 남겨서 확인하는것이 옳다. **건드리지 말자**

                - server.error.include-exception=false // 예외 정보 관련
                - server.error.include-message=never //메시지 포함 여부
                - server.error.include-stacktrace=never // 오류 콜 스택 포함 여부
                - server.error.include-binding-errors=never // 에러 포함 여부
    - Exception - rest api

        api 예외처리는 정확한 오류 스팩을 적어서 json 직렬화하여 보내야한다.

        그러나 지금 상황에서 그냥 예외를 던져버리면 html 페이지가 던져진다.

        api 요청에 대한 정보만 오류 처리하는 컨트롤러로 해결하면 된다.

        - 구현 방법
            1. @RequestMapping(value=”/500”, produces=MediaType.APPLICATION_JSON_VALUE)

                이것을 사용해서 Accept가 application/json인 api 전용 요청의 에러처리 요청을 처리한다.

            2. ResponseEntity로 리턴하면된다.

            근데 스프링 부트는 BasicErrorController에 기본적으로 개발되어있다.

            그러나 api는 보통 api 마다 예외 메시지 스팩이 죄다 다르다. 이것은 따로 리졸버를 등록해야한다.

        - HandlerExceptionResolver

            만약 특정 예외들만 골라서 afterComplition 이전에 리턴을 조작하고 싶다면 이 예외리졸버에 로직을 넣어 등록해주면 된다.

            여러개 등록도 된다.

            - 주요 역할
                - 예외 상태 코드 변환
                - 뷰 템플릿 처리
                - API 응답 처리
            - 구현 방법
                1. HandlerExceptionResolver의 구현체를 만든다.
                2. `resolveException` 을 오버라이드한다.
                3. response.sendError 직접 새 오류로 세팅한다.
                    1. 빈 ModelAndView를 리턴하면 뷰를 렌더링하지 않고 정상흐름으로 서블릿이 리턴된다.
                    2. ModelAndView를 지정하면 뷰를 렌더링한다.
                    3. null을 반환하면 다음 ExceptionHandler를 찾아서 실행한다.만약 발견을 못하면 기존의 발생한 예외를 서블릿 밖으로 던진다.
                4. `WebMvcConfigurer` 구현체에 `extendHandlerExceptionResolvers` 를 오버라이드한다.
                5. 직접 만든 HandlerExceptionResolver를 등록한다.
            - **주의 할점**

                `extendHandlerExceptionResolvers` 를 안쓰고 `configureHandlerExceptionResolvers` 를 쓰면 기존에 등록된 기본 ExceptionResolver가 날라간다!!!

            - 스프링 부트에서 제공하는 기본 ExceptionResolver
                - ExceptionHandlerExceptionResolver

                    [Web on Servlet Stack](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-exceptionhandler-args)

                    @ExceptionHandler를 처리

                    api 예외 처리는 대부분 이 기능으로 해결한다.

                    예외 처리를 정상 흐름으로 만들어준다.

                    내부적으로는 빈 ModelAndView를 반환하게끔 되어있다.

                    보통 실수로 놓치는 예외들까지 커버하기 위해 그냥 Exception도 등록해서 쓴다.

                    - 구현 방법
                        1. DTO 생성
                        2. 예외 처리 메서드를 만들고 @ExceptionHandler(Exception.class)이런식으로 어노테이션을 달아준다.
                        3. 반환은 DTO로 해준다.
                        4. @ResponseStatus로 응답 코드도 설정해준다.
                - ResponseStatusExceptionResolver

                    예외에 따라 HTTP 상태코드 지정

                    - 적용 기준
                        1. @ResponseStatus
                        2. ResponseStatusException

                    거는 방법은 쉽지만 이미 있는 예외에는 써먹기가 귀찮고 힘들다.

                    ResponseStatusException로 래핑해주면 편하게 동적으로 만들어 써먹을수있다.

                - DefaultHandlerExceptionResolver

                    스프링 내부 기본 예외를 처리

            - 예외 처리 로직 분리, 지정하기 @ControllerAdvice
                - 규칙
                    1. @ControllerAdvice(annotations = RestController.class)

                        특정 어노테이션에만 지정

                    2. @ControllerAdvice(”org.example.controllers”)

                        특정 패키지 폴더에만 적용

                    3. @ControllerAdvice(assignableTypes = {ControllerInterface.class, AbstractController.class})

                        특정 클래스에만 적용


                **@RestControllerAdvice는 @ControllerAdvice에 @ResponseBody가 붙은거랑 같다.**

    - 타입 컨버터
        - **주의사항**

            메시지 컨버터(HttpMassgeConverter)에는 컨버전 서비스를 적용하지 않는다.

            Http바디 → 객체, 객체 → Http 바디 이기 때문에 기본적으로 포멧팅과 관련된 이 타입 컨버터와는 전혀 관계가 없다.

            그렇기 때문에 **Json에 데이터 포멧팅을 하려면 Jackson 데이터 포멧팅 이라고 검색해야한다.**

        - 기본적으로 자동 적용되어있는 곳 예시
            - @RequestParam
            - @ModelAttribute
            - @PathVariable
        - 스프링 자체에서 지원하는 컨버터 종류

            보통은 이것들을 다 일일히 사용하진 않고 모아서 사용하게 해주는 컨버전 서비스를 이용한다.

            [Core Technologies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#core-convert)

            - Converter

                기본 타입 컨버터

            - ConverterFactory

                전체 클래스 계층 구조가 필요할 때

            - GenericConverter

                정교한 구현, 대상 필드의 애노테이션 정보 사용가능

            - ConditionalGenericConverter

                특정 조건이 참인 경우에만 실행

        - 컨버전 서비스

            컨버전 서비스가 상속 받는 인터페이스에는

            컨버전 사용에 초점을 둔 인터페이스와

            컨버전 등록에 초점을 둔 인터페이스를 둘다 상속 받고 있다.

            이를 이용해 ISP(인터페이스 분리 원칙)를 만들어 내는 것이다.

            이제 이 컨버전 서비스가 스프링에서 사용된다.

            - 사용법
                1. 각각 구현했던 컨버터들을 컨버전 서비스에 등록한다.
                2. 컨버전서비스의 convert()를 사용해 사용한다.
        - 컨버전 서비스 - 스프링
            - 적용방법
            1. WebConfiguarur 구현체에 addFormatters 메서드를 오버라이드한다.
            2. addFormatters 메서드를 구현한다.

            addFormatters로 등록한 컨버터가 더 높은 우선순위를 가진다.

            - @RequestParam 동작 과정
                1. ArgumentResolver중 RequestParamMethodArgumentResolver가 실행
                2. ConversionService를 이용해 타입을 변환

                나머지 다른 `ElementType.PARAMETER` 인 애노테이션 친구들도 같은 원리로 동작한다.

            - 타임리프 적용 방법

                ```html
                <ul>
                    <li>${number}: <span th:text="${number}"></span></li>
                    <li>${number}: <span th:text="${{number}}"></span></li>
                    <li>${ipPort}: <span th:text="${ipPort}"></span></li>
                		<li>${ipPort}: <span th:text="${{ipPort}}"></span></li>
                </ul>
                ```

                th:text="${{ipPort}}" ← 이렇게 중괄호를 두번 넣게 되면 컨버전 서비스를 적용한다는 의미이다.

        - Formatter

            [Core Technologies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#format)

            주로 실무에서 써봐야 문자 → 객체, 객체 → 문자가 대부분이며

            숫자를 문자로 변환할때 원단위를 붙여 준다거나 하는게 대부분이다.

            이러한 **문자의 경우에 특화된 컨버터가 Formatter**이다.

        - Formatter를 지원하는 컨버전 서비스

            이 포멧터와 컨버터를 동시에 지원하는 컨버전 서비스는 `DefaultFormattingConversionService` 이다. 사용 방법은 컨버전과 동일하다.

        - 포멧터 - 스프링
            - 적용방법

                컨버터와 동일하다.

            - 애노테이션 기반 포멧터

                [Core Technologies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#format-CustomFormatAnnotations)

                - @NumberFormat

                    숫자 관련 형식 지정 포맷터

                - @DateTimeFormat

                    날짜 관련 형식 지정 포맷터

    - 스프링 파일 업로더
        - 멀티파트 폼데이터

            멀티 파트 폼 데이터를 전송

            - properties 세팅
                - `spring.servlet.multipart.max-file-size=1MB`

                    단 개의 파일 사이즈 제한

                - `spring.servlet.multipart.max-request-size=10MB`

                    복수 파일의 총 파일사이즈 제한

                - `spring.servlet.multipart.enabled=false`

                    멀티파트 폼데이터 처리 제한

                    평소에는 RequestFacade 객체를 사용하지만 멀티 파트를 사용하는 순간 StandardMultipartHttpServletRequest를 사용하게 된다. 스프링이 기본으로 제공하는 리졸버인 MultipartHttpServletRequest를 상속받아 구현한 객체이다. 근데 **MultipartFile이 훨씬 사용하기 편하기 때문에 이 MultipartHttpServletRequest를 사용하지 않게 된다.**

            - 스프링이 직접 지원하는 파일 업로드

                @RequestParam MultipartFile file 이렇게 받으면 MultipartFile을 받을 수 있고 여기에서 좀더 손쉬운 메서드 들을 이용해 저장등을 수행할 수 있다.

            - 다중 파일업로드

                form내부 input 속성으로 multiple=”multiple” 속성을 넣으면 된다.

- **고급편[동시성처리, aop, 각종 디자인 패턴]**
    - **동시성 처리**

        스프링 빈은 싱글톤이기 때문에 항상 무조건 동시성 문제가 발생한다.

        공유 변수의 조회는 문제가 안되지만 변경이 일어나게 되면 발생한다.

        - **쓰레드 로컬 [ ThreadLocal ]**

            이 방식은 러스트의 기본적인 오너쉽 할당 방식과 비슷하다.

            특정 공유 변수에 특정 스레드만 접근을 할수 있도록 만드는 것이다.

            **즉, 같은 변수여도 각각 다른 스레드이면 각각 다른 메모리에 변수를 알아서 나눠서 안전하게 저장한다.**

            - **주의사항**

                was에서는 스레드 풀을 사용하기때문에 특정 개수의 스레드들을 한번에 생성하고 돌려가면서 사용한다. 사용이 끝나면 다시 스레드 풀에 집어 넣는 과정을 반복하고있다.

                만약 스레드 로컬을 사용하고 remove를 사용하지 않게 된다면 이 스레드 로컬에 있는 값이 다른 사용자에게 원치 않게 노출될 가능성이 매우 커진다.

                **따라서 사용이 끝난 스레드 로컬은 반드시 remove()로 제거를 해주어야한다!!!!!**

    - 템플릿 메서드 패턴

        변하지 않는 코드부분과 변하는 코드부분이 중간에 섞여 있을때

        변하지 않는 코드부분을 탬플릿으로 만들어 뽑아내는 패턴

        - 구현 방법
            1. 공통 추상 클래스를 만든다.
                1. execute와 call 메서드를 만든다.
                2. execute에는 공통으로 변하지 않는 코드 부분을 넣고 변하는 코드 부분에 call메서드를 호출한다.
                3. call은 protected abstract 메서드로 만들어 자식 클래스에서 구현하도록 만든다.

                    protected abstract로 만들어야 반드시 상속해야 접근이 가능하고(protected 이기때문)

                    반드시 상속 받는 클래스에서 구현해야한다.(abstract 메서드이기 때문)

            2. 이 탬플릿을 사용할 곳에서 이 자식클래스로 생성해 사용한다.
        - 단점

            너무 컴파일 타임에 구현들이 고이게 된다. 이보다 좀더 유연하게 런타임에 의존시켜주는 방식은 전략 패턴이다.

    - 전략 패턴

        변하지 않는 코드부분은 다른 클래스로 빼두고 변하는 코드 부분만 공통 클래스로 만든다.

        그리고 변하지 않는 코드 부분은 공통 클래스에서 위임을 받아 사용하는 패턴이다.

        - 구현 방법
            1. 변하지 않는 코드 부분은 클래스로 빼둔다.
            2. 공통 인터페이스를 만들고 각각 변하는 코드들을 implements로 받아 구체클래스로써  구현한다.
            3. 변하지 않는 코드를 넣은 클래스의 생성자에 공통 인터페이스 변수를 만든다.
            4. 변하지 않는 코드를 넣은 클래스에 execute메서드를 변하지 않는 코드를 넣고 그 사이에 섞인 변하는 코드 부분을 필드에서 받은 전략 변수에서 호출한다.(전형적인 위임패턴)
            5. 이 방식은 람다로도 구현이 가능하다.(인터페이스 덕분)
        - 단점

            선 조립후 실행하는 구조이기 때문에 조립이후에는 재 수정이 힘들다

    - 템플릿 콜백 패턴

        탬플릿(변하지 않는 코드조각)을 만들고 탬플릿에 콜백(변하는 코드 조각)을 넘기는 패턴

        여기서 콜백은 실행코드블럭을 넘겨 넘긴쪽 뒤에서 실행한다는 의미에서 콜백이다.

        이 위의 전략패턴에서 람다를 적용한 방식이다. 다만 생성자에 넣지 않고 실행메서드 파라미터에 넣어서 넘긴다.

    - 프록시 패턴

        한 객체에서 다른 객체를 호출할때 직접 호출하지 않고 대리자(프록시)를 통해 호출하는 패턴

        여기에 대리자를 여러개를 거쳐서 간접 호출할수도있다.(프록시 체인)

        여기서 프록시는 서버와 같은 인터페이스를 사용해야한다.

        - 의도

            다른 객체에 접근을 제어 하기위한 대리자(프록시)를 제공

        - 주요기능
            1. 접근 제어
                1. 권한에 따른 접근 제어
                2. 캐싱
                3. 지연 로딩
            2. 부가 기능 추가
                1. 요청에 따라 다르게 로그를 남기기
                2. 요청, 응답을 수정해서 넘기기
        - 구현방법
            1. 서버 인터페이스를 만든다.
                1. 서버 인터페이스를 구현하는 서버 클래스를 만든다.
                2. 서버 인터페이스를 똑같이 구현하지만 서버 인터페이스를 필드로 받는 프록시를 만든다.
            2. 서버 클래스를 필드로 가지는 클라이언트를 만든다.
            3. 서버 클래스 ← **프록시 클래스** ← 클라이언트 이렇게 주입되도록 만든다.
        - 단점

            기존 코드를 손대지 않고 기능을 추가하거나 타 객체로부터의 접근을 제어 할수 있어 좋았다.

            그러나 이런 프록시를 전체에 적용하기 위해선 전체 객체 클래스 만큼 프록시 클래스를 만들어야하는 단점이 있다. 이런 단점은 동적 프록시를 사용해야한다.

    - 데코레이터 패턴

        프록시 패턴과 매우 흡사하나 의도가 다르다. 프록시 패턴은 접근을 제어하기 위함이며 데코레이터 패턴은 기능의 추가가 주 목적이다.

        구현 방법은 동일하다.

        - 의도

            객체에 대한 추가 책임(기능)을 런타임에 동적으로 추가및 기능 확장을 위한 유연한 대안을 제공

    - 동적 프록시
        - 리플랙션

            런타임에서 클래스와 메서드의 메타정보를 가지고 동적으로 추상화하여 사용하는 기법

            그러나, 사탄의 기술이기 때문에 런타임에서 예외가 터지는 문제가 있으므로 가급적 사용을 금해야한다.

            사용하기 좋은 위치는 가장 일반적으로 공통화 해야하는 부분만 주의해서 사용해야한다.

        - jdk 동적 프록시

            개발자가 직접 프록시 클래스를 만들어 두지 않아도 런타임에 동적으로 프록시 클래스를 만들어사용하는 방식

            InvocationHandler를 구현하여 구현체와 인터페이스들을 Proxy.newProxyInstance()의 파라미터로 넣어 사용하는 방식이다.

            - 실행 순서
                1. InvocationHandler.invoke() 호출
                2. 직접 InvocationHandler를 구현하는 구체클래스에서는 구현 해둔 로직을 함께 버무려 오버라이드한 invoke()를 수행한다.
                3. 이때 구현을 할때 타겟을 필드로 두고 필드의 메서드를 수행하게끔 만든다.
                4. 타켓의 메서드(call)가 실행된다.

            - 단점

                인터페이스가 없는 경우에는 불가능한 방법이다.

                이 경우에는 Code Generator Library, CGLIB을 사용하는 방법이 보편적이다.

        - CGLIB[Code Generator Library]

            바이트코드를 조작하여 동적으로 클래스를 생성하는 라이브러리

            인터페이스 없이 구체 클래스만 가지고 동적 프록시를 만들수 있다.

            직접 사용하진 않고 ProxyFactory를 사용하는 것이 보편적이다.

            - 구현 방법
                1. MethodInterceptor를 구현하는 구현클래스르 만든다.
                2. Enhancer를 생성하여 슈퍼 클래스를 세팅한다.
                3. Enhancer에 콜백을 설정하는데 1번에서 구현한 구체 클래스를 넣어준다.
                4.  Enhancer.create()로 프록시를 만든다.
                5. proxy.call()로 사용한다.
            - 단점

                슈퍼클래스를 설정할때 슈퍼 클래스의 생성자를 체크해야한다. 동적으로 생성하기 때문에 없으면 안된다.

                그리고 생성자를 만들고 setter를 이용해 주입을 해야하게 되기때문에 이용하기에 아직도 까다롭다. 무엇보다 인터페이스가 있을때는 동적프록시, 없을때는 CGLIB를 쓰기에도 상당히 구현하기 힘들어 진다. 이럴 경우엔 ProxyFactory를 주로 사용해 이 문제를 해결해야한다.

    - 프록시 팩토리

        JDK 동적 프록시 혹은 CGLIB를 구현해야 하던지 간에 이 앞단에서 클라이언트 요청에 따라 알아서 구현을 한다. 즉, 팩토리 클래스의 역할을 하는 것이다.

        이 프록시 팩토리로 생성을 한뒤 개발자는 advice에 추가하고 싶은 로직을 몰아 넣으면 각각의 프록시 팩토리에서 추상화하고 있는 클래스에서 해당 advice 로직을 호출한다.

        만약 특정 조건에만 실행하고 싶다면 PointCut을 걸면된다.

        - 실행 순서
            1. 프록시 팩토리 생성
            2. advice 로직 실행
        - 구현 방법
            1. MethodInterceptor를 구현하는 구현클래스르 만든다. 이 경우엔 aop 라이브러리에 있는 것을 사용해야한다. 이것을 Advice라고 부른다.
            2. 프록시 팩토리를 생성한다. 이때 슈퍼클래스로 지정할 클래스이던 인터페이스 이던 타겟으로써 생성해서 프록시 팩터리 생성자 파라미터로 넘겨주어야한다.
            3. 1에서 구현한 Advice를 proxyFactory.addAdvice()로 추가한다.
            4. proxyFactory.getProxy()로 프록시 객체를 얻는다. 그리고 마음대로 사용하면된다.
            - 참고할 점

                AopUtils에는 여러가지 쓸만한 메서드들이 있다.

                이 메서드들은 ProxyFactory를 통해 생성된 객체들만이 사용 가능하다.

        - 포인트 컷, 어드바이스, 어드바이저
            - 포인트 컷

                어디에 부가기능을 추가할 지 추가하지 말지 결정하는 필터링 로직

                주로 클래스명과 메서드명으로 필터링한다.

            - 어드바이스

                프록시가 호출하는 부가기능

            - 어드바이저

                하나의 포인트 컷과 하나의 어드바이스를 가지고 있는 것이다.

            - 포인트 컷 종류
                - `NameMatchMethodPointcut`

                    메서드 이름 기반으로 매칭한다. PatternMatchUtils를 사용한다.

                - `JdkRegexpMethodPointcut`

                    JDK 정규식 기반으로 매칭한다.

                - `Pointcut.TRUE`

                    항상 허용하는 포인트컷을 제공한다.

                - `AnnotationMatchingPointcut`

                    애노테이션으로 매칭한다.

                - `AspectJExpressionPointcut`

                    AspectJ 표현식으로 매칭한다.

            - **스프링이 어드바이저를 거는 규칙**

                **하나의 타겟에 하나의 프록시와 여러개의 어드바이저를 부착한다. [1:N]**

                **여러 aop를 만들수록 프록시가 늘어난다고 착각하면 안된다. 어드바이저가 늘어나는 것이다!!!**

    - 빈 후처리기[BeanPostProcessor]

        빈을 생성한 후 스프링 빈 저장소에 등록하기 직전에 어떠한 행동을 하게끔 후킹을 하는 작업

        - 구현 방법
            1. 빈 후처리기 인터페이스인 BeanPostProcessor를 구현한다.
            2. 이 구현체를 빈으로 등록한다.

            빈이 생성이 되면 이제 모두 이 postProcessor를 거친뒤 빈 저장소에 등록된다.

            이때 빈을 바꿔치기도 가능할정도로 강력한 후킹 기술이다.

            이것을 사용하면 컴포넌트 스캔을 사용한 빈들을 중간에 조작이 가능해져서 이제 프록시 패턴을 사용하지 못했던 방식에도 **빈 객체를 프록시로 교체**하는 것이 가능하다.

        - 참고 1 [@PostConstructor]

            스프링은 사실 CommonAnnotationBeanPostProcessor란 빈 후처리기가 자동으로 등록이 되어있다. 이때 @PostConstructor가 붙은 메서드를 호출하는 것이다.

        - 참고 2

            이 빈 후처리기를 사용할때 스프링부트가 자동으로 등록하는 패키지들이 많다.

            그래서 스프링 aop는 사실 포인트 컷을 사용해 프록시 적용 대상 여부를 판단하기도한다.

            - 포인트 컷 사용 위치

                포인트 컷의 사용 위치는 2곳이다.

                1. 프록시 적용 대상 여부 체크 - 빈 후 처리기
                2. 프록시의 어떤 메서드가 호출 되었는지, 어드바이스 적용 대상인지 체크 - 프록시 내부
    - **스프링 AOP**

        Aop는 관점 기반 프로그래밍을 의미한다.

        aop는 [cross-cutting concerns - 횡단 관심사] 기능을 구현하는데 사용된다.

        얘를 들면 로깅이 될수 있다.

        이 로깅은 모든 기능들이 내포되는 경우가 일반적이기 때문에

        모든 기능들을 횡단하는 대표적인 횡단 관심사 기능들중 하나이다.

        **실무에선 AspectJ 표현식을 차용한 포인트컷만 주로 사용한다.**

        **+** 스프링 aop는 스프링 빈에만 적용이 가능하다.

        스프링 AOP를 설치하면 스프링 부트가 자동으로 @EnableAspectAutoProxy를 자동으로 처리해준다.

        스프링 부트가 활성화 하는 빈 ⇒ AopAutoConfiguration

        - 동작구조

            자동 프록시 생성기 - AnnotationAwareAspectJAutoProxyCreator,

            이 스프링 부트 자동설정은 AnnotationAwareAspectJAutoProxyCreator라는 빈 후처리기가 스프링 빈으로 자동 등록해준다.

            이 친구는 위에서 설명한 빈 후처리기이다.

            스프링 빈으로 등록된 Advisor들을 자동을 찾아 프록시가 필요한 곳에 자동으로 프록시를 적용해준다. Advisor에는 포인트 컷과 어드바이스가 자동으로 들어 있고 포인트 컷으로 프록시 대상 여부를 체크한다. 적용되는 기능은 어드바이스로 넣어주면된다.

            - 작동 과정
                1. 빈 생성
                2. 생성된 빈을 후처리기로 전달
                3. 모든 Advisor 빈 조회
                    1. 그냥 어드바이저 조회
                    2. 모든 @Aspect가 달린 빈을  조회
                        1. @Aspect 어드바이저 빌더 내부 저장소 조회 - 캐시된 어드바이저 조회
                        2. 없으면 어드바이저 빌더를 통해 생성후 어드바이저 빌더 내부 저장소에 저장
                4. 프록시 적용대상 체크 - 포인트 컷을 이용
                5. 프록시 생성후 반환
                6. 반환된 빈or 프록시들 등록

            aspectJ 표현식을 사용해 포인트 컷을 사용하면 훨씬 정밀한 포인트 컷 규칙을 새울 수 있다.

            **실무에선 aspectJ 표현식을 차용한 포인트컷만 주로 사용한다.**

        - **어드바이저가 여러개일 경우**

            하나의 프록시에 여러 어드바이저를 적용할지 여부는 포인트 컷으로 판단한다.

            적용이 가능한 포인트 컷일 경우 해당하는 어드 바이저들만 들고와서 프록시에 적용한다.

    - @Aspect aop - 스프링 자체 기능

        @Aspect를 사용해 aop를 적용하여 프록시를 적용하는 방법

        AnnotationAwareAspectJAutoProxyCreator의 기능중 @Aspect를 찾아 어드바이저로 등록하는 기능이 있다. 이것을 이용하는 것이다.

        - 구현 방법
            1. 어드바이저용도 클래스에 @Aspect를 클래스 레벨에 넣는다.
            2. 어드바이스 메서드에 @Around(”표현식”)이렇게 넣고 어드바이스는 메서드 바디에 넣어준다.
            3. @Around에 들어간 표현식이 포인트 컷이 되고 어드바이스는 메서드의 내용이 된다.
        - 동작 구조
            1. 스프링 시작시 AnnotationAwareAspectJAutoProxyCreator 호출
            2. 모든 @Aspect가 달린 빈을  조회
            3. 어드바이저 생성 - 어드바이저 빌더를 통해 @Aspect 정보를 기반으로 생성
            4. @Aspect기반 어드바이저 저장 - 어드바이저 빌더 내부에 저장
    - AOP 적용방식
        - 적용 시점
            1. 컴파일 시점 - AspectJ 위빙기능
            2. 클래스 로딩 시점 - AspectJ 위빙기능
            3. 런타임 시점(ex: 프록시 - 스프링 aop가 기용하는 시점)
        - **위빙 Weaving**

            AspectJ CGLIB 처럼 바이트 코드를 뜯어서 부가기능 코드를 붙여 버리는 기능또한 내포하고 있다.

            이를 **위빙**이라고 부른다.

            - 컴파일 시점

                .java → .class 파일로 컴파일 될때 일반적인 컴파일러가 아닌 AspectJ 컴파일러를 사용하여 적용한다. 이를 **컴파일 타임 위빙**이라고 부른다.

                특별한 컴파일러가 필요하고 복잡하다

            - 클래스 로드 시점

                자바 Lang은 컴파일된 .class 파일을 JVM 내부 클래스 로더에 보관한다. 이 보관하기 직전에 .class파일을 조작하여 보관하도록 만드는 것이다. 이를 **로드 타임 위빙**이라고 부른다.

                수많은 모니터링 툴들이 이 방식을 차용하고 있다.

                이 방식은 자바 실행시 java -javaagent 옵션을 통해 클래스 로더 조작기를 지정해주어야하고 이것이 번거롭고 운영하기 어려운 포인트이다.

            - 런타임 시점

                위에서 진행한 빈 바꿔치기를 이용한 방식을 의미한다. 보통 직접 aop를 기용할땐 이 방식을 사용한다.

        - 적용 위치

            이 적용 가능한 위치를 조인 포인트라고 부른다.

            1. 생성자
            2. 필드 값 접근
            3. static 메서드 접근
            4. 메서드 실행 - 런타임 시점엔 이 위치만 가능, 나머지는 바이트코드의 조작이 필요함 - AspectJ 필수
        - @Pointcut

            특정 메서드에 포인트 컷들을 모아 둘수도 있다. 이때 이 어노테이션을 쓰면된다.

            접근 제어자로 이 어노테이션이 있는 클래스 안에서만 쓸수도 있고 다른 패키지에서도 사용하게끔 만들수도 있다.

            private, public으로 제어하면 된다. 다만 패키지명이랑 클래스명까지 적어야되서 좀 귀찮다.

            &&,||,! 적용 가능하다.

        - 어드바이스 순서 지정 방법

            @Order를 지정하면되지만 클래스 레벨에만 지정이 가능하다.

            즉, 메서드 레벨로 지정이 된 경우에는 보장이 되지 않으므로

            어드바이스를 @Aspect 단위로 쪼개야한다.

        - 어드바이스 종류

            @Around로 전부 처리가 되지만 다른 단순한 어드바이스 기능들이 있어 역할이 명확해지고 설계가 좋아진다.

            - **호출 순서**

                **리턴 순서는 역순이다. 명심할 것**

                1. @Around
                2. @Before
                3. @After Returning
                4. @After Throwing
                5. @After
            - @Around

                가장 강력한 어드바이스, 메서드 호출 전후 시점에 수행, 조인 포인트 실행 여부 선택, 반환 갑 변환, 예외 변환, proceed 여러번 호출해서 재시도 수행등 가능

                - 주의 할점

                    **proceed 호출이 없으면 체이닝이 일어나지 않는다.!!!**

                - 파라미터

                    `ProceedingJoinPoint joinPoint`

            - @Before

                조인 포인트 실행 이전에 실행

                - 파라미터

                    `JoinPoint point`

            - @After Returning

                조인 포인트가 정상 완료후 실행

                returning의 파라미터명과 결과 파라미터 result와 일치해야한다.

                - 파라미터

                    `JoinPoint point, Object result`

            - @After Throwing

                조인 포인트가 예외를 던지는 경우에만 실행

                throwing의 파라미터명과 예외 파라미터 ex와 일치해야한다.

                - 파라미터

                    `JoinPoint point, Exception ex`

            - @After

                조인 포인트가 정상 또는 예외에 관계 없이 실행(finally)

                보통 리소스 해제에 사용됨

                - 파라미터

                    `JoinPoint point`

        - 트랜잭션 적용 방법
            - 실행 순서
                1. 핵심 로직 실행 직전 트랜잭션 시작
                2. 핵심 로직 실행
                3. 문제 여부 검증
                    1. 문제가 없으면 커밋
                    2. 문제가 있으면 롤백

    - 포인트컷 지시자[PCD - Pointcut Designator]
        - 종류
            - execution

                메서드 실행 조인 포인트를 매칭

                - 문법

                    `execution(접근제어자? 반환타입 선언타입?메서드이름(파라미터) 예외? )`

                    - ? 들어간 파라미터들은 생략 가능
                    - `*` 같은 패턴 지정가능(와일드 카드)
                        - 파라미터에 쓰는 경우

                            파라미터 타입만 상관 없고 파라미터의 수는 따지는 경우

                    - `..` 은 경우가 2가지이다.
                        - 파라미터에 쓰는 경우

                            파라미터의 타입과 파라미터의 수가 상관 없다는 뜻

                        - 패키지를 포함한 메서드 이름쪽에 쓰는 경우

                            하위 패키지를 포함한다는 뜻

                            **패키지쪽에 안써주게 되면 해당 레벨의 클래스와 메서드만 뒤져보니 주의!!!**

                    - **타입 매칭시 부모타입으로 넣어도 매칭 시킨다.** **자식 타입에만 구현된 매서드를 찾는다고 부모 타입을 넣으면 못 찾는다! 주의!!!!**

            - within

                특정 타임 내의 조인 포인트를 매칭

                execution에서 타입 부분만 사용하는 것과 같다.

                딱 정확한 타입만 적어야하는 경우가 많아 실무에서 쓸일이 없다.

                - 주의할 점

                    **타입이 정확하게 맞아야한다. 부모타입을 가져다 쓰면 절때 안된다!!**

            - args

                인자가 주어진 타입의 인스턴스인 조인포인트

                execution에서 파라미터 부분과 같다.

                **파라미터 바인딩에서 주로 사용된다.**

                - 주의할 점

                    **부모 타입을 적어도 잘 적용된다.** execution은 역으로 이게 안된다.

                    **반드시 매칭 적용 범위를 줄여주는 표현식 뒤에 적어서 써야한다.**

            - this

                스프링 빈 객체(스프링 aop 프록시)를 대상으로 하는 조인 포인트

                - 주의할 점
                    1. 적용 타입 하나를 정확하게 지정해야한다.
                    2. `*` 사용 불가
                    3. 부모 타입을 허용한다.
                    4. 인터페이스의 타입을 사용할 경우 괜찮지만 JDK 동적 프록시의 경우 구체클래스의 타입을 사용할 경우 인터페이스를 상속 받아서 만들어진 JDK 동적 프록시는 타 구체 클래스를 알지 못한다. 그렇기 때문에 **JDK 동적프록시의 경우 구체클래스의 타입으로 지정을 하게 된다면 aop 대상이 되지 못한다.**

                    참고로 `spring.aop.proxy-target-class=false` 를 해야 JDK 동적 프록시가 적용된다. 기본적으로 **스프링부트는 JDK dynamic proxy를 막아놨다.**

            - target

                target 객체(스프링 aop 프록시 객체가 가리키는 실 객체)를 대상으로 하는 조인 포인트

                - 주의할 점
                    1. 적용 타입 하나를 정확하게 지정해야한다.
                    2. `*` 사용 불가
                    3. 부모 타입을 허용한다.
                    4. 인터페이스의 타입을 사용하던 구체클래스의 타입을 사용하던 문제 없이 aop의 대상이기 때문에 잘 허용된다.
            - @target

                target 객체(스프링 aop 프록시 객체가 가리키는 실 객체)에 클래스에 주어진 타입의 애노테이션이 있는 조인 포인트

            - @within

                주어진 애노테이션이 있는 타입 안의 조인 포인트

                - @target vs @within

                    둘다 어노테이션이 적용된 **클래스**를 매칭해주는 역할이다.

                    **둘다 파라미터 바인딩에 사용된다.**

                    target의 경우 부모타입까지 어드바이스 적용이 가능하고 within 같은 경우는 마찬가지로 부모타입은 찾지 못한다. 해당하는 클래스의 메서드에만 어드바이스 적용이 가능하다.

                     **반드시 매칭 적용 범위를 줄여주는 표현식 뒤에 적어서 써야한다.**

            - @annotation

                메서드가 주어진 애노테이션을 가지고 있는 조인 포인트를 매칭

                어노테이션이 적용된 **메서드**를 매칭해주는 역할이다.

            - @args

                전달된 실제 인수의 런타임 타입이 주어진 타입의 애노테이션을 갖는 조인 포인트

                파라미터의 클래스에 애노테이션 있는 클래스를 매칭해준다.

                실무에서 잘쓸일 없다.

            - bean

                스프링 전용 포인트컷 지시자, 빈의 이름으로 포인트컷을 지정한다.

                - 기본 문법

                    `bean(orderService)|| bean(*Repository)`

                    `*` 이 와일드 카드 사용도 된다.

        - 어드바이스 매개변수 전달 방법
            - 구현 방법
                1. args

                    포인트컷(파라미터 영역, args)과 매개변수 이름(실제 어드바이스 메서드 파라미터 이름)을 맞춰야한다.

                    타입도 실제 어드바이스 파라미터 이름으로 제한되니 주의해야한다.

                    실제 어드바이스 파라미터 타입을 Object로 맞춰두면 다 받을 수 있어서 팁이다.

                2. this

                    포인트컷(this)과 매개변수 이름(실제 어드바이스 메서드 파라미터 이름)을 맞춰야한다.

                    포인트 컷에 매칭된 빈의 프록시 객체를 그대로 전달 받는다.

                3. target

                    포인트컷(target)과 매개변수 이름(실제 어드바이스 메서드 파라미터 이름)을 맞춰야한다.

                    포인트 컷에 매칭된 빈의 실 객체를 그대로 전달 받는다.

                4. @target

                    포인트컷(@target)과 매개변수 이름(실제 어드바이스 메서드 파라미터 이름)을 맞춰야한다.

                    포인트 컷에 매칭된 메서드의 클래스의 어노테이션 정보를 그래도 전달 받는다.

                5. @within

                    포인트컷(@within)과 매개변수 이름(실제 어드바이스 메서드 파라미터 이름)을 맞춰야한다.

                    포인트 컷에 매칭된 메서드의 클래스의 어노테이션 정보를 그래도 전달 받는다.

                6. @annotation

                    포인트컷(@annotation)과 매개변수 이름(실제 어드바이스 메서드 파라미터 이름)을 맞춰야한다.

                    포인트 컷에 매칭된 메서드의 어노테이션 정보를 그래도 전달 받는다.

                    이때, 메서드 어노테이션에 등록한 값(value)도 가져 올수 있다.

    - 스프링 AOP 한계와 문제점
        - 프록시와 내부 호출 문제

            **일반적으로 aop는 트랜잭션 적용, 주요 컴포넌트들의 로그 출력에 사용된다. 보통 큼직큼직한 기능들인 public 메서드에 적용할 용도로 사용된다. private 내부 메서드들까지 적용할 생각으로 사용하는 기술이 아니다...!! 그럼에도 불구하고 이런 문제는 자주 발생한다. 만약 aop적용이 잘 안된다면 이 문제를 가장 먼저 의심해봐야한다.**

            자바언어 에서 메서드 호출시 대상을 지정하지 않으면 앞에 자기자신의 인스턴스를 뜻하는 this가 자동으로 붙게 되는데 이때 의도치 않게 이는 자기 자신을 가리키게 된다.

            만약 특정 클래스의 내부에서 다른 메서드를 호출한다면 그 메서드는 타겟의 메서드를 의미하게된다.

            이런 **내부의 타겟을 가리키는 메서드는 aop 어드바이스 적용 매칭에서 벗어나게 된다...!!!!!**

            만약 AspectJ의 로드타임 위빙들을 사용하게 되면 이런 문제가 없다. 근데 이건 좀 부담이 있으니 다른 대안책을 알아보자

            - 대안책
                - 프록시 타겟 객체 자체 내부에 자기 자신을 주입받는 방식

                    이 방식은 수정자(setter)를 통해 자기 자신을 주입받아야 순환 참조 문제가 발생하지 않는다.

                    다만 이방식은 2.6버전 부턴 자기 자신 주입방식이 막혔기 때문에 이것을 설정으로 해제해야한다.

                    `spring.main.allow-circular-references=true`

                - 빈 자체를 지연 로딩으로 주입받는다. 예를 들면 `ApplicationContext` 를 주입받거나 O bjectProvider를 사용해 지연 로딩을 활용하는 것이다.
                - 구조 자체를 분리한다.(**가장 권장**)

                    내부에서 호출되는 메서드를 아예 다른 서비스 클래스로 분리해서 주입을 받는 방식이다.

                    제일 깔끔하다.

        - 타입 캐스팅의 한계 - JDK dynamic proxy

            이 JDK 동적 프록시를 통해 프록시를 만들고 구체클래스로 타입 캐스팅을 하려고 하면 실패한다.

            그래서 거의 일반적으로 CGLIB을 디폴트로 사용을 하는데 이렇게 하지 않으면 타입 캐스팅의 한계가 의존 관계 주입에도 문제가 생긴다.

        - 의존 관계 주입의 한계

            만약 jdk 동적 프록시로 세팅을하고 aop를 적용한 상태에서 구체 클래스를 주입 받으려고 하면 예외가 발생한다. jdk는 인터페이스를 상속받아 생성한 프록시이기 때문이다. 이렇기 때문에 이럴땐 그냥 CGLIB을 사용하는 것이 좋다.

        - CGLIB의 한계
            1. 대상 클래스에 기본 생성자 필수

                구체 클래스를 상속을 받아서 프록시를 만든다고 하면 이 구체 클래스의 부모 클래스 생성자 호출이 구체 클래스 생성자에 자동으로 삽입된다. 자바 문법의 규약이다.

                **CGLIB은 이렇기 때문에 항상 기본 생성자를 필요로 한다. 기본 생성자는 파라미터가 하나도 없는 생성자를 의미한다. 생성자가 하나도 없으면 자동으로 만들어 진다 자바 문법의 규약이다.**

            2. 생성자 2번 호출 문제

                1에서 설명한대로 부모 클래스의 생성자 호출이 자동으로 구체 클래스에도 들어가기 때문에 구체클래스를 기반으로 프록시를 생성한다면 생성자가 항상 2번(또는 그 이상) 호출되는 문제가 있다.

            3. final 키워드 클래스, 메서드 사용 불가능

                final 클래스는 상속이 불가능한 클래스

                final 메서드는 오버라이딩이 불가능한 메서드이다.

                일반적으로 프레임워크나 라이브러리 개발이 아닌 웹 어플리케이션 개발에는 사용되는 문법이 아니다. 크게 신경 쓸건 아니다.

        - 해결책
            1. CGLIB를 스프링 내부에 함께 패키징
            2. CGLIB 기본 생성자 문제 해결

                objenesis라는 특별한 라이브러리를 사용, 기본 생성자 없이 객체 생성가능, 생성자 호출없이 객체 생성이 가능하게 해주는 라이브러리

            3. 2를 통해 생성자 2번 호출문제 해결
            4. 스프링 부트 2.0 - CGLIB를 디폴트화 결정

                레거시 스프링은 proxyTargetClass=true라는 옵션을 xml에 넣어줘야한다.

- 이슈와 해결법
    - IDE 이슈 [이클립스]
        - Nothing to fetch

            > [https://d-e-v.tistory.com/5](https://d-e-v.tistory.com/5)
            >
    - **PRG**
        - **CRUD중 수정과 등록, 삭제를 할때 반드시 Post, Redirect, Get으로 되게끔 수정해주어야한다!!!!!**
- SSR관련
    - JSP
        1. <%@ 내용 %>

            include와 같은 역할, import같은 기능을 사용할때 쓴다.

        2. <% 자바코드%>

            자바 코드를 넣을 때 사용한다. <script></script>를 생각하면된다.

        3. <%= 자바변수%>

            내부의 자바 변수의 변수값을 외부에 노출시킬때 사용한다.

        - JSTL

            JSP 표현식들을 간단하게 사용하기 위한 라이브러리이다.

            > [https://atoz-develop.tistory.com/entry/JSP-JSTL-사용-방법-주요-태그-문법-정리](https://atoz-develop.tistory.com/entry/JSP-JSTL-%EC%82%AC%EC%9A%A9-%EB%B0%A9%EB%B2%95-%EC%A3%BC%EC%9A%94-%ED%83%9C%EA%B7%B8-%EB%AC%B8%EB%B2%95-%EC%A0%95%EB%A6%AC)
            >

            > [https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/](https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/)
            >

            사용법

            1. <%@ **taglib** prefix=*"c"* uri=*"http://java.sun.com/jsp/jstl/core"* %> 선언
            2. 사용하고 싶은 태그를 사용한다.

                예시 :

                ```html
                <c:forEach var="item" items="${memberList}">
                		<tr>
                				<td>${item.getId()}</td>
                				<td>${item.getUsername()}</td>
                				<td>${item.getAge()}</td>
                		</tr>
                </c:forEach>
                ```

    - 타임리프

        [[ThymeLeaf]]

    - 부트 스트랩

        > [https://getbootstrap.com/docs/5.0/getting-started/download/](https://getbootstrap.com/docs/5.0/getting-started/download/)
        >


### Spring

[수료증 확인 - 인프런 | 고객센터](https://www.inflearn.com/certificate/330632-325969-4695770)

[수료증 확인 - 인프런 | 고객센터](https://www.inflearn.com/certificate/330632-327901-4695766)

### Spring MVC

[수료증 확인 - 인프런 | 고객센터](https://www.inflearn.com/certificate/330632-326674-4695769)

[수료증 확인 - 인프런 | 고객센터](https://www.inflearn.com/certificate/330632-327260-4695767)

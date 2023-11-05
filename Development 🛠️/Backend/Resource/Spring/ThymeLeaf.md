# ThymeLeaf

- 텍스트
    - th:text
        - 예제

            ```xml
            <ul>
                <li>th:text 사용 <span th:text="${data}"></span></li>
                <li>컨텐츠 안에서 직접 출력하기 = [[${data}]]</li>
            </ul>
            ```

        - Escape 처리

            data: Hello <b>Spring!</b>

            소스코드:  Hello &lt;b&gt;Spring!&lt;b&gt;

            만약 이 경우 태그를 문자 그대로 표현해주기 위해 이렇게 처리를 해주는 것이 이스케이프라고한다. 만약 이스케이프 처리가 안됬다면 진한 **Spring**이 렌더링 됬을 것이다.

            **특수 문자를 문자 그대로를 출력시켜주기 위해 HTML 엔티티로 변환해주는 것을 이스케이프라고 한다. 그리고 타임리프의 th:text나 [[...]]는 자동으로 변환해준다.**

        - Unescape 처리

            **th:text → th:utext**

            **[[...]] → [(...)]**

- 변수 [SpringEL]
    - 표현식

        ${...}

    - SpringEL
        1. ${user.username} → 자바 빈 프로퍼티 접근법
        2. ${user.[’username’]}
        3. ${user.getUsername()}

        셋다 같은 프로퍼티를 가져옴

    - 지역 변수

        th:with

        - 예제

            ```xml
            <div th:with=”first=${users[0]}”>
            ...
            </div>
            ```


- 기본 객체
    - ${#request}
    - ${#response}
    - ${#session}
    - ${#servletContext}
    - ${#locale}
    - param
        - Http 요청 파라미터 접근

            (ex: ${param.userId})

    - session
        - Http 세션 접근

            (ex: ${session.ssn})

    - @
        - 스프링 빈 접근

            (ex: ${@helloBean.hello(”Spring!”)})


- 유틸 객체
    - 리스트

        > [https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#expression-utility-objects](https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#expression-utility-objects)
        >
    - 예시

        > [https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#appendix-b-expression-utility-objects](https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#appendix-b-expression-utility-objects)
        >
- 날짜

    자바8 날짜 라이브러리를 직접 넣어야한다! 근데 이건 스프링부트는 기본으로 넣어서 준다.

- URL 링크
    - 일반 링크
        - 예시

            @{/hello}

            → /hello

    - 쿼리 파라미터
        - 예시

            @{/hello(param1=${param1}, param2=${param2})}

            → /hello?param1=data1&param2=data2

    - path 파라미터
        - 예시

            @{/hello/{param1}/{param2}(param1=${param1}, param2=${param2})}

            → /hello/data1/data2

    - 쿼리 파라미터 + path 파라미터
        - 예시

            @{/hello/{param1}(param1=${param1}, param2=${param2})}

            → /hello/data1?param2=data2

- 리터럴
    - 문자 리터럴

        “’hello’”

        항상 ‘’ ← 작은 따옴표로 감싸야 적용됨

        그러나 공백없이 쭉 이어지면 하나의 의미있는 토큰으로 인식함

        **그러나 공백이 들어가면 토큰으로도 인식이 되지 않으므로 항상 주의할 것!!!**

        근데 리터럴 대체 문법을 사용하면 그냥 편하게 사용이 가능하다.

    - 대체 리터럴
        - 예시

            ```xml
            <span th:text="|hello ${data}|"/>
            ```

- 연산
    - 산술

        생략

    - 비교

        생략

    - Elvis

        ?: ← 이 연산은 있는지 없는지 체크를 하는 연산이다. isNull이라고 보면 된다.

        ```xml
        <span th:text="${nullData}?: '데이터가 없습니다.'"/>
        ```

    - no-operation

        _ ← 이 언더바는 타임리프 처리를 통하지 말고 그냥 원 html 코드를 렌더링하게끔 처리한다.

        ```xml
        <span th:text="${nullData}?: _">데이터가 없습니다.</span>
        ```

- 속성 값 설정

    태그 내부의 속성과 같은 이름을 지정해주면 렌더링 될때 해당 속성이 지정된다.

    - 예시

        ```xml
        <!-- 예시 -->
        <input type="text" name="mock" th:name="userA" />
        <!-- -> 실제 렌더링 된 코드 -->
        <input type="text" name="userA" />
        ```

    - th:attrappend

        특정 속성 뒤에 덧붙여주는 처리이다.

        - 예시

            ```xml
            <!-- 예시 -->
            <input type="text" class="text" th:attrappend="class=' large'" />
            <!-- -> 실제 렌더링 된 코드 -->
            <input type="text" class="text large" />
            ```

    - th:attrprepend

        특정 속성 앞에 덧붙여주는 처리이다.

        - 예시

            ```xml
            <!-- 예시 -->
            <input type="text" class="text" th:attrprepend="class='large '" />
            <!-- -> 실제 렌더링 된 코드 -->
            <input type="text" class="large text" />
            ```

    - th:classappend

        class 속성뒤에 적절히 붙여주는 처리이다.

        - 예시

            ```xml
            <!-- 예시 -->
            <input type="text" class="text" th:classappend="large" />
            <!-- -> 실제 렌더링 된 코드 -->
            <input type="text" class="text large" />
            ```

    - checked 처리

        checkbox 타입의 input 태그의 고질적인 문제인 checked만 있으면 체크처리가 되는 문제가 있지만 타임리프는 bool값으로 처리를 할수 있게 해준다.

        - 예시

            ```xml
            <!-- 예시 -->
            - checked o <input type="checkbox" name="active" th:checked="true" /><br/>
            - checked x <input type="checkbox" name="active" th:checked="false" /><br/>
            <!-- -> 실제 렌더링 된 코드 -->
            - checked o <input type="checkbox" name="active" checked="checked" /><br/>
            - checked x <input type="checkbox" name="active" /><br/>
            ```

- 반복
    - each
        - 예시

            ```xml
            <tr th:each="user : ${users}">
                <td th:text="${user.username}">username</td>
                <td th:text="${user.age}">0</td>
              </tr>
            ```

    - each 반복 상태 추적
        - 예시

            ```xml
            <tr th:each="user, userStat : ${users}">
                <td th:text="${userStat.count}">username</td>
                <td th:text="${user.username}">username</td>
                <td th:text="${user.age}">0</td>
                <td>
                  index = <span th:text="${userStat.index}"></span>
                  count = <span th:text="${userStat.count}"></span>
                  size = <span th:text="${userStat.size}"></span>
                  even? = <span th:text="${userStat.even}"></span>
                  odd? = <span th:text="${userStat.odd}"></span>
                  first? = <span th:text="${userStat.first}"></span>
                  last? = <span th:text="${userStat.last}"></span>
                  current = <span th:text="${userStat.current}"></span>
                </td>
              </tr>
            ```

            **userStat을 생략해도 현재 객체명+”Stat”을 붙여주게되면 상태 객체로 사용이 가능하다**


- 조건부 평가
    - th:if, th:unless(if의 반대)

        만약 if의 조건을 만족하지 않는다면 th:if가 들어간 태그는 아예 렌더링을 하지 않는다.

    - th:swtich, th:case

        case에 만족하는 태그를 제외하고 나머지 태그는 렌더링 되지 않는다.


- 주석
    - 일반 Html 주석

        thymeleaf 렌더링하지 않고 남겨둔다.

        <!— .... —>

    - thymeleaf 파서 주석

        thymeleaf 렌더링에서 주석 부분을 제거한다.

        <!—/* .... */—>

    - thymeleaf 프로토타입 주석

        thymeleaf로 렌더링이 되지 않은 경우에만 주석처리함

        <!—/*/ .... /*/—>

- block

    타임리프의 유일한 자체 태그

    - 예시

        ```xml
        <th:block th:each="user : ${users}">
            <div>
                사용자 이름1 <span th:text="${user.username}"></span>
                사용자 나이1 <span th:text="${user.age}"></span>
            </div>
            <div>
                요약 <span th:text="${user.username} + ' / ' + ${user.age}"></span>
            </div>
        </th:block>
        ```

        이런 경우에 사용해주면 된다.

- 자바스크립트 인라인

    자바스크립트 안에서 편하게 타임리프를 사용하게 해주는 속성

    <script th:inline="javascript">

    - 예제

        ```xml
        <script th:inline="javascript">
            var username = [[${user.username}]];
            var age = [[${user.age}]];

            //자바스크립트 내추럴 템플릿
        		// 주석 내부의 값이 이 html이 렌더링 될때 대입된다.
        		//그전에는 "test username"이 디폴트로 들어가있다.
            var username2 = /*[[${user.username}]]*/ "test username";

            //객체
        		//자동으로 객체는 json으로 변환해준다.
            var user = [[${user}]];
        </script>
        ```

    - 예제 [each]

        ```xml
        <script th:inline="javascript">

            [# th:each="user, stat : ${users}"]
            var user[[${stat.count}]] = [[${user}]];
            [/]

        </script>
        ```

- 템플릿 조각
    - th:fragment

        템플릿 조각

        - 예시

            ```xml
            <footer th:fragment="copy">
                    푸터 자리 입니다.
            </footer>
            ```

    - 템플릿 조각 호출

        표현식 ~{...}

        단순 표현도 가능하다.

        th:replace="~{template/fragment/footer :: copy}"

        → th:replace="template/fragment/footer :: copy"

        - th:insert

            호출 태그를 포함하여 삽입

            - 예시

                ```xml
                <!-- div 내부에 copy를 호출 -->
                <div th:insert="~{template/fragment/footer :: copy}"></div>
                ```

        - th:replace

            호출 태그를 대신하여 교체

            - 예시

                ```xml
                <!-- div 자리를 copy로 교체 -->
                <div th:replace="~{template/fragment/footer :: copy}"></div>
                ```

        - 파라미터 사용시
            - 예시

                ```xml
                <div th:replace="~{template/fragment/footer :: copyParam ('데이터1', '데이터 2')}"></div>
                ```

- 템플릿 레이아웃

    이것을 적극적으로 활용하면 페이지 전체를 레이아웃으로 replace 할수 있다.

- **Form 활용 방법**
    - **th:object=”${item}”**

        이 item은 **선택 변수 식** `“*{...}”`를 사용해 `“*{itemName}"` 이런식으로 자바빈 프로퍼티에 바로 접근이 가능하다. 이렇게 form에 연결된 객체를 **커맨드 객체**라고 부른다.

    - **th:field=”*{itemName}”**

        이 속성을 input 태그에 넣어 id 속성과  name 속성의 생략이 가능해진다.

    - **체크박스 & 라디오**

        form-data에 item.isTrue = on 이런식으로 넘어가게되고 스프링 컨버터가 알아서 on → true 이런식으로 변환해서 객체에 넣어준다.(@ModelAttribute)

        - **싱글 체크박스**
            1. 전통적인 트릭

                ```jsx
                <!-- single checkbox -->
                        <div>판매 여부</div>
                        <div>
                            <div class="form-check">
                                <input type="checkbox" id="open" name="open" class="form-check-input">
                                <input type="hidden" name="_open" value="on"/><!-- 히든 필드 추가 -->
                                <label for="open" class="form-check-label">판매 오픈</label>
                            </div>
                        </div>
                ```

                이렇게 히든 타입의 input 태그를 넣어 name속성에 _하나를 덧붙여서 사용하게 되면 기본적으로 _open은 항상 = on으로 넘어가게 되며 이는 스프링 MVC에서 false로 자동으로 넣어준다. 체크 해제를 인식하기 위한 전통적인 트릭이다!!

            2. 타임리프 활용법

                ```jsx
                <!-- single checkbox -->
                        <div>판매 여부</div>
                        <div>
                            <div class="form-check">
                                <input type="checkbox" id="open" th:field="*{open}" class="form-check-input">
                                <label for="open" class="form-check-label">판매 오픈</label>
                            </div>
                        </div>
                ```

                서버 렌더링 타임때 th:field가 알아서 히든 필드 까지 생성을 해준다. 자동으로 open의 불린 값에 따라 checked 속성도 추가해준다.

        - **멀티 체크박스**

            ```jsx
            <!-- multi checkbox -->
                    <div>
                        <div>등록 지역</div>
                        <div th:each="region : ${regions}" class="form-check form-check-inline">
                            <input type="checkbox" th:field="*{regions}" th:value="${region.key}"
                                   class="form-check-input">
                            <label th:for="${#ids.prev('regions')}"
                                   th:text="${region.value}" class="form-check-label">서울</label>
                        </div>
                    </div>
            ```

            `th:for="${#ids.prev('regions')}"`

            name 속성은 일치 해도 되지만 id는 각각 다르게 생성해야된다. ids 라는 유틸리티 객체를 활용해 ‘regions’의 id를 가져오는 예제이다. label과 input id는 일치해야하기 때문에 동적으로 th:field로 생성한 id를 접근할때 사용하는 방식이다.

            참고로 이 예제도 th:field가 히든 필드를 자동 생성 해준다.

        - **라디오**

            ```jsx
            <!-- radio button -->
                    <div>
                        <div>상품 종류</div>
                        <div th:each="type : ${itemTypes}" class="form-check form-check-inline">
                            <input type="radio" th:field="*{itemType}" th:value="${type.name()}"   class="form-check-input">
                            <label th:for="${#ids.prev('itemType')}" th:text="${type.description}" class="form-check-label"> BOOK</label>
                        </div>
                    </div>
            ```

            `th:for="${#ids.prev('itemType')}”`

            멀티 체크박스 구현과 거의 동일하다. 다만 멀티체크박스는 데이터타입이 Map, 이건 배열이라는 차이가 좀 있으며 서버 렌더링시 히든필드를 만들지 않는다는 차이가 있다.

        - **셀렉트 박스[드롭다운]**

            ```jsx
            <!-- SELECT -->
                    <div>
                        <div>배송 방식</div>
                        <select th:field="*{deliveryCode}" class="form-select">
                            <option value="">==배송 방식 선택==</option>
                            <option th:each="deliveryCode : ${deliveryCodes}" th:value="${deliveryCode.code}" th:text="${deliveryCode.displayName}">FAST</option>
                        </select>
                    </div>
            ```

            input 태그가 없기 때문에 `th:for=` 와같은 속성은 필요 없지만 대신 구현 자체가 멀티 체크 박스와 반대로 되어있다. 각 input 태그들을 th:field를 사용해준것과 달리 select 태그에 th:field를 넣고 내부에 option들을 th:each로 돌려서 option들을 넣어준다

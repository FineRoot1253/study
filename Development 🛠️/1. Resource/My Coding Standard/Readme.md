# My Coding Standard

# 문서화

## 문서화 타입

### 코드 문서화

<aside>
💡 **코드는 코드 그 자체가 문서여야한다.**

단, 최적화의 문제나 특별한 로직의 어느 특성상 설명이 반드시 필요한 구현의 경우 문서화를 해야한다.

</aside>

- 행동요령
    1. 코드는 기본적으로 문서화를 하지 않는다.
    2. 읽거나 이해하기 힘들 수 밖에 없는 특정 로직이나 구현등에만 문서화를 해야한다.
- 이유

    코드는 그 자체가 클린하게 작성되어 누구나 이해가 가능해야 유지보수가 가장 쉽다.

    **문서가 존재하는 순간** 그 로직은 문서가 의존하는 로직이기 때문에 **로직을 수정하면 문서도 수정해야하기 때문**이다.


### 프로세스 문서화

<aside>
💡 신규 입사자 웰컴 페이지, 안내 사항, 워크 플로 설명, 각종 환경 설치, 디비 이관, 코드 수정 등등의 가이드 문서

</aside>

- 행동요령
    1. 작은 프로세스라도 문서화를 해야한다. 심지어 프린터 출력하는 방법이나 wifi 비번등까지도
    2. 프로세스가 아주 작은 변동이 일어난다고 하면 바로 수정해야한다.
    가이드 문서 메인테이너가 있다면 메인테이너에게 수정제안을 해야한다.
- 이유

    각종 업무 프로세스를 이해하고 회고하는데에 필요한 필수 요소이기 때문에 무조건 있는 것이 좋다.

    일은 언제나 나 혼자 한다고 생각하면 안된다.

    인생에 있어 회사는 중요한 거처이지만 평생 동반자는 아니라는 점을 명심하자.

- 참고

    노션만 써도 충분 하겠지만 지라를 쓴다면 confluence를 활용하자. 노션, 깃허브 링크등을 자연스럽게 첨부하기 좋은 방법이다.


### 라이브러리, Web API등 public한 문서 문서화

<aside>
💡 라이브러리, Web API등 **타인이 보게끔(사용하게끔) 만든 특정 기술**들은 반드시 문서화 해야한다.

</aside>

- 행동요령
    1. 인풋, 아웃풋에 대한 모든 데이터 설명과 로직 구동 과정등을 상세히 기술한다.
- 출처
    1. Clean Code

        [[Clean Code]]

    2. Code Complete

        [[Code Complete]]

    3. Refactoring

        [[Refactoring]]

    4. TDD

        [[Test Driven Development]]

    5. Unit Test

        [[2. Area 🔥/Development 🛠️/1. Resource/My Coding Standard/Unit Test]]

    6. ThoughtWorks Anthology

        [[ThoughtWorks Anthology]]

    7. 객체 지향과 디자인 패턴

        [[2. Area 🔥/Development 🛠️/1. Resource/My Coding Standard/객체 지향과 디자인 패턴]]

    8. 오브젝트

        [[2. Area 🔥/Development 🛠️/1. Resource/My Coding Standard/오브젝트]]

    9. 객체 지향의 사실과 오해

        [[객체지향의 사실과 오해]]

    10. Gof Design Pattern

        [[2. Area 🔥/Software Architecture 📐/1. Resource/Design Pattern/GOF design pattern/GOF design pattern]]

    11. Scrum Guide

        [[Scrum Guide]]

    12. eXtreme Programming 공식 홈페이지

        [[eXtreme Programming]]

    13. 포프TV

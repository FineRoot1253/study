# Page

DBMS는 페이지로 불리는 **고정된 크기**의 데이터 블록에서 하나 이상의 파일에 걸쳐 데이터베이스를 구성

튜플이나 Indexes등 여러가지 데이터를 내포할 수 있으며 대부분의 DBMS는 페이지 내에서 이런 Type들을 섞어서 두진 않는다.

- 특징
    1. 가변 크기 페이지를 이용할 때 필요한 오버 엔지니어링을 피하기 위해 고정 크기 페이지를 사용한다.

    ### Page ID

    각 페이지에는 고유한 ID가 주어진다.

    - 특징
        1. 데이터 베이스가 단일 파일일 경우 파일 오프셋일 수 있다.
        2. 대부분의 경우 파일 경로 + 오프셋에 매핑하는 간접 계층을 지닌다.

            ⇒  시스템 상위 레벨에서 특정 페이지 번호 요청하고 Storage Manager가 페이지를 찾기 위해 페이지 번호를 파일로 변환후 오프셋을 지정해야한다.


    ### Page Type

    DBMS에는 3가지 고정 크기 타입의 페이지를 이용한다.

    - 타입
        1. Hardware Page

            ⇒ 보통 4KB

        2. OS Page

            ⇒ 4KB

        3. Database Page

            ⇒ 512B ~ 16KB

            ⇒ [4KB = Oracle, IBM DB2], [8KB = PostgreSQL, MS-SQL], [16KB = MySQL]

    - 특징
        1. 저장장치는 Hardware Page 크기의 Atomic Write를 보장한다. [All or Nothing]

            ⇒ **Database Page가 HardwarePage보다 크다면 DBMS 충돌시 프로그램이 Database Page를 디스크에 Write 하도록 추가 조치를 해줘야한다.**

            ⇒ **기본 HardwarePage보다 Database Page가 크면 미처 다 적지 못할 수도 있기 때문**


    ### Page Layout, 페이지 구조

    각 페이지는 페이지 내용에 관한 메타데이터를 넣은 해더를 가지고 있다.

    특정 오라클 같은 DBMS같은 경우 페이지 자체가 독립적이여야합니다.

    - 구조
        1. 페이지 크기
        2. 체크섬, 무결성 검사를 위함
        3. DBMS 버전
        4. 트랜잭션 가시성,(데이터에 따라 트랜잭션에 보일지 말지 결정하는 조건, 멀티 버저닝에 깊게 파면 팔수록 자세히 나온다.)
        5. 압축 정보
    - 페이지 데이터 저장구조
        - Strawman Approach
            - 특징
                1. DBMS는 매번 페이지의 튜플을 추적하고 끝에 튜플을 추가하는 방식
                2. 삭제시 순서가 흩어질 뿐만 아니라 튜플에 가변길이 속성이 있을 시 문제가 발생한다.
        - Slotted Pages
            - 특징
                1. 가장 보편적인 구조이며 slot 배열은 튜플의 시작 위치 오프셋에 매핑합니다.

                    ⇒ [헤더 - 슬롯배열 … 튜플s]

                2. 헤더는 슬롯의 수, 마지막으로 사용된 슬롯의 시작 위치 오프셋을 추적합니다.
                3. 튜플 추가시 슬롯 배열 끝을 증가하고 튜플또한 끝을 증가 시킵니다.

                    ⇒ 이때, 페이지 내부에서 슬롯배열과 튜플이 만나면 페이지가 꽉 찼다고 판단합니다.

                    ⇒ [튜플 추가시 변동모습 = 슬롯배열 끝 → … ← (튜플s 끝, 튜플s 끝 -1, 튜플s 끝 - 2 … )]

        - Log Structured
            - 특징
                1. 튜플을 저장하는 대신 로그 레코드만 저장하는 방식
                2. 삽입, 업데이트, 삭제시 이에 대한 튜플을 파일에 저장합니다.
                    1. 삽입시 튜플 전체를 저장합니다.
                    2. 삭제시 삭제된 튜플을 마킹합니다.
                    3. 업데이트시 변화성이 있는 속성에 대해 변경합니다.(delta of just,)

                    [Delta update - Wikipedia](https://en.wikipedia.org/wiki/Delta_update)

                3. 레코드를 읽을 때, 로그파일을 거꾸로 스캔하고 튜플을 재생성합니다.
                4. 빠르게 작성이 가능하며(CUD), 잠재적으로 느리게 읽습니다.
                5. 스캔이 너무 길어지는 것을 방지하기 위해 특정 위치로 이동 할 수 있도록 인덱스를 가질수 있습니다.
                6. 주기적으로 로그를 압축할 수 있습니다. 다만 쓰기 증폭문제가 있습니다.(같은 데이터를 계속 반복해서 re-write하는 문제)

                    ⇒ (예시: 튜플이 이미 있고 업데이트를 한 경우 업데이트된 튜플 삽입을 위해 이미 있는 튜플로그를 압축)


    ## Tuple Layout

    튜플은 기본적으로 일련의 바이트이다. 이 바이트를 속성의 타입, 값 으로 해석하는 것이 DBMS의 역할이다.

    ### Tuple Header

    튜플의 메타데이터

    DBMS는 스키마에 대한 메타데이터를 여기에 저장할 필요가 없다.

    - 내용
        1. 동시제어 프로토콜의 가시성 정보

            ⇒ 해당 튜플을 생성 OR 수정한 트랜잭션의 정보

        2. NULL 값에 대한 비트맵

    ### Tuple Data

    속성에 대한 실 데이터

    - 특징
        1. 속성은 일반적으로 테이블을 만들 때 지정한 순서대로 저장된다.[postgresql는 pk 위치 빼고 지 맘대로 저장됨]
        2. 대부분의 DBMS는 페이지 크기를 초과하지 않도록 저장한다.

            ⇒ 튜플은 페이지 안에 들어가야하니 당연한 소리임


    ### Denormalized Tuple Data [비정규화 튜플 데이터]

    두 개의 테이블이 관계될 경우 DBMS가 튜플 Pre-Join 시킬수 있다.

    - 특징
        1. 두개의 별도 페이지를 가져오는 것보다 하나만 로드하면 되므로 로딩에 큰 이득이다.
        2. 각 튜플에 더 많은 공간을 필요로 하므로 업데이트 비용이 더 많이드는 단점이 있다.
        3. 몇몇 No-SQL Database는 이것을 구현하고 있다.

            ⇒ 몽고 DB, Couch DB, Raven DB…


    ### Record IDs

    DB의 각 튜플에는 고유한 ID가 할당된다.

    파일 위치 정보를 내포할 수 도있다.

    - 구성

        **page_id + offset or slot**

    - **주의점**

        **애플리케이션은 ID 의존하여 아무 의미를 가질 수 없다.**

        **특히 이 ID는 DBMS마다 부르는 이름이 다르다.**

        - PostgreSQL

            **CTID [4 byte]**

            PostgreSQL은 Vacuum을 통해 이 CTID가 바뀔 수도 있다.

        - SQLite

            **ROWID [8 byte]**

        - Oracle

            **ROWID [10 byte]**

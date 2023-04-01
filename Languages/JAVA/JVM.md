# JVM

## 주요 구성

1. Class Loader

    class 파일들(바이트코드) 들을 엮어 OS에게서 할당 받은 Runtime Data Area에 적재한다.

2. Execution Engine

    메모리에 적재된 바이트 코드들을 기계어로 변경해 명령어 단위로 실행한다.

    - 인터프리터 방식

        명령어 한줄 한줄을 변환하여 실행

    - JIT 방식 [Just-In-Time]

        적절한 타이밍에 전체 바이트 코드를 네이티브로 컴파일된 코드를 실행하는 방식

3. Garbage Collector

    Heap 영역에 적재되어 있지만 참조 되지 않는 객체들을(생성한후 안쓰는 객체) 탐색해 삭제한다.

    - **주의 사항**

        GC가 실행되는 순간 GC가 실행중인 Thread를 제외한 모든 Thread가 정지된다. **[Stop The World]**

        특히, **FULL GC가 발생하는 순간 서비스 장애로 이어지는 치명적인 장애가 발생 할수 도 있다.**

        - **FULL GC**

            오래된 세대에서 발생하는 GC, 메이저 GC라고도 부른다.

        - minor GC

            젊은 세대에서 발생하는 GC

4. **Runtime Data Area**

    JVM이 사용할 메모리 영역, 자바 애플리케이션 실행시 데이터를 적재하는 메모리영역이다.

    총 5 가지로 구분된다. [코드, 데이터, 힙, 스택]

    - **Method Area**
        - 스레드 공유 여부

            모든 스레드끼리 공유

        - 구성 요소
            - 클래스 필드 정보

                클래스 맴버 변수의 이름, 데이터 타입, 접근 제어자 정보

            - 클래스 메소드 정보

                메소드의 이름, 리턴 타입, 파라미터, 접근 제어자 정보

            - 기타 정보 [주로 정적 데이터 정보]
                1. Type 정보 [Interface인지 Class인지]
                2. Constant Pool

                    문자 상수, 타입, 필드, 객체 참조

                3. static 변수
                4. final class 변수
    - **Heap Area**

        new 키워드로 생성된 객체와 배열이 생성되는 영역

        - 스레드 공유 여부

            모든 스레드끼리 공유

        - 특징
            1. **메소드 영역에 로드된 클래스만 생성가능**
            2. **GC가 참조되지 않는 메모리를 확인하고 제거하는 영역**
        - 구성요소
            1. eden [Young Generation]
            2. survivor1 [Young Generation]
            3. survivor2 [Young Generation]
            4. old [Old Generation]
            5. permanent [JDK8부터는 Meta Space라는 이름으로 Native Method Stack으로 편입되서 없는 영역임]
        - 관련 알고리즘
            1. Reference Counting Algorithm

                Garbage 탐색용 알고리즘

                - 특징

                    각 객체마다 참조 될때마다 +1을 하는 Reference Count를 관리한다.

                    Count가 0이 되면 GC를 수행한다.

                - 주의점

                    순환 참조 구조[예를 들면 위임을 통해 부모 자식 관계 매핑등등]에서 Count가 0이 되지 않아 Memory Leak 발생 가능하다.

            2. Mark-and-Sweep Algorithm

                R-C 알고리즘의 단점을 극복하기 위해 나온 Garbage 탐색용 알고리즘

                - 특징

                    Mark 단계와 Sweep단계로 나뉘어 동작한다.

                    Root Set 즉, 최상위에서 처음 참조한 객체에서부터 계속 추적해 마킹을 하고 스윕을 한다.

                    이 단계가 끝나면 다시 마킹 정보를 초기화 한 후 다시 마킹을 시작한다.

                    - Mark

                        Garbage가 아닌 대상에 마킹한다.

                    - Sweep

                        마킹되지 않은 객체를 지운다.

                    - 주의점
                        - 마킹작업과 어플리케이션 Thread 충돌을 방지 하기 위해 Heap 사용이 제한된다.
                        - Compaction 작업이 없다 즉, 비어있는 공간이 충분하지 않을 경우 Out of Memory 발생 가능성이 있다.
            3. Mark-and-Compact Algorithm

                M&S 알고리즘의 단점인 메모리 분산(Fragmentation)을 해결하기 위해 나온 알고리즘

                - 특징

                    M&S 알고리즘과 동일하지만 마지막에 Compact 작업이 추가된다.

                - 주의점

                    Compact작업과 더불어 Reference를 업데이트 하는 작업이 오버헤드를 야기한다.

                    → 메모리가 클 경우 더욱 오버헤드가 커진다.

            4. Copying Algorithm
            5. Concurrent Mark-Sweep Algorithm
            6. Generational Algorithm

                보편적인 GC 알고리즘이다.

                - 절차
                    1. 맨 처음 객체가 Eden에 생성된다.
                    2. 마이너 GC가 동작하면 미사용 객체를 제거 함과 동시에 아직 사용하는 객체는 surv1, surv2로 이동한다.

                        → 만약 객체의 크기가 각 surv 보다 크면 바로 old로 넘어간다.

                    3. 운영 특성상 두 개의 surv중 한 곳은 항상 비워져야 한다.

                        일반적으로 From, To로 구분한다.

                        → surv1이 가득차면 surv2로 옮기고 surv1을 텅 비우는 방식

                    4. 1~3 반복 도중 surv 영역에 계속 살아 남은 객체들에게 일정 score가 누적되어 기준치 이상이 되면 Old Generation 영역으로 이동

                        → Promotion이라고 함

                    5. 4와 마찬가지로 Old Gen에 계속 살아 남은 객체들이 일정 수준 쌓이게 되면 미사용으로 판단된 객체들을 제거해주는 Full GC 발생

                        → Major GC라고 함

                        → 이때 STW(Stop The World) 현상이 발생한다.

                        → JVM 일시 정지

    - **Stack Area**
        - 스레드 공유 여부

            각각 스레드마다 생성되고 공유되지 않음

        - 구성요소

            지역 변수, 파라미터, 연산에 사용되는 임시 값

            한 메서드에 스코프에 있는 필요한 위와 같은 데이터들을 저장하는 공간이다.

            - 주의점

                **한 객체를 생성하였다면 객체 변수는 스택 영역에 저장되고 인스턴스는 힙 영역에 저장된다.**

    - **PC Register**

        Thread가 생성될 때마다 생성되는 영역

        현재 Thread가 실행되는 부분의 주소와 명령을 저장하고 있는 영역이다.

        - 스레드 공유 여부

            각각 스레드마다 생성되고 공유되지 않음


        **컨텍스트 스위칭을 위해 꼭 필요한 영역이다.**

    - **Native Method Stack Area**

        자바외 언어로 작성된 네이티브 코드를 위한 메모리 영역

        **주로 C/C++ 등 코드를 수행하기 위한 스택(JNI)**

        - 스레드 공유 여부

            각각 스레드마다 생성되고 공유되지 않음


    ### Thread 관점에서 바라본 Runtime Data Area


## 가비지 컬렉터

new 연산을 통해 인스턴스화 된 객체를 대신 delete 해주는 머신

### GC의 종류

- Serial GC

    가장 오래된 GC

    하나의 CPU로 Young Gen과 Old Gen을 연속적으로 처리하는 방식

    M&C 알고리즘 사용

- Parallel GC

    자바 7 ~ 8버전 Default로 설정된 GC

    다른 CPU가 GC 진행 시간 동안 대기 상태로 남아 있는 것을 최소화 하는 것

    GC 작업을 병렬로 처리한다

    → STW 시간이 비교적 짧다.

- Parallel Compacting GC

    Parallel GC 처리중 Old Gen 처리 알고리즘을 변경함

- **CMS GC [Concurrent Mark-Sweep] ⭐️**

    기존 Application Thread와 별도로 GC Thread가 동시에 실행되어 STW를 최소화 하는 GC

    Compation 작업의 유무로 Parallel GC와 차이가 있다.

- **G1 GC [Garbage First, G1] ⭐️**

    큰 메모리에서 사용하기 적합한 GC(대규모 Heap 사이즈에서 짧은 GC 시간을 보장하는 것이 주 목적)

    전체 Heap 영역을 Region이라는 영역으로 분할

    상황에 따라 각 Region에 역할이 동적으로 부여된다.

    → eden, surv1,2, old등의 역할을 의미

- Z GC

    Zpage라는 영역을 사용,

    G1 GC의 Region은 크기가 정적이지만 Zpage는 2mb 배수로 동적으로 운영된다.

    STW 정지시간이 최대 10ms를 초과하지 않는 것이 주 목적

    Heap 크기가 증가 하더라도 정지 시간이 증가하지 않는다.


### GC의 원리

<aside>
💡 약한 세대 가설을 기반으로 메모리 구조를 크게 2개로 나눈다. Young Generation, Old Generation

</aside>

- 가정 1

    대부분의 객체는 금방 접근 불가능한 상태가 된다.

    → 대부분의 객체는 스택 프레임에서 사용되고 더 이상 사용하지 않는다.

- 가정 2

    오래된 객체에서 젊은 객체로의 참조는 아주 적게 발생

    → 대부분의 로직들중에서 오래 살아 있던 객체는 다음 로직에서는 보통 사용하지 않음 예를 들면 리턴용 레코드 클래스 객체

    → 예외: 싱글턴 객체


### GC 튜닝 설정 예시

- G1 설정시 설정 플래그
    1. -XX:MaxGCPauseMilis

        최대 GC 중지 시간 설정

    2. -Xmn, -XX:NewRatio, -XX:NewSize

        Young Generation 사이즈 설정

    3. -XX:+UseStringDeduplication

        문자열 중복 제거 옵션 설정




[[Scouter] 오픈소스 APM Scouter 설치 및 연동 가이드](https://waspro.tistory.com/409)

[Index Page](https://jennifersoft.com/en/)

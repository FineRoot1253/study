# System Programming

# System Mode

<aside>
💡 컴퓨터는 3 Tear로 구성되어 있다.  User Mode, Kernel Mode, H/W

</aside>

- User Mode

    유저가 접근 할수 있으며 프로세스가 올라가 있는 영역

- Kernel Mode

    유저가 접근 할수 없으며 모든 Physical 영역에 접근하는 영역


# Multi-Thread

<aside>
💡 Process에 속한 모든 Thread는 Process의 VM 공간안에 제약된다.

</aside>

- **Process**

    CPU가 수행하는 하나의 작업 단위

- **Thread**

    프로세스가 수행하는 하나의 작업 단위

- **주의점**

    한 프로세스에서, 하나의 스레드에 Lock이 걸리면 나머지 스레드는 자동으로 Blocking 된다.


# IPC

프로세스간 통신 방법

Local Machine에서 프로세스끼리의 통신을 주로 의미한다.

- 주요 기법
    1. VM을 이용하는 방식

        특정 프로세스들의 VM의 한 공간을 서로를 가리키게 OS가 만들어주는 방식

        - 특징
            1. 양방향
            2. 메모리 입출력이라 빠르다.
            3. 용량이 작아서 stream처럼 쓰기 힘들다.
    2. Event OR Signal을 이용하는 방식
    3. File을 이용하는 방식

        파일을 통해 한쪽 프로세스는 write만, 한쪽 프로세스는 read만 하도록 만들어 통신하는 방식

        blocking i/o, event polling 방식등을 써서 사용한다.

        보통 이렇게 통신 용도로 파일을 사용할때는 파일을 **파이프[pipe]**라고 명칭한다.

        - 특징
            1. 단방향

                → 근데 단방향 2개를 놓아 양방향처럼 쓸수도 있다.

            2. 파일 입출력이라 느리다.
            3. streaming이 가능하다.
            4. 보통은 누군가 파일에 쓰고 있는 와중에 접근해서 읽어 들이면 OS가 막아버린다. 그것을 OS에서 허용해준 특수한 시스템 파일이 pipe이다.
        - 예시
            - 소켓(socket)

                TCP, UDP 인터페이스를 사용하는 특수한 파일

                소켓의 본질은 원래 파일이다.

                웹브라우저의 경우도 인터넷을 통해 통신을 할때 소켓을 사용하는데 사실은 파일을 이용하는 것이다.

                다만 그 명칭이 socket이다.

                - 특징
                    1. 양방향
                    2. 포트번호만 쓱 넣으면 사용이 쉽다.
                    3. 이걸 로컬머신에서 쓰기엔 패킷 캡슐, 인캡슐 등등 귀찮은 연산들을 거쳐야한다.
            - UDS[Unix Domain Socket]

                유닉스에서 제공하는 로컬머신용 소켓

                - 특징
                    1. 양방향
                    2. 네트워크를 타지 않아 복잡한 네트워크 IO 추상화 과정을 거치지 않는다.

## 전통적인 기법

### 공유 메모리 기법 [Shared Memory]

커널의 도움이 필요없으며 전역변수, 공유 변수, 공유 파일등을 통해 통신을 이룸

OS는 단지 공유 메모리만을 제공한다.

### 메세지 전달 기법 [Message Passing]

- 용어정리
    - 윈도우의 경우

        Event

    - 리눅스, 유닉스 계열

        Signal

- 기법 종류
    1. 시그널
    2. 세마포어
    3. 파이프
    4. 소켓
    5. RPC

## 유닉스 초기 IPC 3가지 기법

- 공유 메모리 기법 [Shared Memory]
- 세마포어 [Semaphore]
- 메세지 큐 [Message Queue]

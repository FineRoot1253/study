# go-talk

![[e24d9680-e94d-11e9-977a-54046597cf22.png]]

- **UseCase**

    [[UseCase(go-talk)]]

- **깃허브 링크**
    - chat_server

        > https://github.com/JunGeunHong1129/chat_server_api
        >

        [[chat_server_api 디테일]]

    - chat_client

        > https://github.com/JunGeunHong1129/chatting_exp_public
        >
- **PORTS**

    [[Ports]]

- **배포설정**

    [[talker-go 배포 설정]]

- **URL**
    - **api.go-talk.kr**
        - 기본 리소스 서버 접속
    - **mqtt.go-talk.kr**
        - mqtt 접속
    - **mqtt-ws.go-talk.kr**
        - mqtt 웹 소켓 접속
    - **rmq-admin.go-talk.kr**
        - rabbitmq 어드민 접속
    - **ha-admin.go-talk.kr**
        - haproxy 어드민 접속
    - **ha-amqp-admin.go-talk.kr**
        - haproxy_amqp_lb 어드민 접속
- **구현된 기능**
    - 유저 회원가입, 로그인
    - 채팅방 생성이 가능한 유저들리스트 확인후 채팅방 생성
    - 초대 가능한 유저 리스트 확인후 유저 초대
    - 유저 채팅
    - 채팅 지우기
    - 유저 채팅방 나가기
- **미흡한 부분**
    - **자동로그인 구현이 안되어있어 백그라운드에서 톡이 오면 케어가 안됨**
        - 로그인 방식이 basic 하나만 구현되어있어 토큰 인증을 위한 구성이 필요
        - **해결 방안**
            - 따로 토큰 전용으로 레디스 따로 구비해두고 각각 MSA 구성하기
                - grpc로 구현예정
    - **테스트 클라가 너무 급하게 만들어서 미흡함**
        - 시간을 들여서 테스트를 더해야함 + 다만 통합 테스트 돌려보기 딱 좋게 생김
        - **해결 방안**
            - 통합 테스트 코드 구현 진행해보기
    - **Go에서 consume 단계도중 에러 발생시 컨트롤이 불가능함**
        - **해결 방안**
            1. 에러 발생시 관련 기기들에 문제발생을 알려줄 것.[”방번호_u” : 라우팅 키]
            2. FCM + 웹소켓도 고려해볼 것[웹소켓 사용시 유저의 커넥션들을 동적으로 완벽히 관리해야함, 단순한 싱글턴은 문제가 많음]
            3. 재시도 3번 후 문제가 해결되지 않으면 문의 부탁 메시지를 등록할 것

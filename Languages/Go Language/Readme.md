# Go Language

## 좋은 Basic Articles

- grpc
    - grpc가 무엇인가

        > [https://hoony-gunputer.tistory.com/entry/GRPC란-무엇인가](https://hoony-gunputer.tistory.com/entry/GRPC%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80)
        >
    - chat rpc

        > [https://github.com/rodaine/grpc-chat/tree/master/protos](https://github.com/rodaine/grpc-chat/tree/master/protos)
        >
    - 기본적인 예시

        > [https://dev.to/techschoolguru/upload-file-in-chunks-with-client-streaming-grpc-golang-4loc](https://dev.to/techschoolguru/upload-file-in-chunks-with-client-streaming-grpc-golang-4loc)
        >
    - connection 인스턴스 관리법

        개인적으로 커넥션에 대한 싱글턴은 싫어한다. (런타임에서 레이스 상태가 예측 가능한건 극혐...)

        go에 어울리지 않는 스타일이기도하고... 나라면 커넥션 워커 풀을 하나 만들어 관리할 것 같다.

        그러면 레이어 별로 나눠서 유닛 테스트 돌려보기도 편하다.

        무엇보다 vscode go extension에 유닛테스트 코드 만들어주는 기능은... 나에겐 신과도 같다.

        (+ 매 요청마다 새로 커넥션 만들어주면 되자나)

        > [https://nowpark.tistory.com/2](https://nowpark.tistory.com/2)
        >
- 기본 개념
    - **기본 문법**

        > [http://golang.site/](http://golang.site/)
        >

        > [https://medium.com/@TonyBologni/go-bits-magic-with-functions-d094a0fb0509](https://medium.com/@TonyBologni/go-bits-magic-with-functions-d094a0fb0509)
        >
    - **모듈 관리 방법**
        - 모듈 관리 방법

            > [https://litaro.tistory.com/entry/Go-언어-초보의-Go-modules-정리-노트-1](https://litaro.tistory.com/entry/Go-%EC%96%B8%EC%96%B4-%EC%B4%88%EB%B3%B4%EC%9D%98-Go-modules-%EC%A0%95%EB%A6%AC-%EB%85%B8%ED%8A%B8-1)
            >
        - 패키지 관리, 선언 방법

            > [https://brownbears.tistory.com/479](https://brownbears.tistory.com/479)
            >
    - **GO 스케쥴러 [MS, PS & GS]**

        > [https://povilasv.me/go-scheduler/](https://povilasv.me/go-scheduler/)
        >
        - **추가적인 관련 분석자료**

            > [http://www.cs.columbia.edu/~aho/cs6998/reports/12-12-11_DeshpandeSponslerWeiss_GO.pdf](http://www.cs.columbia.edu/~aho/cs6998/reports/12-12-11_DeshpandeSponslerWeiss_GO.pdf)
            >
    - **Go 메모리 할당 로직 분석 [TCMalloc]**

        > [https://medium.com/@ankur_anand/a-visual-guide-to-golang-memory-allocator-from-ground-up-e132258453ed](https://medium.com/@ankur_anand/a-visual-guide-to-golang-memory-allocator-from-ground-up-e132258453ed)
        >
    - **Go 메모리 관리 방법 분석**

        > [https://deepu.tech/memory-management-in-golang/](https://deepu.tech/memory-management-in-golang/)
        >
    - **Go Escape 분석 [Stack → Heap, + AST Graph  weight]**

        > [https://medium.com/a-journey-with-go/go-introduction-to-the-escape-analysis-f7610174e890](https://medium.com/a-journey-with-go/go-introduction-to-the-escape-analysis-f7610174e890)
        >
    - **Go scope 사용법**

        > [https://medium.com/golangspec/scopes-in-go-a6042bb4298c](https://medium.com/golangspec/scopes-in-go-a6042bb4298c)
        >
- 아키텍쳐 기본
    - **go 프로젝트 표준 레이아웃**

        > [[httpsgithub.comgolang-standardsproject-layoutblobmasterREADME_ko.md]]
        >
    - **결합을 느슨하게 하는 방법[Accept interfaces, return structs]**

        > [https://bryanftan.medium.com/accept-interfaces-return-structs-in-go-d4cab29a301b](https://bryanftan.medium.com/accept-interfaces-return-structs-in-go-d4cab29a301b)
        >
    - 위의 방법으로 DI 구조 만들기

        > [https://medium.com/@benbjohnson/structuring-applications-in-go-3b04be4ff091](https://medium.com/@benbjohnson/structuring-applications-in-go-3b04be4ff091)
        >
    - **Hexagonal Architecture**

        > [https://medium.com/@matiasvarela/hexagonal-architecture-in-go-cfd4e436faa3](https://medium.com/@matiasvarela/hexagonal-architecture-in-go-cfd4e436faa3)
        >
        >
        > [https://github.com/matiasvarela/minesweeper-hex-arch-sample](https://github.com/matiasvarela/minesweeper-hex-arch-sample)
        >
    - **패키지 기반 디자인**

        > [https://www.ardanlabs.com/blog/2017/02/package-oriented-design.html](https://www.ardanlabs.com/blog/2017/02/package-oriented-design.html)
        >
    - **각종 아키텍쳐들**

        > https://github.com/katzien/go-structure-examples
        >
    - DDD aggregate

        > [https://levelup.gitconnected.com/practical-ddd-in-golang-aggregate-de13f561e629#:~:text=Aggregate is a domain concept,be persisted and deleted together](https://levelup.gitconnected.com/practical-ddd-in-golang-aggregate-de13f561e629#:~:text=Aggregate%20is%20a%20domain%20concept,be%20persisted%20and%20deleted%20together)
        >
- 동시성 패턴
    - **동시성이란**

        > [https://thegopher.tistory.com/3](https://thegopher.tistory.com/3)
        >
    - **SYNC 사용법**

        > [https://velog.io/@whdnjsdyd111/GO-3-11.-패키지-탐방-sync](https://velog.io/@whdnjsdyd111/GO-3-11.-%ED%8C%A8%ED%82%A4%EC%A7%80-%ED%83%90%EB%B0%A9-sync)
        >
    - **API 구현시 동시성 패턴 사용법**

        > [https://tech.deliveryhero.com/concurrent-api-patterns-in-go/](https://tech.deliveryhero.com/concurrent-api-patterns-in-go/)
        >
    - **context 사용법**

        > [https://www.popit.kr/go언어에서-context-사용하기/](https://www.popit.kr/go%EC%96%B8%EC%96%B4%EC%97%90%EC%84%9C-context-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0/)
        >

        > [https://devjin-blog.com/golang-context/](https://devjin-blog.com/golang-context/)
        >

        > [https://janteshital.medium.com/context-in-go-language-63cef994ed4b](https://janteshital.medium.com/context-in-go-language-63cef994ed4b)
        >
    - **고루틴으로 api 요청 한번에 1000개씩 때리는 방법**

        > [https://stackoverflow.com/questions/23318419/how-can-i-effectively-max-out-concurrent-http-requests](https://stackoverflow.com/questions/23318419/how-can-i-effectively-max-out-concurrent-http-requests)
        >
    - **동시성 패턴 구현하다가 아토믹 사용법**

        > [https://stackoverflow.com/questions/47750967/how-to-atomic-store-load-an-interface-in-golang](https://stackoverflow.com/questions/47750967/how-to-atomic-store-load-an-interface-in-golang)
        >
    - **동시성 패턴시 뮤텍스 사용법**

        > [https://umi0410.github.io/blog/golang/go-mutex-semaphore/](https://umi0410.github.io/blog/golang/go-mutex-semaphore/)
        >
    - **분산 처리 비율 리미트**

        > [https://faun.pub/implementing-distributed-rate-limit-in-go-e48d963ca96f](https://faun.pub/implementing-distributed-rate-limit-in-go-e48d963ca96f)
        >
    - **스트림**

        > https://github.com/devnw/stream
        >
    - **MapReduce**

        > [https://blog.devgenius.io/optimizing-the-service-response-time-by-using-mapreduce-d0379755072d](https://blog.devgenius.io/optimizing-the-service-response-time-by-using-mapreduce-d0379755072d)
        >
- 테스트
    - 인터페이스와 단위 테스트

        > [https://www.popit.kr/golang-인터페이스와-단위-테스트/](https://www.popit.kr/golang-%EC%9D%B8%ED%84%B0%ED%8E%98%EC%9D%B4%EC%8A%A4%EC%99%80-%EB%8B%A8%EC%9C%84-%ED%85%8C%EC%8A%A4%ED%8A%B8/)
        >
    - TestMain 사용법

        [Why use TestMain for testing in Go?](https://medium.com/goingogo/why-use-testmain-for-testing-in-go-dafb52b406bc#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImMxODkyZWI0OWQ3ZWY5YWRmOGIyZTE0YzA1Y2EwZDAzMjcxNGEyMzciLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE2Mzg5MzI3NTUsImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwMzAwNjE5ODkwMTgwMDkxNDY2MiIsImVtYWlsIjoiZ2pob25nMTEyOUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXpwIjoiMjE2Mjk2MDM1ODM0LWsxazZxZTA2MHMydHAyYTJqYW00bGpkY21zMDBzdHRnLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwibmFtZSI6IkpHIEgiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2hMclJpMTVHaHNheGxRLXJUcFNZSW5hMlVMRzNDamxuY044aWRNYXc9czk2LWMiLCJnaXZlbl9uYW1lIjoiSkciLCJmYW1pbHlfbmFtZSI6IkgiLCJpYXQiOjE2Mzg5MzMwNTUsImV4cCI6MTYzODkzNjY1NSwianRpIjoiNjQyNjRjMjVkYmFkZjExZWU3OWVkYWY1M2FhMjE5Yjc4ZTk4MjNhMCJ9.fVVD2zNCYlLhIMR47URViOtJUMYHsI8eS14Vjpe_m-BYaXklGv1BnrLXwD9dZWhFRVLpk3pO02CM8Fhb0RKG1BCENeed7IEd8dkmz56stuf28EkM-UTGrK5ugUBwBHkzbFMQjjiO4Y_6Jd1WM0VYdecUjD5ecFhFpMGs_YYiDhUZNxdT6Acvb8mClwZK4Gn6rg6nKwI5U6wAVrgt0jMyiw-_9oA9XX1VS10FJkS5BGgcATe0wwsWqk5VvKVGq2eAJuQEMyQ-C130BbpT0Z_jAJx-_lc2lH3wXP7fYOJE5dr_WF2ytqsE7PeXZdRIHpmqQiBUSydPWUmp7mOw5HbIbQ)


- **고성능 라이브러리**
    - **go language 관련 레포리터리 검색기**

        > [https://golangrepo.com/](https://golangrepo.com/)
        >
    - **JSON-ITERATOR**

        > https://github.com/json-iterator/go
        >
    - **gnet[네트워크 프레임워크 ex : net/http]**

        > https://github.com/panjf2000/gnet
        >
    - **fiber[fasthttp 기반 네트워크 프레임워크, express 스타일]**

        > https://github.com/gofiber/fiber
        >
    - **grpc 프레임워크 [go-zero]**

        > [https://go-zero.dev/en/](https://go-zero.dev/en/)
        >
    - DI 구현 코드 생성기 [wire]

        > [https://medium.com/@jaybabu_/injecting-interfaces-golang-dependency-injection-79ced0636ad2](https://medium.com/@jaybabu_/injecting-interfaces-golang-dependency-injection-79ced0636ad2)
        >

        > https://github.com/google/wire
        >
    - **wrk[스트레스 테스트 모듈]**

        > https://github.com/tsliwowicz/go-wrk
        >
    - **epoll/kqueue 라이브러리**

        > https://github.com/lemon-mint/lemonwork
        >
    - **이벤트 소싱 패턴 &  관련 툴킷**

        > [https://docs.microsoft.com/ko-kr/azure/architecture/patterns/event-sourcing](https://docs.microsoft.com/ko-kr/azure/architecture/patterns/event-sourcing)
        >

        > https://github.com/modernice/goes
        >
    - **go-dpi**

        > https://github.com/mushorg/go-dpi
        >
    - **Key-Value DB**

        > [https://github.com/alash3al/redix?v=5.0.0](https://github.com/alash3al/redix?v=5.0.0)
        >
    - **기본적인 룸 - 유저 구조 서비스**

        > https://github.com/pratts/goroomlib
        >
    - 마크다운대로 디렉터리 구조를 잡아줌

        > https://github.com/ddddddO/gtree
        >
    - **casdoor [sso 툴킷]**

        > [https://casdoor.org/](https://casdoor.org/)
        >
    - 검색 라이브러리

        > https://github.com/blugelabs/bluge
        >

        > https://github.com/go-ego/riot
        >

        > https://github.com/prabhatsharma/zinc
        >
        - **분산 검색 엔진**

            > https://github.com/mosuka/phalanx
            >
        - **인덱싱 탐색 라이브러리**

            > [https://blevesearch.com/](https://blevesearch.com/)
            >
    - **LRU Cache [with Generic]**

        > [https://jins-dev.tistory.com/entry/LRU-Cache-Algorithm-정리](https://jins-dev.tistory.com/entry/LRU-Cache-Algorithm-%EC%A0%95%EB%A6%AC)
        >

        > https://github.com/Workiva/go-datastructures
        >
    - **map reduce 연산[근데 거기에 고루틴을 곁들인]**

        > https://github.com/kevwan/mapreduce
        >
    - **비순환 그래프**

        > https://github.com/protosam/flow
        >
    - 종속성 체크 라이브러리

        > https://github.com/cugu/gocap
        >
    - 재무 처리 기능 몰빵한 라이브러리

        > [https://engineering.razorpay.com/go-financial-a-pkg-for-elementary-financial-functions-892b1532eb2e](https://engineering.razorpay.com/go-financial-a-pkg-for-elementary-financial-functions-892b1532eb2e)
        >
    - **이런저런 라이브러리 다 모은 것**

        > https://github.com/snowmerak/can-be-awesome-libs
        >
    - **한글라이즈**

        > https://github.com/hangulize/hangulize
        >
    -
- 팁
    - **깔끔한 로깅 방법 [runtime package]**

        > [https://wycd.net/posts/2014-07-02-logging-function-names-in-go.html](https://wycd.net/posts/2014-07-02-logging-function-names-in-go.html)
        >
    - **Vimgo 세팅하기**

        > [https://www.joinc.co.kr/w/man/12/golang/Start](https://www.joinc.co.kr/w/man/12/golang/Start)
        >

        > [https://vimawesome.com/plugin/youcompleteme](https://vimawesome.com/plugin/youcompleteme)
        >

        > [https://stackoverflow.com/questions/30017366/vim-error-e492-not-an-editor-command-plugininstall](https://stackoverflow.com/questions/30017366/vim-error-e492-not-an-editor-command-plugininstall)
        >

        > [https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source](https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source)
        >

        > [https://www.hahwul.com/2019/12/24/terminal-golang-vim-go/](https://www.hahwul.com/2019/12/24/terminal-golang-vim-go/)
        >

        > [https://kamang-it.tistory.com/entry/vivimvundlegolanggovim에서-go환경만들기-vimgo](https://kamang-it.tistory.com/entry/vivimvundlegolanggovim%EC%97%90%EC%84%9C-go%ED%99%98%EA%B2%BD%EB%A7%8C%EB%93%A4%EA%B8%B0-vimgo)
        >

        > [https://harryp.tistory.com/457](https://harryp.tistory.com/457)
        >

        > [https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=jogahyok&logNo=220662395613](https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=jogahyok&logNo=220662395613)
        >
    - **MQTT 깔끔한 sub**

        > [https://stackoverflow.com/questions/51088936/subscribing-to-mqtt-messages-using-a-goroutine](https://stackoverflow.com/questions/51088936/subscribing-to-mqtt-messages-using-a-goroutine)
        >
    - **크로스 컴파일**

        > [https://sarc.io/index.php/development/2061-golang-windows-exe](https://sarc.io/index.php/development/2061-golang-windows-exe)
        >

        > [https://stackoverflow.com/questions/12168873/cross-compile-go-on-osx](https://stackoverflow.com/questions/12168873/cross-compile-go-on-osx)
        >
    - **HTTP 사용시 주의사항**

        > [https://medium.com/@nate510/don-t-use-go-s-default-http-client-4804cb19f779](https://medium.com/@nate510/don-t-use-go-s-default-http-client-4804cb19f779)
        >
    - **임의로 로드벨런싱 처리 해놓기**

        > [https://wutch.medium.com/zero-downtime-api-in-golang-d5b6a52cc0ed](https://wutch.medium.com/zero-downtime-api-in-golang-d5b6a52cc0ed)
        >
    - **고퍼 일러스트 무료로 가져다 쓰는 방법]**

        > https://github.com/MariaLetta/free-gophers-pack
        >
- 기타 예제들
    - go 자료구조

        > https://github.com/Workiva/go-datastructures
        >

    - 비디오 스트리밍

        > [https://stackoverflow.com/questions/47560370/stream-video-in-go-lang-server](https://stackoverflow.com/questions/47560370/stream-video-in-go-lang-server)
        >
    - [공식] 벤치마킹 예제

        > [https://golang.org/cmd/go/#hdr-Testing_flags](https://golang.org/cmd/go/#hdr-Testing_flags)
        >
    - 웹소캣 채팅서버 제작일기

        > [https://aidanbae.github.io/gallery/golang-meetup/](https://aidanbae.github.io/gallery/golang-meetup/)
        >

        > [https://www.slideshare.net/SangikBae/golang-websocket-109095156](https://www.slideshare.net/SangikBae/golang-websocket-109095156)
        >
    - 모두의 플러그

        > [https://modu-print.tistory.com/553](https://modu-print.tistory.com/553)
        >
    - 멀티 룸 채팅 웹소켓서버

        > [https://dev.to/jeroendk/multi-room-chat-application-with-websockets-in-go-and-vue-js-part-2-3la8](https://dev.to/jeroendk/multi-room-chat-application-with-websockets-in-go-and-vue-js-part-2-3la8)
        >
    - 채팅 서버

        > https://github.com/manhtai/golang-nsq-chat
        >
    - 전화망 서비스

        > [https://d2.naver.com/helloworld/0814313](https://d2.naver.com/helloworld/0814313)
        >
    - 스트리밍 API 제작방법

        > [https://blog.devgenius.io/implementing-go-stream-api-a74a6156ac35](https://blog.devgenius.io/implementing-go-stream-api-a74a6156ac35)
        >
    - BFF pattern[Backends For Frontends]

        > [https://itnext.io/bff-pattern-with-go-microservices-using-rest-grpc-87d269bc2434](https://itnext.io/bff-pattern-with-go-microservices-using-rest-grpc-87d269bc2434)
        >

- 고 릴리즈 노트

    > [https://betterprogramming.pub/golang-1-18-what-you-need-to-know-a5701f7e14ab?gi=5f7dabd5b702](https://betterprogramming.pub/golang-1-18-what-you-need-to-know-a5701f7e14ab?gi=5f7dabd5b702)
    >

## Projects

- **chat_server (mqtt)**

    [[go-talk]]

- **file_host_server**

    > [https://github.com/JunGeunHong1129/file_host_server](https://github.com/JunGeunHong1129/file_host_server)
    >
- **grpc_server_exp_1**

    >
    >
    1. 테스트 커멘드

        go test -run="none" -bench="BenchmarkMultipartUploadWithHttp" --benchtime=100x

- **chat_server (wsocket)**

    > 준비중
    >
- **geocode_helper [Excel]**

    [[Project/[레인디어 크리에이티브] 지구본/geocode_helper]]


### Tips

1. 빌드
    1. 크로스 컴파일시

        EX: env GOOS=linux GOARCH=arm go build -o ./geocode_helper_linux -v ./main.go

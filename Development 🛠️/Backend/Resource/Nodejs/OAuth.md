# OAuth

## **OAuth**

모던 웹/앱에서 대부분 기용중인 인증 프레임워크

[공식RFC 문서]

> https://tools.ietf.org/html/rfc6749#page-7
>

[공식 JWT 문서]

> https://tools.ietf.org/html/rfc7519#page-7
>

토큰은 **accessToken, refreshToken** 2개 사용

**refreshToken** 은 앱 유저만 사용하는 토큰

### **토큰 발급 프로세스**

```
  1. 기존 인증 next() -> 2. jwt(토큰발급 : middleware) -> 3. header accesstoken 세팅

```

1. 기존 인증에서 next로 다음으로 넘김 아래의 예제는 sendToken으로 넘김

1-1.

[[2. Area 🔥/Development 🛠️/Backend/Resource/Nodejs/OAuth/Untitled.png]]

2-1.

[[2. Area 🔥/Development 🛠️/Backend/Resource/Nodejs/OAuth/Untitled 1.png]]

2-2.

[[2. Area 🔥/Development 🛠️/Backend/Resource/Nodejs/OAuth/Untitled 2.png]]

유저정보, 시크릿키, 유효기간세팅

2-3. 리프레쉬 키또한 모바일 유저에게 전달 해야함[sendToken내부]

[[2. Area 🔥/Development 🛠️/Backend/Resource/Nodejs/OAuth/Untitled 3.png]]

2-4. 리프레쉬키

[[2. Area 🔥/Development 🛠️/Backend/Resource/Nodejs/OAuth/Untitled 4.png]]

이 리프레쉬키는 유저정보 - 리프레쉬키 이렇게 저장이 되어야함

보통 nodejs에서는 redis(메모리로 로드 하는 NoSql)로 저장

[공식 redis]

> https://github.com/noderedis/node-redis/
>

3_. 헤더세팅

[[2. Area 🔥/Development 🛠️/Backend/Resource/Nodejs/OAuth/Untitled 5.png]]

Oauth2.0부터 Bearer Token Flow을 사용하므로 jwt를 사용할 수 있음[공식 RFC 6750]

> https://tools.ietf.org/html/rfc6750#section-2.1
>

### **이후 인증 프로세스**

```
  1. 토큰 검사 -> 리소스이용

```

1. 미들웨어로 토큰 검사 프로세스를 넣어준다

[[2. Area 🔥/Development 🛠️/Backend/Resource/Nodejs/OAuth/Untitled 6.png]]

jwtMiddleware 내부 로직

```
1. req 헤더 authorization에 토큰 유무검사 ->

2. 헤더토큰 유효기간 검사후 헤더 세팅 ->

3. refresh 토큰 유무검사(없으면 웹접속으로 판단) ->

4. refresh 토큰 유효기간 검사후 access 토큰 재발급 후 헤더 세팅 ->

5. redis에 있는 유저정보 delete후 재로그인 요청

```

### **OAuth 미사용시**

1. 사용자 기기 패널

    사용자 계정설정에서 푸시알람을 받는 기기를 기기 리스트에서 선택

    > https://tools.ietf.org/html/rfc6750#section-2.1
    >
2. 세션

    웹과 앱 따로 세션을 적용함

# IOS provisioning

> [https://medium.com/@NovaWoo/ios-인증서-및-프로비저닝-프로파일-만들기-97355848b823](https://medium.com/@NovaWoo/ios-%EC%9D%B8%EC%A6%9D%EC%84%9C-%EB%B0%8F-%ED%94%84%EB%A1%9C%EB%B9%84%EC%A0%80%EB%8B%9D-%ED%94%84%EB%A1%9C%ED%8C%8C%EC%9D%BC-%EB%A7%8C%EB%93%A4%EA%B8%B0-97355848b823)
>

이 프로비저닝의 메뉴얼은 다 좋지만 키를 등록하는 방식이 빠져있습니다.

다음 절차를 이행해 주세요

## 인증서파일 등록하기

1. command + space bar → 키체인 접근
2. 좌측 로그인 클릭 → 내 인증서

    이때, 등록한 키체인이 없다면 등록을 해주셔야 합니다.

    다운받아둔 cert파일을 드래그로 넣어주세요


  3. 이것을 시스템으로 등록을 해주셔야 jenkins 데몬에서 접근이 가능 합니다.

만약 **로그인으로 등록이 되어있다면 시스템에도 다시 등록** 해야합니다.

[[_2021-04-26__2.59.23.png]]

[[_2021-04-26__2.56.52.png]]

**양측 다 등록이 되어있어야 정상적으로 젠킨스 데몬에서 접근이 가능합니다.**

## 각종 이슈

- **(0xE8008018): The identity used to sign the executable is no longer valid 이슈**
    1. window
    2. device and simulator
    3. 우클릭
    4. show Provisioning Profiles
    5. 등록된 프로파일 전부 선택 & - 눌러서 삭제
- **협업시 주의 사항!!!**
    1. 프로파일 에러시 Library/MobileDevices/Provisioning Profiles/ 내부 프로파일들 싹 삭제
    2. xcode에서 다시 프로파일 다운
    3. Product→ clean Build folder
    4. flutter clean후 재빌드 시도
- **[IOS]수동 프로젝트 초기화 방법**

    <aside>
    💡 대다수의 설치, 플러그인 버전 호환 이슈등등에 일단 우선 적용하면 좋은 방법입니다.

    </aside>

    <aside>
    💡  프로비저닝 오류시 이 과정 이후  [**협업시 주의 사항**]의 절차를 이행해 주세요

    </aside>

    > [https://stackoverflow.com/a/34765245](https://stackoverflow.com/a/34765245)
    >
    1. /Users/newzensolution/Library/Developer/Xcode/DrivedData 폴더 파일 삭제
    2. Projects → clean build folder
    3. pod deintergrate
    4. pod cache clean --all
    5. flutter pub cache repair
    6. flutter clean

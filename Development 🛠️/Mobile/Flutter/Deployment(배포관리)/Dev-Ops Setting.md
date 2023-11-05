# Dev-Ops Setting

# Dev-Ops

> [https://aws.amazon.com/ko/devops/what-is-devops/](https://aws.amazon.com/ko/devops/what-is-devops/)
>

> [https://en.wikipedia.org/wiki/DevOps#:~:text=DevOps is a set of,delivery with high software quality](https://en.wikipedia.org/wiki/DevOps#:~:text=DevOps%20is%20a%20set%20of,delivery%20with%20high%20software%20quality).
>

## Environment

- **System OS**

    [[_2021-04-26__10.45.12.png]]

- **Ruby & RVM**
    - Ruby : 2.4.0 (반드시 default로 설정되어야 합니다.)
    - RVM : 1.29.12 (최신버전을 사용해주세요)
- **Jenkins**
    - Jenkins : 2.277.1 (최신버전을 사용해주세요)
- **Fastlane**
    - Fastlane : 2.180.1 (최신버전을 사용해주세요)
- **CI/CD (flavor + github + jenkins + fastlane)**

    ### RVM 설치(ruby version manager)

    > [https://rvm.io/](https://rvm.io/)
    >
    1. GPG Key 설치

        ```bash
        brew install gnupg gnupg2
        gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
        # 만약 gpg2 커멘드를 못 찾는다면 2지우고 gpg로 실행
        ```

    2. ruby 설치

        ```bash
        \curl -sSL https://get.rvm.io | bash -s stable
        source /Users/hongjungeun/.rvm/scripts/rvm # rvm을 환경변수로 만들어준다.
        ```


    ### Fastlane 설치

    > [https://docs.fastlane.tools/getting-started/ios/setup/](https://docs.fastlane.tools/getting-started/ios/setup/)
    >
    1. Xcode command line tools 설치

        ```bash
        xcode-select --install
        ```

    2. ruby version 변경

        ```bash
        rvm list # 설치 되어있는 루비 리스트 조회 명령어 입니다.
        rvm install 2.4.0 # 2.4.0 버전 루비를 설치하는 명령어 입니다.
        rvm use 2.4.0 --default # 2.4.0 버전 루비를 적용함과 동시에 디폴트로 설정합니다.
                                # 이후 새 쉘에서는 2.4.0 버전으로 루비가 설정됩니다.

        ```

    3. fastlane 설치

        ```bash
        sudo gem install fastlane  # 이때 bundler 설치 요구를 먼저 할 수 있습니다.
        # cli에 적힌 로그에 커멘드가 적혀있으니 그걸 따라서 설치합니다. 예시는 아래에 있습니다.
        # 이 작업은 상당히 노가다 작업입니다. 힘들진 않지만 반복 복붙 작업이라 귀찮긴 합니다만
        # 젠킨스에 돌아가는 ruby 런타임 플러그인이 옛날 버전이라 어쩔수 없습니다.
        # 이 일련의 작업들이 귀찮다면 github action(유료)을 사용하십시오.
        ```

        [[_2021-04-26__11.23.50.png]]


    ### Fastlane 설정

    ```bash
    cd ios    # flutter project 로 이동해 각각 ios, 또는 android 폴더로 이동합니다.
    fastlane init # fastlane 초기화 세팅입니다. 2번은 베타 배포, 3번은 앱스토어 배포입니다.
    ```

    이 이후 부터는 install fastlane 첫 인용에 적은 사이트 URL대로 이행하면 됩니다.

    이외의 추가적인 배포자동화 로직 구성은 아래 링크에서 볼 수 있습니다.

    [IOS]

    ios에서는 프로비저닝 이슈가 해결하기 난해하여 굉장히 유명합니다.

    하나하나 정확하게 따라가야합니다.

    [[IOS provisioning]]

    [[ FastFile  로직 구성]]

    ### 깃허브  웹훅(webhooks) 설정

    깃허브 프로젝트 내부로 이동 → Settings → webhooks

    [[_2021-04-26__1.05.58.png]]

    1. 젠킨스 주소를 적어줍니다. 아직 미설치중이라면 일단 localhost:8080을 넣어줍니다.

        (젠킨스 default 포트가 8080 입니다.)

    2. 언제 이 프로젝트를 젠킨스가 땡겨갈지, 이벤트 조건을 넣는 곳입니다.

        저는 이 프로젝트의 형상관리를 development와 production으로

        간단한 flavor 작업을 통해 나눠 놨기 때문에

        아무때나 젠킨스에서 가져가지 않게끔 하고 싶었습니다.

        그래서 git tag가 적혀서 푸시되는 경우에만 트리거 되게끔 만들었습니다.

    3. 그냥 진행 하면 403에러가 발생합니다.

        ```bash
        [http://newzen_appdev:1135148b7954637d4293235eaf6d8a5a8a@inside.newzensolution.co.kr:8787/github-webhook/](http://newzen_appdev:1135148b7954637d4293235eaf6d8a5a8a@inside.newzensolution.co.kr:8787/github-webhook/)
        # 유저ID:githubAcessToken@[url]/gihhub-webhook/ 이렇게 적어야합니다.
        # 만약 좀더 상세하게 job마다 나눠주고싶다면 그것은 파라미터로 넣어주셔야합니다.
        ```


    ### 젠킨스 설치 & 설정

    1. 자바 환경 변수 수정

        현재 젠킨스에 사용될 플러그인은 RVM 입니다.

        이 RVM에 종속적으로 사용되는 ruby-runtime 플러그인은 자바 버전 8버전에서만 작동됩니다.

        그래서 기본으로 설치되어있는 자바가 아닌 8버전을 설치해 환경변수로 잡아준 뒤 설치해야합니다.

        만약 이미 2의 절차를 진행 했다면 다음 manual 방식을 따라가야합니다.

        > [https://github.com/elvanja/jenkins-gitlab-hook-plugin/issues/78#issuecomment-820868773](https://github.com/elvanja/jenkins-gitlab-hook-plugin/issues/78#issuecomment-820868773)
        >
    2. jenkins-lts 설치

        ```bash
        brew install jenkins-lts

        brew services start jenkins-lts # 시작, 중지, 재시작 명령어입니다.

        brew services stop jenkins-lts

        brew services restart jenkins-lts
        # http://localhost:8080/ 으로 접속 합니다.
        # 이어서 진행 하다 보면 최초 어드민 비밀번호를 요구하게 됩니다.
        # 이 비밀번호는 아래 명령어를 통해 확인해주세요
        sudo cat /Users/YOUR_USER_NAME/.jenkins/secrets/initialAdminPassword
        ```

        이후 **플러그인 선택 페이지에선 왼쪽 추천 플러그인 설치**를 선택해줍니다.

    3. Jenkins 설정
        1. Jenkins 대시보드에서 Jenkins관리 -> 플러그인 관리
        2. Github Authentication, Github Integration, RVM 설치
        3. new items → 프로젝트 이름 입력 → free style
        4. Jenkins 대시보드에서 Jenkins관리 → 시스템 설정

            [[_2021-04-26__1.41.21.png]]

            다음과 같이 세팅 후 Jenkins관리 → Global tool configuration

            [[_2021-04-26__1.45.19.png]]

        5.  Jenkins 대시보드 → 방금 만들어둔 Item 프로젝트 우클릭 → 구성

            다음과 같이 세팅해주세요.

            1. 소스 코드 관리

                [[_2021-04-26__1.47.35.png]]

                credentials은 add를 눌러 추가해주면 됩니다.

            2. 빌드 유발 & 빌드 환경 세팅

                [[_2021-04-26__1.59.25.png]]

            3. 스크립트 작성
            1. 1회차 빌드

                ```bash

                rvm install 2.4.0 --default # 1회차 빌드에 이것을 추가해주세요

                ```

                2. 2회차 빌드

                ```bash
                /bin/bash --login
                source ~/.rvm/scripts/rvm
                rvm use default # 잘 되었나 ruby -v를 추가하여 확인하고 수행하는 것도 좋은 방법입니다.
                sudo gem install fastlane # 두번째 단락, 'fastlane 설치' 와 같은 절차를 거쳐야합니다.
                ```

                3. fastlane 정상 설치 이후

                [IOS]

                정상적으로 프로비저닝 세팅이 끝났다면 다음과 같이 쉘 스크립트를 완성 하셔야합니다.

                만약 그렇지 못했을 경우 계속해서 프로비져닝, 코드 사이닝 이슈가 끊임 없이 생성될 것이며 이는 무조건 해결되어야 합니다. xcode와  apple dev 사이트에서 계속해서 프로파일 오류를 수정 해주셔야 합니다.

                ```bash
                /bin/bash --login
                source ~/.rvm/scripts/rvm
                cd ios
                rvm use default
                security default-keychain -s '/Users/[유저이름]/Library/Keychains/login.keychain'
                security -v unlock-keychain -p ${KEYCHAIN_PASSWORD} '/Users/[유저이름]/Library/Keychains/login.keychain'
                fastlane beta --verbose
                ```

                [Android]

                - [ ]  추후 작성 예정

    ### Test

    1. android studio에서 태그 작성후 푸시
    2. 젠킨스에서 빌드 배포 자동화가 이뤄졌는지 확인합니다.
- **Monitering(firebase crashlytics)**
    1. install plugin firebase crashlytics from pub.dev
        - [ ]  추후 작성 예정
    2. setting on your firebase console
        - [ ]  추후 작성 예정
    3. test

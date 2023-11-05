# FastFile  로직 구성

> [https://eunjin3786.tistory.com/223](https://eunjin3786.tistory.com/223)
>
- **2FA 인증 통과 방법**

    ```bash
    rm -rf ~/.fastlane/spaceship/name@gmail.com
    fastlane spaceauth -u name@gmail.com
    #이후 암호를 입력하면
    [✔] 🚀
    [11:40:36]: Get started using a Gemfile for fastlane https://docs.fastlane.tools/getting-started/ios/setup/#use-a-gemfile
    Logging into to App Store Connect (newzensol@gmail.com)...
    Two-factor Authentication (6 digits code) is enabled for account 'newzensol@gmail.com'
    More information about Two-factor Authentication: https://support.apple.com/en-us/HT204915

    If you're running this in a non-interactive session (e.g. server or CI)
    check out https://github.com/fastlane/fastlane/tree/master/spaceship#2-step-verification

    (Input `sms` to escape this prompt and select a trusted phone number to send the code as a text message)

    (You can also set the environment variable `SPACESHIP_2FA_SMS_DEFAULT_PHONE_NUMBER` to automate this)
    (Read more at: https://github.com/fastlane/fastlane/blob/master/spaceship/docs/Authentication.md#auto-select-sms-via-spaceship_2fa_sms_default_phone_number)

    Please enter the 6 digit code:
    211669
    Requesting session...
    Successfully logged in to App Store Connect

    ---

    Pass the following via the FASTLANE_SESSION environment variable:
    ---\n- !ruby/object:HTTP::Cookie\n  name: myacinfo\n  value: DAWTKNV243a6b0423464ff7c632e8db9f1133c32a595e5ec030f0f62e0ced4cb300523cd08861b652a8856d8faf9659336a27bb389351333e8c5a59441f2b38d7611d407aaf170dd6cf916610d9ea10f66151a2d8c5af51d918ace595d53491bf1b31516884290c1b3815c06a4c69c7efb32c64c58b4eb34c7dd280f286a46d8ed3512325001c772c126b3b5db12f1130aef978a48973f65d1e80b10a64a0ef2495bf3f9085dcdc8024225658b0e244ad83637cc2652193d10f49e05e0833576e7a161b382299c8916ddd56d1305f0eac593e2751cedab10fb602ff80ea589f03ce9392b51406d92450667e71771099f2ac48ef19474210c9b52b41dbff5d297d99ad17e145aa94bb1707e41a330c76c57a7ff4165d96ba7bd8121537d682d2bc300ca26f37e28264a569bb397f049508e962ada63408a5b4e2602e1830c9e99dda27b91ecb9a44e013e9b3fd94fc15ebb27eadee29db5f1fb0b35be991384b6d00435a8c3e00a2d019a50286748ffb3de324f4910fcf17214a4ff68aa4acc0ec1fb58579c40de791b4f82aff62717ef1cb78a721a8df87efcdbac5eeb3464afae1c8bd8f42ce108e4003182cce7fd17bfc4376baa04a096ffdbacfd9097dd9c0de4985afc3cf26d0c2fc838f1eacab6ef81ce94a879861d9183e92c1907783a9f694aa282638e665d9ecdad801ba8738444ee4565623834373630656538626632376236656334626264636138313439323732636132656262623136MVRYV2\n  domain: apple.com\n  for_domain: true\n  path: "/"\n  secure: true\n  httponly: true\n  expires:\n  max_age:\n  created_at: 2021-05-17 11:40:53.580181000 +09:00\n  accessed_at: 2021-05-17 11:40:53.585975000 +09:00\n- !ruby/object:HTTP::Cookie\n  name: DES58c82263872815e07cb18eeb4b9d34722\n  value: HSARMTKNSRVXWFla60pQAU4xAFsqibCsKewFRcIueutH070WKQxTpEyTZKb6TG+54wLGtSaUBEguLTPNmgSN58K5UzLdHaEu18SJE/0dcMzWR3R9F/zOi9p149lfurq/d9apic3LTC62LpLNSRVX\n  domain: idmsa.apple.com\n  for_domain: true\n  path: "/"\n  secure: true\n  httponly: true\n  expires:\n  max_age: 2592000\n  created_at: &1 2021-05-17 11:40:53.580047000 +09:00\n  accessed_at: *1\n- !ruby/object:HTTP::Cookie\n  name: dqsid\n  value: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MjEyMTkyNTQsImp0aSI6IlJRenMxWFlZYzVhdWFnajZBbVFPQmcifQ.8rylZOKd8ybzgqoCZfPx-2_kt_PX9JqnzPv9S4HujQg\n  domain: appstoreconnect.apple.com\n  for_domain: false\n  path: "/"\n  secure: true\n  httponly: true\n  expires:\n  max_age: 1800\n  created_at: &2 2021-05-17 11:40:54.319481000 +09:00\n  accessed_at: *2\n

    Example:
    export FASTLANE_SESSION='---\n- !ruby/object:HTTP::Cookie\n  name: myacinfo\n  value: DAWTKNV243a6b0423464ff7c632e8db9f1133c32a595e5ec030f0f62e0ced4cb300523cd08861b652a8856d8faf9659336a27bb389351333e8c5a59441f2b38d7611d407aaf170dd6cf916610d9ea10f66151a2d8c5af51d918ace595d53491bf1b31516884290c1b3815c06a4c69c7efb32c64c58b4eb34c7dd280f286a46d8ed3512325001c772c126b3b5db12f1130aef978a48973f65d1e80b10a64a0ef2495bf3f9085dcdc8024225658b0e244ad83637cc2652193d10f49e05e0833576e7a161b382299c8916ddd56d1305f0eac593e2751cedab10fb602ff80ea589f03ce9392b51406d92450667e71771099f2ac48ef19474210c9b52b41dbff5d297d99ad17e145aa94bb1707e41a330c76c57a7ff4165d96ba7bd8121537d682d2bc300ca26f37e28264a569bb397f049508e962ada63408a5b4e2602e1830c9e99dda27b91ecb9a44e013e9b3fd94fc15ebb27eadee29db5f1fb0b35be991384b6d00435a8c3e00a2d019a50286748ffb3de324f4910fcf17214a4ff68aa4acc0ec1fb58579c40de791b4f82aff62717ef1cb78a721a8df87efcdbac5eeb3464afae1c8bd8f42ce108e4003182cce7fd17bfc4376baa04a096ffdbacfd9097dd9c0de4985afc3cf26d0c2fc838f1eacab6ef81ce94a879861d9183e92c1907783a9f694aa282638e665d9ecdad801ba8738444ee4565623834373630656538626632376236656334626264636138313439323732636132656262623136MVRYV2\n  domain: apple.com\n  for_domain: true\n  path: "/"\n  secure: true\n  httponly: true\n  expires:\n  max_age:\n  created_at: 2021-05-17 11:40:53.580181000 +09:00\n  accessed_at: 2021-05-17 11:40:53.585975000 +09:00\n- !ruby/object:HTTP::Cookie\n  name: DES58c82263872815e07cb18eeb4b9d34722\n  value: HSARMTKNSRVXWFla60pQAU4xAFsqibCsKewFRcIueutH070WKQxTpEyTZKb6TG+54wLGtSaUBEguLTPNmgSN58K5UzLdHaEu18SJE/0dcMzWR3R9F/zOi9p149lfurq/d9apic3LTC62LpLNSRVX\n  domain: idmsa.apple.com\n  for_domain: true\n  path: "/"\n  secure: true\n  httponly: true\n  expires:\n  max_age: 2592000\n  created_at: &1 2021-05-17 11:40:53.580047000 +09:00\n  accessed_at: *1\n- !ruby/object:HTTP::Cookie\n  name: dqsid\n  value: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MjEyMTkyNTQsImp0aSI6IlJRenMxWFlZYzVhdWFnajZBbVFPQmcifQ.8rylZOKd8ybzgqoCZfPx-2_kt_PX9JqnzPv9S4HujQg\n  domain: appstoreconnect.apple.com\n  for_domain: false\n  path: "/"\n  secure: true\n  httponly: true\n  expires:\n  max_age: 1800\n  created_at: &2 2021-05-17 11:40:54.319481000 +09:00\n  accessed_at: *2\n'
    🙄 Should fastlane copy the cookie into your clipboard, so you can easily paste it? (y/n)

    #맨 하단 export FASTLANE_SESSION=... 이것을 젠킨스 쉘 스크립트 source /.zshrc 전줄에 적어준다.
    ```


아래의 예시는 **현 베타 배포 기준, Fastfile** 구성입니다.

```ruby
# This file contains the fastlane.tools configuration
# You can find the documentation at https://docs.fastlane.tools
#
# For a list of all available actions, check out
#
#     https://docs.fastlane.tools/actions
#
# For a list of all available plugins, check out
#
#     https://docs.fastlane.tools/plugins/available-plugins
#

# Uncomment the line if you want fastlane to automatically update itself
# update_fastlane

default_platform(:ios)

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :beta do
    cert
    sigh
    gym(
    scheme: "production",
    configuration: "Release-production",
    output_directory: "./build",
    archive_path: "./archives")
    increment_build_number(xcodeproj: "Runner.xcodeproj")
    build_app(
    scheme: "production",
    workspace: "Runner.xcworkspace",
    scheme: "production",
    configuration: "Release-production",
    output_directory: "./build",
    archive_path: "./archives")
    upload_to_testflight
  end
end
```

여기서 이런식으로 배포 자동화 로직을 넣어 줍니다. 이보다 더 편하게 넣고 싶다면

환경설정이 배포 자동화 설정을 매우 크게 도와줍니다.

그래서 이땐 .env가 해결해줍니다.

```bash
sudo gem install dotenv
vi .env # fastlnane 폴더 기준입니다. 저는 FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD = "XXXX-XXXX-XXXX-XXXX"
# 를 넣어 베포마다 물어보는 비밀번호 절차를 통과하게끔 만들었습니다.
# 이외에 fastfile 내부에서 사용되는 명령어들의 사용법은 아래처럼 커멘드로 찾아 볼 수 있습니다.
fastlane action [명령어]

```

# Deployment(배포관리)

[Dev-Ops Setting](Deployment(%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5)%206970c6e6afb7450481cbd5e39b45bc4f/Dev-Ops%20Setting%201ca960977daf4b8583f6ea229b0504e5.md)

# Flavoring

> [https://medium.com/@salvatoregiordanoo/flavoring-flutter-392aaa875f36](https://medium.com/@salvatoregiordanoo/flavoring-flutter-392aaa875f36)
>

> [https://flutter.dev/docs/deployment/flavors](https://flutter.dev/docs/deployment/flavors)
>

- Flavor는 빌드를 몇 타입으로 나눠서 해야 할 때 사용


    예를 들어, 릴리즈 용 빌드, 내부 검수용 빌드(릴리즈에서 추가 디버깅 기능이 포함된 버전) 등으로 나눠야 할 때 flavor 사용

    [IOS Flavoring](Deployment(%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5)%206970c6e6afb7450481cbd5e39b45bc4f/IOS%20Flavoring%20ea5a5358351240d9a908058b4fb29d75.md)


# Continuous Delivering

- Github Actions + fastlane
- github webhooks + jenkins + fastlane
- CodeMagic


    > [https://flutter.dev/docs/deployment/cd](https://flutter.dev/docs/deployment/cd)
    >

    대체로 이 둘을 사용을 하며 아니면 그냥 네이티브 배포관리툴로 따로 관리를 한다.

    빌드를 하는 단계에서 네이티브 배포관리툴로 사용한다.

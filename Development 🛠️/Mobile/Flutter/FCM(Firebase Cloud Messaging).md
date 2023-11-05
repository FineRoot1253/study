# FCM(Firebase Cloud Messaging)

### FCM Flutter 프론트엔드 구현

[https://www.djamware.com/post/5e4b26e26cdeb308204b427f/flutter-tutorial-firebase-cloud-messaging-fcm-push-notification](https://www.djamware.com/post/5e4b26e26cdeb308204b427f/flutter-tutorial-firebase-cloud-messaging-fcm-push-notification)

위 링크 그대로의 코드이다. 앞으로 수정이 필요하다면

BLOC 패턴으로 아키텍쳐를 바꿔보는게 좋아보인다.

[https://github.com/JunGeunHong1129/flutter_fcm_test_app](https://github.com/JunGeunHong1129/flutter_fcm_test_app)

### FCM nodejs 백엔드 구현

Nodejs Express Generator를 사용해 구현하였다.

간단한 미들웨어 추가로 마무리 했다.

구현시 주의할 점은 어드민을 초기화 해주어야 할때 한번만 하도록 제어해줄 필요가 있다.

Cloud Function을 사용하는 것도 고려해보자

[https://github.com/JunGeunHong1129/flutter_nodejs_fcm_test__backend](https://github.com/JunGeunHong1129/flutter_nodejs_fcm_test__backend)

- [x]  embedding v1으로 마이그레이션 고려해야함(필요없었음 완료)

fcm은 현재 embedding 버전에 따라 적용여부가 달라지고 있다.

깃허브 이슈에 기재된 해결방법을 잘따라서 잘 적용을 해야한다.

[https://medium.com/@demmydwirhamadan/working-well-firebase-cloud-messaging-push-notification-in-flutter-tested-on-android-4eb91f45d45](https://medium.com/@demmydwirhamadan/working-well-firebase-cloud-messaging-push-notification-in-flutter-tested-on-android-4eb91f45d45)

[https://spiralmoon.tistory.com/m/entry/Flutter-Unable-to-create-service-ioflutterpluginsfirebasemessagingFlutterFirebaseMessagingService-javalangRuntimeException-PluginRegistrantCallback-is-not-set](https://spiralmoon.tistory.com/m/entry/Flutter-Unable-to-create-service-ioflutterpluginsfirebasemessagingFlutterFirebaseMessagingService-javalangRuntimeException-PluginRegistrantCallback-is-not-set)

[https://stackoverflow.com/questions/59223259/restrict-fcm-notification-for-a-specific-users-in-flutter](https://stackoverflow.com/questions/59223259/restrict-fcm-notification-for-a-specific-users-in-flutter)

[https://github.com/FirebaseExtended/flutterfire/issues/1775](https://github.com/FirebaseExtended/flutterfire/issues/1775)

이 현재로써 방법이 가장 좋았다

[https://www.djamware.com/post/5e4b26e26cdeb308204b427f/flutter-tutorial-firebase-cloud-messaging-fcm-push-notification](https://www.djamware.com/post/5e4b26e26cdeb308204b427f/flutter-tutorial-firebase-cloud-messaging-fcm-push-notification)

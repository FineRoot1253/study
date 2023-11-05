# flutter_local_notification(푸시알람)

출처

[https://carmine.dev/posts/flutternotifications/](https://carmine.dev/posts/flutternotifications/)

백그라운드에서 동작하는 알람 플러그인

[https://pub.dev/packages/flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

예제 백엔드 코드

[https://github.com/carzacc/websocketsbackend/blob/master/index.js](https://github.com/carzacc/websocketsbackend/blob/master/index.js)

nodejs(웹소켓) + flutter_local_notification 사용

back에서 다시 살린뒤 리슨상태로 만들어야하는것이 힘듬

네이티브에서 workmanager로 살리는 방법을 모색해야함

immotal service를 만드는 방법 또한 생각해 봐야함

workmanager는 이런 과정을 모아둔 라이브러리 이지만

좀 더 적절하게 원하는 동작이 있다면 이 방법을 생각해보자

[https://forest71.tistory.com/185](https://forest71.tistory.com/185)

[https://flatteredwithflutter.com/flutter-and-services/](https://flatteredwithflutter.com/flutter-and-services/)

죽지않은 서비스를 만들면 잡아먹는 메모리누수가 심하기 때문에 아래 글을 따라 observer pattern으로 만드는 것이 좋아 보인다

[https://stfalcon.com/en/blog/post/android-websocket](https://stfalcon.com/en/blog/post/android-websocket)

flutter deferrable push notification 이거로 검색할것

[https://stackoverflow.com/questions/61943309/normal-push-notifications-appear-silently-or-not-at-all-when-the-flutter-app-is](https://stackoverflow.com/questions/61943309/normal-push-notifications-appear-silently-or-not-at-all-when-the-flutter-app-is)

[FCM(Firebase Cloud Messaging)](FCM(Firebase%20Cloud%20Messaging)%20073b7d4365ab443b83891e35e02f983b.md)

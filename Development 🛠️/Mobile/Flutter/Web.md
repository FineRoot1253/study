# Web

1. 전체 창크기 조절시 사용해야할 메소드
    1. [https://api.flutter.dev/flutter/dart-ui/SingletonFlutterWindow/onMetricsChanged.html](https://api.flutter.dev/flutter/dart-ui/SingletonFlutterWindow/onMetricsChanged.html)
    2. [https://api.flutter.dev/flutter/dart-html/Window/onResize.html](https://api.flutter.dev/flutter/dart-html/Window/onResize.html)

      둘다 적용해 볼 것

    기존 screenUtils 같은 경우 전체가 setstate(리빌드)됨

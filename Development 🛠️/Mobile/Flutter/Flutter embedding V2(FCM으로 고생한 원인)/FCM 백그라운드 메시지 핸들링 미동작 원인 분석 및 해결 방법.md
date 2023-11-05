# FCM 백그라운드 메시지 핸들링 미동작 원인 분석 및 해결 방법

## **문제 발생**

플러그인 사용 방법에 맞게 TOP레벨에 핸들러를 선언,

초기화를 한 후에도 firebase onBackgroundMessage에 넣은

백그라운드 메시지 핸들러가 동작을 하지 않음

### **원인1**

firebase 플러그인 자체 목표 개발 환경 버전 문제

firebase 플러그인 개발 환경은 flutter embedding v1을 기준으로 동작함

### **원인1**

flutter embedding v1 전용 플러그인 동작 방법은

GeneratedPluginRegistrant 클래스에 플러그인을 등록하여 동작

특히 기본 플러터 main영역과 떨어져 다른 메모리를 가져가는 isolate된 플러그인들이

flutter embedding v2 환경에서는 데이터를 주고 받는 방식에 제한이 존재

### **원인3**

flutter embedding v1 전용 플러그인 동작방식 :

전용 플러그인은 아래와 같이 registerWith()으로 정적 등록을 하고플러터 동작 시작시 등록해둔 플러그인을 시작과 동시에 초기화하여 동작하는 방식

```java
    public static void registerWith(PluginRegistry registry) {
    }

```

flutter embedding v2 전용 플러그인 동작 방식 :

flutter embedding v2 전용 플러그인은 ActivityAware를 사용해

플러그인을 인스턴스로 접근하여 동작

onAttachedToFlutterEngine으로 플러터 main에 해당하는 영역에 접근하고 onDetachedFromFlutterEngine으로 인스턴스를 해제하는 방식

```java
class MyNewPlugin implements FlutterPlugin, ActivityAware {
  @override
  public void onAttachedToFlutterEngine(FlutterPluginBinding binding) {
    // ...
  }
  @override
  public void onDetachedFromFlutterEngine(FlutterPluginBinding binding) {
    // ...
  }
  @override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
  }

  @override
  public void onDetachedFromActivityForConfigChanges() {
  }
  @override
  public void onReattachedToActivityForConfigChanges(
    ActivityPluginBinding binding
  ) {
  }
  @override
  public void onDetachedFromActivity() {
  }
}

```

즉, **정적으로 등록하여 동작하는 flutter embedding v1**과

**인스턴스를 통해 접근하는 flutter embedding v2의 방식 차이**로 인해

flutter embedding v1을 기준으로 개발된 플러그인인

**fcm플러그인의 isolate영역에 접근을 하지 못하는 문제**가 발생

## **해결 방법**

1) 플러그인 등록을 위해 등록을 시켜주는 FirebaseCloudMessagingPluginRegistrant클래스를

네이티브 영역에 만들어준다

현재 fcm말고도 notification의 확장성 있는 기능개발을 위해

flutter_local_notification도 같이 등록시켜둔다.

```java
public final class FirebaseCloudMessagingPluginRegistrant{
    public static void registerWith(PluginRegistry registry) {
        if (alreadyRegisteredWith(registry)) {
            return;
        }
        FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    }

    private static boolean alreadyRegisteredWith(PluginRegistry registry) {
        final String key = FirebaseCloudMessagingPluginRegistrant.class.getCanonicalName();
        if (registry.hasPlugin(key)) {
            return true;
        }
        registry.registrarFor(key);
        return false;
    }
}

```

2) FlutterApplication를 상속받아 flutter 기본 엔진을 접근하도록

직접 네이티브 영역에서 Application이라는 클래스를 만들어 주고

플러그인을 등록하도록 만들기 위해 PluginRegistrantCallback을 인터페이스로 상속받아

registerWith를 오버라이드 해준다.

```java
public class Application extends FlutterApplication implements PluginRegistrantCallback {

    @Override
    public void onCreate() {
        super.onCreate();
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        FirebaseCloudMessagingPluginRegistrant.registerWith(registry);
    }
}

```

3) AndroidManifest.xml에 application 태그 안, 이름을 만들어둔 Application클래스의 이름으로 변경 시켜준다.

```xml
<application
        android:name=".Application"
        android:label="fcm_tet_01_1008"
        android:icon="@mipmap/ic_launcher">

```

이 상태에서 만약 한번 빌드를 해본 상황이라면 새로운 빌드를 위해 flutter clean을 해주고 다시 빌드를 하면 해결된다.

- **추가 문제&임시 해결 방안**

백엔드에 메시지 형식 속성중 notification의 속성을 만들어두고

**내용은 완전히 비워두어야** 정상작동하는 문제가 남아있다.

이 추가적인 문제는 플러그인 자체의 문제이며 고치기 위해선

플러그인 개발자가 직접 해야하는 영역의 문제이다.

임시 해결 방안으로 해결하기 위해선 메시지 형식의 속성인 data에 보낼 메시지를 넣어주고,

원하는 키값만 끄집어내어 flutter_local_notifications 플러그인의 형식에 맞게 넣어주어야한다.

# MVC(Getx)

[https://pub.dev/packages/get](https://pub.dev/packages/get)

## Get : 상태 관리 플러그인

### 플러그인 소개

Get은 base 자체가 MVC의 맞게끔 설계되어있다.

### Controller의 간단한 사용방법

1. Get.put으로 다음 하위 위젯부터 사용을 하겠다고 선언
2. 그 하위의 위젯들은 Get.find로 사용이 가능하다.

### OBS 소개

[https://flowarc.tistory.com/entry/디자인-패턴-옵저버-패턴Observer-Pattern](https://flowarc.tistory.com/entry/%EB%94%94%EC%9E%90%EC%9D%B8-%ED%8C%A8%ED%84%B4-%EC%98%B5%EC%A0%80%EB%B2%84-%ED%8C%A8%ED%84%B4Observer-Pattern)

obs는 기존의 안드로이드에서 자주 기용하던 observer pattern을 따서 만들어졌다.

### obs 사용방법

1. obs 선언 초기화

    View에서 사용되며 변하게될 변수를 컨트롤러 내에 선언하고

    Rxtype 변수명 = 변수.obs;

    이렇게 변수를 초기화를 해 observer처럼 만들어준다.

2. obs 변수 적용

    적용을 할때는 위의 controller 사용법처럼 미리 뷰에 컨트롤러를 접근 시켜주고

    사용되는 View의 위치에 Obx(()⇒{}); OR Getx()로 빌더를 만들어주면 된다.


그럼 obs를 걸어둔 변수가 변화 할때마다 해당 변수는 observer이므로

수시로 해당 위치만 rebuild하게 된다.

나머지 라우팅이나 스낵바 사용법은 API를 보면서 따라하면 된다. 설명 잘 되어있다.

### 주의사항

아무리 강조해도 지나치치 않은 주의사항이 있다.

1. binding 하는 법 잘보고 사용하기


    - binding


        사용되는 위젯에서 미리 정적으로 선언을 하는 방식인 put을 사용하지 않고 해당 클래스가 필요하게 되어 호출이 될때 선언, 초기화되는 방식


    이를 잘 사용해야 효율적인 코드가 완성된다.

2. MVC 패턴대로 아키텍쳐 분리, 유지 하기


    이 점이 가장 까다롭고 유지하기도 힘들다.

    MVC 패턴 구현시 아래 사항들을 잘 지키면서 하도록 하자

    - [ ]  클래스를 만들되 접근하는 방식을 귀찮아도 일일히 은닉하기

    - [ ]  해당 클래스에서 사용할 필요가 없는 동작(메서드)을 하나의 클래스에 합쳐서 넣지 않기


[https://github.com/kauemurakami/getx_pattern](https://github.com/kauemurakami/getx_pattern)

위의 링크가 이 규칙들을 잘 지키며 만들어진 예제이다.

정 힘들면 이것을 보면서 분리, 유지를 하도록 하자.

```json
- /app
# This is where all the application's directories will be contained
    - /data
    # Directory responsible for containing everything related to our data
        - /provider
        # 데이터 프로바이더는 예를 들어 API, 로컬 데이터베이스 또는 Firebase가 될 수 있음.
            - my_api_provider.dart
        # 여기에서 비동기 데이터 요청, http, 로컬 데이터베이스 함수는 그대로 유지되어야함.
        - /model
        # 객체 추상화를 담당하는 클래스 또는 데이터 모델들이 들어가야함.
            - my_model.dart
        - /repository
            - my_repository.dart
				# 여기서 이 래포지터리는 컨트롤러와 데이터 간의 통신을 중재하는 클래스에 지나지 않습니다.
        # 컨트롤러는 데이터의 출처를 알 필요가 없으며 필요한 경우 컨트롤러에서 하나 이상의 래포지터리를 사용해야 하며.
        # 래포지터리는 엔티티로 분리되어야하고 거의 항상 데이터베이스 테이블을 기반으로 할 수 있습니다.(전에 만든 캡스톤 디자인 모델등등)
        # 내부에는 로컬 API 또는 데이터베이스에서 데이터를 요청하는 모든 함수가 포함됩니다.
        # 즉, 사용자 테이블이 있고 이 를 영구 객체로 편집, 추가, 업데이트 및 삭제하면
				#	이러한 모든 함수가 api에서 요청되고 api 객체가 있는 래포지터리를 갖게됩니다.
				# 이 저장소에서 모든 작업을 사용자에게 개별적으로 호출합니다.
				# 따라서 저장소는이 모델에서 컨트롤러의 필수 속성이므로
				# 컨트롤러는 소스를 알 필요가 없으며 컨트롤러를 초기화하려면
				# 항상 하나 이상의 저장소를 사용해야합니다 (예제 저장소 참조).
    - /modules
    # 각 모듈에는 페이지, 해당 GetXController 및 해당 종속성 또는 바인딩이 포함됩니다.
    # 각 화면에는 고유 한 컨트롤러가 있고 종속 항목도 포함될 수 있으므로 각 화면을 독립적인 모듈로 취급합니다.
    # 이 모듈에서 재사용 가능한 위젯 만 사용하는 경우 폴더를 추가하도록 선택할 수 있습니다.
        - /my_module
            - my_page.dart
            - my_controller.dart
            - my_binding.dart
            - /local_widgets
    # Binding 클래스는 종속성 주입을 분리하는 클래스이며 "바인딩"은 상태 관리자와 종속성 관리자로 라우팅됩니다.
		# 이러한 방식으로 특정 컨트롤러를 사용할 때 어떤 화면이 표시되는지 알 수 있으며, 그 위치와 폐기 방법을 알 수 있습니다.
		# 또한 Binding 클래스를 사용하면 SmartManager 구성 컨트롤을 사용할 수 있습니다.
    # 종속성이 구성되는 방법을 구성하고 스택에서 경로를 제거하거나 폐기를 위해 위젯을 사용할시기를 구성하거나 아무것도 수행하지 않을 수 있습니다.

    - /global_widgets
    # 여러 **modules** 모듈에서 재사용 할 수있는 위젯(커스텀 스낵바).

    - /routes
    # In this repository we will deposit our routes and pages.
    # We chose to separate into two files, and two classes, one being routes.dart, containing its constant routes and the other for routing.
        - my_routes.dart
        # class Routes {
        # This file will contain your constants ex:
        # class Routes { const HOME = '/ home'; }
        - my_pages.dart
        # This file will contain your array routing ex :
        # class AppPages { static final pages = [
        #  GetPage(name: Routes.HOME, page:()=> HomePage())
        # ]};

    - /theme
    #Here we can create themes for our widgets, texts and colors
        - text_theme.dart
        # inside ex: final textTitle = TextStyle(fontSize: 30)
        - color_theme.dart
        # inside ex: final colorCard = Color(0xffEDEDEE)
        - app_theme.dart
        # inside ex: final textTheme = TextTheme(headline1: TextStyle(color: colorCard))
     - /utils
    #Here you can insert utilities for your application, such as masks, form keys or widgets
        - keys.dart
        # inside ex: static final GlobalKey formKey = GlobalKey<FormState>();
        - masks.dart
        # inside ex: static final maskCPF = MaskTextInputFormatter(mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
        - helpers.dart
    # Use classes to make your variables easier to use, eg Keys.myKey, Masks.maskCPF

- main.dart
# main file
# proposed by william Silva and Kauê Murakami
# We also have a version in packages to vocvê that is used to the good old MVC

examples available in this repository: getx_pattern_site and getx_example
```

### data

여기서는 논의 할 것이 없으며 데이터, 모델, 저장소 및 데이터 공급자와 관련된 모든 것을 추출 / 패키징 할 수있는 저장소 일뿐입니다. 모듈 버전을 사용하도록 선택하면 데이터가 동일한 효과를 가지므로 모든 모듈에서 데이터를 사용할 수 있으며 모듈에 필수적인 콘텐츠 만 유지됩니다!
이 디자인의 목적은 flutter를 사용할 때 디렉토리 구조를 가능한 한 작게 만들면서 직관적이고 사용하기 쉽게 학습 과정을 가속화 할 수 있다는 것입니다.

### Provider

obs : 일부 다른 구조에서 "provider"라는 용어는 여러 가지 방법으로 사용될 수 있지만 여기서는 배타적이며 데이터베이스에서 http 요청 또는 지속성을 만드는 데 사용됩니다. 둘 다 사용하는 경우 해당 디렉토리 및 / 또는 파일을 생성하십시오.
여러 요청이있는 경우 파일에 요청을 엔터티별로 분리하거나 동일한 파일에 저장하도록 선택할 수 있습니다. 이것은 개인 선택이며 각 프로그래머에 따라 다릅니다.

### Repository

엔티티를 분리하는 역할을합니다. 기본적으로 엔티티는 Provider와 상호 작용할 데이터베이스의 모든 "테이블"입니다.
repository는 컨트롤러에서 데이터 소스를 추상화하고 분리하도록 설계되었으므로 단일 실패 지점이 있습니다. 즉, 프로젝트의 API 또는 데이터베이스를 변경 한 적이있는 경우 repository를 변경하지 않고 provider(api)파일 만 변경하면됩니다.

**Provider 메서드 호출 만 담당하며 논리가 없습니다.**
특정 회사의 고객 및 제품 만 포함하는 제품 판매 애플리케이션이 있다고 가정하십시오.
우리에게 이런 질문을 함으로써 우리는 우리의 회사의 제품과 고객을 쉽게 식별 할 수 있습니다.
이 엔티티로부터 데이터를 받거나 보낼 수 있습니까? 대답이 '예'이면 repository가 필요합니다.
이 예에서는 UserRepository, ProductRepository, EstablishmentRepository의 세 가지 저장소가 있습니다.
때때로 우리는 클래스를 기반으로 이러한 엔티티를 삭제할 수 있지만 일반적으로 데이터베이스 또는 API에 보조 클래스가 없을 수 있으므로 데이터베이스와의 실제 상호 작용 내용을 기반으로 선호합니다.

### Controller

controller는 응용 프로그램의 중요한 부분으로, 응용 프로그램 중에 변경할 수있는 값을 저장하는 .obs 변수를 생성합니다.
컨트롤러는 또한 repository를 통해 데이터를 사용할 책임이 있습니다.

그러면 Provider의 데이터 호출 규칙만 실행됩니다.

**각 controller에는 repository가 하나만 있어야**하고 **controller에 있는 repository는 하나만 있어야합니다.**

GetX 위젯에서 controller에 필요한 속성을 초기화합니다.
**동일한 페이지에있는 두 개의 서로 다른 리포지토리의 데이터가 필요한 경우**

**두 개의 GetX 위젯을 사용해야**합니다. 페이지 당 하나 이상의 controller를 권장합니다.
예외가 하나뿐이므로 여러 페이지에 동일한 controller를 사용할 수 있으며 매우 간단합니다.

**중요!**

모든 페이지의 데이터가 하나의 repository를 사용하는 경우

controller는 여러 페이지에서 개별적으로만 사용할 수 있습니다

모든 페이지의 데이터가 단일 repository를 사용하는 경우에만 여러 페이지에서 controller를 사용할 수 있다.

이것의 목적은 GetX를 사용하고 기능을 최대한 활용할 수 있도록하는 것이므로 두 개의 엔티티를 조작해야 할 때마다 두 개의 다른 controller와 하나의 뷰가 필요합니다.
왜? 두 개의 repository가 있는 controller가 있으며, 해당 controller가 두 repository에서 검색한 데이터를 사용하여 한 페이지의 GetX 위젯과 함께 사용되고 있다고 가정해 보십시오.
엔터티가 수정될 때마다 controller는 두 변수를 담당하는 위젯을 update하며, 그 중 하나는 변경할 필요가 없습니다. 따라서 repository를 controller별로 분리하면 GetX 위젯으로 작업할 때 각 위젯에 대한 책임 있는 controller를 사용하는 것이 좋은 방법이 될 수 있으며, 이 컨트롤러에서 이러한 정보를 표시하여 .obs 변수가 변경된 위젯만 렌더링할 수 있습니다.

위에서 data의 설명이 제일 복잡하다.

요약하자면 이렇게 된다.

    - /data
    # 이 디렉토리는 데이터와 관련된 모든 것을 포함한다.
        - /provider
        # API(통신되는 객체 HTTP라던가 등등), 로컬 데이터베이스 또는 Firebase을 의미함
            - my_api_provider.dart
        # 여기에서 비동기 데이터 요청, http, 로컬 데이터베이스 함수는 그대로 유지되어야함.
        - /model
        # 객체 추상화를 담당하는 클래스 또는 데이터 모델들이 들어가야함.(주고 받는 데이터)
            - my_model.dart
        - /repository

            - my_repository.dart

컨트롤러와 데이터 간의 통신을 중재하는 클래스

데이터가 어디서 왔는지, 출처를 확인할 필요가 있을시 사용됨

형태는 DB테이블의 형태를 가져야 한다.

특히 API에 따라 필요한 동작들을 지녀야하는데 이를 위해

위에 앞서 설명한 프로바이더의 객체를 이 레포지토리에서 갖게되고

각각의 사용자들에게 이를 개별적으로 전달해 주어야한다.(사용자 테이블이 있다는 가정하에)

### Bindings

종속성 관리에 이상적인 바인딩은 GetView를 통해 컨트롤러와 리포지토리, API들 및 필요한 모든 것을 직접 호출하지 않고도 초기화할 수 있다!

위의 설명대로 실제로 보게되면

모델은 데이터를 주고받는 그릇에 불과하며 api는 이에 사용되는 api(http)등의 클래스가 선언되어있고 각각 필요한 동작도 정의 되어있으며

이 api를 각 사용자에게 제공하기 위해 api의 각각 동작들을 정의하고 있다.

[[MVC(Getx]]%207c68d6bf7d3648a3933759eec64069ff/Untitled.png)

이런 형태를 띄고 있다.

모델(데이터 그릇)의 객체를 API에서 지니고 있고

이 API객체를 repository에서 지니고 있는 형태이다.

접근 형태는

**model → API → repository → Controller**

이런 느낌으로 접근을 한다.

이런식으로 구현을 해야 컨트롤러의 구성이 간편하고 가벼워지며

이를 못하면 필요없는 기능들(예를 들어 API기능들 ex: CRUD)을 컨트롤러에 쑤셔박을 필요가 없다.

컨트롤러가 API의 기능을 직접 지닐 필요가 없기 때문이다.

model에 따라 API를 만들고 repository에서는 그 메서드만 호출하는 기능만 넣으면되며

**repository와 Controller는  1:1이 되어야만 한다.**

그래야 다른 model A와 model B를 필요로 하는 뷰 하나에서 model A가 업데이트되면 model A만 업데이트를 할수 있기 때문이다. 만약 저 모델 2개가 하나의 컨트롤러에 들어있다면

A만 업데이트가 됬음에도 불구하고 B도 업데이트를 같이 돌려버리기때문에

뷰 A에 업데이트가 필요한 부분에 각각 getx를 걸고 getx에 걸린 컨트롤러만 달리해주면

각각 업데이트가 되기 때문에 훨씬 이상적이다.

정리

1.  API는 model에 따라 만들어지며 repository는 만들어진 API의 메소드를 호출하는 기능을 가진다.
2.  API에 따라 만들어진 repository는 뷰에 쓰일 컨트롤러와 1:1이 되어야 한다.
3.  model이 다르면 API에서 사용되는 플러그인이 같더라도 API파일에는 model에 따라 다르게 동작하는 메소드가 들어가야한다.
4.  3)에 따라서 repository도 만들어져야 하며 컨트롤러의 갯수가 많아 질 수도 있다.

그러니 **컨트롤러 하나에 기능들을 몰빵하는게 아닌, 기능마다 컨트롤러를 쪼개주는 것이 현명**하다.

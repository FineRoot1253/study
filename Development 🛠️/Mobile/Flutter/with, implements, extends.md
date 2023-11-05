# with, implements, extends

with은 mixin에 주로 쓰임

implements는 특정 동작을 한 클래스에 강제로 넣을때 사용되며 인터페이스 대신 abstract를 사용

extends는 특정동작을 상위 클래스와 공유하게끔 만들때 사용된다.

abstract와 with을 같이 사용할수 있고

with은 mixin과 같이 쓰이게 만든 특성상 override로 동작을 강제하지 않는다.

```dart
class Animal {}

// behaviors
abstract class Flyer {
  void fly() => print('I can fly!');
}

abstract class Swimmer {
  void swim() => print('I can swim!');
}

class Bird extends Animal with Flyer {}

class Duck extends Animal with Swimmer, Flyer {}
```

위의 코드중 abstract class를 mixin으로 바꿔도 무방하다

그리고 Animal타입으로 **강요**하고 싶다면 on을 사용하면된다.

그렇게 되면 Bird와 Duck은 반드시 extends로 animal을 상속받아야 행위를 공유하게끔 해야한다.

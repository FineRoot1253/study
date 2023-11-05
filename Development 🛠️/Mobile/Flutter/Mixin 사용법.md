# Mixin 사용법

[https://medium.com/flutter-community/https-medium-com-shubhamhackzz-dart-for-flutter-mixins-in-dart-f8bb10a3d341](https://medium.com/flutter-community/https-medium-com-shubhamhackzz-dart-for-flutter-mixins-in-dart-f8bb10a3d341)

출력 결과

Crocodile -------
Swimming
Crawling
Chomp
Eat Zebra
Alligator -------
Swimming
Crawling
Chomp
Eat Fish

mixin은 서로 다른 객체를 상속 하려할때 DDD를 방지하기 위해 생겼다

만약 Musician 클래스에서 Dancer와 Singer를 상속 받으려고 하는데

둘다 Performer클래스를 상속 받는 클래스라고하면

여기서 DDD라는 다이아몬드 형태의 상속형태를 띄게 되는데 이때 오류가 발생한다.

```dart
abstract class Performer {
void perform();
}

class Dancer extends Performer {
void perform() {
print('Dance Dance Dance ');
}
}
class Singer extends Performer {
void perform() {
print('lalaaa..laaalaaa....laaaaa');
}
}

class Musician extends Dancer,Singer {
void showTime() {
perform();
}
}

```

[[2. Area 🔥/Development 🛠️/Mobile/Flutter/Mixin 사용법/Untitled.png]]

상속을 받되 하나의 클래스에서 상속을 받는 클래스들이라면 그 클래스들을 mixin 으로 만들어 두고 최상위의 조상 클래스에 with 으로 만들어두면

조상클래스에서 스택 형태에 따라 알아서 오버라이드되는 메서드를 판단하게되고

상속을 받는 최종 자손 클래스에서 사용해도 문제가 되지 않게끔 동작하게 된다.

```dart
class Performer {
void perform() {
print('performing...');
}
}

mixin Dancer {
void perform() {
print('Dance...Dance...Dance..');
}
}

mixin Singer {
void perform() {
print('lalaaa..laaalaaa....laaaaa');
}
}

class Musician extends Performer with Dancer, Singer {
void showTime() {
perform();
}
}

main(List<String> args) {
Musician m = Musician();

m.perform();
}

```

[[2. Area 🔥/Development 🛠️/Mobile/Flutter/Mixin 사용법/Untitled 1.png]]

이때 출력 결과는 lalala...lalala...가 나오게 되는데

singer가 상속받는 클래스중에 최상단에 위치하게 되기 때문이다.

```dart
mixin Swim {
  void swim() => print('Swimming');
}

mixin Bite {
  void bite() => print('Chomp');
}

mixin Crawl {
  void crawl() => print('Crawling');
}

abstract class Reptile with Swim, Crawl, Bite {
  void hunt(food) {
    print('${this.runtimeType} -------');
    swim();
    crawl();
    bite();
    print('Eat $food');
  }
}

class Alligator extends Reptile {
  // Alligator Specific stuff...
}

class Crocodile extends Reptile {
  // Crocodile Specific stuff...
}

class Fish with Swim, Bite {
  void feed() {
    print('Fish --------');
    swim();
    bite();
  }
}

main() {
  Crocodile().hunt('Zebra');
  Alligator().hunt('Fish');
  Fish().feed();
}
```

이 예제 또한 비슷하게 동작을 하는 예제이다.

다만 이 예제는 최상클래스에서 mixin을 사용하고

앞서 올려둔 예제는 최단 클래스에서 상속을 받는 것이 차이점이다.

그래도 mixin을 통해 전부 상속을 나눠서 사용할수있게 된것은 차이점이 없다.

그리고 아래의 예를 보게 되면

on을 사용하였는데 이렇게 사용하게 되면

hunt()라는 메서드를 Reptile클래스에서만 사용할수 있게되고

mixin에 클래스 사용처를 제한하고 싶다면 on을 쓰고 제한하려는 위치(클래스)를 적으면 된다.

아래의 Educated라는 mixin을 보게되면 저 Alligator라는 클래스에서 사용할려고 하면

이 Educated mixin은 dog로 on 처리를 하고 있기 때문에

Reptile을 상속받고 있는 상태에서는 사용할수가 없다.

그래서 implements로 Dog를 Alligator의 최상위 클래스인

Reptile클래스 마지막에 붙여주어야 사용이 가능하다.

```dart
mixin Swim {
  void swim() => print('Swimming');
}

mixin Bite {
  void bite() => print('Chomp');
}

mixin Crawl {
  void crawl() => print('Crawling');
}

mixin Hunt on Reptile{
    void hunt(food) {
    print('${this.runtimeType} -------');
    swim();
    crawl();
    bite();
    print('Eat $food');
  }
}

mixin Educated on Dog{
  void educated(){
    print('${this.runtimeType} -------');
    swim();
    crawl();
    bite();
  }
}

abstract class Dog with Swim, Crawl, Bite{

}

abstract class Reptile with Swim, Crawl, Bite implements Dog {

}

class Alligator extends Reptile with Hunt, Educated {
  // Alligator Specific stuff...
}

class Crocodile extends Reptile with Hunt {
  // Crocodile Specific stuff...
}

main() {
  Crocodile().hunt('Zebra');
  Alligator().hunt('Fish');
}
```

즉, 다시 말해 **공통된 조상을 가진 클래스** 들을 **한번에 상속**받기 위한 기술이 mixin이며

**mixin의 사용처를 제한 하기위한 방법**으로 **on**이 존재한다.

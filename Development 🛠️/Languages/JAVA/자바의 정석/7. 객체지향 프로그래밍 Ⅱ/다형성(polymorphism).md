# 다형성(polymorphism)

## 다형성이란?

<aside>
💡 여러 가지 형태를 가질 수 있는 능력

</aside>

**자바에서는 조상클래스 타입의 참조변수로 자존클래스의 인스턴스를 참조 할 수 있도록 하여 구현하였다.**

- 예제

    ```java
    class Tv{
    	boolean power;
    	int channel;

    	void power(){
    		power = !power;
    	}
    	void channelUp(){
    		++channel;
    	}
    	void channelDonw(){
    		--channel;
    	}
    }

    class CaptionTv extends Tv{
    	String text;
    	void caption() {
    		// 내용 생략
    	}
    }
    ```

    [[다형성(polymorphism)/IMG_0818.heic)

    ```java
    Tv t = new Tv();
    CaptionTv ct = new CaptionTv();
    ```

    지금까지 Tv 인스턴스를 다루기 위해서는 Tv타입의 참조 변수를 사용하고
    CaptionTv인스턴스를 다루기 위해서는 CaptionTv 타입의 참조변수를 사용했다.

    ```java
    Tv t = new CaptionTv();
    ```

    다음과 같이 상속관계에 있는 객체인 경우
    조상클래스 타입의 참조 변수로 자손 클래스의 인스턴스를 참조하도록 하는 것도 가능하다.

- 예시

    ```java
    Tv t = new CaptionTv();
    CaptionTv ct = new CaptionTv();
    ```

    이 경우 변수 t는 CaptionTv의 모든 변수를 사용할 수 없다.

    Tv 타입의 참조변수로는 CaptionTv의 멤버중 Tv로부터 상속받은 멤버만 사용가능하다.

    즉, **둘 다 같은 타입의 인스턴스이지만 참조변수의 타입에 따라 접근가능한 멤버의 개수가 달라진다.**

    다음과 같은 경우의 메모리는 이런식으로 잡히게 된다.

    [[다형성(polymorphism)/IMG_0819.heic)

- 주의점

    조상 클래스 타입 참조 변수는 자손클래스 인스턴스를 참조하는건 가능하지만
    자손클래스 타입의 참조변수가 조상클래스의 인스턴스를 참조할 수 없다.

    참조 하는 순간 컴파일에러가 발생한다.

    ⇒ 이 이유는 멤버의 개수가 자손 클래스 타입의 참조변수가 더 많기 때문이다.

    즉**, 참조변수가 사용할 수 있는 멤버의 개수는 인스턴스 멤버의 개수보다 같거나 적어야 한다.**

    ⇒ **조상클래스는 항상 자손클래스보다 멤버의 개수가 작거나 같다.**

    모든 참조변수는 null 또는 4byte 주소값이 저장되며
    참조변수의 타입은 참조할 수 있는 객체의 종류와 사용할 수 있는 멤버의 수를 결정한다.

- 정리

    **조상타입의 참조변수로 자손타입의 인스턴스를 참조할 수 있고
    반대로 자손타입의 참조변수로 조상타입의 인스턴스를 참조할 수 없다.**


## 참조변수의 형변환

- 참조변수의 형변환 방향
    - 자손타입 → 조상타입 [Up-Casting]

        ⇒ 형변환 생략가능,

        바로 윗 조상만 가능하지 않고 제한없이 변환이 가능하다.

        ⇒ 모든 참조형 타입은 Object로 변환 가능하다.

    - 조상타입 → 자손타입 [Down-Casting]

        ⇒ 형변환 생략 불가능

- 예시

    ```java
    class Car {
    	String color;
    	int door;

    	void drive(){
    		System.out.println("drive");
    	}

    	void stop(){
    		System.out.println("stop");
    	}
    }

    class FireEngine extends Car {
    	void water(){
    		System.out.println("water");
    	}
    }

    class Ambulance extends Car{
    	void siren(){
    		System.out.println("siren");
    	}
    }
    ```

    [[다형성(polymorphism)/IMG_0820.heic)

    FireEngine과 Ambulance는 Car를 조상으로 두고 있지만 서로 아무런 관계가 없다.

    즉, FireEngine과 Ambulance는 서로 형변환이 되진 않는다.

    ```java
    FireEngine f;
    Ambulance a;
    a = (Ambulance) f; // ERROR!
    f = (FireEngine) a; // ERROR!

    Car car = null;
    FireEngine fe1 = new FireEngine();
    FireEngin fe2 = null;

    car = fe1; // 업 케스팅,  (Car) 생략됨
    fe2 = (FireEngine) car; // 다운 케스팅 , 명시적 형변환 생략 불가
    ```

- 자손 → 조상 업 케스팅시 케스팅 연산 생략 가능한 이유

    **자손 → 조상 케스팅시 조상이 다룰 수 있는 멤버의 개수가 절대 자손보다 많을 수 없기 때문이다. 그래서 형변환 생략이 가능하다.**

- 조상 → 자손 다운 케스팅시 케스팅 연산 생략이 불가능한 이유

    **조상 → 자손 케스팅시 자송이 다룰 수 있는 멤버의 개수가 조상보다 많을 수도 있기 때문이다. 그래서 정확히 어떤 자손으로 케스팅하는지 명시적으로 지칭을 해주어야한다.**

    ⇒ 그래서 형변환 수행전 instanceof 연산을 통해 참조변수가 참조중인 실제 인스턴스의 타입을 확인하는 것이 안전하며 자바는 이를 억지로 제한하진 않지만 특정 언어들은 이런 확인 절차가 없는 경우 컴파일 에러를 발생시키기도 한다.

- 정리

    **형변환은 참조변수의 타입을 변환하는 것이지 인스턴스를 변환하는 것은 아니기 때문에 참조 변수의 형변환은 인스턴스에 영향을 주지 않는다.**

    **단지 참조변수의 형변환을 통해 참조중인 인스턴스에서 사용할 수 있는 멤버의 범위(개수)를 조절하는 것 뿐이다.**


### 예시 [캐스팅 Ⅰ]

```java
package ch7;

public class CastingTest1 {
    public static void main(String[] args) {
        Car car = null;
        FireEngine fe1 = new FireEngine();
        FireEngine fe2 = null;

        fe1.water();
        car = fe1;
        fe2 = (FireEngine) car;
        fe2.water();
    }
}

class Car{
    String color;
    int door;

    void drive(){
        System.out.println("drive");
    }

    void stop(){
        System.out.println("stop");
    }
}

class FireEngine extends Car{
    void water(){
        System.out.println("water");
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_4.02.12.png]]

- 동작과정
    1. Car타입의 참조변수 car를 선언후 null로 초기화
    2. FireEngine 인스턴스 생성후 FireEngine 타입의 참조변수 fe1이 참조하도록 한다.
    3. 참조변수 fe1이 참조 중인 인스턴스를 참조변수 car또한 참조하도록 만든다.

        이때, car는 참조변수의 타입에 없는 멤버인 water()는 사용하지 못한다.

    4. car가 참조중인 인스턴스를 fe2도 참조하도록 한다.

        이때, 두 참조 변수의 타입이 다르고 **다운캐스팅이므로 명시적 형변환**을 시도해야한다.

    5. 결과적으로 참조변수 car, fe1, fe2는 같은 인스턴스를 참조중이며 모두 같은 인스턴스주소를 가지고 있다.

### 예시 [캐스팅 Ⅱ]

```java
package ch7;

public class CastingTest2 {
    public static void main(String[] args) {
        Car car1 = new Car();
        Car car2 = null;
        FireEngine fe = new FireEngine();

        car1.drive();
        fe = (FireEngine) car1;
        fe.drive();
        car2 = fe;
        car2.drive();
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_4.19.14.png]]

- 특징

    컴파일은 성공하지만 런타임 예외가 발생한다.

    문제는 형변환시 Car의 인스턴스를 자손클래스인 FireEngine에 참조시키려고 했기 때문이다.

    **조상타입의 인스턴스를 자손타입의 참조변수로 참조하는 것은 허용되지 않는다.**

- 정리

    **서로 상속관계에 있는 타입간의 형변환은 양방향이 자유롭지만 참조변수가 가리키는 인스턴스의 자손타입으로 형변환은 허용하지 않는다.**

    **그래서 참조변수가 가리키는 인스턴스타입 체킹이 매우 중요하다.**

    특히 자바는 형변환 체킹에 대해 관대한 편이기 때문에 컴파일타임에 이를 잡아낼수가 없다.

    개발단에서 잡아내야한다.


## instanceof연산자

<aside>
💡 참조변수가 참조중인 인스턴스의 타입을 반환

</aside>

- 예시

    ```java
    void doWork(Car c){
    	if (c instanceof FireEngine) {
    		FireEngine fe = (FireEngine) c;
    		fe.water();
    		...
    	} else if (c instanceof Ambulance){
    		Ambulance a = (Ambulance) c;
    		a.siren();
    		...
    	}
    }
    ```

    - 특징

        이 경우 메서드 내부에서는 Car c가 어느 타입의 인스턴스인지 알 방법이 없기 때문에 타입 체킹이 중요하다.

        참조변수와 인스턴스의 타입이 항상 일치하지 않기 때문에 형변환을 거쳐야만 자손타입으로 캐스팅후 자손의 멤버를 제대로 사용할 수 있다.


### 예시 [캐스팅 Ⅲ]

```java
package ch7;

public class InstanceofTest {
    public static void main(String[] args) {
        FireEngine fe = new FireEngine();

        if(fe instanceof FireEngine){
            System.out.println("This is a FireEngine instance.");
        }

        if(fe instanceof Car){
            System.out.println("This is a Car instance");
        }

        if(fe instanceof Object){
            System.out.println("This is an Object instance");
        }
        System.out.println(fe.getClass().getName());
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_4.41.18.png]]

    [[다형성(polymorphism)/IMG_0821.heic)

- 특징

    instanceof 연산 결과에 전부 true인 이유는 전부 상속 관계에 있기 때문이다.

- 정리

    **어떤 타입에 대한 instanceof 연산의 결과가 true라는 것은 검사한 타입으로 형변환이 가능하다는 것을 뜻한다.**


## 참조변수와 인스턴스 연결

조상클래스에 선언된 멤버변수와 같은 이름의 인스턴스변수를 자손 클래스에 중복으로 정의했을 때, 조상타입의 참조변수로 자손 인스턴스를 참조하는 경우와 자손타입의 참조변수로 자손 인스턴스를 참조하는 경우는 서로 다른 결과를 얻는다.

메서드의 경우 조상클래스의 메서드를 자손의 클래스에서 오버라이딩을 해도 참조 타입에 상관없이 항상 실제 인스턴스의 메서드(오버라이딩된 메서드)가 호출되지만, **멤버변수의 경우 참조변수의 타입에 따라 달라진다.**

- 주의점

    static 메서드의 경우 static 변수처럼 참조변수의 타입에 영향을 받는다.

    참조변수의 타입에 영향을 받지 않는 것은 인스턴스메서드 뿐이다.

    그래서 static 메서드는 반드시 참조변수가 아닌 클래스명.메서드()로 호출해야한다.


### 예시 [참조변수와 인스턴스 연결 Ⅰ]

```java
package ch7;

public class BindingTest {
    public static void main(String[] args) {
        Parent p = new Child();
        Child c = new Child();

        System.out.println("p.x = " + p.x);
        p.method();

        System.out.println("c.x = " + c.x);
        c.method();
    }

    private static class Parent{
        int x = 100;

        void method(){
            System.out.println("Parent.method");
        }
    }

    private static class Child extends Parent {
        int x = 200;

        void method(){
            System.out.println("Child.method");
        }
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5.06.02.png]]

- 특징

    중복 정의시 멤버 변수는 참조변수에 묶이고 멤버 메서드는 인스턴스에 묶인다.


### 예시 [참조변수와 인스턴스 연결 Ⅱ]

```java
package ch7;

public class BindingTest2 {
    public static void main(String[] args) {
        Parent p = new Child();
        Child c = new Child();

        System.out.println("p.x = " + p.x);
        p.method();

        System.out.println("c.x = " + c.x);
        c.method();
    }
    private static class Parent{
        int x = 100;

        void method(){
            System.out.println("Parent.method");
        }
    }

    private static class Child extends Parent {}

}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5.11.47.png]]

- 특징

    자손클래스에 중복정의가 되어있지 않는 경우 당연히 기존에 정의된 조상클래스의 멤버들을 사용하게 된다.


### 예시 [참조변수와 인스턴스 연결 Ⅲ]

```java
package ch7;

public class BindingTest3 {

    public static void main(String[] args) {
        Parent p = new Child();
        Child c = new Child();

        System.out.println("p.x = " + p.x);
        p.method();

        System.out.println();
        System.out.println("c.x = " + c.x);
        c.method();
    }

    private static class Parent{
        int x = 100;

        void method(){
            System.out.println("Parent.method");
        }
    }

    private static class Child extends Parent {
        int x = 200;

        void method(){
            System.out.println("x = " + x);
            System.out.println("super.x = " + super.x);
            System.out.println("this.x = " + this.x);
        }
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5.19.10.png]]

- 특징

    중복 정의시 멤버변수는 확실히 참조변수의 타입에 따라 다른 값을 보여주지만

    멤버 메서드는 오버라이딩된 자손의 메서드를 따라가는 모습이다.

    그중 멤버변수를 출력하게되면 당연히 멤버메서드의 멤버를 가리키고 있다.

- 정리

    **멤버변수**가 **조상 클래스와 자손 클래스에 동시 중복 정의**된 경우

    **조상 타입의 참조변수 사용시 조상 클래스에 선언된 멤버변수**가 사용되고

    **자손 타입의 참조변수 사용시 자손 클래스에 선언된 멤버변수**가 사용된다.

    **private 멤버변수를 차단해두는 핵심적인 이유이기도 하다.**

    **private로 멤버변수를 감춰두면 이런일은 일어나지 않는다.**


## 매개변수의 다형성

참조변수의 다형적인 특징은 메서드의 매개변수에도 적용된다.

```java
class Product{
	int price;
	int bonusPoint;
}

class Tv extends Product{}
class Computer extends Product{}
class Audio extends Product{}

class Buyer{
	int money = 1000;
	int bonusPoint = 0;

	void buy(Tv t){
		money = money - t.price;
		bonusPoint = bonusPoint + t.bonusPoint;
	}

}
```

만약 이렇게 buy라는 메서드를 추가하게되면 모든 객체에 대한 buy 메서드를 만들어야한다.

이렇기 때문에 다형성을 이용해주게 되면 깔끔하게 처리된다.

```java
void buy(Product p){
	money = money - t.price;
	bonusPoint = bonusPoint + t.bonusPoint;
}
```

### 예시 [다형성:매개변수]

```java
package ch7;

public class PolyArgumentTest {
    public static void main(String[] args) {
        Buyer b = new Buyer();

        b.buy(new TV1());
        b.buy(new Computer());

        System.out.println("현재 남은 돈은 ".concat(Integer.toString(b.money)).concat("입니다."));
        System.out.println("현재 보너스점수는 ".concat(Integer.toString(b.bonusPoint)).concat("점입니다."));

    }
}

class Buyer {
    int money = 1000;
    int bonusPoint = 0;

    void buy(Product p){
        if(money < p.price){
            System.out.println("잔액 부족");
            return;
        }

        money -= p.price;
        bonusPoint += p.bonusPoint;
        System.out.println(p + " 을/를 구입하셨습니다.");
    }
}

class Product {
    int price;
    int bonusPoint;

    Product(int price) {
        this.price = price;
        bonusPoint = (int) (price / 10.0);
    }
}

class TV1 extends Product {
    TV1() {
        super(100);
    }

    public String toString() {
        return "TV";
    }
}

class Computer extends Product {
    Computer() {
        super(200);
    }

    public String toString() {
        return "Computer";
    }
}

class Audio extends Product {
    Audio() {
        super(50);
    }

    public String toString() {
        return "Audio";
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.57.23.png]]

- 특징

    buy 메서드를 오버로딩없이 한번만 정의해서 사용한다.

    참고로 print메서드에서 toString메서드는 다음과 같이 동작한다.

    ```java
    public void print(Object obj){
    	write(String.valueOf(obj));
    }
    ////
    public static String valueOf(Object obj){
    	return (obj == null) ? "null" : obj.toString();
    }
    ```


## 여러 종류의 객체를 배열로 다루기

위의 사례를 활용하면 배열 또한 다형성으로 여러 종류의 타입의 객체를 동시에 다룰 수 있게 된다.

```java
Product p[] = new Product[3];
p[0] = new Tv();
p[1] = new Computer();
p[2] = new Audio();
```

### 예시 [다형성:배열]

```java
package ch7;

public class PolyArgumentTest2 {
    public static void main(String[] args) {
        Buyer b = new Buyer();

        b.buy(new TV1());
        b.buy(new Computer());
        b.buy(new Audio());
        b.summary();
    }

    private static class Buyer {
        int money = 1000;
        int bonusPoint = 0;
        Product[] item = new Product[10];
        int i = 0;

        void buy(Product p){
            if(money < p.price){
                System.out.println("잔액 부족");
                return;
            }

            money -= p.price;
            bonusPoint += p.bonusPoint;
            item[i++] = p;
            System.out.println(p + " 을/를 구입하셨습니다.");
        }

        void summary(){
            int sum = 0;
            String itemList = "";

            for(int i = 0;i < item.length; i++){
                if(item[i]==null) {
                    break;
                }
                sum += item[i].price;
                itemList += item[i] +", ";

            }
            System.out.println("구입하신 물품의 총 금액은 ".concat(Integer.toString(sum)).concat("만원입니다."));
            System.out.println("구입하신 제품은 ".concat(itemList).concat("입니다."));
        }
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.25.10.png]]

- 특징

    고정크기 배열이라 좀 아쉬운 면이 있다. Vector 클래스를 사용하면 동적 크기배열을 이용해 볼 수 있다.

    | 메서드/생성자 | 설명 |
    | --- | --- |
    | Vector() | 10개의 객체를 저장할 수 있는 Vector 인스턴스를 생성한다.
    10개 이상의 인스턴스가 저장되면, 자동적으로 크기가 증가된다. |
    | boolean add(Object o) | Vector에 객체를 추가한다.
    추가에 성공하면 결과값으로 true, 실패하면 false를 반환한다. |
    | boolean remove(Object o) | Vector에 저장되어 있는 객체를 제거한다.
    제거에 성공하면 결과값으로 true, 실패하면 false를 반환한다. |
    | boolean isEmpty() | Vector가 비어있는지 검사한다.
    비어있으면 true, 비어있지 않으면 false를 반환한다. |
    | Object get(int index) | 지정된 위치(index)에 객체를 반환한다. 반환타입이 Object 타입이므로 적절한 타입으로의 형변환이 필요하다. |
    | int size() | Vector에 저장된 객체의 개수를 반환한다. |

### 예시 [다형성:Vector]

```java
package ch7;

import java.util.Vector;

public class PolyArgumentTest3 {
    public static void main(String[] args) {
        Buyer b = new Buyer();
        TV1 tv = new TV1();
        Computer com = new Computer();
        Audio audio = new Audio();

        b.buy(tv);
        b.buy(com);
        b.buy(audio);
        b.summary();

        b.refund(com);
        b.summary();
    }

    private static class Buyer {
        int money = 1000;
        int bonusPoint = 0;
        Vector<Product> items = new Vector<Product>();
        int i = 0;

        void buy(Product p){
            if(money < p.price){
                System.out.println("잔액 부족");
                return;
            }

            money -= p.price;
            bonusPoint += p.bonusPoint;
            items.add(p);
            System.out.println(p.toString().concat("을/를 구입하셨습니다."));
        }

        void refund(Product p){
            if(items.remove(p)){
                money += p.price;
                bonusPoint -= p.bonusPoint;
                System.out.println(p.toString().concat("을/를 반품하셨습니다."));
            }else{
                System.out.println("구입하신 제품 중 해당 제품이 없습니다.");
            }
        }

        void summary(){
            int sum = 0;
            String itemList = "";

            for(int i = 0;i < items.size(); i++){
                Product p = items.get(i);
                sum += p.price;
                itemList += (i == 0) ? "" + p : ", "+p;

            }
            System.out.println("구입하신 물품의 총 금액은 ".concat(Integer.toString(sum)).concat("만원입니다."));
            System.out.println("구입하신 제품은 ".concat(itemList).concat("입니다."));
        }
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-19_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.52.24.png]]

- 주의점

    summary에서 StringBuilder를 써야 성능 저하가 없다.

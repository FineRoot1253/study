# 생성자(Constructor)

## 생성자란?

<aside>
💡 인스턴스가 생성될 때 호출되는 인스턴스 초기화 메서드

</aside>

인스턴스 변수 초기화 작업에 주로 사용되며 인스턴스 생성 시에 실행되어야 할 작업을 위해서도 사용된다.

구조는 메서드와 유사하지만 반환 타입을 적지 않는다.

### 생성자 조건

1. 생성자의 이름은 클래스의 이름과 같아야한다.
2. 생성자는 리턴 값이 없다.

모든 생성자는 리턴 값이 있을 수 없기에 void를 생략한 것이다.

```java
클래스명(타입 변수명1, 타입 변수명2, ...){
		// 인스턴스 초기화 구문들
}

// 예시
class Card{
	Card(){ // 매개 변수가 없는 생성자
		...
	}

	Card(String k, int num){ // 매개 변수가 있는 생성자
		...
	}

}
```

- 주의점

    인스턴스의 생성은 생성자 메서드가 하는 것이 아니라 new 연산자가 수행하는 것이다. 착각해선 안된다!


### new 연산시 동작 과정

`Card card = new Card();`

1. 연산자 `new`에 의해 메모리 힙 영역에 `Card` 클래스의 인스턴스가 생성된다.
2. 생성자 `Card()`가 호출되고 초기화과정을 수행한다.
3. 연산자 `new`의 결과로, 생성된 `Card` 인스턴스의 주소가 반환되어 참조변수 `card`에 저장된다.

즉, new 뒤에 오는 “`클래스명()`”은 사실 생성자였던 것이였다.

## 기본 생성자(default constructor)

사실 지금껏 생성자 구현 없이도 동작한 이유는 컴파일러가 자동으로 하나씩 끼워주는 기본 생성자가 있었기 때문이다.

만약 컴파일러가 컴파일 진행 도중 클래스에 아무 생성자가 없는 경우 다음과 같은 생성자 구문을 끼워 넣게 된다.

```java
클래스명() { }

// 예시
Card() { }
```

컴파일러는 자동적으로 아무 내용도 파라미터도 없는 생성자를 끼워 넣어준다.

즉, 특별히 인스턴스 초기화 작업이 필요하지 않은 경우엔 따로 생성자를 구현해줄 필요는 없다.

### 예시 [생성자]

```java
package ch6;

public class ConstructorTest {
    public static void main(String[] args) {
        Data1 data1 = new Data1();
        Data2 data2 = new Data2();
    }
}

class Data1{
    int value;
}

class Data2{
    int value;

    Data2(int x){
        value = x;
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-14_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_11.47.48.png]]

- 특징

    이렇게 생성자를 구현해주면 컴파일러가 생성자가 있는 것을 확인하고 기본 생성자를 넣어주지 않게 된다.

    이럴땐 파라미터를 넣어 구현한 생성자를 이용하거나 아님 파라미터가 없는 생성자를 추가로 직접 넣어야한다.

- 정리

    **기본 생성자가 컴파일러에 의해서 추가되는 경우는 클래스에 정의된 생성자가 하나도 없을 때 뿐이다.**


## 매개변수가 있는 생성자

생성자또한 메서드처럼 매개변수를 선언하여 호출 시 값을 넘겨받아 인스턴스의 초기화 작업에 사용 가능하다.

이 방식은 아주 보편적인 생성자 사용 방법이며 일반적으론 다 이 방식으로 객체를 생성해준다.

특히나 생성자와 제어자를 합쳐서 적절히 사용하면 인스턴스 변수와 인스턴스 자체와의 생체주기를 잡아 줄 수 있다.

생성자에 초기화하지 않고 나중에 초기화 하도록 미룬다거나 (지연로딩) 생성자에서 초기화를 하지 않고 미리 초기화를 멤버 변수를 초기화 하거나 이런식으로 필요에 따라 생체 주기를 조정해가며 구현을 하는 것이다.

- 예시

    ```java
    class Car{
    	String color;
    	String gearType;
    	int door;
    	Car(){ }
    	Car(String c, String g, int d){
    		color = c;
    		gearType = g;
    		door = d;
    	}
    }
    /// 기본 생성자
    Car c = new Car();
    c.color = "white";
    c.gearType = "auto";
    c.door = 4;
    /// 매개변수가 있는 생성자
    Car c = new Car("white", "auto", 4);
    ```

    - 특징

        기본 생성자 같은 경우 일일히 멤버 변수에 접근하여 초기화해야하지만

        매개 변수가 있는 생성자의 경우 초기화 방식을 단순화 할 수 있으며 멤버변수 접근을 방지할 수 있는 효과가 가장 크다.

        초기화의 방식을 단조롭게 만드는 것이 가장 좋다.


### 예시 [Car 생성자]

```java
package ch6;

public class CarTest {
    public static void main(String[] args) {
        Car car1 = new Car();
        car1.color = "white";
        car1.gearType = "auto";
        car1.door = 4;

        Car car2 = new Car("white", "auto", 4);

        System.out.println("car1의 color =" + car1.color + ", gearType = "+ car1.gearType + ", door = "+car1.door);
        System.out.println("car2의 color =" + car2.color + ", gearType = "+ car2.gearType + ", door = "+car2.door);
    }
}

class Car {
    String color;
    String gearType;
    int door;

    Car() {
    }

    Car(String c, String g, int d) {
        color = c;
        gearType = g;
        door = d;
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-14_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_1.51.53.png]]


## 생성자에서 다른 생성자 호출하기 [this(), this]

- 생성자에서 다른 생성자 호출 조건
    1. 생성자의 이름으로 클래스이름 대신 this를 사용한다.
    2. 한 생성자에서 다른 생성자를 호출할 때는 반드시 첫 줄에서만 호출이 가능하다.
- 예시

    ```java
    Car(String color){
    	door = 5;
    	Car(color, "auto", 4); // ERROR!
    }

    Car(String color){
    	this(color, "auto", 5); // OK.
    }
    ```

    첫번째의 생성자는 생성자 호출시 this()를 사용하지도 않았고 첫째줄에서 호출하지도 않았다.

    두번째 생성자는 첫번째 호출에 this()를 사용해 올바르게 사용한 방식이다.


### 예시 [this()]

```java
package ch6;

public class CarTest2 {
    public static void main(String[] args) {
        Car car1 = new Car();
        Car car2 = new Car("blue");

        System.out.println("car1의 color =" + car1.color + ", gearType = "+ car1.gearType + ", door = "+car1.door);
        System.out.println("car2의 color =" + car2.color + ", gearType = "+ car2.gearType + ", door = "+car2.door);
    }

    private static class Car {
        String color;
        String gearType;
        int door;
        Car(){
            this("white", "auto", 4);
        }

        Car(String color){
            this(color, "auto", 4);
        }

        Car(String color, String gearType, int door){
            this.color = color;
            this.gearType= gearType;
            this.door = door;
        }
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-14_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_2.07.51.png]]

- 특징

    color만 받는 생성자와 전부 받는 생성자, 안받는 생성자까지 만들어 디폴트 값을 미리 넣어 초기화 되게끔 만든 예제이다.

    이렇게 생성자를 오버로딩하는 방식으로 만들어두면 여러모로 유지보수를 괜찮게 이끌어 갈 수 있다.

    다만 오버로딩 자체를 금지하는 컨벤션을 가진 팀들도 더러있다.

    어설픈 오버로딩은 제대로 된 디폴트 값이 무엇인지 혼동이 오고 알기 힘들다는 이유가 크기 때문이다.

- 정리
    - this

        인스턴스 자신을 가리키는 참조변수, 인스턴스의 주소가 저장되어 있다.
        모든 인스턴스메서드에 지역변수로 숨겨진 채로 존재한다.
        단, 클래스메서드에서는 사용할 수 없다. 현재 클래스의 인스턴스 주소를 가리키고 있기 때문이다.

    - this(), this(매개변수)

        생성자, 같은 클래스의 다른 생성자를 호출할 때 사용한다.


## 생성자를 이용한 인스턴스의 복사

현재 사용하고 있는 인스턴스와 같은 상태를 갖는 인스턴스를 하나 더 만들고자 할 때 생성자를 이용할 수 있다.

```java
// 예시, 파라미터로 Car 참조변수(인스턴스 주소)를 넘겨받음
Car(Car c){
	color = c.color;
	gearType = c.gearType;
	door = c.door;
}
```

### 예시 [생성자:참조형 매개변수]

```java
package ch6;

public class CarTest3 {
    public static void main(String[] args) {
        Car car1 = new Car();
        Car car2 = new Car(car1);

        System.out.println("car1의 color =" + car1.color + ", gearType = "+ car1.gearType + ", door = "+car1.door);
        System.out.println("car2의 color =" + car2.color + ", gearType = "+ car2.gearType + ", door = "+car2.door);

        car1.door = 100;
        System.out.println("car1.door=100 수행 후");
        System.out.println("car1의 color =" + car1.color + ", gearType = "+ car1.gearType + ", door = "+car1.door);
        System.out.println("car2의 color =" + car2.color + ", gearType = "+ car2.gearType + ", door = "+car2.door);
    }

    private static class Car{
        String color;
        String gearType;
        int door;

        Car(){
            this("white","auto",4);
        }

        Car(Car c){
            color = c.color;
            gearType = c.gearType;
            door = c.door;
        }

        Car(String color, String gearType, int door){
            this.color = color;
            this.gearType = gearType;
            this.door = door;
        }
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-15_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_8.49.47.png]]

- 주의점

    ```java
    /// 1)
    Car(Car c){
      color = c.color;
      gearType = c.gearType;
      door = c.door;
    }
    /// 2)
    Car(Car c){
    	this(c.color, c.gearType, c.door);
    }
    ```

    위의 기존 코드 1) 보다 2)가 더 간결하고 깔끔하다.

    항상 더 나은 방법은 없나 고민하는 습관이 중요하다.

- 정리

    **인스턴스 생성시 다음 2가지 사항을 결정해야한다.**

    1. **클래스 - 어떤 클래스의 인스턴스를 생성할 것인가?**
    2. **생성자 - 선택한 클래스의 어떤 생성자로 인스턴스를 생성할 것인가?**

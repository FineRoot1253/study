# 제어자(modifier)

## 제어자란?

<aside>
💡 클래스, 변수 또는 메서드의 선언부에 함께 사용되어 부가적인 의미를 부여한다.

</aside>

- 종류
    - 접근 제어자

        `public`, `protected`, `default`, `private`

    - 그 외 제어자

        `static`, `final`, `abstract`, `native`, `transient`, `synchronized`, `volatile`, `strictfp`

- 주의점

    접근 제어자는 4개중 딱 하나만 선택할 수 있다.

    일반적으로 순서는 접근 제어자를 가장 왼쪽에 적어둔다.


## static - 클래스의, 공통적인

- 사용 위치

    멤버 변수, 메서드, 초기화 블럭


| 대상 | 의미 |
| --- | --- |
| 멤버 변수 |  - 모든 인스턴스에 공통적으로 사용되는 클래스변수가 된다.
 - 클래스변수는 인스턴스를 생성하지 않고도 사용가능하다.
 - 클래스가 메모리에 로드될때 생성된다. |
| 메서드 |  - 인스턴스를 생성하지 않고도 호출이 가능한 static 메서드가 된다.
 - static메서드 내에서는 인스턴스멤버들을 직접 사용할 수 없다. |
- 팁

    인스턴스멤버를 사용하지 않는 메서드는 static을 붙여 조기 로딩을 노려 성능향상을 도모해보자.

- 예시

    ```java
    class StaticTest{
    	static int width = 200;
    	static int height = 120;

    	static {
    		// static 변수의 복잡한 초기화 수행
    	}

    	static int max(int a, int b){
    		return a > b ? a : b;
    	}

    }
    ```


## final - 마지막의, 변경될 수 없는

- 사용 위치

    클래스, 메서드, 멤버변수, 지역변수


| 대상 | 의미 |
| --- | --- |
| 클래스 | 변경될 수 없는 클래스, 확장될 수 없는 클래스가 된다.
그래서 final로 지정된 클래스는 다른 클래스의 조상이 될 수 없다.
일반적으로 클래스 라이브러리의 경우 final로 묶어버리는 경우가 많다.
대표적으로 String, Math등이 있다. |
| 메서드 | 변경될 수 없는 메서드, final로 지정된 메서드는 오버라이딩을 통해 재정의 될 수 없다. |
| 멤버 변수 & 지역변수 | 변수 앞에 final이 붙으면, 값을 변경할 수 없는 상수가 된다. |
- 예시

    ```java
    final class FinalTest{ // 조상이 될 수 없는 클래스
    	final int MAX_SIZE = 10; // 값을 변경할 수 없는 멤버 변수(상수)

    	final void getMaxSize() { // 오버라이딩을 할 수 없는 메서드 (재정의, 변경불가)
    		final int LV = MAX_SIZE;
    		return MAX_SIZE;
    	}
    }
    ```


### 생성자를 이용한 final 멤버 변수의 초기화

final이 붙은 변수는 일반적으로 선언과 초기화를 동시에 하지만,

인스턴스변수라면 생성자에서 초기화 되도록 할 수 있다.

- 특징

    각 인스턴스마다 final이 붙은 멤버변수가 각각 다른 값을 갖도록 하는 것이 가능하다.


### 예시[카드게임 final화]

```java
package ch7;

public class FinalCardTest {

    public static void main(String[] args) {
        Card c = new Card("HEART", 10);
        System.out.println(c.KIND);
        System.out.println(c.NUMBER);
        System.out.println(c);
    }

    private static class Card{
        final int NUMBER;
        final String KIND;
        static int width = 100;
        static int height = 250;

        Card(String kind, int num){
            this.KIND = kind;
            this.NUMBER = num;
        }

        Card(){
            this("HEART",1);
        }

        public String toString(){
            return KIND +" " + NUMBER;
        }

    }

}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-18_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.41.53.png]]


## abstract - 추상의, 미완성의

- 사용 위치

    클래스, 메서드


| 대상 | 의미 |
| --- | --- |
| 클래스 | 클래스 내에 추상 메서드가 선언되어 있음을 의미한다. |
| 메서드 | 선언부만 작성하고 구현부는 작성하지 않은 추상 메서드임을 알린다. |
- 특징

    추상 클래스는 아직 완성되지 않은 메서드가 존재하는 ‘**미완성 설계도**’를 의미한다.

    **즉, 인스턴스를 생성할 수 없다.**

- 예시

    java.awt.event.WindowAdapter는 아무 내용이 없는 메서드만 정의되어 있다.

    인스턴스를 생성하진 못하고 **이 클래스를 상속을 받아 원하는 메서드만 오버라이딩하여 사용**한다.


## 접근 제어자(access modifier)

- 사용 위치

    클래스, 멤버 변수, 메서드, 생성자

- 접근 가능 범위


    | 제어자 | 같은 클래스 | 같은 패키지 | 자손클래스 | 전체 |
    | --- | --- | --- | --- | --- |
    | public | O | O | O | O |
    | protected | O | O | O | X |
    | (default) | O | O | X | X |
    | private | O | X | X | X |
- 사용가능한 위치


    | 제어자 | 사용 가능한 접근 제어자 |
    | --- | --- |
    | 클래스 | public, (default) |
    | 메서드 & 멤버변수 | public, protected, (default), private |
    | 지역변수 | 없음 |

### 접근 제어자를 이용한 캡슐화

접근 제어자의 주 목적은 클래스 내부에 선언된 데이터 보호이다.

이것을 데이터 감추기(data hiding)라고 하며 객체지향이론의 캡슐화(encapsulation)에 해당하는 내용이다.

- 접근 제어자 사용목적
    1. 외부로부터 데이터를 보호하기 위해
    2. 외부에는 불필요하고 내부적으로만 사용되는 부분을 감추기 위해
- 예시

    ```java
    public class Time{
    	public int hour;
    	public int minute;
    	public int second;
    }
    // 외부에서
    Time t = new Time();
    t.hour = 25; // 런타임상 예외에 해당하는 경우!
    ```

    위의 예시처럼 멤버변수를 공개하는 순간 데이터의 정합성이 사라지게 된다.

    이런 경우 private이나 protected로 보호하고
    다른 public 메서드를 추가해 접근 수단을 제공하는 것이 바람직하다.

    ```java
    public class Time{
    	private int hour;
    	private int minute;
    	private int second;

    	public void setHour(int hour){
    		if(hour <0 || hour > 23) {
    			return;
    		}
    		this.hour = hour;
    	}

    	public void setMinute(int minute){
    		if(minute <0 || minute > 59) {
    			return;
    		}
    		this.minute = minute;
    	}

    	public void setSecond(int second){
    		if(second <0 || second > 23) {
    			return;
    		}
    		this.second = second;
    	}

    	public int getHour() {
    		return hour;
    	}

    	public int getMinute() {
    		return minute;
    	}

    	public int getSecond() {
    		return second;
    	}
    }
    ```

    - 특징

        get으로 시작하는 이름의 메서드는 단순히 멤버변수의 값을 반환하는 일을 하고
        set으로 시작하는 이름의 메서드는 매개변수에 지정된 값을 검사하여 조건에 맞는 값일 때만 멤버변수에 값을 변경하도록 작성되어있다.

        만약 상속을 통한 확장가능성이 높은 클래스라면 멤버에 접근 제한을 주되 자손클래스에서 접근하는 것이 가능하도록 하기 위해 private가 아닌 protected를 사용한다.

        private 멤버변수는 자손 클래스에서도 접근이 불가능하기 때문이다.

        <aside>
        💡 보통 “**get멤버변수명**” 이렇게 지은 메서드를 **getter, 게터**라 부르고
        ”**set멤버변수명**” 이렇게 지은 메서드를 **setter, 세터**라고 부른다.

        </aside>

    - 정리

        <aside>
        💡 **일단 게터는 만들어두고 세터는 지양하자.**

        </aside>

        왠만하면 게터는 만드는게 좋다. 특히 값을 리턴할 때 기본형으로 리턴한다면 더욱 좋다.

        다만 참조형을 리턴할때는 해당 참조형의 핵심 멤버변수가 final인지 확인하는편이 좋다.

        만약 기본형 `int channel`을 참조형 `Channel`로 만들고 이것을 사용한다면
        내부의 채널 `value`를 `final int`로 잡아야 안전한 값 객체이다.
        (값 객체의 멤버변수는 일반적으로 불변해야 여러 상황에서 좋다.)

        왠만하면 세터는 안 만드는게 좋다.

        멤버변수에 값을 변경하는 메서드는 특정 행위의 메서드로 제한해두는 것이 바람직한 객체 설계이다.


### 예시 [접근 제어자]

```java
package ch7;

public class TimeTest {

    public static void main(String[] args) {
        Time t = new Time(12, 35, 30);
        System.out.println(t);
//        t.hour = 13;
        t.setHour(t.getHour() + 1);
        System.out.println(t);
    }

    private static class Time{
        private int hour, minute, second;

        Time(int hour, int minute, int second){
            setHour(hour);
            setMinute(minute);
            setSecond(second);
        }

        public void setHour(int hour){
            if(hour <0 || hour > 23) {
                return;
            }
            this.hour = hour;
        }

        public void setMinute(int minute){
            if(minute <0 || minute > 59) {
                return;
            }
            this.minute = minute;
        }

        public void setSecond(int second){
            if(second <0 || second > 23) {
                return;
            }
            this.second = second;
        }

        public int getHour() {
            return hour;
        }

        public int getMinute() {
            return minute;
        }

        public int getSecond() {
            return second;
        }

        @Override
        public String toString() {
            return "Time{" +
                    "hour=" + hour +
                    ", minute=" + minute +
                    ", second=" + second +
                    '}';
        }
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-18_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5.11.52.png]]


### 생성자의 접근 제어자

생성자에 접근 제어자를 사용함으로써 인스턴스의 생성을 제한할 수 있다.

- private 생성자의 특징
    1. **외부에서 인스턴스를 생성할 수 없다.**

        이 특성을 이용한 대표적인 패턴이 싱글턴 패턴이다.

        대신 인스턴스를 생성해서 반환해주는 public 메서드를 static으로 제공함으로써 외부에서 클래스의 인스턴스를 사용하도록 할 수 있다.

    2. **다른 클래스의 조상이 될 수 없다.**

        자손 클래스에서 super()를 호출해야하는데 접근이 불가능해 호출 할수 없기 때문이다.

        **일반적으로 의도적으로 상속방지를 위해 private 생성자를 만들었다면
        클래스명 앞에 final까지 붙여 상속 불가능 클래스임을 들어내는 것이 바람직하다.**


### 예시 [싱글턴]

```java
package ch7;

public class SingletonTest {
    public static void main(String[] args) {
//        Singleton singleton = new Singleton();
        Singleton instance = Singleton.getInstance();
    }
}

final class Singleton{
    private static Singleton instance = new Singleton();

    private Singleton(){}

    public static Singleton getInstance(){
        if(instance == null){
            instance = new Singleton();
        }
        return instance;
    }
}
```

- 특징

    이 패턴을 사용하면 어디 어디서든 이 싱글턴 객체를 접근할 수 있다는 장점이 있다.

- 단점

    동시성 문제에 취약하다.


## 제어자(modifier)의 조합

이 제어자들을 조합하면 여러 패턴들을 만들어 낼 수 있다.

이것을 디자인 패턴(Design Pattern)이라고 부르며 대표적으로 Gang Of Four 디자인 패턴이 유명하다.

GOF 디자인 패턴은 현대 객체지향언어에서 쓰이는 대부분의 패턴들을 소개하며
이중 몇몇 안티패턴으로 여겨지는 패턴을 제외하고 대부분의 패턴들을 지금까지도 사용하고 있다.

그중 하나가 위에서 소개한 싱글턴이다.

- 정리


    | 대상 | 사용가능한 제어자 |
    | --- | --- |
    | 클래스 | public, (default), final, abstract |
    | 메서드 | 모든 접근 제어자, final, abstract, static |
    | 멤버변수 | 모든 접근 제어자, final, static |
    | 지역변수 | final |

    이 테이블을 굳이 애써 외우지않아도 코딩을 하다보면 자연스레 익혀진다.

- 주의점
    1. **메서드에 static과 abstract는 함께 사용할 수 없다.**

        ⇒ static 메서드는 메서드 몸통이 있는 메서드에만 사용가능하기 때문이다.

    2. **클래스에 abstract와 final을 함께 쓸 수 없다.**

        ⇒ 클래스에 사용되는 final은 클래스를 확장할 수 없다는 의미이고 abstract는 상속을 통해서 완성되어야한다는 의미이므로 서로 모순되는 관계이다.

    3. **abstract 메서드의 접근 제어자가 private일 수 없다.**

        ⇒ abstract 메서드는 상속을 받아 구현해야하는 메서드 헤더만 존재하는 메서드인데 private일 경우 상속이 되지 않아 모순이다.

    4. **메서드에 private와 final을 같이 사용할 필요는 없다.**
        5.

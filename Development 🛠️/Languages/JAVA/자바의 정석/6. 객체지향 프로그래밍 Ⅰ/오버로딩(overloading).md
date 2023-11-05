# 오버로딩(overloading)

## 오버로딩이란?

<aside>
💡 한 클래스 내에 같은 이름의 메서드를 여러 개 정의하는 것

</aside>

정확히는 메서드 오버로딩이라고 하며, 축약해 오버로딩이라고 통상적으로 사용한다.

## 오버로딩의 조건

1. 메서드의 이름이 같아야한다.
2. 매개변수의 이름 또는 타입이 달라야 한다.
- 주의점

    반환 타입은 오버로딩 구현시 아무 영향을 주지 않는다.


## 오버로딩의 예

### System.out.println 메서드

이 메서드 호출시 아무 값을 집어넣어도 잘 출력 되던 이유는 여러 타입의 매개변수를 오버로딩하고 있었기 때문이다.

- 예시 1

    `int add(int a, int b){return a+b;}`

    `int add(int x, int y){return x+y;}`

    이 경우는 오버로딩에 해당 되지 않는다. 파라미터 명만 다르고 나머지는 동일하기 때문이다.

- 예시 2

    `int add(int a, int b){return a+b;}`

    `long add(int x, int y){return (long) (x + y);}`

    이 경우는 오버로딩에 해당 되지 않는다. 반환 타입만 다른 메서드이기 때문에 컴파일 에러가 일어난다.

- 예시 3

    `long add(int a, long b){return a+b;}`

    `long add(long x, int y){return (long) (x + y);}`

    이 경우는 오버로딩으로 간주한다. 매개변수의 위치가 서로 다른 상태의 메서드는 매개 변수가 달라 호출시 구분이 가능하기 때문이다.

    허나 이런식의 오버로딩은 안하느만 못하니 주의하자

- 예시 4

    ```java
    int add(int a, int b){return a+b;}
    long add(long a, long b){return a+b;}
    long add(int[] a){
    	long result = 0;
    	for(int i = 0; i < a.length; i++){
    		result += a[i];
    	}
    	return result;
    }
    ```

    이 경우는 모든 메서드 정의가 올바르게 오버로딩 되어있는 경우이다.

    호출시의 매개변수가 다르면 전부 제대로 동작한다.


## 오버로딩의 장점

1. 메서드 이름절약
2. 호출 사용시 간편함

### 예시 [오버로딩]

```java
package ch6;

public class OverloadingTest {
    public static void main(String[] args) {
        MyMath3 mm = new MyMath3();
        System.out.println("mm.add(3, 3) 결과: " + mm.add(3, 3));
        System.out.println("mm.add(3L, 3) 결과: " + mm.add(3L, 3));
        System.out.println("mm.add(3, 3L) 결과: " + mm.add(3, 3L));
        System.out.println("mm.add(3L, 3) 결과: " + mm.add(3L, 3L));

        int[] a = {100, 200, 300};
        System.out.println("mm.add(a) 결과: "+mm.add(a));
    }
}

class MyMath3{
    int add(int a, int b){
        System.out.print("int add(int a, int b) - ");
        return a+b;
    }

    long add(int a, long b){
        System.out.print("long add(int a, long b) - ");
        return a+b;
    }

    long add(long a, int b){
        System.out.print("long add(int a, long b) - ");
        return a+b;
    }

    long add(long a, long b){
        System.out.print("long add(long a, long b) - ");
        return a+b;
    }

    int add(int[] a){
        System.out.print("int add(int[] a) - ");
        int result = 0;
        for (int i = 0; i < a.length; i++) {
            result +=a[i];
        }
        return result;
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-14_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_11.04.06.png]]

- 특징

    mm.add() 메서드가 호출되고 나서 println이 동작하는 모습을 볼 수 있다. 헷갈릴 수도 있으니 주의하자.

    먼저 호출된 애가 먼저 실행된다.


## 가변인자(varargs)와 오버로딩

### 가변인자(varargs)

JDK1.5부터 동적으로 지정해 줄 수 있는 매개변수의 개수가 동적인 arguments이다.

```java
타입... 변수명

// 올바른 예시
public PrintStream printf(String format, Object... args){
...
}
// 잘못된 예시
public PrintStream printf(Object... args, String format){
...
}
```

위의 예시를 보면 이 가변인자는 항상 맨 마지막에 배치해야한다.

컴파일러가 구분을 못하기 때문이다.

- 예시

    ```java
    String concatenate(String s1, String s2){}
    String concatenate(String s1, String s2, String s3){}
    String concatenate(String s1, String s2, String s3, String s4){}
    //////////

    String concatenate(String... args){}
    ```

    위의 오버로딩보단 가변인자를 활용하는 것이 더 좋다.

    이러면 다음과 같이 사용이 가능하다.

    ```java
    System.out.println(concatenate());
    System.out.println(concatenate("a"));
    System.out.println(concatenate("a", "b"));
    System.out.println(concatenate(new String[]{"A", "B"}));
    ```

    사용 예시를 보게되면 배열도 가능하다. 즉, 내부적으로는 배열을 사용하고 있다.

    그러나 만약 배열을 파라미터로 지정하게 되면 아무것도 넣지 않았을땐 에러가 발생한다.

    최소한의 값을 던져줘야해서 null이라도 넣어야한다.

    ```java
    String concatenate(String[] str){}
    ///
    String result = concatenate(new String[0]); // OK
    String result = concatenate(null); // OK
    String result = concatenate(); // ERROR
    ```


### 예시 [가변인자]

```java
package ch6;

public class VarArgsEx {
    public static void main(String[] args) {
        String[] strArr = {"100","200","300"};

        System.out.println(concatenate("", "100","200","300"));
        System.out.println(concatenate("-", strArr));
        System.out.println(concatenate(",", new String[]{"1", "2", "3"}));
        System.out.println("["+concatenate(",", new String[0])+"]");
        System.out.println("["+concatenate(",")+"]");
    }
    private static String concatenate(String delim, String... args){
        String result = "";
        for (String arg : args) {
            result = result.concat(arg.concat(delim));
        }
        return result;
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-14_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_11.20.40.png]]

- 주의점
    1. `System.out.println(concatenate(",", {"1", "2", "3"}));`
    이렇게 타입 지정 없는 배열은 에러를 던진다!
    2. 오버로딩시 주의하자

        `private static String concatenate(String delim, String... args){...}`

        `private static String concatenate(String... args){...}`

        이렇게 오버로딩을 하게 되면 컴파일러는 구분을 하지 못해 오버로딩으로 인지하지 못한다.

        즉, **가변인자를 사용하는 메서드는 오버로딩을 하지 않는 것이 좋다.**

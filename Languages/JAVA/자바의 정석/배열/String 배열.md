# String 배열

## String배열의 선언과 생성

<aside>
💡 String[] name = new String[3];

</aside>

- 특징

    참조형 변수인 String은 null이 기본값이므로 초기값은 null로 초기화된다.


### 타입에 따른 초기 기본값

| 자료형 | 기본값 |
| --- | --- |
| boolean | false |
| char | ‘\u0000’ |
| byte, short, int | 0 |
| long | 0L |
| float | 0.0f |
| double | 0.0d 또는
0.0 |
| 참조 타입 | null 또는
4 byte 정수값(0x0 ~ 0xffffff) |

## String배열의 초기화

```java
String[] name = new String[3];
String[] name = new String[]{"Kim", "Park", "Yi"};
```

- 특징

    배열 내부에 객체가 아닌 객체 주소가 담겨있다.

    참조형 변수는 모두 객체의 주소를 참조하고 있다고 볼수 있는데

    그래서 보통 참조형 배열은 **객체 배열**이라고 부르기도한다.


### 예시[기본 예제]

```java
package ch5;

public class ArrayEx12 {
    public static void main(String[] args) {
        String[] names = {"Kim","Park","Yi"};

        for (int i = 0; i < names.length; i++) {
            System.out.println("names["+i+"]: "+names[i]);
        }
        String tmp = names[2];
        System.out.println("tmp: "+tmp);

        names[0] = "Yu";
        for (String name : names) {
            System.out.println("name = " + name);
        }
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-08_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.23.57.png]]


### 예시[hex to binary]

```java
package ch5;

public class ArrayEx13 {
    public static void main(String[] args) {
        char[] hex = {'C', 'A', 'F', 'E'};

        String[] binary = {
                "0000", "0001", "0010", "0011",
                "0100", "0101", "0110", "0111",
                "1000", "1001", "1010", "1011",
                "1100", "1101", "1110", "1111"
        };
        String result = "";
        for (int i = 0; i < hex.length; i++) {
            if (hex[i] >= '0' && hex[i] <= '9') {
                result += binary[hex[i] - '0'];
            } else {
                result += binary[hex[i] - 'A' + 10];
            }
        }
        System.out.println("hex: " + new String(hex));
        System.out.println("binary: " + result);
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-08_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.37.52.png]]


## char배열과 String 클래스

<aside>
💡 String 클래스는 char배열에 기능(메서드)를 추가한 클래스이다.

</aside>

C의 경우 모든 문자열은 char 배열로 처리하지만 자바는 String클래스를 따로 제공한다.

객체지향이전 언어들은 데이터와 기능을 분리해서 개발을 하였지만 객체지향은 다르다.

특정 개체의 속성(필드)과 개체가 타 개체와 소통할 수단(메서드)로 구성된다.

실 세계를 표현하기 위해 이렇게 설계된 것이다.

사실 함수나 메서드나 크게 다르진 않다.

- 주의점

    **char 배열은 변동 가능하지만 기본적으로 String은 불변 클래스이다.**

    불변 클래스의 이점은 다음과 같다.

    1. 멀티 스래드 환경에서 효율 감소가 없다.
    2. 값 객체로 활용이 가능하다.

    다만, 자바 1.8에선 문자열용 메모리풀인 String constant pool을 따로 힙 영역에서 관리하는데

    이 뜻은 String을 이리저리 + concatenation을 하는 순간마다 힙영역을 계속 해서 잡아 먹는다는 의미이다.

    이 내용은 서버운용에서 매우 중요하기 때문에 나머지 내용은 9장에서 이어가겠다.


### String 클래스의 주요 메서드

| 메서드 | 설명 |
| --- | --- |
| char charAt(int index) | 문자열에서 해당 위치(index)에 있는 문자를 반환한다. |
| int length() | 문자열의 길이를 반환한다. |
| String substring(int from, int to) | 문자열에서 해당 범위(from~to)에 있는 문자열을 반환한다.
(to는 범위에 포함되지 않는다. 반열린집합을 뜻한다.) |
| boolean equals(Object obj) | boolean equals(Object obj) 문자열의 내용이 obj와 같은지 확인한다.
같으면 결과는 true, 다르면 false를 반환한다. |
| char[] toCharArray() | 문자열을 문자배열(char[])로 변환해서 반환한다.
(char배열은 반대로 Arrays.toString()을 쓰면 문자배열을 문자열로 반환한다.)  |
- 특징

    위의 메서드 목록은 실무에서나 입사를 위한 코딩테스트나 여러 환경에서 굉장히 자주 쓰인다.

    특히, 실무에선 대부분의 데이터들은 확장성을 이유로 문자열로 영속화되는 경우가 대다수이다.


### char 배열과 String 클래스의 변환

### 예시 [char배열과 String]

```java
package ch5;

public class ArrayEx14 {
    public static void main(String[] args) {
        String src = "ABCDE";

        for (int i = 0; i < src.length(); i++) {
            char ch = src.charAt(i);
            System.out.println("src.charAt("+i+"): "+ch);
        }

        char[] chars = src.toCharArray();

        System.out.println(chars);

    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-08_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.59.54.png]]


### 예시 [모스부호와 매칭]

```java
package ch5;

public class ArrayEx15 {
    public static void main(String[] args) {
        String source = "SOSHELP";
        String[] morse = {
                ".-","-...","-.-.","-..",".",
                "..-.","--.","....","..",".---",
                "-.-",".-..","--","...","-",
                "..-","...-",".--","-..-","-.--",
                "--.."
        };

        String result = "";

        for (int i = 0; i < source.length(); i++) {
            result += morse[source.charAt(i) - 'A'];
        }
        System.out.println("source = " + source);
        System.out.println("morse = " + result);
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-08_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.04.35.png]]


## 커맨드 라인을 통해 입력받기

`public static void (String[] args) {…}`

예전글에 자바가 이 메서드를 찾아서 이 메서드가 있는 클래스를 기준으로 로딩한다고 했었다.

사실 이 args는 외부에서 플래그 변수를 받아들이는 파라미터이다.

CS를 제대로 공부해본사람은 알태지만 모르는 사람을 위해 몇글자 적자면

대부분의 실행 가능한 프로그램은 플래그 변수를 받도록 되어있다.

예를 들면 여러 영상 플레이어들도 또한 마찬가지이다.

사실은 일시정지, 앞으로 10초, 뒤로 10초 등등의 명령 전부

ffmpeg이라는 프로그램에 해당 영상의 위치, 명령 플래그값 등등을 합쳐서 매번 플래그 변수를 던져

프로그램을 한땀 한땀 실행 시키는 구조이다.

영상 자체는 연속적인 사진과 음성의 조합이기 때문에 이런식으로 동작하는 것인데 더 들어가면 나도 모르는 영역이 불쑥불쑥 튀어 나오니 이만 각설하고…

자바도 마찬가지로 이 플래그 변수를 기본적으로 받아들여 실행하게끔 되어있다는 의미이다.

- 예시

    `java MainTest abc 123`

    이런식으로 cmd 창에 입력을 해서 `MainTest` 클래스를 실행 시키면 `abc`와 `123`이 플래그로 넘어간다.


### 예시 [args 받기]

```java
package ch5;

public class ArrayEx16 {
    public static void main(String[] args) {
        System.out.println("매개 변수의 개수: "+ args.length);
        for (int i = 0; i < args.length; i++) {
            System.out.println("args["+ i + "] = \"" + args[i] + "\"");
        }
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-09_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_2.37.46.png]]

- 주의점
    1. 실제로 진행할때는 class 파일 위치와 패키지명을 잘 지정해줘야한다.
    2. 매개 변수가 없으면 JVM은 알아서 크기가 0인 String 배열을 생성해서 넘긴다.
    ⇒ null 접근 에러 방지

### 예시 [args 받기: 사칙연산]

```java
package ch5;

public class ArrayEx17 {
    public static void main(String[] args) {
        if(args.length != 3){
            System.out.println("usage: java ch5.ArrayEx17 NUM1 OP NUM2");
            System.exit(0); // 0은 정상종료
        }

        int num1 = Integer.parseInt(args[0]);
        int num2 = Integer.parseInt(args[2]);
        char op = args[1].charAt(0);
        int result = 0;

        switch (op){
            case '+':
                result = num1 + num2;
                break;
            case '-':
                result = num1 - num2;
                break;
            case 'x':
                result = num1 * num2;
                break;
            case '/':
                result = num1 / num2;
                break;
            default:
                System.out.println("지원되지 않는 연산입니다.");
        }
        System.out.println("결과: " + result);
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-09_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_2.47.22.png]]

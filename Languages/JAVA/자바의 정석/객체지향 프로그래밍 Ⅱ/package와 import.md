# package와 import

## 패키지(package)

<aside>
💡 클래스의 묶음이다.

</aside>

- 특징
    1. 클래스 또는 인터페이스를 포함시킬 수 있다.
    2. 서로 관련된 클래스끼리 그룹 단위로 묶어 놓음으로써 클래스를 효율적으로 관리할 수 있다.
    3. 같은 이름의 클래스도 패키지가 다르면 생성이 가능하다
    4. 클래스의 풀네임은 사실 모든 패키지명을 합쳐야한다.

        ⇒ String클래스의 풀네임은 java.lang.String이다.

    5. **클래스가 물리적으로 하나의 클래스파일(.class)인 것 처럼, 패키지는 물리적으로 하나의 디렉토리이다.**

        ⇒ String 클래스는 java 디렉토리의 lang 디렉토리에 들어있는 클래스이다.

    6. 파일 경로를 ‘/’로 구분하듯 패키지는 ‘.’점으로 구분한다.
- 규칙
    1. 하나의 소스파일에는 첫 번째 문장으로 단 한 번의 패키지 선언만을 허용한다.
    2. 모든 클래스는 반드시 하나의 패키지에 속해야 한다.
    3. 패키지는 점(.)을 구분자로 하여 계층구조로 구성된다.
    4. 패키지는 물지적으로 클래스 파일(.class)을 포함하는 하나의 디렉토리이다.

## 패키지의 선언

```java
package 패키지명;
```

- 특징
    1. 반드시 소스파일의 첫 번째 문장이여야한다.
    2. 하나의 소스파일에 단 한번만 선언 가능하다.
    3. 해당 소스파일에 포함된 모든 클래스나 인터페이스는 선언된 패키지에 속하게 된다.
    4. 대소문자 둘다 가능하지만 소문자로만 구성하는 것이 바람직하다.
    5. unnamed package를 통해 이름없는 패키지도 존재하며 이 패키지를 쓰는 소스파일의 클래스와 인터페이스들은 모두 같은 패키지에 속하게 된다.
    6. 클래스 라이브러리 작성이나 큰 프로젝트를 작성하게 된다면 무조건 적어주는게 맞다.

### 예시[package]

```java
package ch7;

public class PackageTest {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
```

- 특징

    지금껏 예시 작성하면서 모든 예시에 패키지를 작성해왔다.

    사실 이대로 컴파일을 하면 클래스경로를 적지않아 제대로 컴파일 되지 않는다.

     javac -d 옵션을 추가하고 패키지명을 전부 적어주어야 제대로 컴파일을 한다.

    참고로 OSX, Monterey 기준, 클래스경로 구성방법은

    `export CLASSPATH="$CLASSPATH:/[주요 작업 경로]:./”`

    이런식으로 적어주면 [주요 작업 경로]를 먼저 찾아 보고 없으면 현재 명령어를 수행하는 위치(./)에서 찾는다.


## import문

<aside>
💡 컴파일러에게 소스파일에 사용된 클래스의 패키지에 대한 정보를 제공하는 역할

</aside>

import를 많이 적어도 컴파일 타임이 좀 늘어날 뿐, 실제 런타임 성능에 영향을 주지 않는다.

최대한 적어주는게 바람직하다.

## import문의 선언

- 소스파일 구성
    1. package 문
    2. import 문
    3. 클래스 또는 인터페이스 선언

```java
import 패키지명.클래스명;
import 패키지명.*;
//예시
import java.util.*;
import java.lang.String;
```

- 주의점
    1. 와일드카드(*)을 사용한다고해서 하위의 모든 클래스까지 포함하진 않는다.

        ⇒ import를 그냥 java.* 적는다고 제대로 동작하지 않는다.


### 예시 [import]

```java
package ch7;

import java.text.SimpleDateFormat;
import java.util.Date;

public class ImportTest {
    public static void main(String[] args) {
        Date today = new Date();

        SimpleDateFormat date = new SimpleDateFormat("yyyy/MM/dd");
        SimpleDateFormat time = new SimpleDateFormat("hh:mm:ss a");

        System.out.println("오늘 날짜는 ".concat(date.format(today)));
        System.out.println("현재 시간은 ".concat(time.format(today)));
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-18_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_11.14.56.png]]

- 특징

    ```java
    import java.text.SimpleDateFormat;
    import java.util.Date;
    ```

    이런식으로 적어주어야 외부 패키지를 땡겨다쓸 수 있다.

    **사실 String이나 System은 java.lang에 있는 클래스이지만 import 없이 쓸 수 있는 이유는
    묵시적으로 모든 소스파일에 java.lang.*이 import 되기 때문이다.**


## static import문

<aside>
💡 클래스의 static 멤버를 호출할 때 클래스 이름을 생략할 수 있게 해주는 역할

</aside>

```java
import static java.lang.System.out;

///이후 소스 코드
out.println("Hello world!");
```

### 예시 [static import]

```java
package ch7;

import static java.lang.Math.PI;
import static java.lang.Math.random;
import static java.lang.System.out;

public class StaticImportEx1 {
    public static void main(String[] args) {
        out.println(random());
        out.println("Math.PI: ".concat(Double.toString(PI)));
    }
}
```

- 실행 결과

    [[%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-10-18_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_11.22.14.png]]

- 특징

    이 `static import`는 실무에서 테스트코드 작성시 정말 자주 쓰인다.

    ⇒ AssertJ의 `Assertion`이나 Jupiter의 `AssertThrownBy`등등

    만약 실무에서 QueryDSL을 도입한다면 이때는 대부분 서비스코드에 `static import`를 적용해야한다.

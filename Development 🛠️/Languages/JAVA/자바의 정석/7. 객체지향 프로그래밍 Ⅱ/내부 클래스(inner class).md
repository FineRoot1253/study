# 내부 클래스(inner class)

>[!info]
> 내부 클래스는 사용빈도가 많은 기술은 아니다.
> 주로 한 클래스에 비슷하지만 다른 클래스들을 내포시켜 정리하는 용도로 사용한다.


<br><br>


## 내부 클래스란?

>[!info] Theorem
> 클래스 내에 선언된 클래스
> 
> 두 클래스가 긴밀한 관계에 있는 경우 사용함

&emsp;&emsp;

### 장점

+ 내부 클래스에서 외부 클래스의 멤버들을 쉽게 접근 가능
+ 코드의 복잡성을 줄임 (캡슐화)

>[!info]
> 클래스를 감싸고 있는 클래스를 외부 클래스, 외부 클래스에 감싸져있는 클래스를 내부 클래스라고 부르며 **내부 클래스는 외부 클래스를 제외하고는 다른 클래스에서 잘 사용되지 않아야한다.**




<br><br>



## 내부 클래스의 종류와 특징


>[!info]
> 내부 클래스의 종류는 변수의 선언위치에 따른 종류와 동일하다.



&emsp;&emsp;

| 내부 클래스 정의 | 특징                                                                                                                                                    |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| 인스턴스 클래스  | 외부 클래스의 멤버변수 선언위치에 선언,<br>외부 클래스의 인스턴스 멤버처럼 다루어짐<br>주로 외부 클래스의 인스턴스 멤버들과 관련된 작업에 사용된다.<br>보통 현업에서는 테스트 객체용으로 자주 사용한다.                                 |
| 스태틱 클래스   | 외부 클래스의 멤버변수 선언위치에 선언<br>외부 클래스의 static 멤버처럼 다루어진다.<br>static 메서드에 사용될 목적으로 선언된다.<br>보통 public static void main()에 바로 구현하는 매우 급조된 프로그램에 종종 사용된다.      |
| 지역 클래스    | 외부 클래스의 메서드나 초기화블럭 안에 선언하며, 선언된 영역 내부에서만 사용될 수 있다.                                                                                                    |
| 익명 클래스    | 클래스의 선언과 객체의 생성을 동시에 하는 이름없는 클래스(일회용)<br>이것을 현업에서는 매우 자주 사용한다.<br>특히 자바를 사용하는 안드로이드 환경이나, 레거시 코드를 수정하지 못해 대신 익명클래스로 다시 상속받아 오버라이딩해서 덮어쓰는 코드를 자주 사용한다. |


<br><br>




## 내부 클래스의 선언

&emsp;&emsp;

``` Java
class Outer{
	class InstanceInner {}
	static class StaticInner {}

	void myMethod() {
		class LocalInner {}
	}
}
```


<br><br>


## 내부 클래스의 제어자와 접근성

&emsp;&emsp;

>[!info] Theorem
> 내부 클래스의 기본 접근 규칙은 변수와 동일하게 적용된다.
> abstract, final 같은 제어자도 클래스이기 때문에 허용되며 private, protected와 같은 접근 제어자도 허용된다.

&emsp;&emsp;

``` Java

package ch7;  
  
public class InnerEx1 {  
    class InstanceInner {  
        int iv = 100;  
        // static int cv = 100; 이건 jdk 1.8에서 허용되지 않는다. 근데 16부터는 허용된다.  
        final static int CONST = 100;  
    }  
  
    static class StaticInner {  
        int iv = 200;  
        static int CONST = 200; // static 클래스만 static 맴버 정의가 가능하다.  
        // jdk 17이 많이 쓰이는 지금 이건 좀 의미가 없긴하지만 염두해두자.  
    }  
  
    void method(){  
        class LocalInner {  
            int iv = 300;  
            // static int cv = 300; 이건 jdk 1.8에서 허용되지 않는다. 근데 16부터는 허용된다.  
            final static int CONST = 300;  
        }  
    }  
}

///

import ch7.InnerEx1.StaticInner;  
import org.junit.jupiter.api.DisplayName;  
import org.junit.jupiter.api.Test;  
  
public class InnerEx1Test {  
  
    @Test  
    @DisplayName("클래스의 정적 내부 클래스를 접근할 수 있다.")  
    void staticInnerClass(){  
        //given  
        int actual = InnerEx1.InstanceInner.CONST;  
        //when  
        //then        assertThat(actual).isEqualTo(100);  
    }  
  
    @Test  
    @DisplayName("클래스의 인스턴스 내부 클래스를 접근할 수 있다.")  
    void instanceInnerClass(){  
        //given  
        int actual = StaticInner.CONST;  
        //when  
        //then        assertThat(actual).isEqualTo(200);  
    }  
}
```

&emsp;&emsp;

>[!info]
> static 내부 클래스에 한해서 final 없이 static 변수를 가질 수 있는 규칙이 있다. (단, jdk 16에선 없다.)

&emsp;&emsp;


``` Java
package ch7;  
  
public class InnerEx2 {  
    class InstanceInner {}  
    static class StaticInner {}  
      
    InstanceInner instanceInner = new InstanceInner();  
    static StaticInner staticInner = new StaticInner();  
      
    static void staticMethod(){  
        // static 멤버는 인스턴스 멤버 접근 불가능,   
// 이미 컴파일 타임에 메모리에 적재되는 클래스이기 때문에 생성 과정이 런타임에 필요한 인스턴스 멤버는 접근이 불가능하다.  
        // InstanceInner obj1 = new InstanceInner();        StaticInner staticInner1 = new StaticInner();  
          
        // 단, 외부 클래스를 생성한 뒤 접근하면 접근이 가능해진다.  
        // 인스턴스 클래스(외부 클래스)를 미리 생성해버린다는 가정이면 접근이 가능한 것  
        InnerEx2 outer = new InnerEx2();  
        InstanceInner obj1 = outer.instanceInner;  
    }  
      
    void instanceMethod(){  
        // 인스턴스 메서드에서는 인스턴스 멤버와 static 멤버 전부 접근가능  
        // 다른 메서드에서 지역적으로 선언된 내부 클래스는 외부에서 접근은 불가능하다.  
        StaticInner staticInner1 = new StaticInner();  
        InstanceInner obj1 = new InstanceInner();  
        // LocalInner lv = new LocalInner();  
    }  
      
    void method(){  
        class LocalInner {}  
        LocalInner localInner = new LocalInner();  
    }  
}
```

&emsp;&emsp;

>[!info]
> 스태틱 메서드에서 인스턴스 내부 클래스를 접근하기 위해서 외부 클래스를 먼저 생성을 해주어야하는 조건이 존재한다.




``` Java
package ch7;  
  
public class InnerEx3 {  
  
    private int outerIv = 0;  
    static int outerCv = 0;  
  
    class InstanceInner{  
        int iiv = outerIv;  
        int iiv2 = outerCv;  
    }  
  
    static class StaticInner {  
        // int siv = outerIv; 불가능하다. Ex2와 같은 맥락이다.  
        static int scv = outerCv;  
    }  
      
    void method(){  
        int lv = 0;  
        final int LV = 0; // JDK 1.8 부터 final 생략이 가능하다.  
  
        class LocalInner {  
            int liv = outerIv;  
            int liv2 = outerCv;  
            // 외부클래스의 지역 변수는 final이 있는 상수만 가능하다!!  
            int liv3 = lv; // 1.8부터는 에러가 아니다. 컴파일러가 자동으로 붙여준다.  
            int liv4 = LV;  
        }  
    }  
}

```

&emsp;&emsp;

>[!info]
> 외부 클래스의 지역 변수는 final 상수만 접근 가능하지만 1.8부터는 컴파일러가 자동으로 붙여주는 모습이다. 원래는 컴파일 에러가 터졌다고 한다.
> 
> 인스턴스 내부 클래스의 변수들은 외부 클래스의 변수가 private여도 접근이 가능하다.
> 
> (이런 점에서 내부 클래스를 왠만하면 사용하지 않는 회사도 있다. 역으로 내부 클래스가 캡슐화를 박살내는 구조이기 때문)
> 


&emsp;&emsp;

### 개인적인 생각

+ 내부 클래스는 정말 쓸일이 없다. 주로 사용한다면 사용처가 같은 여러가지 형식의 클래스를 한데 모아 관리한다고 가정하면 이런 경우에 내부 클래스로 세부적인 구현 클래스를 모아서 관리하는 경우가 있다.
	+ 보통 결과 클래스를 한데 모아서 관리하는 경우나, DTO 클래스를 한데 모아 관리하는 경우도 있다.
		+ 보통 MemberDTO라고 외부 클래스를 만들고, MemberRequestDTO, MemberResponseDTO, 이렇게 내부 클래스를 만드는 방식이 주로 사용된다.
	+ 이러면 클래스 파일 단위 관리가 수월해지고 코드를 한파일에서 볼 수 있다는 장점이 있지만 외부, 내부 클래스간 캡슐화가 깨진다는 점 때문에 멀리하는 경우도 많다.
	+ 개인적으로는 정말 수천개의 클래스를 관리해야한다고 가정하는 경우에도 내부클래스는 사용하지 않는 것을 추천한다.
		+ 의도치 않는다고 해도 언어 문법상에서 캡슐화를 무너뜨리는 방법을 쥐어준 방식이기 때문에 형식이 무너지거나 생각지도 못한 곳에서 버그가 터질 가능성이 너무나 높다.


&emsp;&emsp;

``` Java
package ch7;  
  
import static org.assertj.core.api.Assertions.assertThat;  
  
import ch7.InnerEx4.InstanceInner;  
import ch7.InnerEx4.StaticInner;  
import org.junit.jupiter.api.DisplayName;  
import org.junit.jupiter.api.Test;  
  
public class InnerEx4Test {  
    @Test  
    @DisplayName("내부 클래스의 생성 과정")  
    void create(){  
        //given  
        InnerEx4 innerEx4 = new InnerEx4();  
        InstanceInner instanceInner = innerEx4.new InstanceInner();  
        StaticInner staticInner = new StaticInner();  
        assertThat(instanceInner.iv).isEqualTo(100);  
        assertThat(StaticInner.cv).isEqualTo(300);  
        assertThat(staticInner.iv).isEqualTo(200);  
    }  
}
```

&emsp;&emsp;

>[!info]
> static 내부 클래스의 경우 인스턴스 변수에 한해서 생성을 해주어야 접근이 가능하다.
> 
> 책에서도 강조하지만 **내부클래스를 다른 클래스에서 꺼내서 사용하는 경우는 내부 클래스로 선언하면 안되는 클래스라는 것이라고 조언**한다.



&emsp;&emsp;

``` Java

package ch7;  
  
public class InnerEx5 {  
    int value = 10;  
    public class Inner {  
        int value = 20;  
  
        void method1(){  
            int value = 30;  
            System.out.println("value: "+value);  
            System.out.println("this.value: "+this.value);  
            System.out.println("InnerEx5.this.value: "+InnerEx5.this.value);  
        }  
    }  
}

///

package ch7;  
  
import static org.assertj.core.api.Assertions.assertThat;  
  
import ch7.InnerEx5.Inner;  
import java.io.ByteArrayOutputStream;  
import java.io.PrintStream;  
import org.junit.jupiter.api.DisplayName;  
import org.junit.jupiter.api.Test;  
  
public class InnerEx5Test {  
  
    @Test  
    @DisplayName("외부 클래스의 변수와 내부 클래스의 변수를 각각 출력")  
    void method1(){  
        //given  
        ByteArrayOutputStream outContent = new ByteArrayOutputStream();  
        PrintStream originalOut = System.out;  
        System.setOut(new PrintStream(outContent));  
        InnerEx5 innerEx5 = new InnerEx5();  
        Inner inner = innerEx5.new Inner();  
        try {  
            inner.method1();  
            assertThat("value: 30\nthis.value: 20\nInnerEx5.this.value: 10\n").hasToString(outContent.toString());  
        } finally {  
            System.setOut(originalOut);  
        }  
    }  
}
```

&emsp;&emsp;

>[!info]
> 변수명이 같은 경우 this.로 구분할 수 있다. 허나 이렇게 사용하면 매우 햇갈리니 애시당초 이름을 다르게 해주는게 좋다.



<br><br>

## 익명 클래스(anonymous class)

&emsp;&emsp;

>[!info] Theorem
> 이름이 없고 클래스의 선언과 객체의 생성을 동시에 하는 일회용 클래스
> 
> 현업에서 레거시 코드를 만지는 경우와 람다를 만지는 경우에 가장 자주 사용되며 
> 추후 람다에서 가장 많이 활용되는 클래스

&emsp;&emsp;

### 특징

+ 생성자를 가질 수 없다.
+ 하나의 클래스로 상속을 받는 동시에 인터페이스를 구현하거나 둘 이상의 인터페이스 구현이 불가능하다.


&emsp;&emsp;

``` Java

package ch7;  
  
public class InnerEx6 {  
    Object iv = new Object(){void method(){}};  
    static Object cv = new Object(){void method(){}};  
    void method(){  
        Object iv = new Object(){void method(){}};  
    }  
}
```

&emsp;&emsp;

>[!info]
> 익명클래스이기 때문에 실제로 컴파일하면 클래스 파일은 숫자로만 지정된다.
> 그리고 현업에서 가장 많이 사용되는 방식은 위의 로컬 메서드에서 사용하는 방식이다.

&emsp;&emsp;


``` Java
package ch7;  
  
import java.awt.Button;  
  
import org.junit.jupiter.api.DisplayName;  
import org.junit.jupiter.api.Test;  
  
public class InnerEx7Test {  
    @Test  
    @DisplayName("액션 리스너 학습테스트")  
    void actionPerformed(){  
        Button start = new Button("Start");  
        start.addActionListener(new InnerEx7());  
    }  
}

```

&emsp;&emsp;




``` Java

package ch7;  
  
import java.awt.Button;  
import java.awt.event.ActionEvent;  
import java.awt.event.ActionListener;  
import org.junit.jupiter.api.DisplayName;  
import org.junit.jupiter.api.Test;  
  
public class InnerEx8Test {  
    @Test  
    @DisplayName("익명클래스 학습테스트")  
    void actionPerformed(){  
        Button start = new Button("Start");  
        start.addActionListener(new ActionListener() {  
            public void actionPerformed(ActionEvent e) {  
                System.out.println("ActionPerformed occurred!!!");  
            }  
        });  
        start.addActionListener((ActionEvent e)   
        -> System.out.println("ActionPerformed occurred!!!"));
    }  
}
```

&emsp;&emsp;

>[!info]
> 이 형태가 **가장 현업에서 많이 사용되는 형태**이며 아래의 경우는 함수형으로 표현한 것인데, 인터페이스에 함수가 하나만 존재한다면 저렇게 변환이 가능해진다.
> 
> 람다로 표현하는 경우가 가장 많이 사용된다.
> 
> 이것을 활용해 레거시 코드를 건들지 않고 새로 기능을 추가할 수도 있다.
> 매우 극단적으로 코드를 건들지 않아야하는 조건에서 유지보수를 하는 경우에는 이런식으로 진행하는 경우도 존재한다.
> 보통 법적인 문제가 얽혀있는 경우에는 이렇게 진행할 수 밖에 없는 경우가 존재한다고 한다.



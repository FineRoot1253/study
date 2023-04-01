# static

## static이란?

<aside>
💡 스택 프레임을 벗어나 다른 모든 스택에서 사용가능하게 만드는 키워드

</aside>

### C static 스타일 특징

1. 전역변수에 선언된 `static`은 선언된 파일 내에서만 참조를 허용한다.
2. 함수 내에 선언된 `static`은 한번만 초기화되고 지역변수와 달리 `static` 메모리에 남아있는다.

### 예시 [C 스타일 static]

```cpp
//
// Created by 홍준근 on 2023/02/22.
//
#include <iostream>

void counter() {
    static int count;
    std::cout << "Current count: " << ++count << std::endl;
}

int main() {
    for (int i = 0; i < 10; ++i) {
        counter();
    }
    return 0;
}
```

### 예시 [C++ 스타일 static]

```cpp
#ifndef FIRSTCPP_NEEDGLOBAL _H
#define FIRSTCPP_NEEDGLOBAL _H
#include <iostream>

int simpleObjectCount = 0;
int complexObjectCount = 0;

class SoSimple{
public:
    SoSimple(){
        ++simpleObjectCount;
        std::cout<<simpleObjectCount<<"번째 SoSimple 객체"<<std::endl;
    }
};

class SoComplex{
public:
    SoComplex(){
        ++complexObjectCount;
        std::cout<<complexObjectCount<<"번째 SoComplex 객체"<<std::endl;
    }

    SoComplex(const SoComplex& copy){
        ++complexObjectCount;
        std::cout<<complexObjectCount<<"번째 SoComplex 객체"<<std::endl;
    }
};
#endif // FIRSTCPP_NEEDGLOBAL _H

#include "enthusiasm/friend/NeedGlobal.h"

int main() {
    SoSimple sim1;
    SoSimple sim2;

    SoComplex com1;
    SoComplex com2 = com1;
    SoComplex();
    return 0;
}
```

- 설명

    전역으로 `simpleObjectCount`, `complexObjectCount` 을 선언했다.

    그러나 이렇게 선언하면 어디서든 접근이 가능해 굉장히 불안한 상태이다.

    이것을 클래스 멤버로 만들면 어느정도 해결이 된다.


### 예제 [클래스 static 멤버]

```cpp
#ifndef FIRSTCPP_STATICMEMBER _H
#define FIRSTCPP_STATICMEMBER _H
#include <iostream>

class SoSimple{
    static int simpleObjectCount;
public:
    SoSimple(){
        ++simpleObjectCount;
        std::cout<<simpleObjectCount<<"번째 SoSimple 객체"<<std::endl;
    }
};
int SoSimple::simpleObjectCount=0;

class SoComplex{
    static int complexObjectCount;
public:
    SoComplex(){
        ++complexObjectCount;
        std::cout<<complexObjectCount<<"번째 SoComplex 객체"<<std::endl;
    }

    SoComplex(const SoComplex& copy){
        ++complexObjectCount;
        std::cout<<complexObjectCount<<"번째 SoComplex 객체"<<std::endl;
    }
};

int SoComplex::complexObjectCount = 0;
#endif // FIRSTCPP_STATICMEMBER _H

#include "enthusiasm/friend/StaticMember.h"

int main(){
    SoSimple sim1;
    SoSimple sim2;

    SoComplex com1;
    SoComplex com2 = com1;
    SoComplex();
    return 0;
}
```

- 설명

    `static` 클래스 멤버 변수는 다음과 같이 생성자에서 생성이 불가능하기때문에 따로 초기화 문법이 존재한다.

    `int SoComplex::complexObjectCount = 0;`

    **이유는 매번 객체를 생성할 때마다 0으로 초기화 되는 전역변수는 의미가 없기 때문이다.**


### 예시 [public 클래스 static 멤버]

```cpp
#ifndef FIRSTCPP_PUBLICSTATICMEMBER _H
#define FIRSTCPP_PUBLICSTATICMEMBER _H
#include <iostream>

class SoSimple{
public:
    static int simpleObjectCount;
public:
    SoSimple(){
        ++simpleObjectCount;
    }
};
int SoSimple::simpleObjectCount = 0;
#endif // FIRSTCPP_PUBLICSTATICMEMBER _H

#include "enthusiasm/friend/PublicStaticMember.h"

int main(){
    std::cout<<SoSimple::simpleObjectCount<<"번째 SoSimple 객체"<<std::endl;
    SoSimple sim1;
    SoSimple sim2;

    std::cout<<SoSimple::simpleObjectCount<<"번째 SoSimple 객체"<<std::endl;
    std::cout<<sim1.simpleObjectCount<<"번째 SoSimple 객체"<<std::endl;
    std::cout<<sim2.simpleObjectCount<<"번째 SoSimple 객체"<<std::endl;
    return 0;
}
```

- 설명

    public으로 만들면 `.` 연산자를 통해 접근 가능하지만 보통 `객체타입명::변수명`으로 접근한다.


### 예제 [static 멤버 함수]

```cpp
#ifndef FIRSTCPP_STATICMEMBERFUNCTION _H
#define FIRSTCPP_STATICMEMBERFUNCTION _H
#include <iostream>

class SoSimple{
public:
    int num1;
    static int num2;
public:
    SoSimple(int n):num1(n){
    }
    static void add(int n){
//        num1+=n;  // ERROR!
        num2+=n;
    }
};
int SoSimple::num2 = 0;
#endif // FIRSTCPP_STATICMEMBERFUNCTION _H
```

- 설명
    1. **static 멤버 함수는 static 멤버 변수만 접근 가능**하며 **인스턴스 멤버 변수에 접근하면 컴파일 에러가 발생**한다.
    2. **static 멤버 함수는 객체의 멤버로써 존재하는 것이 아니다.**
    (참고로 **모든 함수는 포인터**이며 **static 멤버 함수는 static 영역 메모리에 올라가있는 포인터**이다.)
    그렇기 때문에 **static 영역 메모리에 올라가있는 static 멤버 변수에만 접근이 가능**하다.

### 예제 [const static 멤버]

```cpp
#ifndef FIRSTCPP_CONSTSTATICMEMBER _H
#define FIRSTCPP_CONSTSTATICMEMBER _H
class CountryArea{
public:
    const static int RUSSIA = 1707540;
    const static int CANADA = 998467;
    const static int CHINA = 957290;
    const static int KOREA = 9922;
};
#endif // FIRSTCPP_CONSTSTATICMEMBER _H

#include "enthusiasm/friend/ConstStaticMember.h"
#include <iostream>

int main(){
    std::cout<<"러시아 면적: "<<CountryArea::RUSSIA<<"km^2"<<std::endl;
    std::cout<<"캐나다 면적: "<<CountryArea::CANADA<<"km^2"<<std::endl;
    std::cout<<"중국 면적: "<<CountryArea::CHINA<<"km^2"<<std::endl;
    std::cout<<"한국 면적: "<<CountryArea::KOREA<<"km^2"<<std::endl;
    return 0;
}
```

- 설명

    일반적으로 **키워드에 해당하는 특정 상수**는 이런식으로 `const static` 클래스 멤버변수로 만든다.

    이 패턴은 매우 일반적이며 나도 자주 사용하는 방식이다.

    근데 난 이 방식보단 `namespace` + `constexpr`을 좀 더 사용한다.

    `constexpr`은 무조건 컴파일이 끝나면 이 변수를 완전히 `const`로 만들어달라는 의미로 컴파일러에게 전달된다.

    그래서 일반적으로 C/C++에서는 `namespace` + `constexpr`을 사용하는 경우가 많다.

    근데 저렇게 적어도 뭐 문제 될 것은 없다.

    C 계열은 일반적으로 성능을 극한까지 땡겨써야하는 경우가 많아 이런 경우가 많은 것이다.


### 예제 [mutable]

```cpp
#ifndef FIRSTCPP_MUTABLE _H
#define FIRSTCPP_MUTABLE _H
#include <iostream>

class SoSimple{
public:
    int num1;
    mutable int num2;
public:
    SoSimple(int num1, int num2):num1(num1), num2(num2){
    }
    void showSimpleData() const{
        std::cout<<num1<<", "<<num2<<std::endl;
    }

    void copyToNum2() const{
        num2=num1;
    }
};
#endif // FIRSTCPP_MUTABLE _H

#include "enthusiasm/friend/Mutable.h"

int main(){
    SoSimple sim(1, 2);
    sim.showSimpleData();
    sim.copyToNum2();
    sim.showSimpleData();
    return 0;
}

```

- 설명

    const 함수는 변수의 변동이 없어야하지만 mutable은 그 제한을 해제하는 모습을 볼 수 있다.

    이렇게 사용하면 const로 선언했으니 “num2에 대해서만 안전하게 값을 대입 시킬 수 있어 좋다”

    라고 생각 할 수 있겠지만 대입의 대상이 바뀌게 된다면  모든 함수를 const 화 하고 모든 변수를 mutable화 해야하는데 이러면 결국 의미가 없어진다.

    즉, mutable은 정말 특수한 상황에서만 쓰여야하며 난 경험이 적어 아직 써먹어 보진 못했다.

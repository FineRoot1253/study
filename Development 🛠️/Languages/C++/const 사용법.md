# const 사용법

## const란?

변수를 상수로 만들어주는 예약어

### 사용법

```cpp
#include <iostream>

int main(){
	const int aInteger = 10;
	return 0;
}
```

## const 객체

<aside>
💡 변수를 상수화 하듯 객체도 상수화 할 수 있다.

const를 통해 상수화 한 객체를 const 객체라고 부른다.

</aside>

### 특징

1. **const 객체**는 이 객체에서 **const 맴버함수만** 호출 할 수 있다.
2. 이 객체는 데이터 변경을 허용하지 않겠다는 의미이다.

### 예시

```cpp
//
// Created by 홍준근 on 2023/02/21.
//

#ifndef FIRSTCPP_CONSTOBJECT_H
#define FIRSTCPP_CONSTOBJECT_H
#include <iostream>

class SoSimple{
private:
    int num;
public:
    SoSimple(int n):num(n){
    };

    SoSimple& addNum(int n){
        num += n;
        return *this;
    }

    void showData() const {
        std::cout<<"num: "<<num<<std::endl;
    }
};
#endif //FIRSTCPP_CONSTOBJECT_H

//
// Created by 홍준근 on 2023/02/21.
//
#include "enthusiasm/friend/ConstObject.h"

int main(){
    const SoSimple obj(10);
    //obj.addNum(20); // ERROR!
    obj.showData();
    return 0;
}
```

- 설명

    const 객체 `obj`에서 const 함수만 호출이 가능하며 const가 아닌 함수 호출시 컴파일에러를 발생시킨다.


## const 함수 오버로딩

### 예시

```cpp
//
// Created by 홍준근 on 2023/02/21.
//

#ifndef FIRSTCPP_CONSTOVERLOADING_H
#define FIRSTCPP_CONSTOVERLOADING_H
#include <iostream>

class SoSimple{
private:
    int num;
public:
    SoSimple(int n):num(n){
    };

    SoSimple& addNum(int n){
        num += n;
        return *this;
    }

    void simpleFunc() {
        std::cout<<"simpleFunc: "<<num<<std::endl;
    }

    void simpleFunc() const {
        std::cout<<"const simpleFunc: "<<num<<std::endl;
    }
};

void yourFunc(const SoSimple& obj){
    obj.simpleFunc();
}
#endif //FIRSTCPP_CONSTOVERLOADING_H

//
// Created by 홍준근 on 2023/02/21.
//
#include "enthusiasm/friend/ConstOverloading.h"

int main(){
    SoSimple obj1(2);
    const SoSimple obj2(7);
    obj1.simpleFunc();
    obj2.simpleFunc();

    yourFunc(obj1);
    yourFunc(obj2);
    return 0;
}
```

- 설명

    `yourFunc()`은 `const` 참조자로 객체를 넘겨받는다.

    즉, `const` 참조자 객체가 생성되므로 이 함수 내부에서 호출하는 `simpleFunc()`은 `const`화 된 `simpleFunc()`를 호출한다.

### 추가 설명

const를 가진 const 포인터 객체를 파라미터로 넘기게 되면 const 지정자를 통해 const 파라미터로써 넣어주어야한다.

예를들면 
``` cpp

class Person{
private:
	std::string name;
	
public:
	std::string getName() const{
		return name;
	}
}
```

이러한 `Person` 클래스에 `getName()`이라는 `const` 맴버 함수를 가지고 있다고 하자

여기서 주의해서 보아야하는 것은 `const` 함수를 가지고 있어도 `const` 맴버 변수는 없으므로 `const`를 한정자가 없는 타입이 아니다.

따라서 `Person`의 `this` 포인터 타입도 `const`가 포함된 `Person const \*` 타입이 `Person`이 타입이 되며 `const` 속성을 유지시켜야하는 컴파일러 입장으로써 `const` 타입으로 캐스팅해야한다. 

그래서 만약 아래와 같은 함수에 `Person`을 넘긴다고 하자.

``` cpp
void printPersonName(Person* person){
	std::cout<<person->getName()<<std::endl;
}
```

이 함수에 `this`를 넘기는 것은 불가능하다.
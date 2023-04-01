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

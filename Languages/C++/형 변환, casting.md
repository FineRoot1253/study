
<br>

## C 스타일 형 변환

> C 스타일 형변환은 강력한 형 변환으로 여기에서 생기는 문제를 컴파일러가 잡지 못한다.


<br>

### 예제

``` cpp
#ifndef FIRSTCPP_POWERFULLCASTING _H  
#define FIRSTCPP_POWERFULLCASTING _H  
#include <iostream>  
  
class Car{  
private:  
    int fuelGauge;  
public:  
    Car(int fuel) : fuelGauge(fuel){}  
  
    void showCarState(){  
        std::cout<<"잔여 연료량: "<<fuelGauge<<std::endl;  
    }  
};  
  
class Truck : public Car {  
private:  
    int freightWeight;  
public:  
    Truck(int fuel, int freightWeight) : Car(fuel), freightWeight(freightWeight){}  
  
    void showTruckState(){  
        showCarState();  
        std::cout<<"화물의 무게: "<<freightWeight<<std::endl;  
    }  
};  
#endif // FIRSTCPP_POWERFULLCASTING _H

#include "enthusiasm/casting/PowerfullCasting.h"  
  
int main(){  
    Car * car1 = new Truck(80, 200);  
    Truck* truck1 = (Truck *) car1;  
    truck1->showTruckState();  
    std::cout<<std::endl;  
  
    Car * car2 = new Car(120);  
    Truck* truck2 = (Truck *) car2;  
    truck2->showTruckState();  
    std::cout<<std::endl;  
    return 0;  
}
```

+ 설명
	
	기초 클래스의 포인터 형을 하위 유도 클래스의 포인터 형으로 캐스팅하는 것은 일반적인 캐스팅이 아니다.
	
	(근데 자바진영 주니어 개발자 코드에서 상당히 자주 있는 캐스팅이다. 물론 이렇게 짜면 욕먹는다. Object에서 하위로 캐스팅하는 경우가 대표적)
	
	허나 별 문제없이 컴파일 - 실행까지 되는 이유는 C 스타일 캐스팅이기 때문이다.


<br>

## 형 변환 연산자의 종류


<br>

+ `static_cast`
	
	==**유도 클래스**의 포인터 및 레퍼런스형 데이터== -> ==**기초 클래스**의 포인터 및 레퍼런스 형 데이터==
	==**기초 클래스**의 포인터 및 레퍼런스형 데이터== ->  ==**유도 클래스**의 포인터 및 레퍼런스형 데이터== 
	
	다음 위의 변환들을 아무 조건 없이 형 변환을 제공해준다. 다만 여기서 발생하는 문제는 개발자가 책임져야한다.

<br>

+ `const_cast`
	
	const 성향을 제거해준다.

<br>

+ `dynamic_cast`
	
	상속 관계에서 안전한 형 변환을 제공한다.

<br>

+ `reinterpret_cast`
	
	전혀 상관 없는 자료형으로의 형변환을 제공해준다.

<br>

### 예제 - dynamic_cast

``` cpp

#include "enthusiasm/casting/DynamicCasting.h"  
  
int main(){  
    Car * car1 = new Truck(80, 200);  
//    Truck* truck1 = dynamic_cast<Truck*>(car1);  
  
  
    Car * car2 = new Car(120);  
//    Truck* truck2 = dynamic_cast<Truck*>(car2);  
  
    Truck* truck3 = new Truck(70, 150);  
    Car * car3 = dynamic_cast<Car*>(truck3);  
    truck3->showTruckState();  
    std::cout<<std::endl;  
    return 0;  
}

```

+ 설명
	
	오직 유도 클래스에서 기초 클래스로의 형변환을 제공하는 연산자이다.
	
	의도적으로 기초에서 유도로 하면 안되는게 맞지만 그래도 필요하다면 static_cast를 써야한다.
	
	근데 사실 기초 클래스가 하나 이상의 가상함수를 포함하는 함수라면 또 가능하다.
	
	이런 기초 클래스를 **Polymorphic 클래스**라고 부른다.


<br>

### 예제 - dynamic_cast, polymorphy 기반

``` cpp
#ifndef FIRSTCPP_POLYMORPHISMDYNAMICCASTING _H  
#define FIRSTCPP_POLYMORPHISMDYNAMICCASTING _H  
#include <iostream>  
  
class SoSimple{  
public:  
    virtual void showSimpleInfo(){  
        std::cout<<"SoSimple Base Class"<<std::endl;  
    }  
};  
  
class SoComplex : public SoSimple{  
public:  
    void showSimpleInfo() override {  
        std::cout<<"SoComplex Derived Class"<<std::endl;  
    }  
};  
#endif // FIRSTCPP_POLYMORPHISMDYNAMICCASTING _H

#include "enthusiasm/casting/PolymorphismDynamicCasting.h"  
  
int main(){  
    SoSimple * simple = new SoComplex;  
    SoComplex * complex = dynamic_cast<SoComplex*>(simple);  
    complex->showSimpleInfo();  
    return 0;  
}
```

+ 설명
	
	가상함수를 포함하는 클래스를 상속 받는 중인 클래스는 dynamic_cast에 안전한 형 변환이 지원되는 모습을 볼 수 있다.
	
	다만 여기에는 규칙이 하나 있다. 바로 기초 클래스의 포인터 변수는 반드시 애초에 변환 할 유도 클래스로 생성, 할당이 되어야한다.
	
	그렇지 않았을 경우에는 NULL을 반환하는데 그 예제를 아래에서 보자


<br>

### 예제

``` cpp
#ifndef FIRSTCPP_POLYMORPHICSTABLECASTING_H  
#define FIRSTCPP_POLYMORPHICSTABLECASTING_H  
#include <iostream>  
  
class SoSimple{  
public:  
    virtual void showSimpleInfo(){  
        std::cout<<"SoSimple Base Class"<<std::endl;  
    }  
};  
  
class SoComplex : public SoSimple{  
public:  
    void showSimpleInfo() override {  
        std::cout<<"SoComplex Derived Class"<<std::endl;  
    }  
};  
#endif // FIRSTCPP_POLYMORPHICSTABLECASTING_H

#include "enthusiasm/casting/PolymorphicStableCasting.h"  
  
int main(){  
    SoSimple * simple = new SoSimple;  
    SoComplex * complex = dynamic_cast<SoComplex*>(simple);  
    if(complex != nullptr){  
        complex->showSimpleInfo();  
    }else{  
        std::cout<<"형 변환 실패!"<<std::endl;  
    }  
  
    return 0;  
}
```

+ 설명
	
	보다시피 변환 시킬 유도 클래스가 아닌 기초 클래스 그대로 생성한 경우 다음과 같이 nullptr로 초기화된다.
	
	이는 **==`dynamic_cast`는 컴파일 시간이 아닌 런타임 시간에 안정성을 검사하도록 컴파일러가 바이너리 코드를 생성하기 때문==**이다.
	
	이런 반면에 `static_cast`는 반드시 형 변환이 되도록 바이너리 코드를 생성하기 때문에 이런 형변환 검사의 의무는 개발자에게 짊어지게 하는 것이다.
	
	즉, 바이너리 코드에 조작이 가해지는 캐스팅이며 나름 연산 속도에 영향도 주는 연산이기 때문에 ~~골프코딩과 성능 변태의 성지인~~ C++ 계열에서는 상당히 호불호가 있다고 하는 형변환 연산자라고 할 수 있다.
	

<br>

### 예제 - static_cast

``` cpp
#ifndef FIRSTCPP_STATICCASTING _H  
#define FIRSTCPP_STATICCASTING _H  
#include <iostream>  
  
class Car{  
private:  
    int fuelGauge;  
public:  
    Car(int fuel) : fuelGauge(fuel){}  
  
    void showCarState(){  
        std::cout<<"잔여 연료량: "<<fuelGauge<<std::endl;  
    }  
};  
  
class Truck : public Car {  
private:  
    int freightWeight;  
public:  
    Truck(int fuel, int freightWeight) : Car(fuel), freightWeight(freightWeight){}  
  
    void showTruckState(){  
        showCarState();  
        std::cout<<"화물의 무게: "<<freightWeight<<std::endl;  
    }  
};  
#endif // FIRSTCPP_STATICCASTING _H

#include "enthusiasm/casting/StaticCasting.h"  
  
int main(){  
    Car * car1 = new Truck(80, 200);  
    Truck* truck1 = static_cast<Truck*>(car1);  
    truck1->showTruckState();  
    std::cout<<std::endl;  
  
    Car * car2 = new Car(120);  
    Truck* truck2 = static_cast<Truck*>(car2);  
    truck2->showTruckState();  
    std::cout<<std::endl;  
    return 0;  
}
```

+ 설명
	
	이렇게 기초에서 유도 클래스로 다운 캐스팅을 하려면 `static_cast`를 이용하면 되지만
	
	Clion 기준에서 경고를 띄운다.
	
	이런 경고는 무조건 악취라고 부르는 코드에서 나오는 경고인데 **다운캐스팅**을 경고하는 것이다.
	
	책에서도 나오듯 **이러한 상황자체를 만들면 안되는 것**이며 **==이 캐스팅 대한 책임은 코드를 짜는 개발자가 온전히 져야하는 캐스팅==**이다.


<br>

+ 결론
	
	`dynamic_cast`를 쓸 수 있는 상황이면 무조건 `dynamic_cast`를 쓰고 이 여건이 안되면 `static_cast`를 사용해아하나 정말 책임질 수 있는 상황에서만 제한적으로 사용해야한다.
	테스트 커버리지가 완벽한 상황등등
	
	다만 `dynamic_cast`보다 `static_cast`의 속도가 더 빠르다. 이 이유때문에 `dynamic_cast`를 사용하지 않고 `static_cast`를 사용한뒤 테스트 코드를 빡시게 적는 경우가 실무에서는 더 많다고 한다.
	
	그래도 int -> double 과 같은 캐스팅 또한 지원하는 연산자라 C++ 에서는 static_cast를 통한 자료형 변환 캐스팅도 static_cast를 추천한다.
	
	C 스타일 연산자는 말도안되는 캐스팅도 허용하기 때문이다.


<br>

### 예제 - const_cast

``` cpp
#ifndef FIRSTCPP_CONSTCASTING _H  
#define FIRSTCPP_CONSTCASTING _H  
#include <iostream>  
  
void showString(char* str){  
    std::cout<<str<<std::endl;  
}  
  
void showAddResult(int& num1, int& num2){  
    std::cout<<num1 + num2<<std::endl;  
}  
#endif // FIRSTCPP_CONSTCASTING _H

#include "enthusiasm/casting/ConstCasting.h"  
  
int main(){  
    const char* name = "Lee Sung Ju";  
    showString(const_cast<char*>(name));  
  
    const int& num1 = 100;  
    const int& num2 = 200;  
    showAddResult(const_cast<int&>(num1), const_cast<int&>(num2));  
    return 0;  
}
```

+ 설명
	
	이런식으로 const 성향을 제거해주는 키워드이며 
	mutable하게 만들어주는건 아니다. 그냥 const만 지워주는 것이다.
	
	레퍼런스에 const를 지운다고 해서 레퍼런스를 변경할 수 있는가?
	
	즉, 그냥 const 성향을 지워주는 키워드인 것이며
	
	참고로 volatile의 성향도 제거되는데 사용이 된다.
	
	(volatile은 컴파일러 최적화에 제한을 주기 위한 예약어이다.)


<br>

### 예제 - reinterpret_cast

``` cpp
#include "enthusiasm/casting/ReinterpretCasting.h"  
#include <iostream>  
  
int main(){  
    int num = 0x010203;  
    char * str = reinterpret_cast<char*>(&num);  
  
    for (int i = 0; i < sizeof(num); ++i) {  
        std::cout<<static_cast<int>(*(str+i))<<std::endl;  
    }  
  
    return 0;  
}
```

+ 설명
	
	기본적으로 reinterpret_cast는 **==포인터를 대상으로 하고, 포인터와 관련이 있는 모든 유형의 형변환을 허용한다.==**
	
	위의 예제에서 보듯이 주소 값을 문자열로 반환하고 문자열을 주소 값으로 반환하거나 하는 이러한 연산에서 큰 힘을 발휘한다.

<br>
### 예제 - bad_cast 예외

``` cpp
#include "enthusiasm/casting/DynamicBadCastRef.h"  
  
int main(){  
    SoSimple simple;  
    SoSimple& ref = simple;  
  
    try{  
        SoComplex& complexRef= dynamic_cast<SoComplex&>(ref);  
        complexRef.showSimpleInfo();  
    }catch (std::bad_cast ex){  
        std::cout<<ex.what()<<std::endl;  
    }  
    return 0;  
}
```

+ 설명
	
	dynamic_cast는 포인터에만 정상적용되는 연산자이기 때문에 bad_cast 예외가 발생한다.
	
	위의 예제에서 그 모습을 볼 수 있다.

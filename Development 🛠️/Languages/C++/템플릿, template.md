## 템플릿 이란?

>  강타입 언어인 C++에서는 프로그래머가 명시적으로 선언하거나 컴파일러에서 추론한 특정 형식을 갖는 모든 변수가 필요하다. 템플릿을 사용하면 사용자가 직접 클래스 또는 함수의 작업을 정의하고 해당 작업이 작동해야 하는 구체 타입을 지정할 수 있다.
<br>

## 함수 템플릿
<br>

### 예시

``` cpp
template <class T>
T add(T num1, T num2){
	return num1 + num2;
}
```

+ 설명
	+ 함수의 기능
		덧셈
	+ 타겟 자료형
		아직 안정해짐
	이는 컴파일러에게 T는 자료형을 결정 짓지 않겠다는 의미로 사용한 것이며 함수를 만들어 내는 템플릿을 정의 하기 위해 사용했다고 전달해야한다.
	그래서 `template <class T>`를 붙여 컴파일러에게 알려주는 역할을 한다.
	
	이것이 함수 템플릿이다.
	
	참고로 typename이나 class나 둘다 사용이 가능하나 class를 사용해야한다는 의견이 많다. 컨벤션을 주로 class로 두기로 하는 회사가 많다고 알고 있다.

### 예제

``` cpp
#ifndef FIRSTCPP_ADDFUNCTIONTEMPLATE _H  
#define FIRSTCPP_ADDFUNCTIONTEMPLATE _H  
#include <iostream>  
  
template <class T>  
T add(T num1, T num2){  
    return num1 + num2;  
}  
#endif // FIRSTCPP_ADDFUNCTIONTEMPLATE _H


#include "enthusiasm/template/AddFunctionTemplate.h"  
  
int main(){  
    std::cout<<add<int>(15, 20)<<std::endl;  
    std::cout<<add<double>(2.9, 3.7)<<std::endl;  
    std::cout<<add<int>(3.2, 3.2)<<std::endl;  
    std::cout<<add<int>(3.14, 2.75)<<std::endl;  
    return 0;  
}
```

+ 설명
	저렇게 int를 주고 부동소수점 타입 값을 넣으면 narrowing이라는 현상이 발생한다.
	예시니까 저렇게 적은거지 현업에서는 저런일이 있으면 ==절대 안된다==.
	
	C++ 템플릿은 자바의 제네릭과 매우 비슷하지만 다른 점이 몇 가지 존재한다.
	바로 타입 제한이 없다는 점 *(방법은 있지만 상당히 코드가 더러워짐)*과 무조건 컴파일 타임에 값이 지정되어야 한다는 점이다.
	자바는 상당히 제네릭에서는 이 점이 널널한 편이기도하고 리플렉션 또한 널널하게 가져다가 사용하기 편하다. ~~이점이 orm에서 프로젝션에 특히 빛을 발하기도 한다.~~
	c++은 ==**무조건 컴파일타임에 컴파일러가 모든 타입을 다 알고 있어야한다.**==
	~~애초에 C++은 db를 이용하기 보단 텍스트파일을 열어젖혀서 쓰고 닫아버리는게 훨씬 빠르기에 딴세상 이야기처럼 들리기도 하다.~~
	
	여튼 이점이 상당히 까다롭기 때문에 타입제한을 걸려고하면 여기서부터는 코드가 더러워지며 이해하기 힘든 코드를 뽑아내야한다. 이점을 이해하고 진행하자.
<br>

+ 참고 할 점
	저 타입을 적지 않아도 컴파일러가 파라미터의 자료형을 보고 알아서 넣어준다.

### template function

> template을 기반으로 컴파일러가 만들어내는 함수

### 예제

``` cpp
#ifndef FIRSTCPP_TWOTYPEADDFUNCTION _H  
#define FIRSTCPP_TWOTYPEADDFUNCTION _H  
#include <iostream>  
  
template<class T>  
T add(T num1, T num2){  
    std::cout<<"T add(T num1, T num2)"<<std::endl;  
    return num1 + num2;  
}  
  
int add(int num1, int num2){  
    std::cout<<"int add(int num1, int num2)"<<std::endl;  
    return num1 + num2;  
}  
  
double add(double num1, double num2){  
    std::cout<<"double add(double num1, double num2)"<<std::endl;  
    return num1 + num2;  
}  
#endif // FIRSTCPP_TWOTYPEADDFUNCTION _H

#include "enthusiasm/template/TwoTypeAddFunction.h"  
  
int main(){  
    std::cout<<add(5, 7)<<std::endl;  
    std::cout<<add(3.7, 7.5)<<std::endl;  
    std::cout<<add<int>(5, 7)<<std::endl;  
    std::cout<<add<double>(3.7, 7.5)<<std::endl;  
    return 0;  
}
```

+ 설명
	
	그저 일반함수와 템플릿 함수가 비교되는 것을 보여주기 위한 예제이다.
<br>
### 예제

``` cpp
#ifndef FIRSTCPP_PRIMITIVEFUNCTIONTEMPLATE _H  
#define FIRSTCPP_PRIMITIVEFUNCTIONTEMPLATE _H  
#include <iostream>  
  
template<class T1, class T2>  
void showData(double num){  
    std::cout<<(T1)num<<", "<<(T2)num<<std::endl;  
}  
#endif // FIRSTCPP_PRIMITIVEFUNCTIONTEMPLATE _H

#include "enthusiasm/template/PrimitiveFunctionTemplate.h"  
  
int main(){  
    showData<char, int>(65);  
    showData<char, int>(65);  
    showData<char, double>(68.9);  
    showData<short, double>(69.2);  
    showData<short, double>(70.4);  
    return 0;  
}
```

+ 설명
	
	보다 시피 `char`를 넣으면 잘 변환되서 출력되는 모습이다.
	`double`의 경우 narrowing에 의해 `D`를 출력한다.
<br>
## 함수 템플릿 특수화, Spectialization
<br>
### 예제

``` cpp
#ifndef FIRSTCPP_NEEDSPECIALFUNCTIONTEMPLATE _H  
#define FIRSTCPP_NEEDSPECIALFUNCTIONTEMPLATE _H  
#include <iostream>  
  
template <class T>  
T max(T a, T b){  
    return a > b ? a : b;  
}  
#endif // FIRSTCPP_NEEDSPECIALFUNCTIONTEMPLATE _H

#include "enthusiasm/template/NeedSpecialFunctionTemplate.h"  
  
int main(){  
    std::cout<<max(11, 15)<<std::endl;  
    std::cout<<max('T', 'Q')<<std::endl;  
    std::cout<<max(3.5, 7.5)<<std::endl;  
    std::cout<<max("Simple", "Best")<<std::endl;  
    return 0;  
}
```

+ 설명
	
	double 형 비교 까진 괜찮았지만 char 포인터 형인 문자열이 오니 비교를 주소 값중 무엇이 더 큰지 비교를 해버린다.
	
	이런 상황에서는 ==문자열의 경우는 따로 구현하도록 **특수화**==를 진행해야한다.
<br>
### 예제

``` cpp
#ifndef FIRSTCPP_SPECIALFUNCTIONTEMPLATE _H  
#define FIRSTCPP_SPECIALFUNCTIONTEMPLATE _H  
  
#include <iostream>  
  
template <class T>  
T max(T a, T b){  
    return a > b ? a : b;  
}  
  
template <>  
char* max(char* a, char* b){  
    std::cout<<"char* max<char*>(char* a, char* b)"<<std::endl;  
    return std::strlen(a) > std::strlen(b) ? a : b;  
}  
  
template <>  
const char* max(const char* a, const char* b){  
    std::cout<<"const char* max<const char*>(const char* a, const char* b)"<<std::endl;  
    return std::strcmp(a, b) ? a : b;  
}  
#endif // FIRSTCPP_SPECIALFUNCTIONTEMPLATE _H

#include "enthusiasm/template/SpecialFunctionTemplate.h"  
  
int main(){  
    std::cout<<max(11, 15)<<std::endl;  
    std::cout<<max('T', 'Q')<<std::endl;  
    std::cout<<max(3.5, 7.5)<<std::endl;  
    std::cout<<max("Simple", "Best")<<std::endl;  
  
    char str1[] = "Simple";  
    char str2[] = "Best";  
    std::cout<<max(str1, str2);  
    return 0;  
}
```

+ 설명
	
	template <> 이렇게 비워서 적은 뒤 원하는 타입의 함수를 직접 지정하는 것이다.
	
	이런식으로 구현을 하면 특수화가 진행된다.
<br>
## 클래스 템플릿, class template

앞서 연산자 오버로딩 예제에 인덱스 범위 지정 연산자를 오버로딩을 한적이  있다.
이때 분명 템플릿으로 지정하면 좋은 예제였었다.
우선, 가장 먼저 자주 사용하던 Point부터 클래스 템플릿을 적용해보자
<br>
### 예제

``` cpp
#ifndef FIRSTCPP_POINTCLASSTEMPLATE _H  
#define FIRSTCPP_POINTCLASSTEMPLATE _H  
#include <iostream>  
  
template <class T>  
class Point{  
private:  
    T xpos;  
    T ypos;  
public:  
    Point(T x= 0, T y= 0):xpos(x), ypos(y){}  
  
    void showPosition() const {  
        std::cout<<"["<<xpos<<", "<<ypos<<"]"<<std::endl;  
    }  
    Point operator*(int times){  
        Point pos(xpos * times, ypos * times);  
        return pos;  
    }  
  
    friend std::ostream& operator<<(std::ostream&, const Point&);  
};  
std::ostream& operator<<(std::ostream& output, const Point& ref){  
    output<<"["<<ref.xpos<<", "<<ref.ypos<<"]"<<std::endl;  
    return output;  
}  
#endif // FIRSTCPP_POINTCLASSTEMPLATE _H

#include "enthusiasm/template/PointClassTemplate.h"  
  
int main(){  
    Point<int> pos1(3, 4);  
    pos1.showPosition();  
  
    Point<double> pos2(2.4, 3.6);  
    pos2.showPosition();  
  
    Point<char> pos3('P', 'F');  
    pos3.showPosition();  
    return 0;  
}
```

+ 설명
	
	함수 템플릿과 마찬가지로 클래스 템플릿을 기반으로 템플릿 클래스를 컴파일러가 만들어낸다. 위의 예제의 경우 총 3개의 템플릿 클래스가 만들어지는 것을 볼 수 있다.

<br>
### 예제

``` cpp
#ifndef FIRSTCPP_POINTCLASSTEMPLATEFUNCDEF _H  
#define FIRSTCPP_POINTCLASSTEMPLATEFUNCDEF _H  
#include <iostream>  
  
template <class T>  
class Point{  
private:  
    T xpos;  
    T ypos;  
public:  
    Point(T x= 0, T y= 0);  
  
    void showPosition() const ;  
};  
  
template <class T>  
Point<T>::Point(T x, T y) : xpos(x), ypos(y){}  
  
template <class T>  
void Point<T>::showPosition() const {  
    std::cout<<"["<<xpos<<", "<<ypos<<"]"<<std::endl;  
}  
  
#endif // FIRSTCPP_POINTCLASSTEMPLATEFUNCDEF _H

#include "enthusiasm/template/PointClassTemplateFuncDef.h"  
  
int main(){  
    Point<int> pos1(3, 4);  
    pos1.showPosition();  
  
    Point<double> pos2(2.4, 3.6);  
    pos2.showPosition();  
  
    Point<char> pos3('P', 'F');  
    pos3.showPosition();  
    return 0;  
}
```

+ 설명
	
	클래스 템플릿의 멤버함수를 외부에 정의하는 방법이다.
<br>

 ### 예제

``` cpp
//  
// Created by 홍준근 on 2023/02/23.//  
  
#ifndef FIRSTCPP_POINTTEMPLATE_H  
#define FIRSTCPP_POINTTEMPLATE_H  
#include <iostream>  
  
template <class T>  
class Point{  
private:  
    T xpos;  
    T ypos;  
public:  
    Point(T x= 0, T y= 0);  
  
    void showPosition() const ;  
};  
  
#endif //FIRSTCPP_POINTTEMPLATE_H

//  
// Created by 홍준근 on 2023/02/23.//  
#include "enthusiasm/template/PointTemplate.h"  
  
template <class T>  
Point<T>::Point(T x, T y) : xpos(x), ypos(y){}  
  
template <class T>  
void Point<T>::showPosition() const {  
    std::cout<<"["<<xpos<<", "<<ypos<<"]"<<std::endl;  
}

//  
// Created by 홍준근 on 2023/02/23.//  
  
#include "enthusiasm/template/PointTemplate.h"  
  
int main(){  
    Point<int> pos1(3, 4);  
    pos1.showPosition();  
  
    Point<double> pos2(2.4, 3.6);  
    pos2.showPosition();  
  
    Point<char> pos3('P', 'F');  
    pos3.showPosition();  
    return 0;  
}
```

+ 설명
	
	그냥 이렇게 실행하면 컴파일 에러가 발생한다.
	그 이유는 컴파일 당시 컴파일러는 h 파일을 include하면 h파일만 살펴보고 copy & paste를 시도한다.
	이렇게 되면 컴파일러는 시그니쳐만 존재하는 클래스 파일만 가지고 컴파일을 시도해야되니 구현체를 알지 못해 컴파일 에러가 발생한다. (C에서 배운 파일단위 컴파일이다.)
	CMakeLists에 라이브러리를 링킹해줘도 PointMain.cpp는 PointTemplate.cpp를 참조하지 않고 반대로도 참조 하지 않는다. 
	
	해결 방안은 다음과 같다.
	1. PointMain.cpp에 PointTemplate.cpp를 추가한다.
	2. 아니면 PointTemplate.h에 멤버함수 구현을 모두 집어 넣는다.
	
	보통 2번째를 가장 많이 사용한다. 1번 같은 경우는 휴먼 에러를 발생시킬 가능성이 크기 때문이다. 물론 C의 파일 단위 컴파일 규칙때문에 1번이 정석이긴 하지만 문제가 있는 방식을 원조랍시고 고집하는건 더더욱 문제가 있는 것이다.
	
<br>
### 예제

``` cpp
#ifndef FIRSTCPP_ARRAYTEMPLATE _H  
#define FIRSTCPP_ARRAYTEMPLATE _H  
#include <iostream>  
#include <cstdlib>  
  
template <class T>  
class BoundCheckArray{  
private:  
    T * arr;  
    int length;  
  
    BoundCheckArray(const BoundCheckArray& ref){}  
    BoundCheckArray& operator=(const BoundCheckArray& ref){}  
  
public:  
    BoundCheckArray(int length);  
    ~BoundCheckArray();  
    T& operator[] (int index);  
    T operator[] (int index) const;  
    int getLength() const;  
};  
  
template <class T>  
BoundCheckArray<T>::BoundCheckArray(int length) :length(length){  
    arr = new T[length];  
}  
  
template <class T>  
BoundCheckArray<T>::~BoundCheckArray() {  
    delete []arr;  
}  
template <class T>  
T &BoundCheckArray<T>::operator[](int index) {  
    if(index < 0 || index >= this->length){  
        std::cout<<"Array index out of bound exception"<<std::endl;  
        exit(1);  
    }  
    return arr[index];  
}  
  
template <class T>  
T BoundCheckArray<T>::operator[](int index) const {  
    if(index < 0 || index >= this->length){  
        std::cout<<"Array index out of bound exception"<<std::endl;  
        exit(1);  
    }  
    return arr[index];  
}  
  
  
template <class T>  
int BoundCheckArray<T>::getLength() const {  
    return length;  
}  
  
#endif // FIRSTCPP_ARRAYTEMPLATE _H

#ifndef FIRSTCPP_POINT _H  
#define FIRSTCPP_POINT _H  
  
#include "enthusiasm/template/ArrayTemplate.h"  
  
class Point{  
private:  
    int xpos;  
    int ypos;  
public:  
    Point(int x= 0, int y= 0);  
  
    friend std::ostream& operator<<(std::ostream&, const Point&);  
};  
  
  
#endif // FIRSTCPP_POINT _H

//  
// Created by 홍준근 on 2023/02/23.//  
  
#include "enthusiasm/template/Point.h"  
  
Point::Point(int x, int y) :xpos(x), ypos(y) {}  
  
std::ostream& operator<<(std::ostream& output, const Point& ref){  
    output<<"["<<ref.xpos<<", "<<ref.ypos<<"]"<<std::endl;  
    return output;  
}

//  
// Created by 홍준근 on 2023/02/23.//  
  
#include "enthusiasm/template/ArrayTemplate.h";  
#include "enthusiasm/template/Point.h";  
  
int main(){  
    /***  
     *  int형 정수 저장  
     */     BoundCheckArray<int> intArray(5);  
    for (int i = 0; i < 5; ++i) {  
        intArray[i] = (i+1)*11;  
    }  
    for (int i = 0; i < 5; ++i) {  
        std::cout<<intArray[i]<<std::endl;  
    }  
    /***  
     *  Point 객체 저장  
     */    BoundCheckArray<Point> objectArray(3);  
    objectArray[0] = Point(3, 4);  
    objectArray[1] = Point(5, 6);  
    objectArray[2] = Point(7, 8);  
    for (int i = 0; i < objectArray.getLength(); ++i) {  
        std::cout<<objectArray[i];  
    }  
    /***  
     *  Point 객체 주소 값 저장  
     */    BoundCheckArray<Point*> objectPointArray(3);  
    objectPointArray[0] = new Point(3, 4);  
    objectPointArray[1] = new Point(5, 6);  
    objectPointArray[2] = new Point(7, 8);  
    for (int i = 0; i < objectPointArray.getLength(); ++i) {  
        std::cout<<*objectPointArray[i];  
    }  
  
    return 0;  
}
```

+ 설명
	
	이 챕터의 맨 첫장에서 언급한대로  인덱스 범위 지정 연산자를 오버로딩을 한 배열 체크 예제에 클래스 템플릿을 적용한 새로운 예제이다.
	
	이런식으로 대부분 사용을 많이들 한다.
	
	가장 대표적으로 `vector`도 이런 클래스 템플릿이다.
<br>


### 예제

``` cpp
#ifndef FIRSTCPP_POINT _H  
#define FIRSTCPP_POINT _H  
  
#include "enthusiasm/template/ArrayTemplate.h"  
template <class T>  
class Point{  
private:  
    T xpos;  
    T ypos;  
public:  
    Point(T x= 0, T y= 0);  
  
    void showPosition() const;  
};  
#endif // FIRSTCPP_POINT _H

//  
// Created by 홍준근 on 2023/02/23.//  
  
#include "enthusiasm/template/Point.h"  
  
template <class T>  
Point<T>::Point(T x, T y) :xpos(x), ypos(y) {}  
  
template <class T>  
void Point<T>::showPosition()const{  
    std::cout<<"["<<xpos<<", "<<ypos<<"]"<<std::endl;  
}

//  
// Created by 홍준근 on 2023/02/23.//  
  
#include "enthusiasm/template/ArrayTemplate.h"  
#include "enthusiasm/template/Point.h"  
#include "enthusiasm/template/Point.cpp"  
  
int main(){  
    /***  
     *  int형 정수 저장  
     */     BoundCheckArray<int> intArray(5);  
    for (int i = 0; i < 5; ++i) {  
        intArray[i] = (i+1)*11;  
    }  
    for (int i = 0; i < 5; ++i) {  
        std::cout<<intArray[i]<<std::endl;  
    }  
    /***  
     *  Point 객체 저장  
     */    BoundCheckArray<Point<int>> objectArray(3);  
    objectArray[0] = Point<int>(3, 4);  
    objectArray[1] = Point<int>(5, 6);  
    objectArray[2] = Point<int>(7, 8);  
    for (int i = 0; i < objectArray.getLength(); ++i) {  
        objectArray[i].showPosition();  
    }  
    /***  
     *  Point 객체 주소 값 저장  
     */    BoundCheckArray<Point<int>*> objectPointArray(3);  
    objectPointArray[0] = new Point<int>(3, 4);  
    objectPointArray[1] = new Point<int>(5, 6);  
    objectPointArray[2] = new Point<int>(7, 8);  
    for (int i = 0; i < objectPointArray.getLength(); ++i) {  
        objectPointArray[i]->showPosition();  
    }  
    for (int i = 0; i < objectPointArray.getLength(); ++i) {  
        delete objectPointArray[i];  
    }  
  
    return 0;  
}
```

+ 설명
	
	위의 예제에서 `Point` 클래스까지 클래스 템플릿으로 만든 예제이다.
	
	여기서 한가지 알아둘 점은 전역함수 방식 `<<` 연산자 오버로딩을 시도하면 에러가 발생한다.
	
	`std::ostream` 클래스가 내 `Point` 클래스 템플릿을 알게끔 해야하는데 그렇게 하려면 `std::ostream` 클래스 파일에 내가 만든 이 클래스 템플릿 소스파일을  `include` 시켜야하니 코어 소스파일을 수정하는 바보같은 짓을 하게 되는 것이다.
	
	그리하여 오버로딩을 `template <class T>`를 위에 넣어 선언하여 진행하여도 컴파일 오류가 발생해 진행이 불가능하다.
	
	그래서 새로 그냥 `showPosition() const;` 이 함수를 만들어서 사용한 것이다.
	
	물론 오버로딩을 진행하는 방법은 있다. 다만 타입을 확실하게 적어야해서 활용도는 떨어진다.
	
	아래 예제는 << 연산자 오버로딩을 가능하게 만드는 방법이다.
	

<br>
### 예제

``` 
#ifndef FIRSTCPP_POINTTEMPLATEFRIENDFUNCTION _H  
#define FIRSTCPP_POINTTEMPLATEFRIENDFUNCTION _H  
  
#include <iostream>  
  
template<class T>  
class Point {  
private:  
    T xpos;  
    T ypos;  
public:  
    Point(T x = 0, T y = 0);  
  
    friend Point<int> operator+(const Point<int> &point1, const Point<int> &point2);  
  
    friend std::ostream &operator<<(std::ostream &, const Point<int> &);  
};  
  
template<class T>  
Point<T>::Point(T x, T y)  
        :xpos(x), ypos(y) {}  
  
Point<int> operator+(const Point<int> &point1, const Point<int> &point2) {  
    return Point<int>(point1.xpos + point2.xpos, point1.ypos + point2.ypos);  
}  
  
std::ostream &operator<<(std::ostream &output, const Point<int> &ref) {  
    output << "[" << ref.xpos << ", " << ref.ypos << "]" << std::endl;  
    return output;  
}  
  
#endif // FIRSTCPP_POINTTEMPLATEFRIENDFUNCTION _H

#include "enthusiasm/template/PointTemplateFriendFunction.h"  
  
int main(){  
    Point<int> pos1(2, 4);  
    Point<int> pos2(4, 8);  
    Point<int> pos3 = pos1 + pos2;  
    std::cout<<pos1<<pos2<<pos3;  
    return 0;  
}
```

+ 설명
	
	이렇게 미리 타입을 명시하면 연산자 오버로딩도 가능하다.
	
	다만 이게 얼마나 효용이 있는 사용방법인지는 모르겠다.
<br>
## 클래스 템플릿 특수화
<br>

### 클래스 템플릿 특수화 방법
<br>

함수 템플릿 특수화와 동일하다.
먼저 클래스 템플릿을 정의하고 
`template<>` 이렇게 비운채로 다시 클래스를 정의하면 된다.

### 예제

``` cpp
#ifndef FIRSTCPP_CLASSTEMPLATESPECIALIZATION _H  
#define FIRSTCPP_CLASSTEMPLATESPECIALIZATION _H  
  
#include <iostream>  
  
template <class T>  
class Point{  
private:  
    T xpos;  
    T ypos;  
public:  
    Point(T x= 0, T y= 0);  
  
    void showPosition() const;  
};  
  
template <class T>  
Point<T>::Point(T x, T y) :xpos(x), ypos(y) {}  
  
template <class T>  
void Point<T>::showPosition()const{  
    std::cout<<"["<<xpos<<", "<<ypos<<"]"<<std::endl;  
}  
  
template <class T>  
class SimpleDataWrapper{  
private:  
    T data;  
public:  
    SimpleDataWrapper(T data):data(data){}  
  
    void showDataInfo() const{  
        std::cout<<"Data: "<<data<<std::endl;  
    }  
};  
  
template <>  
class SimpleDataWrapper<char *>{  
private:  
    char * data;  
public:  
    SimpleDataWrapper(char * data) {  
        this->data = new char[std::strlen(data)+1];  
        std::strcpy(this->data, data);  
    }  
  
    void showDataInfo() const{  
        std::cout<<"String: "<<data<<std::endl;  
        std::cout<<"Length: "<<std::strlen(data)<<std::endl;  
    }  
  
    ~SimpleDataWrapper(){  
        delete[] data;  
    }  
};  
  
template <>  
class SimpleDataWrapper<Point<int>>{  
private:  
    Point<int> data;  
public:  
    SimpleDataWrapper(int x, int y) : data(x, y) {  
    }  
  
    void showDataInfo() const{  
        data.showPosition();  
    }  
};  
  
#endif // FIRSTCPP_CLASSTEMPLATESPECIALIZATION _H

#include "enthusiasm/template/ClassTemplateSpecialization.h"  
  
int main(){  
    SimpleDataWrapper<int> integerWrap(170);  
    integerWrap.showDataInfo();  
    SimpleDataWrapper<char *> charPointerWrap("Class Template Specialization");  
    charPointerWrap.showDataInfo();  
    SimpleDataWrapper<Point<int>> integerPointObjectWrap(3, 7);  
    integerPointObjectWrap.showDataInfo();  
    return 0;  
}
```

+ 설명
	
	구현 자체가 함수 템플릿 특수화와 크게 다를 점이 없어서 넘어간다.
<br>
### 클래스 템플릿 부분 특수화
<br>
함수 템플릿 특수화와 가장 다른 점은 부분 특수화가 가능하다는 점이다.
<br>
### 예제

``` cpp
#ifndef FIRSTCPP_CLASSTEMPLATEPARTIALSPECIALIZATION _H  
#define FIRSTCPP_CLASSTEMPLATEPARTIALSPECIALIZATION _H  
#include <iostream>  
  
template <class T1, class T2>  
class MySimple{  
public:  
    void whoAreYou(){  
        std::cout<<"size of T1: "<<sizeof(T1)<<std::endl;  
        std::cout<<"size of T2: "<<sizeof(T2)<<std::endl;  
        std::cout<<"<class T1, class T2>"<<std::endl;  
    }  
};  
  
template <>  
class MySimple<int, double>{  
public:  
    void whoAreYou(){  
        std::cout<<"size of int: "<<sizeof(int)<<std::endl;  
        std::cout<<"size of double: "<<sizeof(double)<<std::endl;  
        std::cout<<"<class int, class double>"<<std::endl;  
    }  
};  
  
//부분 특수화  
//template <class T1>  
//class MySimple<T1, double>{  
//public:  
//    void whoAreYou(){  
//        std::cout<<"size of int: "<<sizeof(int)<<std::endl;  
//        std::cout<<"size of double: "<<sizeof(double)<<std::endl;  
//        std::cout<<"<class int, class double>"<<std::endl;  
//    }  
//};  
  
#endif // FIRSTCPP_CLASSTEMPLATEPARTIALSPECIALIZATION _H

#include "enthusiasm/template/ClassTemplatePartialSpecialization.h"  
  
int main(){  
    MySimple<char, double> obj1;  
    obj1.whoAreYou();  
    MySimple<int, long> obj2;  
    obj2.whoAreYou();  
    MySimple<int, double> obj3;  
    obj3.whoAreYou();  
    return 0;  
}
```

+ 설명
	
	주석 해제시 부분 특수화가 진행된다.
<br>
## 템플릿 파라미터
<br>
템플릿 타입을 적는 자리에 변수를 선언하여 값을 받을 수도 있다.
<br>
### 예제

``` cpp
#ifndef FIRSTCPP_NONTYPETEMPLATEPARAM _H  
#define FIRSTCPP_NONTYPETEMPLATEPARAM _H  
#include <iostream>  
  
template <class T, int length>  
class SimpleArray{  
private:  
    T arr[length];  
public:  
    SimpleArray<T, length>& operator=(const SimpleArray<T, length>& ref){  
        for (int i = 0; i < length; ++i) {  
            arr[i] = ref.arr[i];  
        }  
        return *this;  
    }  
  
    T& operator[] (int index) {  
        return arr[index];  
    }  
};  
#endif // FIRSTCPP_NONTYPETEMPLATEPARAM _H

#include "enthusiasm/template/NonTypeTemplateParam.h"  
  
int main(){  
    SimpleArray<int, 5> integer5Array1;  
    for (int i = 0; i <5 ; ++i) {  
        integer5Array1[i] = i* 10;  
    }  
  
    SimpleArray<int, 5> integer5Array2;  
    integer5Array2 = integer5Array1;  
    for (int i = 0; i < 5; ++i) {  
        std::cout<<integer5Array2[i]<<", ";  
    }  
    std::cout<<std::endl;  
  
    SimpleArray<int, 7> integer7Array1;  
    for (int i = 0; i < 7; ++i) {  
        integer7Array1[i] = i* 10;  
    }  
    SimpleArray<int, 7> integer7Array2;  
    integer7Array2 = integer7Array1;  
    for (int i = 0; i < 7; ++i) {  
        std::cout<<integer7Array2[i]<<", ";  
    }  
    std::cout<<std::endl;  
    return 0;  
}
```

+ 설명
	
	여기서 주목할 점은 `SimpleArray<int, 5>`와 `SimpleArray<int, 7>`은 명백히 다른 타입으로 동작한다. 즉, 실수로 `SimpleArray<int, 5>`에 `SimpleArray<int, 7>`을 대입해도 컴파일러가 알아서 에러를 잡아준다.
	
	이런 휴먼 에러를 줄여줄 뿐만 아니라 동적으로 배열크기를 잡게되면 생기는 소멸자에 `delete[]` 처리를 해줘야하는 귀찮은 구현과정도 약간 줄여줄 수 있다.
	
	거기에 길이가 다른 배열의 대입연산을 못하도록 막아야한다면 이걸 추가로 검산해야하는 로직을 추가해야하니 CPU부담과 검산 로직을 넣지 못하게 미연에 설계적으로 방지하는 효과가 있다.
<br>
### 예제 - 템플릿 파라미터 디폴트 값 지정

``` cpp
#ifndef FIRSTCPP_TEMPLATEPARAMDEFAULTVALUE _H  
#define FIRSTCPP_TEMPLATEPARAMDEFAULTVALUE _H  
#include <iostream>  
  
template <class T = int, int length = 7>  
class SimpleArray{  
private:  
    T arr[length];  
public:  
    SimpleArray<T, length>& operator=(const SimpleArray<T, length>& ref){  
        for (int i = 0; i < length; ++i) {  
            arr[i] = ref.arr[i];  
        }  
        return *this;  
    }  
  
    T& operator[] (int index) {  
        return arr[index];  
    }  
};  
#endif // FIRSTCPP_TEMPLATEPARAMDEFAULTVALUE _H

#include "enthusiasm/template/TemplateParamDefaultValue.h"  
  
int main(){  
    SimpleArray<> array;  
    for (int i = 0; i < 7; ++i) {  
        array[i] = i+1;  
    }  
    for (int i = 0; i <7; ++i) {  
        std::cout<<array[i]<<", ";  
    }  
    std::cout<<std::endl;  
    return 0;  
}
```

+ 설명
	
	디폴트 값 지정도 가능하다.
<br>
## 템플릿과 static
<br>
함수 템플릿 내부에 static 변수를 넣으면 static 변수를 넣은 템플릿이 각각 만들어지게 된다.
<br>

### 예제

``` cpp
#ifndef FIRSTCPP_FUNCTIONTEMPLATESTATICVAR _H  
#define FIRSTCPP_FUNCTIONTEMPLATESTATICVAR _H  
#include <iostream>  
  
template <class T>  
void showStaticValue(){  
    static T num = 0;  
    num += 1;  
    std::cout<<num<<" ";  
}  
#endif // FIRSTCPP_FUNCTIONTEMPLATESTATICVAR _H

#include "enthusiasm/template/FunctionTemplateStaticVar.h"  
  
int main(){  
    showStaticValue<int>();  
    showStaticValue<int>();  
    showStaticValue<int>();  
    std::cout<<std::endl;  
    showStaticValue<long>();  
    showStaticValue<long>();  
    showStaticValue<long>();  
    std::cout<<std::endl;  
    showStaticValue<double>();  
    showStaticValue<double>();  
    showStaticValue<double>();  
    return 0;  
}
```

+ 설명
	
	보다시피 각 함수별로 각기 다른 static 변수가 적용되는 모습을 볼 수 있다.
	그리고 클래스 템플릿에도 static 멤버변수를 적용하면 똑같이 적용되는 모습을 볼 수 있다.
<br>
### 예제

``` cpp
#ifndef FIRSTCPP_CLASSTEMPLATESTATICMEM_H  
#define FIRSTCPP_CLASSTEMPLATESTATICMEM_H  
#include <iostream>  
  
template <class T>  
class SimpleStaticMem{  
private:  
    static T mem;  
public:  
    void addMem(T num){  
        mem += num;  
    }  
  
    void showMem() const {  
        std::cout<<mem<<std::endl;  
    }  
};  
  
template <class T>  
T SimpleStaticMem<T>::mem = 0;  
#endif // FIRSTCPP_CLASSTEMPLATESTATICMEM_H

#include "enthusiasm/template/ClassTemplateStaticMem.h"  
  
int main(){  
    SimpleStaticMem<int> obj1;  
    SimpleStaticMem<int> obj2;  
    obj1.addMem(2);  
    obj2.addMem(3);  
    obj1.showMem();  
  
    SimpleStaticMem<long> obj3;  
    SimpleStaticMem<long> obj4;  
    obj3.addMem(100);  
    obj4.showMem();  
    return 0;  
}
```

+ 설명
	
	함수 템플릿과 동일한 결과를 뽑아준다.
<br>
## 빈 템플릿 사용시기
<br>
빈 템플릿은 특수화를 구현할때 사용된다.

<br>
## 템플릿 static 멤버변수 초기화의 특수화

`template <class T>`
`T SimpleStaticMem<T>::mem = 0;`

이렇게 초기화하는 방법말고 다른 숫자나 데이터로 초기화 하는 방법도 있다.

`template <>
`T SimpleStaticMem<long>::mem = 5;`

예시를 5로 들었지만 이런식으로 특수화를 이용하면 된다.


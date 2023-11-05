# String 클래스 만들기

## 표준 문자열 클래스

### 예제

```cpp
#include "enthusiasm/string/STDString.h"
#include <iostream>
#include <string>

int main(){
    std::string str1 = "I like ";
    std::string str2 = "string class ";
    std::string str3 = str1 + str2;
    std::cout<<str1<<std::endl;
    std::cout<<str2<<std::endl;
    std::cout<<str3<<std::endl;

    str1 += str2;
    if(str1 == str3){
        std::cout<<"동일한 문자열!"<<std::endl;
    }else{
        std::cout<<"동일하지 않은 문자열!"<<std::endl;
    }

    std::string str4;
    std::cout<<"문자열 입력: ";
    std::cin>>str4;
    std::cout<<"입력한 문자열: "<<str4<<std::endl;
    return 0;
}
```

- 설명

    각종 연산자들을 오버로딩하여 편하게 연산자 사용이 가능한 클래스임을 알 수 있다.

    이것을 어느정도 따라해본 클래스를 만들어보자


## 표준 string class 분석

### 특징

1. 문자열을 인자로 전달받는 생성자가 존재함

    `std::string str1 = "I like ";`

    이런 대입 연산이 가능한 것은 대입연산자와 문자열을 인자로 받는 생성자가 존재한다는 의미이다.

2. 생성자, 소멸자, 복사 생성자, 대입연산자의 정의 [Rule of 5]

    문자열의 길이는 당연히 동적이다. 그렇기 때문에 동적할당을 할 수밖에 없으므로 이를 동적할당, 해제를 담당하는 로직을 생성자, 복사생성자, 소멸자에 각각 담아야하며 대입연산자 또한 오버로딩해야한다.

    모던 C++에서는 여기에 디폴트 생성자 정의까지를 포함해 **Rule Of 5**라고 이야기한다.

    어떠한 클래스를 정의한다면 이런식으로 정의를 해야한다.

    그러나 요즘 모던 C++은 온전히 stl에 의존하는 **Rule Of 0**를 따른다.

    이는 stl컨테이너와 알고리즘등을 제대로 이해하고서 클래스를 구현해야 맞는 이치이므로

    지금부터는 **Rule Of 5** 방식으로 진행하도록 하겠다.

3. 결합된 문자열을 초기화된 객체로 반환하는 `+` 연산자 오버로딩

    `std::string str3 = str1 + str2;`

    이전 연산자 오버로딩에 `+` 연산을 오버로딩한 적이 있다.

    이 문자열도 똑같이 진행해야한다.

4. 문자열을 덧붙이는 `+=` 연산자 오버로딩
5. 내용비교를 하는 `==` 연산자 오버로딩

    자바는 연산자 오버로딩이 미리 만들어둔 `String` 클래스를 제외하고는 없기 때문에(애초에 개발자가 손대는 것이 불가능하기 때문) `Comparable` 같은 인터페이스를 `implements` 해 `isEqual()`같은 메서드를 오버라이딩하는 방식으로 구현한다.

    내가 구현한 뱅킹 시스템 예제도 이런식으로 구현했는데 C++에서는 이럴 필요가 없다.

    그저 값객체이니 동치비교 멤버함수를 따로 구현하지 말고 `==`, `≠` 등의 연산자를 오버로딩하면 된다.

6. 콘솔 입출력이 가능하도록 `<<`, `>>` 연산자 오버로딩

### 예제

```cpp
//  
// Created by 홍준근 on 2023/03/02.//  
#include "StringClass.h"  
  
String::String() {  
    length = 0;  
    value = nullptr;  
}  
  
String::String(const char *string) {  
    length = std::strlen(string);  
    value = new char[length];  
    std::strcpy(value, string);  
}  
  
String::String(const String &ref) {  
    length = ref.length;  
    value = new char[length];  
    std::strcpy(value, ref.value);  
}  
  
String::~String() {  
    if(value != nullptr){  
        delete[] value;  
    }  
}  
  
String& String::operator=(const String &ref) {  
    if(value != nullptr){  
        delete[] value;  
    }  
    length = ref.length;  
    value = new char[length];  
    std::strcpy(value, ref.value);  
    return *this;  
}  
  
String& String::operator+=(const String &ref) {  
    length +=(ref.length -1);  
    char* temp = new char[length];  
    std::strcpy(temp, value);  
    std::strcat(temp, ref.value);  
    if(value != nullptr){  
        delete[] value;  
    }  
    value = temp;  
    return *this;  
}  
  
bool String::operator==(const String &ref) {  
    return !std::strcmp(value, ref.value);  
}  
  
String String::operator+(const String &ref) {  
    char* temp = new char[length + ref.length -1];  
    std::strcpy(temp, value);  
    std::strcat(temp, ref.value);  
    delete[] temp;  
    return String(temp);  
}  
  
std::ostream &operator<<(std::ostream &output, const String &string) {  
    output<<string.value;  
    return output;  
}  
  
std::istream &operator>>(std::istream &input, String &string) {  
    char str[100];  
    input>>str;  
    string = String(str);  
    return input;  
}

#include "enthusiasm/string/StringClass.h"  
  
int main(){  
    String str1 = "I like ";  
    String str2 = "string class ";  
    String str3 = str1 + str2;  
    std::cout<<str1<<std::endl;  
    std::cout<<str2<<std::endl;  
    std::cout<<str3<<std::endl;  
  
    str1 += str2;  
    if(str1 == str3){  
        std::cout<<"동일한 문자열!"<<std::endl;  
    }else{  
        std::cout<<"동일하지 않은 문자열!"<<std::endl;  
    }  
  
    String str4;  
    std::cout<<"문자열 입력: ";  
    std::cin>>str4;  
    std::cout<<"입력한 문자열: "<<str4<<std::endl;  
    return 0;  
}
```
+ 설명
	책에는 NULL 키워드를 사용하지만 요즘은 `nullptr`를 사용하는 것이 좀 더 확장성 있는 사용법이다.
	그 이유는 버전 호환성 때문이다.
	
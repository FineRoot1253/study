## 예외 처리를 하지 않을 때의 결과
1. 나이를 입력하라고 했는데 음수를 입력해도 통과
2. 나눗셈에 했는데 0을 입력받아도 통과
3. 주민 등록번호 13자리를 입력받을려고 했는데 -를 포함해도 통과

이런 로직 때문에 실제 실무에서도 큰 사고 처리 비용을 치루기도 한다.
실제 실무에서는 연차가 쌓이면 쌓일 수록 짬에서 나오는 바이브는 예외 처리에서 나온다.
설계 능력? 기술을 다루는 지식? 논리적 사고력? 커뮤니케이션 능력? 이런건 사람마다 다 다르다.
그렇지만 이것 한가지는 일관적이다. 
그것이 바로 ==짬에서 나오는 예외 처리 능력==이다.
나도 짧은 실무경험이 있지만 대부분의 경우 가장 시간을 많이 소모하는 것이 예외처리를 넣고 테스트 케이스를 돌리면서 시간이 가장 많이 소모되는 것을 보았다.

잘 모르는 어리숙한 개발자는 서둘러 개발하고 퇴근하고 후에 사고를 치지만 나중에 연차가 쌓이면 예외처리를 깔끔하게 하여 사고가 터지지 않게 만드느라 시간을 소모한다.

물론 경험이 더 쌓이면 쌓일수록 이런 일처리는 눈감고도 하게 된다.
하여튼간에, 내 개인적인 경험상 이런 예외 처리 능력은 연차가 쌓이면 동일하게 잘 처리해내는 듯 했다.
그만큼 기본기술이며 중요한 기술이다.
==나쁘게 말하자면 **기본적인 예외처리도 못하면 평생 주니어인 개발자**인 것이다.==
<br>
### 예제

``` cpp
#include <iostream>  
  
int main(){  
    int num1;  
    int num2;  
    std::cout<<"두 개의 숫자 입력: ";  
    std::cin>>num1>>num2;  
    std::cout<<"나눗셈의 몫: "<<num1/num2<<std::endl;  
    std::cout<<"나눗셈의 나머지: "<<num1%num2<<std::endl;  
    return 0;  
}

////////////////////////////////////////

#include <iostream>  
  
int main(){  
    int num1;  
    int num2;  
    std::cout<<"두 개의 숫자 입력: ";  
    std::cin>>num1>>num2;  
    if (num2 <=0){  
        std::cout<<"제수는 0이 될 수 없습니다."<<std::endl;  
        std::cout<<"프로그램을 다시 실행하세요."<<std::endl;  
    }else{  
        std::cout<<"나눗셈의 몫: "<<num1/num2<<std::endl;  
        std::cout<<"나눗셈의 나머지: "<<num1%num2<<std::endl;  
    }  
    return 0;  
}
```

+ 설명
	
	위가 전형적인 예외 없이 문제가 생기는 코드이고 아래가 if문으로 예외를 처리한 방식이다.
	
	사실 앞으로 소개할 exception이 없는 언어도 있다. 
	
	이 if문으로 예외를 거르는게 다인 것뿐인 언어도 있으며 써보면 사실 많이 불편하긴 하다.
	
	여튼 C++의 예외 처리 메커니즘을 배워보자.
<br>
## C++ 예외처리 메커니즘
<br>
### try-catch, throw

+ try
	  
	예외를 발견한다.

	+ 사용방법
		```
		try{
			... 코드작성
		}
		```
		저 코드 작성 영역에 예외발생이 예상되는 코드를 작성한다.
<br>

+ catch
	
	예외를 잡는다.

	+ 사용방법
		```
		catch(처리할 예상하는 예외의 타입 명시){
			//try 블록 끝나자마자 작성한다.
		}
		```
		저 영역에는 예외발생시 동작하는 예외 처리 코드를 삽입한다.
<br>

+ throw
	
	예외를 던진다.

	+ 사용방법
		```
		throw Exception;
		```
		예외 클래스를 상위 스택프레임에 리턴한다.
<br>
### 예제

``` cpp
#include <iostream>  
  
int main(){  
    int num1;  
    int num2;  
    std::cout<<"두 개의 숫자 입력: ";  
    std::cin>>num1>>num2;  
    try{  
        if (num2 <=0){  
            throw num2;  
        }  
        std::cout<<"나눗셈의 몫: "<<num1/num2<<std::endl;  
        std::cout<<"나눗셈의 나머지: "<<num1%num2<<std::endl;  
    }catch (int e){  
        std::cout<<"제수는 "<<e<<"이 될 수 없습니다."<<std::endl;  
        std::cout<<"프로그램을 다시 실행하세요."<<std::endl;  
    }  
    return 0;  
}

```

+ 설명
	
	`throw`가 실행되면 그 즉시 `catch`문으로 이동하는 모습을 볼 수 있다.
	
	거기에 특이한 점은 `throw`는 무엇이든 던질 수 있다는 점이다.
	
	자바의 경우에는 `Exception`을 상속받은 객체만 던질 수 있지만 C++은 그런 제한은 없다. 
	다만 권장하기로는 stl에 만들어둔 `exception`을 상속받아 구현한 객체를 던지는 것을 권장한다.
<br>
## try 블록의 기준
<br>

> try 블록은 하나의 일의 단위로 구성해 묶어야한다.

<br>
만약 위의 예제의 경우에도 예외를 처리한 뒤 나눗셈 연산을 따로 진행하게 된다면?
그러면 저렇게 예외처리를 하는 것이 의미가 없어진다.

반드시 한가지 일의 단위로 묶어서 `try` 블록으로 만들어야한다.

그리고 자바에서는 특히 트랜잭션을 이렇게 묶는다.
(특히 자바는 바이트코드 구성시 위빙으로 바이트코드 조작을 하여 try - catch 블록을 프록시를 활용해 깔끔한 구문구성을 할 수도 있다. (이것이 AOP라는 기술이다))
<br>
## Stack Unwinding, 스택 풀기

> 예외 발생후 예외를 처리하지 않으면 발생한 예외를 호출시킨 호출부쪽에 책임을 지게한다.

<br>

### 예제

``` cpp
#ifndef FIRSTCPP_PASSEXCEPTION _H  
#define FIRSTCPP_PASSEXCEPTION _H  
#include <iostream>  
  
void divide(int num1, int num2){  
    if(num2 == 0){  
        throw num2;  
    }  
    std::cout<<"나눗셈의 몫: "<<num1/num2<<std::endl;  
    std::cout<<"나눗셈의 나머지: "<<num1%num2<<std::endl;  
}  
#endif // FIRSTCPP_PASSEXCEPTION _H

#include "enthusiasm/exception/PassException.h"  
  
int main(){  
    int num1;  
    int num2;  
    std::cout<<"두 개의 숫자 입력: ";  
    std::cin>>num1>>num2;  
  
    try{  
        divide(num1, num2);  
        std::cout<<"나눗셈을 마쳤습니다."<<std::endl;  
    }catch(int e){  
        std::cout<<"제수는 "<<e<<"이 될 수 없습니다."<<std::endl;  
        std::cout<<"프로그램을 다시 실행하세요."<<std::endl;  
    }  
    return 0;  
}
```

+ 설명
	
	외부로 끄집어낸 작업에서 throw 던지만 호출부에서 받는 모습을 볼 수 있다.
<br>

+ 결론
	 
	 예외처리가 되지 않으면 예외를 발생한 함수를 호출한 스택 영역으로 예외 데이터가 전달된다. (+ 책임까지)
<br>
### 예제

``` cpp
#include "enthusiasm/exception/DiffHandingPosition.h"  
  
int main(){  
    char str1[100];  
    char str2[100];  
  
    while(true){  
        std::cout<<"두 개의 숫자 입력: ";  
        std::cin>>str1>>str2;  
  
        try{  
            std::cout<<str1<<" + "<<str2<<" = "<<sToI(str1)+sToI(str2)<<std::endl;  
            break;        }catch (char e){  
            std::cout<<"문자 "<<e<<"가 입력되었습니다."<<std::endl;  
            std::cout<<"재입력을 진행합니다."<<std::endl;  
        }  
    }  
    std::cout<<"프로그램을 종료합니다."<<std::endl;  
    return 0;  
}

#ifndef FIRSTCPP_DIFFHANDINGPOSITION _H  
#define FIRSTCPP_DIFFHANDINGPOSITION _H  
#include <iostream>  
#include <cmath>  
#include <cstring>  
  
int sToI(char* str){  
    int num = 0;  
  
    for (int i = 0; i < std::strlen(str); ++i) {  
        if(str[i] < '0' || str[i] > '9'){  
            throw str[i];  
        }  
        num += (int) (pow((double)10, (std::strlen(str)-1)-i) * (str[i] + (7 -'7')));  
    }  
    return num;  
}  
#endif // FIRSTCPP_DIFFHANDINGPOSITION _H
```

+ 설명
	
	예외 처리에 대한 가장 간단한 프로그램의 예시이다.
<br>
### 예제

``` cpp
#ifndef FIRSTCPP_STACKUNWINDING _H  
#define FIRSTCPP_STACKUNWINDING _H  
#include <iostream>  
  
void simpleFuncOne();  
void simpleFuncTwo();  
void simpleFuncThree();  
  
void simpleFuncOne(){  
    std::cout<<"simpleFuncOne()"<<std::endl;  
    simpleFuncTwo();  
}  
  
void simpleFuncTwo(){  
    std::cout<<"simpleFuncTwo()"<<std::endl;  
    simpleFuncThree();  
}  
  
void simpleFuncThree(){  
    std::cout<<"simpleFuncThree()"<<std::endl;  
    throw -1;  
}  
#endif // FIRSTCPP_STACKUNWINDING _H

#include "enthusiasm/exception/StackUnwinding.h"  
  
int main(){  
    try{  
        simpleFuncOne();  
    }catch (int e){  
        std::cout<<"에외코드: "<<e<<std::endl;  
    }  
    return 0;  
}
```

+ 설명
	
	이 예제는 무조건 예외를 던지도록 만들어졌다.
	
	특히 실행 결과를 보게되면 호출 스택이 쌓이는 것을 직관적으로 볼 수 있는 예제이다.
<br>

## 예외의 자료형은 일치 하지 않아도 예외데이터는 전달된다.

특히 다른 예외 객체의 경우일지라도 그 객체는 반드시 전달된다.

catch를 못하지만 않으면 된다.

<br>

### 예제

``` cpp 
#ifndef FIRSTCPP_CATCHLIST _H  
#define FIRSTCPP_CATCHLIST _H  
#include <iostream>  
#include <cmath>  
#include <cstring>  
  
int sToI(char* str){  
    int num = 0;  
  
    if(std::strlen(str) !=  0 && str[0] == '0'){  
        throw 0;  
    }  
  
    for (int i = 0; i < std::strlen(str); ++i) {  
        if(str[i] < '0' || str[i] > '9'){  
            throw str[i];  
        }  
        num += (int) (pow((double)10, (std::strlen(str)-1)-i) * (str[i] + (7 -'7')));  
    }  
    return num;  
}  
#endif // FIRSTCPP_CATCHLIST _H

#include "enthusiasm/exception/CatchList.h"  
  
int main(){  
    char str1[100];  
    char str2[100];  
  
    while(true){  
        std::cout<<"두 개의 숫자 입력: ";  
        std::cin>>str1>>str2;  
  
        try{  
            std::cout<<str1<<" + "<<str2<<" = "<<sToI(str1)+sToI(str2)<<std::endl;  
            break;        }catch (char e){  
            std::cout<<"문자 "<<e<<"가 입력되었습니다."<<std::endl;  
            std::cout<<"재입력을 진행합니다."<<std::endl;  
        }catch (int e){  
            if(e == 0){  
                std::cout<<"0으로 시작하는 숫자는 입력불가."<<std::endl;  
            }else{  
                std::cout<<"비정상적입력이 이루어졌습니다."<<std::endl;  
            }  
            std::cout<<"재입력을 진행합니다."<<std::endl;  
        }  
    }  
    std::cout<<"프로그램을 종료합니다."<<std::endl;  
    return 0;  
}
```

+ 설명
	
	다른 자료형인 `int`를 리턴해도 잘 전달되는 모습을 볼 수 있다.
<br>

### 구현시 주의할 점
<br>

==**예외를 함수 시그니쳐에 명시를 해주는 것이 중요하다.**==

그래야 이 함수를 가져다 쓰는 개발자입장에서 직관적으로 예외처리가 가능하다.

만약 다른 자료형의 예외를 까먹고 명시하지않아 예외처리를 하지 못했다면 이는 프로그램 종료로 이어진다.

**예외 처리 실패시 프로그램 종료는 사실 굉장히 중요한 것**이다. 

==프로그램이 종료되지 않고 그대로 실행된다면 개발자는 예외가 발생했는지도 모르는 채로 개발을 이어가기 때문==이다.

### 예제

``` cpp

int simpleFunc() throw (int, char)

```

+ 설명
	
	만약 `int`와 `char` 두 가지의 예외가 나오는 상황이면 저렇게 2개를 적어주면 되며
	
	어떠한 예외도 전달되지 않는 경우에는 `noexcept` 예약어를 사용한다.

<br>

## 예외 객체 설계하기

주로 실무에서는 예외 처리를 담당하는 예외 클래스를 따로 구현해서 만드는 것이 일반적이다.

### 예제

``` cpp
#ifndef FIRSTCPP_ATMSIM _H  
#define FIRSTCPP_ATMSIM _H  
#include <iostream>  
#include <string>  
#include <utility>  
  
class DepositException{  
private:  
    int requireDepositAmount;  
public:  
    DepositException(int requireDepositAmount) : requireDepositAmount(requireDepositAmount){}  
  
    void showExceptionMessage(){  
        std::cout<<"[예외 메시지: "<<requireDepositAmount<<"는 입금 불가]"<<std::endl;  
    }  
};  
  
class WithdrawException{  
private:  
    int requireWithdrawAmount;  
public:  
    WithdrawException(int requireWithdrawAmount):requireWithdrawAmount(requireWithdrawAmount){}  
  
    void showExceptionMessage(){  
        std::cout<<"[예외 메시지: "<<requireWithdrawAmount<<"는 출금 불가]"<<std::endl;  
    }  
};  
  
class Account{  
private:  
    std::string accountNumber;  
    int balance;  
public:  
    Account(std::string  accountNumber, int balance):accountNumber(std::move(accountNumber)), balance(balance){}  
  
    void deposit(int money) throw(DepositException){  
        if(money<=0){  
            throw DepositException(money);  
        }  
        balance += money;  
    }  
  
    void withdraw(int money) throw(WithdrawException){  
        if(money > balance){  
            throw WithdrawException(balance);  
        }  
        balance-= money;  
    }  
  
    void showMoney(){  
        std::cout<<"잔고: "<<balance<<std::endl;  
    }  
};  
  
  
#endif // FIRSTCPP_ATMSIM _H

#include "enthusiasm/exception/ATMSim.h"  
  
int main(){  
    Account myAccount("123456-123456", 5000);  
  
    try{  
        myAccount.deposit(2000);  
        myAccount.deposit(-300);  
    }catch (DepositException &ex){  
        ex.showExceptionMessage();  
    }  
    myAccount.showMoney();  
  
    try{  
        myAccount.withdraw(3500);  
        myAccount.withdraw(4500);  
    }catch (WithdrawException &ex){  
        ex.showExceptionMessage();  
    }  
    myAccount.showMoney();  
    return 0;  
}
```

+ 설명
	
	가장 보편적으로 사용되는 try catch의 예시이다.
	실제 금융 서비스의 트랜잭션의 로직도 전부 이런식으로 구현되어있다.
	물론 요즘은 자바를 쓰는 곳이 대부분이긴 하지만 여튼 이런식으로 구현되어있다.
	
	여기에 추가로 AOP를 써서 좀 더 이쁘게 로직만 들어내는 경우가 오늘날의 트랜잭션 로직이다.
	
	이 예외 객체에 상속관계를 부여하면 좀 더 괜찮게 사용 가능하다.
	
	==**특히 주의할 점은 객체를 받을 때는 `&` 연산자를 꼭 붙여줘야한다. 만약 `char*` 동적할당이 존재하는 객체라면 복사과정중 할당에 문제가 생길 수도 있다.**==

<br>

### 예제

``` cpp
#ifndef FIRSTCPP_ATMSIM2 _H  
#define FIRSTCPP_ATMSIM2 _H  
#include <iostream>  
#include <string>  
#include <utility>  
  
class IAccountException{  
public:  
    virtual void showExceptionMessage() = 0;  
};  
  
class DepositException : public IAccountException {  
private:  
    int requireDepositAmount;  
public:  
    DepositException(int requireDepositAmount) : requireDepositAmount(requireDepositAmount){}  
  
    void showExceptionMessage() override {  
        std::cout<<"[예외 메시지: "<<requireDepositAmount<<"는 입금 불가]"<<std::endl;  
    }  
};  
  
class WithdrawException : public IAccountException {  
private:  
    int requireWithdrawAmount;  
public:  
    WithdrawException(int requireWithdrawAmount):requireWithdrawAmount(requireWithdrawAmount){}  
  
    void showExceptionMessage() override {  
        std::cout<<"[예외 메시지: "<<requireWithdrawAmount<<"는 출금 불가]"<<std::endl;  
    }  
};  
  
class Account{  
private:  
    std::string accountNumber;  
    int balance;  
public:  
    Account(std::string  accountNumber, int balance):accountNumber(std::move(accountNumber)), balance(balance){}  
  
    void deposit(int money) throw(DepositException){  
        if(money<=0){  
            throw DepositException(money);  
        }  
        balance += money;  
    }  
  
    void withdraw(int money) throw(WithdrawException){  
        if(money > balance){  
            throw WithdrawException(balance);  
        }  
        balance-= money;  
    }  
  
    void showMoney(){  
        std::cout<<"잔고: "<<balance<<std::endl;  
    }  
};  
  
  
#endif // FIRSTCPP_ATMSIM2 _H


#include "enthusiasm/exception/ATMSim2.h"  
  
int main(){  
    Account myAccount("123456-123456", 5000);  
  
    try{  
        myAccount.deposit(2000);  
        myAccount.deposit(-300);  
    }catch (IAccountException &ex){  
        ex.showExceptionMessage();  
    }  
    myAccount.showMoney();  
  
    try{  
        myAccount.withdraw(3500);  
        myAccount.withdraw(4500);  
    }catch (IAccountException &ex){  
        ex.showExceptionMessage();  
    }  
    myAccount.showMoney();  
    return 0;  
}

```

+ 설명
	
	이런식으로 예외를 거르면 공통 예외 객체하나로 거를 수 있다.
	
	근데 자바에서는 왠만해선 이렇게 사용하진 않는다.
	
	명백한 예외를 프로그래밍 코드상 표현해주는 것이 좋기 때문이다.
	

<br>

## 예외 처리 전달 방식

<br>

try - catch 문에서 catch에 잡지 못하는 예외일 경우 하위 catch로 차례로 넘겨서 검사를 진행한다.
<br>

### 예제

``` cpp
#ifndef FIRSTCPP_CATCHFLOW _H  
#define FIRSTCPP_CATCHFLOW _H  
#include <iostream>  
  
class ExceptionAAA{  
public:  
    void showYourSelf(){  
        std::cout<<"ExceptionAAA!!!"<<std::endl;  
    }  
};  
  
class ExceptionBBB : public ExceptionAAA {  
public:  
    void showYourSelf(){  
        std::cout<<"ExceptionBBB!!!"<<std::endl;  
    }  
};  
  
class ExceptionCCC : public ExceptionBBB {  
public:  
    void showYourSelf(){  
        std::cout<<"ExceptionCCC!!!"<<std::endl;  
    }  
};  
  
void exceptionGenerator(int ex) noexcept(false) {  
    switch(ex){  
        case 1:  
            throw ExceptionAAA();  
        case 2:  
            throw ExceptionBBB();  
        default:  
            throw ExceptionCCC();  
    }  
}  
#endif // FIRSTCPP_CATCHFLOW _H

#include "enthusiasm/exception/CatchFlow.h"  
  
int main(){  
    try{  
        exceptionGenerator(3);  
        exceptionGenerator(2);  
        exceptionGenerator(1);  
    }catch (ExceptionAAA &ex){  
        std::cout<<"catch (ExceptionAAA &ex)"<<std::endl;  
        ex.showYourSelf();  
    }catch (ExceptionBBB &ex){  
        std::cout<<"catch (ExceptionBBB &ex)"<<std::endl;  
        ex.showYourSelf();  
    }catch (ExceptionCCC& ex){  
        std::cout<<"catch (ExceptionCCC& ex)"<<std::endl;  
        ex.showYourSelf();  
    }  
    return 0;  
}
```

+ 설명
	
	 위의 예제는 서순에 어울리지 않게끔 catch 문장이 구성되어있다.
	 즉, exceptionGenerator(3);은 ExceptionCCC를 던지지만 상속 관계에 모든 클래스에 얽혀있고 catch 블록 순서를 기반 예외 클래스부터 구성해버렸다.
	 이렇게 구성하면 최상위 예외로써 모든 클래스가 걸리게 되므로
	 
	 ==**반드시 catch블록을 구성할 때는 최하위 유도 예외 클래스부터 catch를 해야한다.**==
	 
	 ==이게 **주니어 개발자가 엄청나게 자주 실수하는 문제중 하나**이다.==

<br>

+ 결론
  
	 ==**반드시 catch블록을 구성할 때는 최하위 유도 예외 클래스부터 catch를 해야한다.**==

<br>

## 이미 정의된 예외 종류

<br>

+ bad_alloc
	
	메모리 공간 할당 실패시 발생

<br>

+ bad_cast
	
	형변환 실패시 발생

<br>

+ ...
	
	모든 타입을 다 받아들이는 `catch` 표현
	
	다만 이렇게 사용하면 그 어떤 예외 데이터도 받을 수 없다.
	
	이렇게 맨 마지막 `catch` 블록을 처리하는 경우가 많이 있다.


<br>
### 예제

``` cpp

#include <iostream>  
  
int main(){  
    int num = 0;  
  
    try{  
        while(true){  
            num++;  
            std::cout<<num<<"번째 할당 시도"<<std::endl;  
            new int[10000][10000];  
        }  
    }catch (std::bad_alloc& bad){  
        std::cout<<bad.what()<<std::endl;  
        std::cout<<"더 이상 할당 불가"<<std::endl;  
    }  
    return 0;  
}

```

+ 설명
	
	미리 만들어진 bad_alloc 예외이다.



<br>
## 예외 던지기


<br>
자바와는 다르게 예외를 다시 catch 블록에서 던질때는 `throw;` 이렇게 던지면 된다.

만약 넘겨 받은 예외 데이터를 다시 `throw ex;` 이렇게 넘기면 다시 한번 더 복사생성자가 호출되는 문제가 발생한다.

### 예제

``` cpp
#ifndef FIRSTCPP_RETHROW _H  
#define FIRSTCPP_RETHROW _H  
#include <iostream>  
  
void divide(int num1, int num2){  
    try{  
        if(num2 == 0){  
            throw num2;  
        }  
        std::cout<<"나눗셈의 몫: "<<num1/num2<<std::endl;  
        std::cout<<"나눗셈의 나머지: "<<num1%num2<<std::endl;  
    }catch(int ex){  
        std::cout<<"first catch"<<std::endl;  
        throw;    }  
  
}  
  
#endif // FIRSTCPP_RETHROW _H

#include "enthusiasm/exception/ReThrow.h"  
  
int main(){  
    try{  
        divide(9, 2);  
        divide(4, 0);  
    }catch(int ex){  
        std::cout<<"second catch"<<std::endl;  
    }  
    return 0;  
}
```

+ 설명
	
	일반적으로 이런식으로 구성을 하진 않는다.
	
	이렇게 하면 욕먹으니까 이런게 가능하구나 하는 것만 봐두자.

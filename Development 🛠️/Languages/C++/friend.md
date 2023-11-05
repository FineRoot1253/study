# friend

## friend란?

<aside>
💡 특정 클래스가 다른 클래스에 friend를 선언하면 다른 클래스가 private까지 접근 할 수 있도록 해주는 예약어

</aside>

### 예시 [클래스]

```cpp
#ifndef FIRSTCPP_MYFRIENDCLASS _H
#define FIRSTCPP_MYFRIENDCLASS _H
#include <cstring>
#include <iostream>

class Girl;

class Boy{
private:
    int height;
    friend class Girl;
public:
    Boy(int len):height(len){}
    void showYourFriendInfo(Girl& frn);
};

class Girl{
private:
    char phNum[20];
public:
    Girl(char* num){
        std::strcpy(phNum, num);
    }
    void showYourFriendInfo(Boy& frn);
    friend class Boy;
};

void Boy::showYourFriendInfo(Girl &frn) {
    std::cout<<"Her phone number: "<<frn.phNum<<std::endl;
}

void Girl::showYourFriendInfo(Boy &frn) {
    std::cout<<"His height: "<<frn.height<<std::endl;
}
#endif // FIRSTCPP_MYFRIENDCLASS _H

#include "enthusiasm/friend/MyFriendClass.h"

int main(){
    Boy boy(163);
    Girl girl("010-1234-5678");
    boy.showYourFriendInfo(girl);
    girl.showYourFriendInfo(boy);
    return 0;
}
```

- 설명

    `Boy`와 `Girl` 둘 다 상호 간 `friend` 선언을 하여 접근 할 수 없는 `private` 멤버에 접근 한다.


### 예시 [함수]

```cpp
#ifndef FIRSTCPP_MYFRIENDFUNCTION _H
#define FIRSTCPP_MYFRIENDFUNCTION _H

#include <iostream>

class Point;

class PointOperation {
private:
    int operationCount;
public:
    PointOperation()
            : operationCount(0) {};

    ~PointOperation() {
        std::cout << "Operation times: " << operationCount << std::endl;
    }

    Point addPoint(const Point &, const Point &);

    Point subPoint(const Point &, const Point &);
};

class Point {
private:
    int x;
    int y;
public:
    Point(const int &xpos, const int &ypos)
            : x(xpos), y(ypos) {};

    friend Point PointOperation::addPoint(const Point &, const Point &);

    friend Point PointOperation::subPoint(const Point &, const Point &);

    friend void showPointPos(const Point &);
};

Point PointOperation::addPoint(const Point &pos1, const Point &pos2) {
    ++operationCount;
    return Point(pos1.x + pos2.x, pos1.y + pos2.y);
}

Point PointOperation::subPoint(const Point &pos1, const Point &pos2) {
    ++operationCount;
    return Point(pos1.x - pos2.x, pos1.y - pos2.y);
}

void showPointPos(const Point &pos) {
    std::cout << "X: " << pos.x << ", Y: " << pos.y << std::endl;
}

#endif // FIRSTCPP_MYFRIENDFUNCTION _H

#include "enthusiasm/friend/MyFriendFunction.h"

int main(){
    Point pos1(1,2);
    Point pos2(2,4);
    PointOperation op;

    showPointPos(op.addPoint(pos1, pos2));
    showPointPos(op.subPoint(pos1, pos2));
    return 0;
}
```

- 설명

    `Point`의 기능 클래스를 따로 분리하여 `PointOperation` 클래스에서 선언하고 초기화 하였다.

    이런식으로 구현하는 방식은 객체지향의 원리를 박살내는 것이다.

    차라리 기능 `Point`에 넣지 않을거면 `PointImpl` 클래스를 만들고 이 클래스가 기능을 담당하도록 만들어 위임 패턴을 활용한 브릿지 패턴등 을 사용하는 것이 더 낫다.

    패턴등을 활용하면 얼마든지 기능을 분리해낼 수 있다.

    ~~근데 기능과 데이터를 합칠려고 노력한 나날을 생각해보면 좀 어처구니 없는..~~


## 주의점 및 사용시기

### 주의점

friend 선언은 엄밀히 말하자면 객체간의 정보은닉을 부수는 방법이다.

이는 객체지향의 어긋나는 행위 임으로 엄격히 금지하고 있다.

다만, 이를 사용하는 시기가 따로 존재한다.

### 사용시기

**연산자 오버로딩**에 필수적으로 사용이 된다.

특히 이런 오버로딩에 사용되는 이유는 `operator`가 접근 할 수 없는 private 영역에 대해 접근을 하게끔 만들어야하는 특수한 상황이기 때문이다.

예를들면 `ostream`, `istream` 등을 활용해 객체를 출력하거나 초기화를 한다면
이런 경우에는 `private` 영역의 멤버를 초기화하거나 접근하여 값을 가져와야하므로 `friend` 선언이 필요하다.

만약 `friend` 선언을 하지 않는다면 모든 멤버의 getter/setter를 생성해줘야하는 수고로움과 이로인한 유지보수비용이 증가한다.

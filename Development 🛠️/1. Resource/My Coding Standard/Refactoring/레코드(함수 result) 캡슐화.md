# 레코드(함수 result) 캡슐화

```jsx
organization = {name : "애크미 구스베리", country: "GB"};
```

↓

```jsx
class Organization {
	constructor(data) {
		this._name = data.name;
		this._country = data.country;
	}
	get name() => this._name;
	set name(arg) => {this._name = arg;}
	get country() => this._country;
	set country(arg) {this._country = arg;}
}
```

<aside>
⚠️ *"나는 '**가변**'데이터일 때 객체를 선호한다고 했다. 값이 불변이면(데이터가 범위 데이터일시) 단순히 'start', 'end', 'length' 를 모두 구해 레코드에 저장하면 된다. 이름 변경시 그저 필드를 복제한다. 그러면 앞서 객체를 활용해 수정 전후의 두 메서드를 동시에 제공한 방식과 비슷 하게 점진적으로 수정할 수 있다. ..."*

</aside>

<aside>
💬 [Dart 기준]플러터에선 이 [직렬화 도구](https://flutter-ko.dev/docs/development/data-and-backend/json)를 사용하면 편하게 리펙토링이 가능하다. 그러나 이미 데이터 모델을 하나 만들어둔 상태에서 직렬화를 진행한다면 기존에 만든 데이터 모델을 전부 주석처리를 하고 진행 해야하는 불편함이 있다.

</aside>

<aside>
💬 [Dart 기준]직렬화 도구 없이 그냥 만든다고 하면 네임드 생성자를 이용해서 편하게 추가가 가능하다. 일단 직렬화 도구로 모델을 하나 만들어두고 생성되어있는 네임드 생성자를 고치는 것도 방법이다. 그래서 이 기법 또한 dart 기준으로 진행할 예정이다.

</aside>

<aside>
💬 책 내부 예시에선 **간단한 레코드** & **중첩된 레코드**, 두 개를 예시로 들어 설명하는데 **복잡한 레코드는** **결국 어디에 있는지는 알아서 찾은 후 추가**해줘야 하기 때문에 간단한 레코드만 알아도 객체화 하는 데에 문제는 없다.

</aside>

### 절차

1. 레코드를 담은 변수를 캡슐화 한다.
2. 레코드를 감싼 단순한 클래스로 해당 변수의 내용을 교체한다.
    1. 이 클래스에서 원본 레코드를 반환하는 접근자를 정의 할 것
    2.  변수를 캡슐화 하는 함수들이 이 접근자를 사용하도록 수정 할 것
3. 테스트
4. 원본 레코드 대신 새로 정의한 클래스 타입의 객체를 반환하는 함수들을 새로 만든다.
5. 레코드를 반환하는 예전 함수를 사용하는 코드를 4에서 만든 새 함수를 사용하도록 변경
    - 필드에 접근시 객체의 접근자를 사용 할 것
    - 적절한 접근자가 없다면 추가 할 것
    - 이 수정은 1수정1테스트를 권장
    - 만약 중첩된 구조의 복잡한 레코드 일시
        - 데이터를 갱신하는 클라이언드를 먼저 주의해서 볼 것
        - 클라이언트가 데이터를 읽기만 한다면 데이터의 복제본 OR 읽기 전용 프락시를 반환하는 것도 고려 할 것
6. 클래스에서 원본 데이터를 반환하는 접근자와(1에서 검색하기 쉬운 이름을 붙여둔) 원본 레코드를 반환하는 함수들을 제거
7. 테스트
8. 레코드의 필드도 데이터 구조인 중첩 구조라면 레코드 캡슐화와 [[컬렉션 캡슐화]]를 재귀적으로 적용 할 것

### 예시

```dart
import 'package:intl/intl.dart';

// 현 프로젝트에서 사용중인 레코드 모델을 들고 와봤다.
class MessageModel {

  String _msgType;
  String _title;
  String _body;
  String _url;
  String _userId;
  String _compCd;
  String _compNm;
  String _receivedDate;

  MessageModel(
      {msgType = "0",
      title = "Default_Title_Text",
      body = "Default_Body_Text",
      url = "/",
      userId,
      compCd,
      compNm = "Default_Company_Text",
      receivedDate = "0000-00-00 00:00:00"}) {
    _msgType = msgType ?? "0";
    _title = title ?? "Default_Title_Text";
    _body = body ?? "Default_Body_Text";
    _url = url ?? "/";
    _userId = userId ?? null;
    _compCd = compCd ?? null;
    _compNm = compNm ?? "Default_Company_Text";
    _receivedDate = receivedDate ?? "0000-00-00 00:00:00";
  }

  get msgType => _msgType;
  get title => _title;
  get body => _body;
  get url => _url;
  get userId => _userId;
  get compCd => _compCd;
  get compNm => _compNm;
  get receivedDate => _receivedDate;

// 이 아래 세터 코드는 강렬한 악취를 내뿜는다.
// 이 데이터는 수정될 일이 없기 때문이다. 악취24중 추측성 일반화에 해당한다.
// 이 세터들은 삭제하면 된다.
  set msgType(msgType) {
    this._msgType = msgType;
  }
  set title(title) {
    this._title = title;
  }
  set body(body) {
    this._body = body;
  }
  set url(url) {
    this._url = url;
  }
  set userId(userId) {
    this._userId = userId;
  }
  set compCd(compCd) {
    this._compCd = compCd;
  }
  set compNm(compNm) {
    this._compNm = compNm;
  }
  set receivedDate(receivedDate) {
    this._receivedDate = receivedDate;
  }
// 앞서 얘기한 네임드 생성자를 이용한 생성
// 중첩시 map["recivedDate"]["day"]이런식으로 탐색을 미리해서 알아둬야 적용 가능하다.
  MessageModel.fromJson(Map<String, dynamic> map)
      : _msgType = map["msgType"] ?? "0",
        _title = map["title"] ?? "Default_Title_Text",
        _body = map["body"] ?? "Default_Body_Text",
        _url = map["url"] ?? map["URL"] ??  "/",
        _userId = map["userId"] ?? null,
        _compCd = map["compCd"] ?? null,
        _compNm = map["compNm"] ?? "Default_Company_Text",
        _receivedDate = map["receivedDate"] ?? DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

  toMap() {
    return {
      "msgType": this._msgType,
      "title": this._title,
      "body": this._body,
      "url": this._url,
      "userId": this._userId,
      "compCd": this._compCd,
      "compNm": this._compNm,
      "receivedDate": this._receivedDate
    };
  }

  toString() {
    return toMap().toString();
  }
}
```

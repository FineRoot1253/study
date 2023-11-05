# map, where 사용법

list

리스트가 객체이고 특정 속성만 들어있는 리스트만 뽑고 싶을때

 idList = list.map((e)⇒ e.id);

리스트 2개에서 중복 체크후 중복된 값을 제거하고 싶을때

distinctedList = list1.removeWhere((element) ⇒ list2.contains.(element));

리스트 2개에서 중복 체크후 중복된 값을 제외한 나머지를 지우고 싶을때

List3 = list1.removeWhere((element) ⇒ !(list2.contains.(element)));

활용예제

만약 list2에 값이 객체여서 특정 값만 있는 리스트로 만들고 비교하고싶다면

List3 = list1.removeWhere((element) ⇒ !(list2.map((e)⇒ e.id.toString).toList().contains.(element)));

map으로 원하는 map을 만들수 있다

이것을 다시 toList()로 만들면 원하는 값만 뽑아낸 리스트를 만들 수 있다.

where에는 무조건 bool로 반환 되는 값이 들어가야함 (조건식)

map은 특정 값, 내지는 map으로 만들어주면 된다

List<Map<String, dynamic>> resultList = userList.map((e) => {"id": [e.id](http://e.id/), "name" : [e.name](http://e.name/)}).toList();

이것도 되고

List<int> resultList = userList.map((e) => e.id).toList();

이것도 된다.

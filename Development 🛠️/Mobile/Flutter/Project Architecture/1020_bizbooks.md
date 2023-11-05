# 1020_bizbooks

[[2. Area 🔥/Development 🛠️/Mobile/Flutter/Project Architecture/1020_bizbooks/Untitled.png]]

lib 구조

controller, keyword, routes, screen등으로 디렉토리 구성

controller,

view에 해당하는 screen의 동작등을 인식해 모델에 전달하고 역으로 모델에서 받은 값을 뷰에 업데이트 시켜준다.

keyword

C언어에서 define처럼 미리 선언 초기화를 해 전역에서 사용될 변수를 저장해둔다.

routes

view의 위치를 저곳에 등록하여 사용한다.

화면의 이동에 사용된다.

screen

mvc 패턴의 v에 해당한다.

main.dart

 플러터 앱의 main에 해당한다.

아직 model이 필요한 앱이 아니라서 model은 만들어 두지 않음

웹앱 기반임으로 v를 컨트롤할 controller만 구성해둔 상태

사용된 plugins

[[2. Area 🔥/Development 🛠️/Mobile/Flutter/Project Architecture/1020_bizbooks/Untitled 1.png]]

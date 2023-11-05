# deb_hjg.md

**# 21년도**

**## 6월 10일 작업내용**

- SNS 업로드 테스트 페이지 제작 완료

**## 6월 16일 작업내용**

- CountryPicker기능 추가

- map_coloring + CountryPicker 연동 완료

...

**## 8월 9일 작업내용**

**### locale 마무리 작업 및 버그 수정**

- main.dart :: WithHotel쪽 생략된 Tutorial 컨트롤 관련 바인딩 추가

- hotel_booking_view.dart :: 에러 포인트 수정 및 영어 locale 작업 완료

- hotel_booking_controller.dart :: 다이얼로그 버그 및 영어 locale 작업 완료

- image_brick_page_widget :: 사진 4장 이상일때만 스크롤 되도록 수정

- en.json & ko.json :: 누락된 단어 및 영어 locale 작업 완료

**## 8월 10일 작업내용**

**### place 뷰 앱바 그라데이션 추가 및 사진 배열 수정**

- place_view.dart 좋아요시 하트 색상 변경 및 그라데이션 추가 & 메인 사진리스트 배열 변경

- place_viewmodel.dart 기존 오퍼시티계산 메서드 역함수로 작동하는 메서드 추가

- common_utils.dart outlinedTextStyleLight메서드 색상 파라미터 추가, shadowIcon 오버시티 파라미터 추가

**## 8월 20일 작업 내용**

**### 21_08_20 sns 업로드 기능 구현및 플레이스뷰 상세 위치 변동 업데이트 PR**

- main.dart sns 업로드 기능 추가

- common_utils.dart sns 업로드기능 모드로 변환 하게끔 변수 추가

- fabtoggle_controller.dart sns업로드기능 추가

- passrport_controller.dart 호텔 모드 분기 이름 변경

- sns_controller.dart 중복 검사 기능 추가 및 ui 변경

- passport_view 호텔 모드 분기 이름 변경

- place_view.dart ui 변경

- sns_upload_view.dart Ui 변경

- disconnected_screen.dart 호텔모드 분기 이름 변경

- expandable_fap_widget.dart sns 모드 추가를 위한 Ui및 애니메이션 추가

**## 8월 20일 작업 내용**

**### 21_08_20 런모드 기능 추가 구현 버전 PR**

- main.dart 불필요 주석 제거
- fabtoggle_controller.dart 호텔 버전까지 구현되도록 수정
- expandable_fap_widget.dart 호텔 버전까지 구현되도록 수정

**## 8월 23일 작업 내용**

**### 21_08_23 sns 기능 전체 주석처리 및 플레이스 뷰 수정 버전 PR**

- sns_upload_view.dart & sns_controller.dart 수정 이후 전체 주석처리
- place_view.dart overflow 에러 수정
- main.dart null type 에러 수정 및 sns 관련 로직 주석처리
- api.dart sns 관련 로직 주석처리

**## 8월 23일 작업 내용**

**### 21_08_23 sns 업로드 기능 수정 버전 PR**

- sns_upload_view.dart & sns_controller.dart 수정 이후 전체 주석처리 제거
- main.dart showBottomSheet => showModalBottomSheet로 변경
- api.dart sns 관련 로직 주석처리 제거
- pubspec.lock & pubspec.yaml video_trimmer & flutter_ffmpeg 추가, image & flutter_image_compress 제거

**## 8월 24일 작업 내용**

**### 21_08_24 sns 업로드 : 구글맵 좌표 기능 추가 버전 PR**

- constants.dart 디폴트 좌표 추가
- sns_controller.dart 좌표 필드 추가
- comment_widget.dart 댓글 순서 역순으로 변경
- sns_map_select_view.dart sns 좌표 설정 지도 뷰 추가
- sns_upload_view.dart sns 업로드 : 구글맵 좌표 기능 추가

**## 8월 25일 작업 내용**

**### 21_08_25 기타 오류 수정버전 PR**

- main.dart SNS Upload 버튼 탭시 로그인 체크 추가
- sns_upload_view.dart 테마 변경시 색상 적용 버그 수정및 영상 미선택시 그냥 리턴 되도록 로직 변경
- sns_map_select_view.dart 좌표 설정 탭을 눌러 좌표 설정시 millisec 1500 만큼 대기후 pop하도록 변경
- place_view.dart UTB 타입임에도 불구하고 링크가 유튜브 링크가 아닐시 예외처리 추가
- sns_controller.dart 영상 미선택시 그냥 리턴 되도록 로직 변경
- common_utils.dart 유튜브 링크인지 판단하는 함수 추가

**## 9월 1일 작업 내용**

**### 21_09_01 sns 업로드 컨펌전 PR**

- main_view.dart & appbar_view.dart & fabtoggle_controller.dart & home_view.dart 기존 스케폴드키로 여는 방식은 버그가 있어 수정
- sns_controller.dart & sns_upload_view.dart 업로드후 페이지 이동 로직 추가 및 영상 편집 페이지 수정 및 WillPop버그 수정

**## 9월 2일 작업 내용**

**### 21_09_02 데이터 모델 변경 버전 PR**

- main.dart 누락된부분 재 수정
- api.dart 데이터 모델 변경에 따른 api 파라미터 추가
- common_utils.dart 토스트 메시지 호출 메서드 추가
- sns_controller.dart 사진 개수 제한 및 데이터 모델 변경에 따른 파라미터 변경
- passport_view.dart memImg가 널일 경우 배제 하도록 로직 변경
- sns_upload_view.dart 컨텐츠 개수 제한 추가 및 불필요 로직 주석처리
- toast_message.dart 사진 개수 초과 경고 메시지를 위한 토스트 위젯 추가

**## 9월 3일 작업 내용**

**### 21_09_03 sns 업로드 기능 패키지 교체 버전 PR**

- main.dart 액션 로거 추가
- sns_controller.dart wechat_picker로 기존 로직 교체
- mypost_page.dart 불필요 로직 주석 처리
- sns_map_select_view.dart 불필요 파일 삭제
- sns_upload_view.dart 오버레이 엔트리 위치 조정 및 액션 로거 추가 및 로직 교체

**## 9월 6일 작업 내용**

**### 21_09_06 액션로거 누락된 부분 새로 추가 버전 PR**

- api.dart 인터셉터 onRequest 콜백에 액션로거 추가
- place_view.dart 누락된 액셜로거 추가 및 불필요 부분 제거
- sns_upload_view.dart  불필요 주석 제거 및 썸네일 퀄리티 0 -> 15 변경
- spot_list.dart 누락된 액셜로거 추가

**### 21_09_06  업로드 메서드 한번만 돌게끔 처리 및 locale처리 준비 버전 PR**

- en.json & ko.json sns_upload_view 쪽 추가
- api.dart 프로그래스 콜백 처리 제거
- sns_controller.dart 업로드 메서드 한번만 돌게끔 처리
- sns_upload_view.dart 업로드 메서드 한번만 돌게끔 처리 및 locale처리 준비

**## 9월 7일 작업 내용**

**### 21_09_07 sns 업로드 뷰 위젯 분할 처리 버전 PR**

**## 9월 8일 작업 내용**

**### 21_09_08 신규 메뉴 social place 추가 버전 PR**

- en.json & ko.json 신규 메뉴명 추가
- main.dart 신규 메뉴 추가
- fabtoggle_controller.dart 기본 리스트를 allDestination으로 변경
- passport_controller.dart 내부 post_controller, sns_controller.dart 로 이동
- passport_view.dart PostController -> SNSController로 변경
- sns_main_view.dart 신규 메뉴 뷰 추가
- sns_upload_view.dart & sns_video_editing_view.dart SNSController -> SNSuploadController로 변경
- coach_mark.dart allDestinations.length 길이로 keys 초기화하게끔 변경
- post_page.dart mypost_page -> post_page로 변경 및 신규 메뉴와 마이 패스포트에 혼용 하도록 수정

**## 9월 10일 작업 내용**

**### 21_09_10  플러그인 버전 변경 PR**

- mapcoloring_view.dart & mapcoloring_controller.dart 삭제
- api.dart 카카오 인증쪽 await 추가
- map_cluster.dart 버그 수정
- passport_view.dart 리빌드 버그 수정
- drawer.dart import 수정
- 나머지 불필요한 print 제거

**## 9월 13일 작업 내용**

**### 21_09_13 각종 버그 수정 버전 PR**

- en.json & ko.json sns_main_view 서브타이틀 추가
- sns_controller.dart 메인 로직 버그 수정
- hotel_list_view.dart 바텀바가 리스트를 가리는 버그 수정
- sns_main.view.dart 서브타이틀 locale 작업 적용
- sns_upload_view.dart 버그 수정

**## 9월 14일 작업내용**

**### 21_09_14 새 api 교체 버전 PR**

- en.json 번역 완료
- main.dart & city_guide_view.dart & hashtag_view.dart & hotel_booking_view & hotel_list_view.dart & passport_view 빠진 옵션 추가
- sns_controller.dart 널 처리 및 새 api 적용
- post_page.dart 널 에러처리
- sns_main_view.dart 새api 및 RefreshIndicator 적용

**## 9월 15일 작업내용**

**### 21_09_15 번역 처리 및 메뉴 일부 수정 버전 PR**

- en.json & ko.json social 수정 완료
- g9bon-square.svg 소셜 메뉴 아이콘 추가
- ...app/build.gradle & api.dart & pubspec.yaml & pubspec.lock 카카오 패키지 업데이트 적용
- main.dart & fabtoggle_controller.dart 소셜 메뉴 아이콘 적용 및 순서 변경 (2 ↔  3)
- place_view.dart 탭바 인디케이터 색상 지구본 메인 컬러 적용
- ...viewmodel/sns_controller.dart 이미 sns 쪽으로 파일 이동을 했으나 예전 제거리스트에서 누락되어 이번에 제대로 제거

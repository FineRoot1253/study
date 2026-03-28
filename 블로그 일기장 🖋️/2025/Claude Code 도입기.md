# Claude Code 도입하기


<br><br><br>

## 프론트를 Claude Code로 자동화

&emsp;&emsp;

- 개요
	- 도입 이유
	- 계획
	- 기존 프로젝트에 Claude Code 구성하기
	- Claude Code를 이용한 구현 방법


<br><br><br>

## 도입 이유

&emsp;&emsp;

- 설명
	- 히스토리
		- Lit-Tok 개발 당시 당장 운영 페이지를 구성해야할 기능들이 많았지만 개발을 안하고 넘어간 것들이 너무 많았다. 이 당장 필요한 기능들을 구성해서 도입해야만 했다.

<br><br><br>

## 계획

&emsp;&emsp;

- 설명
	- 미 개발 기능들
		- 역할 관리
			- 역할 목록 조회
				- 아이템 구성
					- 체크 박스
					- 역할 이름
			- 역할 수정
			- 역할 추가
		- API 자원 관리
			-  API 자원 목록 조회
				- 아이템 구성
					- 체크박스
					- API 명
					- API 설명
					- API 경로
					- 허용된 HTTP
					- API 타입
						- ANT
						- URL
					- 할당된 역할 목록 (누르면 더보기로 열려서 볼 수 있는 형식)
			- API 자원 수정
				- 데이터 수정
				- 허용 역할 추가, 변경 및 삭제
			- API 자원 추가
			- API 자원 일괄 추가
				- CSV 일괄 등록
		- 전시 데이터
			- 목록 조회
				- 아이템 구성
					- 체크 박스
					- 전시 명
					- API 경로
					- 전시 상태
			- 전시 데이터 수정
				- 전시 데이터 순서 재배치
				- 전시 데이터 비공개 처리 및 삭제 처리
			- 전시 데이터 일괄 수정
				- 전시 데이터 비공개 처리 및 삭제 처리
			- 전시 데이터 추가
			- 전시 데이터 일괄 추가
				- CSV 일괄 등록
		- 사용자 정보 관리
			- 사용자 상세 페이지 조회
				- 구성
					- 프로필 사진
					- 닉네임
					- 아이디
					- 이메일
					- 상태
					- 변경 이력
			- 사용자 정보 목록 조회
				- 아이템 구성
					- 체크 박스
					- 사용자
					- 신고 횟수
					- 사용자 상태
			- 사용자 정보 수정
				- 데이터 수정
				- 권한 변경
				- 차단, 숨김, 탈퇴, 복원
			- 사용자 일괄 수정
				- 권한 변경
				- 차단, 숨김, 탈퇴, 복원
			- 사용자 추가
			- 사용자 일괄 추가
				- CSV 일괄 등록
		- 신고 관리
			- 신고 상세 페이지
				- 구성
					- 신고자 프로필
					- 피신고자 프로필
					- 신고 사유
					- 신고 상태
					- 신고 처리 이력
			- 신고 접수 대시보드 
				- 대시 보드 구성
					- 미처리 신고 수량
					- 처리중 신고 수량
					- 완료 신고 수량
				- 신고 유형별 종류
					- 유저 신고 수량
					- 리뷰 신고 수량
					- 댓글 신고 수량
				- 신고자 유형별 종류
					- 신고자 수량
					- 피 신고자 수량
			- 신고 내역 조회
				- 필터 구성
					- 관계 필터
						- 신고자별 조회
						- 피신고자별 조회
					- 신고 필터 (신고 타겟은 유저, 리뷰, 댓글이 존재함)
						- 유저별 조회
						- 리뷰별 조회
						- 댓글별 조회
				- 아이템 구성 (자세한 신고 사유는 누르면 더보기 로 열려서 확인하는 형식)
					- 체크 박스
					- 사용자
					- 피사용자
					- 신고 횟수
					- 신고 사유 항목
					- 사용자 상태
			- 사용자 누적 신고 자동 차단 조절
			- 사용자 일괄 차단
		- 리뷰 정보 관리
			- 리뷰 상세페이지
				- 구성
					- 도서 프로필
					- 사용자 프로필
					- 리뷰 변경 이력
			- 리뷰 목록 조회
				- 아이템 구성 (리뷰 내용은 누르면 상세 페이지가 열려서 확인하는 형식)
					- 체크박스
					- 도서 제목
					- 도서 커버 사진
					- 평점 점수
					- 리뷰 상태
			- 리뷰 수정
				- 데이터 수정
				- 숨김 / 복원
			- 리뷰 일괄 수정
				- 리뷰 태그 일괄 삭제
				- 숨김 / 복원
			- 리뷰 추가
			- 리뷰 일괄 추가
				- csv 일괄 등록
		- 리뷰 댓글 정보 관리
			- 댓글 상세 페이지
				- 구성
					- 리뷰 프로필
					- 사용자 프로필
					- 댓글 내용
					- 댓글 변경 이력
			- 댓글 목록 조회
				- 아이템 구성
					- 체크 박스
					- 사용자 닉네임
					- 사용자 ID
					- 사용자 프로필 사진
					- 리뷰 ID
					- 댓글 내용
			- 댓글 수정
			- 댓글 일괄 등록
				- csv 일괄 등록
		- 사용자 차단 관리
			- 사용자 차단 상세 페이지
				- 아이템 구성
					- 차단 사용자 프로필
					- 차단 피사용자 프로필
					- 사용자 차단 이력
			- 사용자 차단 목록 조회
				- 아이템 구성
					- 체크박스
					- 사용자
					- 피사용자
					- 차단 상태
			- 사용자 차단 해제
			- 사용자 차단 추가
			- 사용자 차단 일괄 추가
				- csv 일괄 등록
			- 사용자 차단 일괄 해제
		- 팔로워쉽 관리
			- 팔로워쉽 상세 페이지
				- 구성
					- 팔로우 사용자 프로필
					- 팔로잉 사용자 프로필
					- 맞팔로우 여부
					- 팔로우 팔로잉 이력
			- 팔로워쉽 목록 조회
				- 아이템 구성
					- 체크박스
					- 팔로우 사용자 닉네임
					- 팔로우 사용자 Id
					- 팔로잉 사용자 닉네임
					- 팔로잉 사용자 Id
					- 팔로워쉽 상태
			- 팔로워쉽 수정
				- 팔로워쉽 변경
					- 팔로우 사용자 변경
					- 팔로잉 사용자 변경
				- 팔로워쉽 해제
			- 팔로워쉽 추가
			- 팔로워쉽 일괄 추가
				- csv 일괄 등록
	- 처리 우선 순위
		1. 역할 관리
		2. API 자원 관리
		3. 전시 데이터 관리
		4. 리뷰 정보 관리
		5. 리뷰 댓글 정보 관리
		6. 사용자 정보 관리
		7. 사용자 차단 정보 관리
		8. 팔로우쉽 정보 관리

<br><br><br>

## 기존 프로젝트에 Claude Code 구성하기

&emsp;&emsp;

- 설명
	- 필요 도구 목록
		- `ccusage`
			- 목적
				- 토큰 사용량 추적
			- 자주 쓰는 명령어
				- `npx ccusage@latest`
					- 설명
						- 사용량 조회
		- `claude-code`
			- 목적
				- LLM을 이용한 구현 자동화
		- `serena`
			- 목적
				- 구현시 모델에 전달할 코드를 검색하여 토큰 소모량 최적화
	- 구성 시나리오
		1. `pnpm`을 설치해 기존 프로젝트의 패키지부터 정리한다. 현재 모노레포를 고수해야 하는데 이 방식이 가장 깔끔하며 이래야 각자의 패키지에서 개발하여 토큰 낭비도 적을 것으로 보인다.
		2. CLAUDE.md 파일을 구성하기 위해 기존 프로젝트의 구조, 아키텍쳐, 탬플릿, 컨벤션, 함수 규칙, 코드 품질 기준, 주석 작성 기준을 세운다.

&emsp;&emsp;

### 구성 방법

&emsp;&emsp;


#### 프로젝트 구조 문서화

&emsp;&emsp;

##### 기본 문서 구조

&emsp;&emsp;

``` markdown
# CLAUDE.md

## 프로젝트 구조

### 디렉토리 구조
```

&emsp;&emsp;

```
### 주요 파일 위치
- 환경 설정: `.env`, `.env.example`
- API 엔드포인트: `src/services/api.ts`
- 라우팅 설정: `src/routes/index.tsx`
- 전역 스타일: `src/styles/global.css`

### 파일 명명 규칙
- 컴포넌트: PascalCase (예: UserProfile.tsx)
- 유틸리티: camelCase (예: formatDate.ts)
- 상수: UPPER_SNAKE_CASE (예: API_ENDPOINTS.ts)
- 스타일: kebab-case (예: user-profile.module.css)
```

&emsp;&emsp;

##### 아키텍쳐 문서 구조

&emsp;&emsp;

````
## 아키텍처 패턴

### 상태 관리
- Redux Toolkit 사용
- 각 기능별로 slice 파일 생성
- RTK Query로 API 상태 관리

### 컴포넌트 구조
```typescript
// 모든 컴포넌트는 다음 구조를 따름
interface ComponentProps {
  // props 정의
}

export const ComponentName: React.FC<ComponentProps> = (props) => {
  // 훅은 최상단에
  // 로직
  // JSX 반환
}
````

&emsp;&emsp;

#### 코딩 스타일 문서화

&emsp;&emsp;

##### 언어별 예시 (언어별로 정리해야한다)

&emsp;&emsp;

````
## 코딩 스타일

### TypeScript/JavaScript
- 함수명: camelCase
- 컴포넌트명: PascalCase  
- 상수: UPPER_SNAKE_CASE
- 파일명: kebab-case.ts

### 명명 규칙 예시
```typescript
// 좋은 예
const getUserData = async (userId: string) => { }
const MAX_RETRY_COUNT = 3;
export const UserProfile: React.FC = () => { }

// 피해야 할 예
const get_user_data = async (userid) => { }
const maxretrycount = 3;
export const userprofile = () => { }
```

### Import 순서
1. Vue 관련
	1. Vue, useState, useEffect
2. 외부 라이브러리
	1. axios, lodash, moment
3. 내부 모듈
	1. @/common, @/layout
4. 상대 경로 import
	1. ../components, ./utils
5. 스타일 파일
	1. CSS, SCSS 파일

#### Import 순서 예시

```typescript
import Vue, { ref,  onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { userInfo } from '@/main/api/user'

import {ADMIN_END_POINTS, BASE_URL, END_POINTS} from "@/common/config/Endpoints";

import { Button } from '../components';
import './styles.css';
```
````

&emsp;&emsp;

#### 코드 품질 기준

&emsp;&emsp;

````
## 코드 품질 기준

### 함수 작성 규칙
- 한 가지 일만 수행
- 함수 길이 50줄 이하
- 매개변수 3개 이하
````

&emsp;&emsp;

#### 함수 작성 규칙

&emsp;&emsp;

##### 에러 처리

&emsp;&emsp;

```
// 모든 비동기 함수는 try-catch 사용
try {
  const data = await fetchData();
  return { success: true, data };
} catch (error) {
  console.error('Error fetching data:', error);
  return { success: false, error: error.message };
}
```

&emsp;&emsp;

##### 주석 작성

&emsp;&emsp;

```
/**
 * 사용자 인증 토큰을 검증합니다.
 * @param token - JWT 토큰
 * @returns 토큰이 유효한지 여부
 */
const validateToken = (token: string): boolean => {
  return jwt.verify(token, SECRET_KEY);
}
```


&emsp;&emsp;

#### 개발 환경 문서화

&emsp;&emsp;

##### 개발 환경 설정 명시하기

&emsp;&emsp;

##### 코드 생성 템플릿

- Live Template 또는 정의해둔 탬플릿 라이브러리 사용하기

&emsp;&emsp;

#### 최적화 방법

&emsp;&emsp;

##### 중요도 선정

&emsp;&emsp;

```
# CLAUDE.md

## 🚨 중요 규칙 (항상 준수)
- 절대 main 브랜치에 직접 푸시 금지
- 모든 API 키는 환경 변수로
- 테스트 없는 코드 커밋 금지

## 📋 일반 가이드라인
- 가능하면 함수형 프로그래밍
- 주석은 최소화, 코드로 설명

## 💡 권장사항
- 새로운 라이브러리 도입 전 팀 논의
- 성능 최적화는 측정 후 진행 
```
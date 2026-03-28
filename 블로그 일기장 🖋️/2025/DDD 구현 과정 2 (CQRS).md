# DDD 구현 과정

<br><br><br>

## CQRS

&emsp;&emsp;

- 개요
	- CQRS란
	- 도입하려는 이유
	- CQRS 도입 여정

<br><br><br>

## CQRS란

&emsp;&emsp;

- 설명
	- 정의
		- 데이터 저장소에 대한 읽기 및 쓰기 작업을 별도의 데이터 모델로 분리하는 디자인 패턴
	- 특징
		- 코드베이스가 2배로 늘게되어 혼자 개발할때는 쓸게 못된다.


<br><br><br>

## 도입하려는 이유

&emsp;&emsp;

- 설명
	1. 도메인을 도메인 답게, 특히 애그리거트를 의미있게 만들려면 기존 다른 레이어드 패턴에서 나온 것대로 구현하는 것이 불가능하다.
		1. 쉽게 이야기하면 댓글의 경우, 리뷰에 의존적인 존재이며, 리뷰는 존재해도 댓글는 리뷰 없이 존재해서는 안된다. 이런 구조에서 댓글와 리뷰는 다른 애그리거트이긴 하다. 리뷰는 댓글 없이 존재할 수 있기 때문.

-- Main Entity Tables  
ALTER TABLE `user_tb` ALTER COLUMN user_id SET DEFAULT NEXT VALUE FOR `user_seq`;  
ALTER TABLE `book_tb` ALTER COLUMN book_id SET DEFAULT NEXT VALUE FOR `book_seq`;  
ALTER TABLE `review_tb` ALTER COLUMN review_id SET DEFAULT NEXT VALUE FOR `review_seq`;  
ALTER TABLE `tag_tb` ALTER COLUMN tag_id SET DEFAULT NEXT VALUE FOR `tag_seq`;  
ALTER TABLE `rating_tb` ALTER COLUMN rating_id SET DEFAULT NEXT VALUE FOR `rating_seq`;  
ALTER TABLE `comment_tb` ALTER COLUMN comment_id SET DEFAULT NEXT VALUE FOR `comment_seq`;  
ALTER TABLE `author_tb` ALTER COLUMN author_id SET DEFAULT NEXT VALUE FOR `author_seq`;  
ALTER TABLE `series_tb` ALTER COLUMN series_id SET DEFAULT NEXT VALUE FOR `series_seq`;  
ALTER TABLE `genre_tb` ALTER COLUMN genre_id SET DEFAULT NEXT VALUE FOR `genre_seq`;  
ALTER TABLE `subject_tb` ALTER COLUMN subject_id SET DEFAULT NEXT VALUE FOR `subject_seq`;  
ALTER TABLE `role_tb` ALTER COLUMN role_id SET DEFAULT NEXT VALUE FOR `role_seq`;  
ALTER TABLE `resource_tb` ALTER COLUMN resource_id SET DEFAULT NEXT VALUE FOR `resource_seq`;  
ALTER TABLE `account_tb` ALTER COLUMN account_id SET DEFAULT NEXT VALUE FOR `account_seq`;  
ALTER TABLE `followership_tb` ALTER COLUMN followership_id SET DEFAULT NEXT VALUE FOR `followership_seq`;  
  
-- Relationship/Junction Tables  
ALTER TABLE `review_tag_tb` ALTER COLUMN review_tag_id SET DEFAULT NEXT VALUE FOR `review_tag_seq`;  
ALTER TABLE `book_genre_tb` ALTER COLUMN genre_id SET DEFAULT NEXT VALUE FOR `book_genre_seq`;  
ALTER TABLE `book_subject_tb` ALTER COLUMN subject_id SET DEFAULT NEXT VALUE FOR `book_subject_seq`;  
ALTER TABLE `work_tb` ALTER COLUMN work_id SET DEFAULT NEXT VALUE FOR `writing_seq`;  
ALTER TABLE `user_manage_tb` ALTER COLUMN user_manage_id SET DEFAULT NEXT VALUE FOR `user_manage_seq`;  
ALTER TABLE `resource_manage_tb` ALTER COLUMN resource_manage_id SET DEFAULT NEXT VALUE FOR `resource_manage_seq`;  
ALTER TABLE `monthly_best_tb` ALTER COLUMN mothly_best_id SET DEFAULT NEXT VALUE FOR `monthly_best_seq`;  
ALTER TABLE `weekly_best_tb` ALTER COLUMN weekly_best_id SET DEFAULT NEXT VALUE FOR `weekly_best_seq`;  
ALTER TABLE `book_status_tb` ALTER COLUMN book_status_id SET DEFAULT NEXT VALUE FOR `book_status_seq`;  
  
-- Like/Interaction Tables  
ALTER TABLE `review_like_tb` ALTER COLUMN review_like_id SET DEFAULT NEXT VALUE FOR `review_like_seq`;  
ALTER TABLE `comment_like_tb` ALTER COLUMN comment_like_id SET DEFAULT NEXT VALUE FOR `comment_like_seq`;  
  
-- Content/Password Tables  
ALTER TABLE `review_content_tb` ALTER COLUMN review_content_id SET DEFAULT NEXT VALUE FOR `review_content_seq`;  
ALTER TABLE `account_password_tb` ALTER COLUMN account_password_id SET DEFAULT NEXT VALUE FOR `account_password_seq`;  
  
-- Token Tables  
ALTER TABLE `refresh_token_tb` ALTER COLUMN refresh_token_id SET DEFAULT NEXT VALUE FOR `refresh_token_seq`;  
ALTER TABLE `access_token_black_list_tb` ALTER COLUMN access_token_black_list_id SET DEFAULT NEXT VALUE FOR `access_token_black_list_seq`;  
ALTER TABLE `verify_token_tb` ALTER COLUMN verify_token_id SET DEFAULT NEXT VALUE FOR `verify_token_seq`;  
  
-- Log Tables  
ALTER TABLE `user_log_tb` ALTER COLUMN user_log_id SET DEFAULT NEXT VALUE FOR `user_log_seq`;  
ALTER TABLE `book_log_tb` ALTER COLUMN book_log_id SET DEFAULT NEXT VALUE FOR `book_log_seq`;  
ALTER TABLE `author_log_tb` ALTER COLUMN author_log_id SET DEFAULT NEXT VALUE FOR `author_log_seq`;  
ALTER TABLE `rating_log_tb` ALTER COLUMN rating_log_id SET DEFAULT NEXT VALUE FOR `rating_log_seq`;  
ALTER TABLE `comment_log_tb` ALTER COLUMN comment_log_id SET DEFAULT NEXT VALUE FOR `comment_log_seq`;  
ALTER TABLE `review_like_log_tb` ALTER COLUMN review_like_log_id SET DEFAULT NEXT VALUE FOR `review_like_log_seq`;  
ALTER TABLE `comment_like_log_tb` ALTER COLUMN comment_like_log_id SET DEFAULT NEXT VALUE FOR `comment_like_log_seq`;  
ALTER TABLE `followership_log_tb` ALTER COLUMN followership_log_id SET DEFAULT NEXT VALUE FOR `followership_log_seq`;  
ALTER TABLE `work_log_tb` ALTER COLUMN work_log_id SET DEFAULT NEXT VALUE FOR `work_log_seq`;
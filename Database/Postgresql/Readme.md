# Postgresql

## Documentations

[](https://www.postgresql.org/files/documentation/pdf/14/postgresql-14-A4.pdf)

2000페이지가 넘는 분량이다. 핵심 키워드를 중심으로 정리할 필요가 있다.

## Articles

- WAL파일 [Log Tailing을 위한...]

    [https://www.google.com/search?q=postgres+wal+to+kafka&rlz=1C5CHFA_enKR956KR956&biw=2560&bih=912&sxsrf=APq-WBs5saE19-GyJqMkgwyrJZhBi8_TXg%3A1644307755578&ei=KyUCYv7nIujh2roP0de30Ao&oq=postgres+wal+to&gs_lcp=Cgdnd3Mtd2l6EAMYATIFCAAQgAQyBQgAEIAEMgYIABAWEB4yBggAEBYQHjIGCAAQFhAeOgcIIxCwAxAnOgcIABBHELADOgcIIxDqAhAnOgQIIxAnOgQIABBDOgUIABCRAjoFCAAQywE6BwgjELECECc6BAgAEAo6CggAEIAEEIcCEBRKBAhBGABKBAhGGABQnRJYkVVgjGJoA3AAeACAAY0BiAGdDpIBBDAuMTaYAQCgAQGwAQrIAQnAAQE&sclient=gws-wiz](https://www.google.com/search?q=postgres+wal+to+kafka&rlz=1C5CHFA_enKR956KR956&biw=2560&bih=912&sxsrf=APq-WBs5saE19-GyJqMkgwyrJZhBi8_TXg%3A1644307755578&ei=KyUCYv7nIujh2roP0de30Ao&oq=postgres+wal+to&gs_lcp=Cgdnd3Mtd2l6EAMYATIFCAAQgAQyBQgAEIAEMgYIABAWEB4yBggAEBYQHjIGCAAQFhAeOgcIIxCwAxAnOgcIABBHELADOgcIIxDqAhAnOgQIIxAnOgQIABBDOgUIABCRAjoFCAAQywE6BwgjELECECc6BAgAEAo6CggAEIAEEIcCEBRKBAhBGABKBAhGGABQnRJYkVVgjGJoA3AAeACAAY0BiAGdDpIBBDAuMTaYAQCgAQGwAQrIAQnAAQE&sclient=gws-wiz)


- Isolation Level

    [트랜잭션 격리](https://www.postgresql.kr/docs/9.4/transaction-iso.html)

- phantom read

    [트랜잭션 격리 이야기에서 팬텀 읽기 현상](https://postgresql.kr/blog/pg_phantom_read.html)


## Projects

- **go-talk**

    sql

    [dump-postgres-202112031414](Postgresql%204c884eeb43734a5b92a388990c123742/dump-postgres-202112031414.txt)

    [dump-postgres-202112031414.zip](Postgresql%204c884eeb43734a5b92a388990c123742/dump-postgres-202112031414.zip)


# MVCC

타임스탬프를 활용해 각 개체의 여러버전을 유지 하는 기술

- 특징
    - 2PL과 OCC와 달리 Read가 절때 거부되지 않는다.
    - “*Read는 Write를 막지 않고 Write는 Read를 막지 않는다”*는 개념으로 시작되었다.
    - 가비지 컬렉션이 필요하다. [PostgreSQL의 Vacuum 데몬 등등]
    - 모든 트랜잭션은 Read와 Write로 분할된다.

        ⇒ 모든 Read 하나의 스냅샷 처럼 실행되며 모든 Write는 Read 이후에 하나의 스냅샷 처럼 실행된다.

    - DBMS별로 구현한 방식이 조금씩 다르다.

## Timestamps

모든 개체 버전 OV에는 Read 및 Write TS가 있다.

- ReadTS

    Ov를 읽는 tx의 가장 큰 타임스탬프

- WriteTS

    Ov를 쓴 tx의 가장 큰 타임스탬프


## Postgesql MVCC/SSI

[[PostgreSQL MVCC SSI/Readme]]

# MVCC

<aside>
🕶️ *다중 버전 병행 수행 제어의 약자로 DBMS에서는 읽기 세션은 언제나 중복해서 읽을 수 있고 쓰기 세션과 블로킹 되지 않게 **각 세션당 스냅샷 이미지**를 보장해주는 메커니즘이다.*

</aside>

# MGA 방식

- 대표적인 DBMS
    - PostgreSQL
    - InnoDB (Rollback Segment와 중간의 성격을 띈다)

    ## PostgreSQL MVCC/SSI

    [[PostgreSQL MVCC SSI/Readme]]


# Rollback Segment 방식

- 대표적인 DBMS
    - OracleDBMS
    - InnoDB (MGA와 중간의 성격을 띈다)

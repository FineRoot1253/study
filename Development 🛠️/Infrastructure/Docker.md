# Docker

- 이미지 빌드
    - 멀티플랫폼 생성

        `docker buildx create --name multiarch-builder --use`

    - nodejs

        `docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag gjhong1129/examples:local_commute_resource_backend_v0.0.1 .`

    - haproxy

        `docker buildx build --platform linux/arm64/v8,linux/amd64 -t gjhong1129/examples:chat_server_haproxy_amd64_v0.0.35 --push ../haproxy-amqp-dockfile/`

- Network
    1. docker network create chat_server_network
- DB
    1. 실행

        docker run -d --name chat_server_db_dev_v2 -v $(pwd)/volume/graphgresql/data:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_PASSWORD=reindeer2021 -e POSTGRES_DB=postgres --network chat_server_network gjhong1129/examples:chat_server_db_0.0.1_5v_dev

- Golang
    1. 실행

        docker run -it -p 80:80 -p 443:443 -p 50000:50000 --name golang_exp --network chat_server_network -e CHAT_SERVER_DB_PWD=reindeer2021 gjhong1129/examples:golang_exp_0.0.1_6v_dev bash


- rabbitMQ
    1. 이미지 설치

        docker pull rabbitmq:3-management

    2. 실행

        docker run --restart always -v rabbit_test_vol:/var/lib/rabbitmq/ -p 5672:5672 -p 15672:15672 -p 1883:1883 -p 8883:8883 -p 1884:1884 -p 8884:8884 --hostname rmq_dev --name rabbitmq3m gjhong1129/examples:rabbitmq3m_dev_0.0.3v

        - 다음 설치시 rabbitmq:3-management 말고 이미지 이름 넣기
            - ex : gjhong1129/examples:rabbitmq3m_dev_0.0.3v
- 뭔가 설정 파일을 설정 해줘야하는데 최소 설치라 vi같은 에디터가 없을 경우
    1. 로컬 → 도커 컨테이너 파일 복사하기

        docker cp

        ```
        $ docker cp CONTAINER:FILEPATH LOCALFILEPATH
        $ vi LOCALFILEPATH
        $ docker cp LOCALFILEPATH CONTAINER:FILEPATH
        ```

    2. 사실 그냥 도커파일로 처리하면 편하다.[오피셜 doc에서도 추천한다]

        ```docker
        FROM gjhong1129/examples:rabbitmq3m_dev_0.0.4v

        RUN rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_web_mqtt

        COPY ./cert/ /etc/rabbitmq/cert
        RUN chown -R rabbitmq:rabbitmq /etc/rabbitmq/cert
        COPY ./rabbitmq.conf /etc/rabbitmq
        ```


    > [[httpswww.notion.sogjhong1129RabbitMQ-3e9d21ace1ce42ceb44ab320e1ceb70a]]
    >

    tls 예제이다.

- Redis

    ```jsx
    docker run -v redis_test_vol:/data --name chat_server_redis_dev -d -p 6379:6379 redis redis-server --save 60 1 --loglevel warning
    ```


컨테이너 전체 삭제

$ docker rm $(docker ps -a -q)

이미지 전체 삭제

$ docker rmi $(docker images -q)

오라클 데이터베이스 접속

docker exec -it [컨테이너 ID] bash

sqlplus / as ****sysdba

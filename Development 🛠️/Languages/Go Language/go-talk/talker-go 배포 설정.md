# talker-go 배포 설정

## POSTGRESQL&REDIS

- 빌드 과정
    1. 도커파일 생성

        ```docker
        FROM postgres:latest
        # init.sql은 덤프 떠둔 개발 완료한 디비이다.
        # 도커파일 빌드 전에 create schama public 이거 주석처리 안하면 진행이 되지 않는다.!!!!
        COPY ./init_dump/init.sql /docker-entrypoint-initdb.d/
        ### 주의! 깜박하고 볼륨 삭제 안하면 초기화 단계 무시해버림!!!
        ```

    2. 이미지 생성

        ```bash
        docker build -t gjhong1129/examples:chat_server_db_v0.0.5 ./postgresql-dockfile/
        ```

    3. .env 설정

        원래 있던 .env에 추가해줄것

        ```bash
        RABBITMQ_ERLANG_COOKIE=raindeer2017!
        POSTGRES_USER=postgres
        POSTGRES_PWD=reindeer2021
        POSTGRES_DB=postgres
        POSTGRES_PORT=24000
        REDIS_PORT=25000
        CHAT_SERVER_PORT=50000
        HAPOXY_PORT=1936
        RABBITMQ_DEFAULT_PASS=reindeer2017!
        RABBITMQ_DEFAULT_USER=g9bon
        RABBITMQ_DEFAULT_VHOST=chat
        RABBITMQ_SSL_CERTFILE=/cert_rabbitmq/testca/cacert.pem
        RABBITMQ_SSL_KEYFILE=/cert_rabbitmq/server/cert.pem
        RABBITMQ_SSL_CACERTFILE=/cert_rabbitmq/server/key.pem
        ```

    4. docker-compose.yaml 생성

        ```yaml
        version: "3" ## ## <- 이표식은 다른 도커와 함께 배포시 생략해줘요 하는 표시
        services: ##
            db: ##
                image: gjhong1129/examples:chat_server_db_v0.0.5
                container_name: chat_server_db_v0.0.7
                restart: always
                ports:
                    - "54321:5432"
                environment:
                    POSTGRES_PASSWORD: "${POSTGRES_PWD}"
                    POSTGRES_DB: "${POSTGRES_DB}"
                volumes:
                    - ./volume/graphgresql/data/:/var/lib/postgresql/data
        ### 주의! 깜박하고 볼륨 삭제 안하면 초기화 단계 무시해버림!!!
        		k-v_db:
                image: redis:latest
                container_name: chat_server_redis_v0.0.1
                restart: always
                ports:
                 - 25000:6379
                volumes:
                    - ./volume/redis/data/:/data
                command: redis-server --port 6379 --save 60 1 --loglevel warning
        ```

    5. 커맨드 입력

        ```bash
        docker-compose config

        # 이후 이렇게 진행하겠다는 결과 로그가 나옴 yaml파일에서
        # .env파일 자리에 변수가 알아서 끼워넣어준다.

        docker-compose up

        # 백그라운드로 돌리고 싶으면 -d 를 플래그로 넣어주자!

        # 하나씩 따로따로 올려줄수도있다.뒤에 k-v_db나 db 이렇게 넣어주면 된다.
        # ex: docker-compose up -d k-v_db

        mkdir volume && chmod 777 -R volume

        ## 이렇게 미리 777 옵션을 줘야 접근이 가능해서 로그파일이든 디비 디렉토리이든 저장이 가능합니다!
        ## 이렇게 안해주면 볼륨을 사용하는 모든 컨테이너에서 에러를 던지며 문을 닫습니다!!!
        ```


## 주의사항!!

- 리눅스 최초 설치시 소켓에 대해 퍼미션이 없습니다!!

    ```bash
    sudo chmod 666 /var/run/docker.sock
    ```

- **리눅스는 amd64기반입니다!!**

    **다음과 같이 크로스 컴파일로 빌드를 시켜야 리눅스 환경에서 컨테이너가 정상 작동합니다 !!!!!!**

    - 버그 예시

        [[스크린샷_2021-12-16_오후_7.39.39.png]]

        요런 버그와 함께 동작을 하지 않습니다.!!!

    - 해결 방안

        ```bash
        docker buildx build --platform linux/amd64 -t gjhong1129/examples:chat_server_amd64_v0.0.3 --push .

        docker pull gjhong1129/examples:chat_server_amd64_v0.0.3

        # inspect시 아래 예시화면 처럼 나와야합니다.
        docker inspect gjhong1129/examples:chat_server_amd64_v0.0.3
        ## 허나 저는 buildx를 통해서 크로스 컴파일의 결과를 얻진 못했습니다.
        ## 아래의 예시화면은... 별의미 없더군요
        ## 결국 qemu 애뮬을 통해 실행하는 방법으로 진행하였습니다.
        ## 제가 빼먹거나 실패한 부분이 있다면... 알려주시면 감사하겠습니다.

        ## 아래의 커맨드는 데비안 기반 리눅스에서만 사용가능합니다.
        ## 레드햇계열, centos 같은 리눅스는 사용 불가능합니다.
        sudo apt-get install qemu binfmt-support qemu-user-static # Install the qemu packages
        docker run --rm --privileged multiarch/qemu-user-static --reset -p yes # This step will execute the registering scripts
        ```

        [[스크린샷_2021-12-16_오후_7.27.34.png]]

- 제대로된 haproxy 세팅이 필요합니다.

    [[스크린샷_2021-12-20_오후_4.01.58.png]]

    이건 유저가 지정되지 않은 에러입니다.


## FINAL

```yaml
version: "3"
services:
  master_rabbitmq_node:
    image: gjhong1129/examples:rmq_amd64_v0.0.10
    container_name: master_rmq_node
    hostname: master_rmq_node
    command: rabbitmq-server
    restart: always
    platform: linux/amd64
    user: root
    networks:
      - chat_server_network
    volumes:
      - ./volume/master_rmq_node/data/:/var/lib/rabbitmq/mnesia
      - ./volume/master_rmq_node/log/:/var/log/rabbitmq/
      # - /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static
    environment:
      - RABBITMQ_ERLANG_COOKIE=${RABBITMQ_ERLANG_COOKIE}
      - RABBITMQ_DEFAULT_USER=${RABBITMQ_DEFAULT_USER}
      - RABBITMQ_DEFAULT_PASS=${RABBITMQ_DEFAULT_PASS}
    healthcheck:
      test: rabbitmq-diagnostics -q ping
      interval: 30s
      timeout: 30s
      retries: 3

  slave_rabbitmq_node_1:
    image: gjhong1129/examples:rmq_amd64_v0.0.10
    container_name: slave_rmq_node_1
    hostname: slave_rmq_node_1
    command: rabbitmq-server
    restart: always
    user: root
    platform: linux/amd64
    networks:
      - chat_server_network
    volumes:
      - ./volume/slave_rmq_node_1/data/:/var/lib/rabbitmq/mnesia
      - ./volume/slave_rmq_node_1/log/:/var/log/rabbitmq/
      # - /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static
    environment:
      - RABBITMQ_ERLANG_COOKIE=${RABBITMQ_ERLANG_COOKIE}
      - RABBITMQ_DEFAULT_USER=${RABBITMQ_DEFAULT_USER}
      - RABBITMQ_DEFAULT_PASS=${RABBITMQ_DEFAULT_PASS}
      - CLUSTERED=true
      - CLUSTER_WITH=master_rmq_node
      - RAM_NODE=false
    healthcheck:
      test: rabbitmq-diagnostics -q ping
      interval: 30s
      timeout: 30s
      retries: 3

  slave_rabbitmq_node_2:
    image: gjhong1129/examples:rmq_amd64_v0.0.10
    container_name: slave_rmq_node_2
    hostname: slave_rmq_node_2
    command: rabbitmq-server
    restart: always
    user: root
    networks:
      - chat_server_network

    platform: linux/amd64
    volumes:
      - ./volume/slave_rmq_node_2/data/:/var/lib/rabbitmq/mnesia
      - ./volume/slave_rmq_node_2/log/:/var/log/rabbitmq/
      # - /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static
    environment:
      - RABBITMQ_ERLANG_COOKIE=${RABBITMQ_ERLANG_COOKIE}
      - RABBITMQ_DEFAULT_USER=${RABBITMQ_DEFAULT_USER}
      - RABBITMQ_DEFAULT_PASS=${RABBITMQ_DEFAULT_PASS}
      - CLUSTERED=true
      - CLUSTER_WITH=master_rmq_node
      - RAM_NODE=false
    healthcheck:
      test: rabbitmq-diagnostics -q ping
      interval: 30s
      timeout: 30s
      retries: 3

  haproxy_amqp_load_balancer:
    image: gjhong1129/examples:chat_server_haproxy_amqp_amd64_v0.0.2
    container_name: haproxy_amqp_v0.0.2
    hostname: haproxy_amqp_lb
    restart: always
    platform: linux/amd64
    user: root
    # volumes:
    # - /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static
    expose:
      - "5672"
      - "27002"
    networks:
      - chat_server_network
    healthcheck:
      test: [ "CMD", "curl", "-f", "http://localhost:27002" ]
      interval: 200s
      timeout: 200s
      retries: 5
      # 도커 네트워크 : 컨테이너 네트워크
  postgresql:
    image: gjhong1129/examples:chat_server_db_amd64_v0.0.10
    container_name: chat_server_db_v0.0.14
    hostname: postgresql
    restart: always
    platform: linux/amd64
    user: root
    networks:
      - chat_server_network
    expose:
      - "26000"
    ports:
      - "33333:26000"
    environment:
      POSTGRES_USER: "${POSTGRES_USER}"
      POSTGRES_PASSWORD: "${POSTGRES_PWD}"
      POSTGRES_DB: "${POSTGRES_DB}"
    command: postgres -p 26000 -c hba_file=/etc/postgresql/pg_hba.conf -c
      config_file=/etc/postgresql/postgresql.conf
    volumes:
      - ./volume/postgresql/run:/var/run/postgresql
      - ./volume/postgresql/data/:/var/lib/postgresql/data
      # - /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static
    healthcheck:
      test: [ "CMD-SHELL", "pg_isready -U postgres" ]
      interval: 10s
      timeout: 5s
      retries: 5
    depends_on:
      - haproxy_amqp_load_balancer

  redis:
    image: redis:latest
    container_name: chat_server_redis_v0.0.2
    restart: always
    platform: linux/amd64
    user: root
    networks:
      - chat_server_network
    expose:
      - "25000"
    volumes:
      - ./volume/redis/data/:/data
      # - /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static
    command: redis-server --port 25000 --save 60 1 --loglevel warning
    healthcheck:
      test: [ "CMD", "redis-cli", "ping" ]
      interval: 1s
      timeout: 3s
      retries: 30
    depends_on:
      - haproxy_amqp_load_balancer
  chat_server:
    image: gjhong1129/examples:chat_server_amd64_v0.0.41
    container_name: chat_server_v0.0.32
    hostname: chat_server
    restart: always
    platform: linux/amd64
    # volumes:
    # - /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static
    expose:
      - "50000"
    networks:
      - chat_server_network
    depends_on:
      - postgresql
      - redis
  haproxy:
    image: gjhong1129/examples:chat_server_haproxy_amd64_v0.0.7
    container_name: haproxy_v0.0.4
    platform: linux/amd64
    user: root
    hostname: haproxy
    restart: always
    ports:
      - "80:80"
      - "443:443"
      - "8883:8883"
      - "27001:1936"
    expose:
      - "1936"
    networks:
      - chat_server_network
    depends_on:
      - chat_server

networks:
  chat_server_network:
    driver: bridge
```

# HOW TO SET TLS ON MQTT

> [https://medium.com/javarevisited/configuring-rabbitmq-mqtt-with-tls-ca1dcbc397d3](https://medium.com/javarevisited/configuring-rabbitmq-mqtt-with-tls-ca1dcbc397d3)
>
1. Set conf.files

    키생성

    ```bash
    git clone https://github.com/michaelklishin/tls-gen tls-gen
    cd tls-gen/basic
    make PASSWORD=reindeer
    make verify
    make info
    ls -l ./result
    cd result
    openssl rsa -in client_key.pem -out client_key_unencrypted.pem
    ```

    advanced.config

    ```docker
    [{rabbit,        [{tcp_listeners,    [5672]}]},
     {rabbitmq_mqtt, [{default_user,     "<MQTT-ID>"},
                      {default_pass,     "<MQTT-ID>"},
                      {allow_anonymous,  true},
                      {vhost,            "/"},
                      {exchange,         "room_exchange"},
                      {subscription_ttl, 1800000},
                      {prefetch,         10},
                      {ssl_listeners,    []},
                      %% Default MQTT with TLS port is 8883
                      {ssl_listeners,    [8883]},
                      {tcp_listeners,    [1883]},
                      {tcp_listen_options, [binary,
                                            {packet,    raw},
                                            {reuseaddr, true},
                                            {backlog,   128},
                                            {nodelay,   true}]}]}
    ].
    ```

    rabbitmq.conf

    ```erlang
    listeners.ssl.default = 5671
    mqtt.listeners.tcp.default = 1883
    mqtt.listeners.ssl.default = 8883

    web_mqtt.ssl.port       = 15676
    web_mqtt.ssl.backlog    = 1024
    web_mqtt.ssl.certfile   = /etc/rabbitmq/cert/server_certificate.pem
    web_mqtt.ssl.keyfile    = /etc/rabbitmq/cert/server_key.pem
    web_mqtt.ssl.cacertfile = /etc/rabbitmq/cert/ca_certificate.pem
    web_mqtt.ssl.password   = reindeer

    web_mqtt.ssl.honor_cipher_order   = true
    web_mqtt.ssl.honor_ecc_order      = true
    web_mqtt.ssl.client_renegotiation = false
    web_mqtt.ssl.secure_renegotiate   = true

    web_mqtt.ssl.versions.1 = tlsv1.2
    web_mqtt.ssl.versions.2 = tlsv1.1
    web_mqtt.ssl.ciphers.1 = ECDHE-ECDSA-AES256-GCM-SHA384
    web_mqtt.ssl.ciphers.2 = ECDHE-RSA-AES256-GCM-SHA384
    web_mqtt.ssl.ciphers.3 = ECDHE-ECDSA-AES256-SHA384
    web_mqtt.ssl.ciphers.4 = ECDHE-RSA-AES256-SHA384
    web_mqtt.ssl.ciphers.5 = ECDH-ECDSA-AES256-GCM-SHA384
    web_mqtt.ssl.ciphers.6 = ECDH-RSA-AES256-GCM-SHA384
    web_mqtt.ssl.ciphers.7 = ECDH-ECDSA-AES256-SHA384
    web_mqtt.ssl.ciphers.8 = ECDH-RSA-AES256-SHA384
    web_mqtt.ssl.ciphers.9 = DHE-RSA-AES256-GCM-SHA384

    management.tcp.port = 15672
    management.ssl.port       = 15671
    management.ssl.cacertfile = /etc/rabbitmq/cert/ca_certificate.pem
    management.ssl.certfile   = /etc/rabbitmq/cert/server_certificate.pem
    management.ssl.keyfile    = /etc/rabbitmq/cert/server_key.pem
    management.load_definitions = /etc/rabbitmq/definitions.json

    ssl_options.cacertfile = /etc/rabbitmq/cert/ca_certificate.pem
    ssl_options.certfile   = /etc/rabbitmq/cert/server_certificate.pem
    ssl_options.keyfile    = /etc/rabbitmq/cert/server_key.pem
    ssl_options.password   = reindeer
    ssl_options.verify     = verify_peer
    ssl_options.fail_if_no_peer_cert = true
    ssl_options.versions.1 = tlsv1.3
    ssl_options.versions.2 = tlsv1.2
    ssl_options.versions.3 = tlsv1.1

    cluster_formation.peer_discovery_backend = rabbit_peer_discovery_classic_config
    cluster_formation.classic_config.nodes.1 = rabbit@master_rmq_node
    cluster_formation.classic_config.nodes.2 = rabbit@slave_rmq_node_1
    cluster_formation.classic_config.nodes.3 = rabbit@slave_rmq_node_2
    ```

2. Set definition.json

    ```
    ha-sync-batch-size가 50000이고 큐의 메시지가 건당 1kb라면 net_ticktime이 1초로 설정되어있다면
    네트워크는 50Mb/1초 의 성능을 커버할 수 있어야 한다.

    최소 BatchSize = 네트워크 대역폭 * ticktime / 메시지당 size

    {
        "policies": [
            {
                "vhost": "/",
                "name": "ha",
                "pattern": "",
                "definition": {
                    "ha-mode": "all",
                    "ha-sync-mode": "automatic",
                    "ha-sync-batch-size": 1000
                }
            }
        ]
    }
    ```

3. Set Dockerfile

    ```docker
    FROM --platform=$BUILDPLATFORM rabbitmq:3-management

    RUN rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_web_mqtt

    COPY ./cert /etc/rabbitmq/cert
    RUN chown -R rabbitmq:rabbitmq /etc/rabbitmq/cert
    RUN chown -R rabbitmq:rabbitmq /var/log/rabbitmq
    RUN chown -R rabbitmq:rabbitmq /var/lib/rabbitmq

    COPY ./conf/rabbitmq.conf /etc/rabbitmq
    COPY ./conf/advanced.config /etc/rabbitmq
    COPY ./conf/definitions.json /etc/rabbitmq
    # amqp 5672 5671[ssl]
    # mqtt 1883 8883[ssl]
    # mqtt-web 15675 15676[ssl]
    # web-ui-admin 5672 5671[ssl]
    EXPOSE 5671 5672 15671 15672 15675 15676 1883 8883
    ```

4. Use command [build]

    ```bash
    docker build -t gjhong1129/examples:rmq_v0.0.1 ./rabbitmq-dockfile/
    docker buildx build --platform linux/amd64 -t gjhong1129/examples:rmq_v0.0.1 --push ./rabbitmq-dockfile/
    ```

5. Use Command [run]

    ```bash
    docker run --restart always -v rabbit_test_vol:/var/lib/rabbitmq/ -p 5672:5672 -p 15672:15672 -p 1883:1883 -p 8883:8883 -p 1884:1884 -p 8884:8884 --hostname rmq_dev --name rabbitmq3m gjhong1129/examples:rabbitmq3m_dev_0.0.3v
    ```

# HAPROXY

## Projects

- **go-talk**
    1. dockerfile [dockerfile]

        ```yaml
        FROM haproxy:1.9
        COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
        ```

    2. env conf [haproxy.cfg]

        ```yaml
        global
          log     127.0.0.1 alert
          log     127.0.0.1 alert debug
          maxconn 3000

        defaults
          log     global
          option  dontlognull
          option  persist
          option  redispatch
          retries 3
          timeout connect 5000
          timeout client  50000
          timeout server  50000

        listen haproxy-stats
            bind  *:1936
            mode  http
            stats enable
            stats hide-version
            stats refresh 5s
            stats uri     /haproxy?stats
            stats realm   Haproxy\ Statistics
            stats auth    haproxy:haproxy

        listen rabbitmq
            bind    *:5672
            mode    tcp
            option  tcplog
            balance roundrobin
            server  rabbitmq-node-1 rabbitmq-node-1:5672 check inter 5000 rise 3 fall 5
            server  rabbitmq-node-2 rabbitmq-node-2:5672 check inter 5000 rise 3 fall 5
            server  rabbitmq-node-3 rabbitmq-node-3:5672 check inter 5000 rise 3 fall 5

        listen rabbitmq_mqtt
            bind    *:1883
            mode    tcp
            option  tcplog
            balance roundrobin
            server  rabbitmq-node-1 rabbitmq-node-1:1883 check inter 5000 rise 3 fall 5
            server  rabbitmq-node-2 rabbitmq-node-2:1883 check inter 5000 rise 3 fall 5
            server  rabbitmq-node-3 rabbitmq-node-3:1883 check inter 5000 rise 3 fall 5

        listen rabbitmq_web_mqtt
            bind    *:15675
            mode    http
            option  tcplog
            balance roundrobin
            server  rabbitmq-node-1 rabbitmq-node-1:15675 check inter 5000 rise 3 fall 5
            server  rabbitmq-node-2 rabbitmq-node-2:15675 check inter 5000 rise 3 fall 5
            server  rabbitmq-node-3 rabbitmq-node-3:15675 check inter 5000 rise 3 fall 5
        ```

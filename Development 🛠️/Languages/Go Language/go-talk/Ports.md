# Ports

## MQTT-WEB

- **inside**

    15675,

- **master-node**

    20000

- **slave_node_1**

    20001

- **slave_node_2**

    20002


## MQTT

- **inside**

    1883,8883

- **master-node**

    21000

- **slave_node_1**

    21000

- **slave_node_2**

    21000


## WEB-ADMIN

- **inside**

    15672

- **master-node**

    22000

- **slave_node_1**

    22001

- **slave_node_2**

    22002


## AMQP

- **inside**

    5672,5671

- **master-node**

    23000

- **slave_node_1**

    23001

- **slave_node_2**

    23002


## POSTGRESQL

- **inside**

    5432 → 24000

- **inside-api-server**

    24000


## REDIS

- **inside**

    6379 → 25000

- **inside-api-server**

    25000


## HAPROXY

### HAPROXY_ADMIN

접근 433

내부 27001

### HAPROXY_AMQP_ADMIN

접근 433

내부 27002

### RMQ

- **amqp**

    23000 ~3  : 5672

- **mqtt**

    21000 ~3  : 1883

- **mqtt-web**

    20000 ~3  : 15675

# Elasticsearch

[Elasticsearch](https://www.elastic.co/products/elasticsearch) Docker image based on Alpine Linux.

### Tags

- `2, 2.3, 2.3.3, latest`

### Exposed ports

- `9200`, `9300`


### Env. variables

Variable | Description | Default value | Example
 ------- | ----------- | ------------- | -------
JAVA_HEAP_SIZE | Java heap size in MB | | 1024
java_max_direct_mem_size | Java max direct memory size | |
java_opts | Java options | |
max_fd | Max open file descriptors | | 1024

When JAVA_HEAP_SIZE is empty, the value is set depending on system max memory (256 to 10% of max memory).

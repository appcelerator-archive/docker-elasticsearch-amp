FROM appcelerator/alpine:20160726

RUN apk --no-cache add elasticsearch

ENV PATH /bin:$PATH

RUN mkdir -p /etc/elasticsearch/scripts /var/log/elasticsearch /var/lib/elasticsearch/data /var/tmp/elasticsearch

COPY config/elasticsearch.yml /etc/elasticsearch/
COPY config/logging.yml /etc/elasticsearch/
COPY /bin/docker-entrypoint.sh /bin/
COPY bin/elasticsearch /bin/

RUN chown -R elastico:elastico /var/lib/elasticsearch /etc/elasticsearch /var/log/elasticsearch /var/tmp/elasticsearch /bin/elasticsearch

VOLUME /var/lib/elasticsearch/data

HEALTHCHECK NONE

EXPOSE 9200 9300
ENV JAVA_HEAP_SIZE=256

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["elasticsearch"]

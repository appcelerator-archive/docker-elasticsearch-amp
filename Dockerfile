FROM appcelerator/amp:latest

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --no-cache add elasticsearch gosu@testing

ENV PATH /bin:$PATH

RUN mkdir -p /etc/elasticsearch/scripts /var/log/elasticsearch /var/lib/elasticsearch/data /var/tmp/elasticsearch

COPY config/elasticsearch.yml /etc/elasticsearch/
COPY config/logging.yml /etc/elasticsearch/
COPY /bin/docker-entrypoint.sh /bin/
COPY bin/elasticsearch /bin/

RUN chown -R elastico:elastico /var/lib/elasticsearch /etc/elasticsearch /var/log/elasticsearch /var/tmp/elasticsearch /bin/elasticsearch

VOLUME /var/lib/elasticsearch/data

EXPOSE 9200 9300

ENV SERVICE_NAME="elasticsearch"
ENV AMPPILOT_REGISTEREDPORT="9200"
ENV DEPENDENCIES="amp-log-agent"
ENV AMPPILOT_AMPLOGAGENT_ONLYATSTARTUP=true

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["elasticsearch"]

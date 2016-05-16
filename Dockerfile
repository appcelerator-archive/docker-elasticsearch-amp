FROM elasticsearch

USER root

# helpful while debugging, will remove in the future
RUN apt-get update && apt-get install -y vim bash

EXPOSE 9200 9300

# Add ContainerPilot
RUN curl -Lo /tmp/cb.tar.gz https://github.com/joyent/containerpilot/releases/download/2.1.0/containerpilot-2.1.0.tar.gz \
&& tar -xz -f /tmp/cb.tar.gz \
&& mv ./containerpilot /bin/ \
&& chown elasticsearch /etc
COPY containerpilot.json /etc/containerpilot.json
COPY start.sh ./start.sh


ENV CONTAINERPILOT=file:///etc/containerpilot.json

USER elasticsearch

CMD ["sh", "-c", "./start.sh"]

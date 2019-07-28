FROM alpine:3.10

RUN apk add --no-cache curl grep

ADD run.sh /opt/run.sh

CMD ["sh", "/opt/run.sh"]

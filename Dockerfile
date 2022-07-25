FROM alpine:latest

COPY ./godaddy-dyndns-loop.sh /
RUN apk update && apk add bash curl
ENTRYPOINT bash /godaddy-dyndns ${DOMAIN} ${KEY} ${SECRET}

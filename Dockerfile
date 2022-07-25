FROM alpine:latest

COPY ./godaddy-dyndns.sh /
RUN apk update && apk add bash curl
ENTRYPOINT bash /godaddy-dyndns.sh ${DOMAIN} ${KEY} ${SECRET}

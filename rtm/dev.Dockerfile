FROM golang:1.23 AS go
FROM node:22 AS node

ARG UID
ARG GID

ENV GOPATH=/go
ENV CGO_ENABLED=0
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

COPY --from=go /usr/local/go /usr/local/go
RUN mkdir -p /go
RUN chown ${UID}:${GID} /go

USER ${UID}:${GID}
RUN go install github.com/knadh/stuffbin/...@v1.3.0

WORKDIR /app
ENTRYPOINT [ "" ]

FROM golang:1.23 AS go
FROM node:22 AS node

ARG USER
ARG UID
ARG GID

ENV GOPATH=/go
ENV CGO_ENABLED=0
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN groupadd -g ${GID} -o ${USER}
RUN useradd -m -u ${UID} -g ${GID} -o -s /bin/bash ${USER}

COPY --from=go /usr/local/go /usr/local/go
RUN mkdir -p /go
RUN chown ${USER} /go

USER ${USER}
RUN go install github.com/knadh/stuffbin/...@v1.3.0

WORKDIR /app
ENTRYPOINT [ "" ]

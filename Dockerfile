FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git

WORKDIR /src

RUN git clone --branch v0.16.2 https://github.com/fiatjaf/nak.git .

RUN go mod download
RUN go mod tidy

RUN CGO_ENABLED=0 GOARCH=arm64 go build -ldflags "-s -w" -o nak .

FROM alpine:3.20

RUN apk add --no-cache jq curl

COPY --from=builder /src/nak /usr/local/bin/nak
RUN chmod +x /usr/local/bin/nak

ENTRYPOINT ["/bin/sh"]

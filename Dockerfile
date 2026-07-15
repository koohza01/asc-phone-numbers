FROM golang:1.26.2 AS builder
WORKDIR /app

COPY go.mod .
RUN go mod tidy

COPY app/ ./app/

RUN go build -o asc-phone-numbers-service ./app/Main.go

FROM debian:bookworm-slim
WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/asc-phone-numbers-service .
EXPOSE 8080
CMD ["./asc-phone-numbers-service"]
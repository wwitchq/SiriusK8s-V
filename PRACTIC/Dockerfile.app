FROM golang:1.21-alpine as builder

WORKDIR /app
COPY main.go go.mod go.sum ./
RUN go build -o app .

FROM alpine:latest
RUN apk --no-cache add ca-certificates curl postgresql-client
WORKDIR /app
COPY --from=builder /app/app .
EXPOSE 8080
CMD ["./app"]

FROM golang:1.13.8-buster
RUN mkdir /app
COPY main.go /app
COPY go.mod go.sum /app/
ENV CGO_ENABLED=0
WORKDIR /app
RUN go mod download
RUN go build -o main .


FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=0 /app/main .
RUN chmod +x ./main
ENTRYPOINT ["./main"]
FROM golang:1.25-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o katib main.go

FROM alpine:3.23
RUN apk --no-cache add ca-certificates
# Create unprivileged user
RUN adduser -u 1000 -S appuser
WORKDIR /app
COPY --chown=appuser --from=builder /app/katib .
EXPOSE 8080
USER appuser
CMD ["./katib"]

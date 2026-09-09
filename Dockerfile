# ---------- Build stage ----------
FROM golang:1.24-alpine AS builder

WORKDIR /build

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o openrouter-bot .

# ---------- Runtime stage ----------
FROM alpine:latest

WORKDIR /openrouter-bot

RUN apk add --no-cache ca-certificates

COPY --from=builder /build/openrouter-bot ./openrouter-bot
COPY entrypoint.sh ./entrypoint.sh

RUN chmod +x ./openrouter-bot ./entrypoint.sh

CMD ["./entrypoint.sh"]

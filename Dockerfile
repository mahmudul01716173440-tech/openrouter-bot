# ---------- Build stage ----------
FROM golang:1.24-alpine AS builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o /build/openrouter-bot .

# ---------- Runtime stage ----------
FROM alpine:latest

WORKDIR /openrouter-bot

RUN apk add --no-cache ca-certificates

# Bot binary
COPY --from=builder /build/openrouter-bot ./openrouter-bot

# Translation files
COPY --from=builder /build/lang ./lang

# Config
COPY --from=builder /build/config.yaml ./config.yaml

# Entrypoint
COPY entrypoint.sh ./entrypoint.sh

# Logs directory
RUN mkdir -p ./logs

RUN chmod +x ./openrouter-bot ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

# ---------- Build stage ----------
FROM golang:1.25 AS build

WORKDIR /openrouter-bot

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -o /openrouter-bot/openrouter-bot .

# ---------- Runtime stage ----------
FROM alpine:3.22

WORKDIR /openrouter-bot

RUN apk add --no-cache ca-certificates

# Config
COPY --from=build /openrouter-bot/config.yaml ./config.yaml

# Translation files
COPY --from=build /openrouter-bot/lang ./lang

# Compiled bot
COPY --from=build /openrouter-bot/openrouter-bot ./openrouter-bot

# Logs
RUN mkdir -p ./logs

# Railway environment variables -> .env
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh ./openrouter-bot

ENTRYPOINT ["./entrypoint.sh"]

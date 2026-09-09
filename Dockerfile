FROM alpine:latest

WORKDIR /openrouter-bot

COPY . .

RUN apk add --no-cache ca-certificates
RUN chmod +x ./openrouter-bot

COPY entrypoint.sh /openrouter-bot/entrypoint.sh
RUN chmod +x /openrouter-bot/entrypoint.sh

CMD ["./entrypoint.sh"]

# ---- Dependencies Stage ----
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev

# ---- Runtime Stage ----
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
COPY server.js ./

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
CMD wget -qO- http://localhost:8080/health || exit 1

CMD ["node", "server.js"]

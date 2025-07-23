# Build Stage
FROM node:22.12-alpine AS builder

WORKDIR /app

# Nur package.json und package-lock.json zuerst kopieren für besseren Build-Cache
COPY package*.json ./

RUN npm install

# Dann Quellcode kopieren und kompilieren
COPY . .

RUN npm run build

# Release Stage
FROM node:22-alpine AS release

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/memory.json ./memory.json

ENV NODE_ENV=production
ENV MEMORY_FILE_PATH=/app/memory.json

RUN npm ci --omit=dev

ENTRYPOINT ["node", "dist/project_index.js"]

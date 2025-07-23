# --- Base Image
FROM node:22-alpine

# --- Arbeitsverzeichnis
WORKDIR /app

# --- Nur package files zuerst für besseren Cache
COPY package*.json ./

# --- Abhängigkeiten installieren
RUN npm install

# --- Restliche Dateien kopieren
COPY . .

# --- Optionaler TypeScript-Build (nur wenn "build"-Skript existiert)
RUN if [ -f tsconfig.json ]; then npm run build; fi

# --- Standard-ENV-Variablen
ENV NODE_ENV=production
ENV MEMORY_FILE_PATH=/app/memory.json

# --- Start-Kommando
CMD ["node", "dist/project_index.js"]

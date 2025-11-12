# ---- Stage 1: Build ----
FROM node:20-alpine AS build
WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# ---- Stage 2: Production ----
FROM node:20-alpine
WORKDIR /app

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy dependencies & code
COPY --from=build /app /app

USER appuser
EXPOSE 3000
CMD ["node", "src/server.js"]

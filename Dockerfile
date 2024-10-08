# Stage 1: Build Stage
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies early to leverage Docker cache
COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Copy the rest of the application
COPY . /app

# Create a non-root user
RUN addgroup -S nodejs && adduser -S nodejs -G nodejs

# Change ownership to non-root user
RUN chown -R nodejs:nodejs /app

# Set permissions for security
RUN chmod -R 755 /app

# Switch to non-root user
USER nodejs

# Expose application port
EXPOSE 8080

# Start the Node.js app
CMD ["node", "app.js"]

# Security best practices:
# 1. Use a minimal base image (Alpine).
# 2. Use a non-root user.
# 3. Avoid installing unnecessary dependencies.
# 4. Multi-stage build to keep the final image lean.
# 5. Set file permissions appropriately.
# 6. Leverage npm ci for reproducible builds and secure package management.

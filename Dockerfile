FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy all source code
COPY . .

# Accept environment variable for environment type
ARG ENVIRONMENT
ENV NODE_ENV=$ENVIRONMENT

# Expose app port
EXPOSE 3000

# Run the app
CMD ["npm", "start"]

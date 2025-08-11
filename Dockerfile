cat > Dockerfile <<'EOF'
FROM node:18-alpine

ARG ENVIRONMENT=dev
ENV NODE_ENV=$ENVIRONMENT

WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .

EXPOSE 3000
CMD ["npm", "start"]
EOF

FROM node:24-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY index.js ./

EXPOSE 4444

# Start the application
CMD ["node", "index.js"]

FROM node:16

WORKDIR /app

COPY server.js .

RUN npm install express --production

ENV PORT=80

ENTRYPOINT ["node", "server"]
EXPOSE 80

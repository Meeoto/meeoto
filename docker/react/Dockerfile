FROM node:20-alpine AS dev

WORKDIR /usr/src/app

COPY apps/front/package*.json ./
RUN npm install

CMD ["npm", "run", "dev"] 

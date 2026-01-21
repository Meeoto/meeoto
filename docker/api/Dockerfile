FROM nginx:1.21.3-alpine AS base
WORKDIR /usr/src/app

FROM base AS dev
COPY docker/api/conf/nginx.dev.conf /etc/nginx/nginx.conf

FROM base AS preprod

COPY docker/api/conf/nginx.prod.conf /etc/nginx/nginx.conf
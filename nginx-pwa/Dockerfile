###
#   Build steps
###
FROM node:16-alpine AS builder

# Check https://github.com/nodejs/docker-node#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat

WORKDIR /app

## Uncomment if some package use git acces 
# RUN apk update && apk upgrade && apk add --no-cache git openssh
# COPY ./ssh /root/.ssh

COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./

# Installs all node packages
RUN \
  if [ -f yarn.lock ]; then yarn install --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci --no-fund --no-audit --no-update-notifier --no-progress; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Copy sources & Build
COPY . ./

ARG ENV_VARIABLE
ENV ENV_VARIABLE=${ENV_VARIABLE}

RUN yarn run build


##
#   Deploys steps
##
FROM nginx:1.23-alpine

# Set working directory to nginx resources directory
WORKDIR /usr/share/nginx/html

RUN apk add --no-cache bash

# Remove default nginx static resources
RUN rm -rf ./*

# nginx config
COPY --from=builder /app/build .
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["/bin/bash", "-c", "nginx -g \"daemon off;\""]

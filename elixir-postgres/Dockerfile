FROM elixir:1.11-alpine as builder

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
# COPY assets/package.json assets/package-lock.json ./assets/
# RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# COPY priv priv
# COPY assets assets
# RUN npm run --prefix ./assets deploy
# RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel

RUN mix compile
RUN mix release

FROM alpine

RUN apk add --update bash postgresql-client inotify-tools libgcc libstdc++

WORKDIR /app

COPY --from=builder /app/_build/prod ./

RUN tar -x -f *.tar.gz
RUN rm -rf *.tar.gz
RUN chmod a+x /app/bin/timemanager

ENV MIX_ENV=prod

COPY ./entrypoint.sh .
RUN chmod a+x entrypoint.sh

ENTRYPOINT ["sh","./entrypoint.sh"]

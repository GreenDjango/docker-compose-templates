
> [Harbor behind Traefik](https://www.robert-jensen.dk/posts/2021-harbor-behind-traefik-with-letsencrypt-certificate/)

> [Harbor 2.0 with Traefik 2.0 reverse proxy](https://medium.com/@jodywan/cloud-native-devops-08-harbor-2-0-with-traefik-2-0-reverse-proxy-5acbba95534a)

# [Harbor](https://goharbor.io)

## Install Harbor

```shell
curl -L https://github.com/goharbor/harbor/releases/download/v2.5.3/harbor-online-installer-v2.5.3.tgz -o harbor-online-installer-version.tgz
tar zxvf harbor-online-installer-version.tgz
```

## Config Harbor

In `harbor.yml`, change this line:

```yml
# ...
hostname: # remove if you want to enable external proxy
# ...
http:
  relative_url: true # if you want to enable external proxy
# ...
https: # comment this block if you use traefik
# ...
external_url: https://example.com # if you want to enable external proxy
# ...
harbor_admin_password: pswd
# ...
database:
  password: pswd
# ...
```

Next, run `./install.sh` with `--with-trivy` if you want Trivy DB vulnerability check

In the new generated `docker-compose.yml`, you can enable traefik with:

```yml
# ...
services:
# ...
  proxy:
  # ...
    networks:
      - harbor
      - reverse-proxy-traefik
    # ports:
    #   - 80:8080
    # ...
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=reverse-proxy-traefik"
      # Routers
      - "traefik.http.routers.proxy.rule=Host(`epitek.fr`)"
      - "traefik.http.routers.proxy.middlewares=harbor-behind-proxy"
      # Service
      - "traefik.http.services.proxy.loadbalancer.server.scheme=http"
      - "traefik.http.services.proxy.loadbalancer.server.port=8080"
      # middleware
      - "traefik.http.middlewares.harbor-behind-proxy.headers.customrequestheaders.X-Forwarded-Proto=https"
      # [SSL]
      - "traefik.http.routers.proxy.tls=true"
      - "traefik.http.routers.proxy.tls.certresolver=sslresolver"
# ...
networks:
  # ...
  reverse-proxy-traefik:
    external: true
# ...
```

In `/common/config/nginx/nginx.conf` comment all:

```conf
# proxy_set_header Host $host;
# proxy_set_header X-Forwarded-Proto $scheme;
```

## Start Harbor

```shell
cd traefik/
docker-compose up -d -f docker-compose.yml -f docker-compose.ssl.yml
cd metrics/
docker-compose up -d
cd ../
docker-compose up -d
```
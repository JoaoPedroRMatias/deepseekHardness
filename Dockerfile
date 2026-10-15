FROM node:24-slim

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
 && apt-get update \
 && apt-get install -y --no-install-recommends git ca-certificates openssh-client ripgrep

RUN --mount=type=cache,target=/root/.npm \
    npm i -g --no-audit --no-fund pnpm @deepseek-ai/dsh

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

ENV HOME=/home/user
WORKDIR /home/user/projetos

HEALTHCHECK --interval=30s --timeout=3s --start-period=20s --retries=3 \
  CMD bash -c 'echo > /dev/tcp/127.0.0.1/3080' || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

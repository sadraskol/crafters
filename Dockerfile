FROM elixir:1.6-slim

COPY . /tmp/
RUN apt update && \
  apt install -y --no-install-recommends curl sqlite3 ca-certificates build-essential git && \
  curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt install -y --no-install-recommends nodejs && \
  npm install -g bower && \
  cd /tmp && \
  ./package.sh && \
  mkdir -p /var/cafters && \
  apt purge -y --auto-remove curl ca-certificates build-essential nodejs git && \
  rm -rf /var/lib/apt/lists/* README.md TODO.md config deps front lib mix.exs mix.lock package.sh priv rel test .git

ENV PORT 4000
EXPOSE 4000

VOLUME ["/var/crafters"]

CMD ["/tmp/_build/prod/rel/crafters/bin/crafters", "run"]

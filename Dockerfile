FROM elixir:1.6

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt install -y nodejs sqlite3 && \
  npm install -g bower

COPY . /tmp/
RUN cd /tmp && \
  ./package.sh && \
  mkdir -p /var/cafters

ENV PORT 4000
EXPOSE 4000

VOLUME ["/var/crafters"]

CMD ["/tmp/_build/prod/rel/crafters/bin/crafters", "run"]

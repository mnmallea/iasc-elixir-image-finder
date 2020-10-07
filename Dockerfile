FROM elixir:latest
COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh
RUN mkdir -p /var/app
WORKDIR /var/app
COPY mix.exs ./
COPY mix.lock ./
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get && mkdir /elixir && cp mix.lock /elixir/mix.lock
ENTRYPOINT ["/docker-entrypoint.sh"]

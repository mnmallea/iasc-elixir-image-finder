FROM elixir:latest
ADD . /app
WORKDIR /app
RUN mix local.hex --force
RUN mix deps.get
CMD ["/bin/bash"]

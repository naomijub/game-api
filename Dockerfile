FROM elixir:1.8

RUN useradd -ms /bin/bash web
USER web

RUN mix local.hex --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
RUN mix local.rebar --force

WORKDIR /app

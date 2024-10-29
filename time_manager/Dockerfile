FROM hexpm/elixir:1.14.5-erlang-25.3.2.4-debian-bullseye-20230612-slim AS builder

RUN apt-get update -y && apt-get install -y build-essential git make gcc libgmp-dev \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN make --version


RUN which make

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV="prod"

COPY mix.exs ./
RUN mix deps.get --only $MIX_ENV

RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/

COPY priv priv
COPY lib lib
RUN mix compile

RUN mix release

RUN ls -la /app/_build/prod/rel/


FROM hexpm/elixir:1.14.5-erlang-25.3.2.4-debian-bullseye-20230612-slim

# Installer make et d'autres dépendances nécessaires
RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates postgresql-client \
    build-essential make \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Vérifier que 'make' est bien installé dans cette phase également
RUN which make

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"

ENV MIX_ENV="prod"

RUN mix local.hex --force && mix local.rebar --force

COPY --from=builder /app/_build/prod/rel/ ./

CMD ["/app/bin/server"]

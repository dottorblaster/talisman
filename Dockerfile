FROM registry.opensuse.org/opensuse/bci/rust AS elixir-build
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}
ENV MIX_HOME=/usr/bin
ENV MIX_REBAR3=/usr/bin/rebar3
ENV MIX_PATH=/usr/lib/elixir/lib/hex/ebin
RUN zypper -n in make gcc git-core elixir elixir-hex erlang erlang-rebar3
COPY . /build
WORKDIR /build
RUN mix deps.get
RUN mix compile
RUN mix assets.deploy
RUN mix phx.digest
RUN mix release

FROM registry.opensuse.org/opensuse/bci/bci-init
LABEL org.opencontainers.image.source="https://github.com/dottorblaster/talisman"
ARG MIX_ENV=prod
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# these are needed as erlang runtime's deps
RUN zypper -n in libsystemd0 libopenssl3
WORKDIR /app
COPY --from=elixir-build /build/_build/${MIX_ENV}/rel/talisman .
EXPOSE 4000

ENTRYPOINT ["/app/bin/talisman"]

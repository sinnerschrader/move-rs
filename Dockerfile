FROM codercom/code-server

FROM ekidd/rust-musl-builder:nightly

COPY --from=0 /usr/local/bin/code-server /usr/local/bin/

USER root

# install code-server dependencies
RUN apt-get update && apt-get install -y openssl net-tools

# upgrade libstdc++6 since code-server was buid in ubuntu 18.10 and rust-musl-builder uses 16.04
RUN apt-get install -y software-properties-common \
 && add-apt-repository ppa:ubuntu-toolchain-r/test \
 && apt-get update \
 && apt-get install -y gcc-4.9 \
 && apt-get upgrade -y libstdc++6

USER rust

RUN cargo install cargo-watch
RUN cargo install cargo-add

RUN mkdir src
RUN touch src/lib.rs
ADD Cargo.lock Cargo.toml ./

RUN cargo build
RUN cargo build --tests

ENV ROCKET_ADDRESS 0.0.0.0


USER root
RUN apt-get install -y npm
RUN apt-get install -y nodejs
RUN ln -s /usr/bin/nodejs /usr/bin/node
USER rust

RUN mkdir -p /home/rust/.code-server/extensions
ADD extensions/rust-lang.rust-0.5.3 \
    /home/rust/.code-server/extensions/rust-lang.rust-0.5.3
RUN chmod a+rwx /home/rust/.code-server

RUN rustup component add rls rust-analysis rust-src

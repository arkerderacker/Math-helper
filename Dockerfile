FROM node:24

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    binaryen

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install wasm-bindgen-cli --version 0.2.105
RUN cargo install --git https://github.com/r58playz/wasm-snip

WORKDIR /app

COPY . .

RUN corepack enable
RUN pnpm install

RUN cd packages/core && pnpm rewriter:build
RUN cd packages/core && pnpm build

EXPOSE 4141

CMD ["pnpm","dev"]

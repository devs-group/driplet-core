FROM denoland/deno:2.0.4

WORKDIR /app

COPY deps.ts .
RUN deno install --entrypoint deps.ts

COPY . .

RUN deno cache main.ts

CMD ["run", "--allow-net", "--allow-read", "--allow-env", "--allow-write", "--allow-sys", "main.ts"]
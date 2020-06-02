FROM python:3.8-slim AS builder


COPY . /app
WORKDIR /app

RUN pip install -r requirements.txt
RUN jupyter-book build .

FROM nginx:alpine
COPY --from=builder /app/_build/html /usr/share/nginx/html

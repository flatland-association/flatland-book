FROM python:3.8-slim AS builder

COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt

COPY . /app
WORKDIR /app

RUN jupyter-book build .

FROM nginx:alpine

COPY --from=builder /app/_build/html /usr/share/nginx/html/
COPY --from=builder /app/assets/static/ /usr/share/nginx/html/assets/static/
COPY ./deploy/nginx.conf /etc/nginx/conf.d/default.conf

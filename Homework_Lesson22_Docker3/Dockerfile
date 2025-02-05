FROM ubuntu:20.04

RUN apt update && apt install -y nginx curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/static

COPY nginx.conf /etc/nginx/nginx.conf

COPY static/ /app/static/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

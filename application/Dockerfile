FROM alpine:latest


RUN mkdir /app
RUN wget -O /app/gopher_search https://github.com/nicholasjackson/gopher_search/releases/download/v0.1/gopher_search
RUN chmod +x /app/gopher_search

ENTRYPOINT "/app/gopher_search

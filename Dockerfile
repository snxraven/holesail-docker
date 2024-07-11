FROM node:lts-slim as base

RUN npm i holesail -g

ENV MODE client
ENV HOST 0.0.0.0

EXPOSE 8989

ENTRYPOINT sh -c ' \
    if [ "$MODE" = "server" ]; then \
        holesail --live $PORT --host $HOST --connector $CONNECTOR; \
    elif [ "$MODE" = "client" ]; then \
        holesail --port $PORT --host $HOST $CONNECTOR; \
    fi '

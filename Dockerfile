FROM node:lts-slim as base

RUN npm i holesail -g

ENV MODE client
ENV HOST 0.0.0.0
ENV PORT 8989

EXPOSE $PORT

ENTRYPOINT sh -c ' \
    if [ "$MODE" = "server" ]; then \
        holesail --live $PORT --host $HOST --connector $CONNECTOR; \
    elif [ "$MODE" = "client" ]; then \
        holesail --port $PORT --host $HOST $CONNECTOR; \
    fi '

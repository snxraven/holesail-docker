FROM node:lts-slim AS base

WORKDIR /temp
COPY run.sh .
RUN chmod +x run.sh

RUN npm install -g holesail@2.0.3

ENV MODE server
ENV HOST 0.0.0.0
ENV PORT 8989
ENV PUBLIC true
ENV USERNAME admin
ENV PASSWORD admin
ENV ROLE user 
ENV CONNECTOR ""
ENV FORCE ""

#EXPOSE 8989

WORKDIR /data

ENTRYPOINT [ "/temp/run.sh" ]

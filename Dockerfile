FROM node:alpine AS build
WORKDIR /data/app

COPY ./static/.gitignore ./static/.gitignore
COPY ./frontend ./frontend
RUN cd frontend && yarn && yarn run dist

COPY ./backend ./backend
RUN cd ./backend && yarn

# COPY . .

FROM node:alpine
WORKDIR /data/app

# COPY --from=build /data/app/backend /data/app/backend
# COPY --from=build /data/app/static /data/app/static
# COPY --from=build /data/app/data /data/app/data
# COPY --from=build /data/app/trash /data/app/trash
# COPY --from=build /data/app/config.json /data/app/config.json
# COPY --from=build /data/app/README.md /data/app/README.md

# 必须要排除前端源目录frontend，减少镜像的大小
COPY --from=build /data/app/backend ./backend
COPY --from=build /data/app/static ./static
COPY ./data ./data
COPY ./trash ./trash 
COPY \
  ./config.json \
  ./README.md \
  ./0.png \
  ./1.png \
  ./2.png \
  ./3.png \
  ./4.gif \
  ./

EXPOSE 3000

# ENTRYPOINT [ "/bin/sh" ]
CMD [ "node", "backend/main.js" ]

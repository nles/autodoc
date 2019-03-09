FROM ubuntu:18.04

WORKDIR /app

RUN apt-get update

RUN apt-get install -y libdbi-perl \
  libhtml-template-perl libterm-readkey-perl \
  libdbd-pg-perl make

COPY . .

RUN make install

ARG container_user_id
RUN useradd --shell /bin/bash -u $container_user_id -o -c "" -m user-in-container
RUN chown -R user-in-container:user-in-container /app
USER user-in-container

ENV DATABASE=app \
  HOST=localhost \
  USER=app \
  PASSWORD=password

CMD postgresql_autodoc -d ${DATABASE} \
  -h ${HOST} \
  -u ${USER} \
  --password=${PASSWORD}

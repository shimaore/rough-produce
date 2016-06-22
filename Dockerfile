FROM node:6.2.2
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

# Our convention is to use userid 9999 as an anonymous docker user.
RUN useradd -m -u 9999 docker -d /usr/src/app
USER docker
WORKDIR /usr/src/app

COPY . /usr/src/app/
RUN npm install

CMD [ "npm", "start" ]

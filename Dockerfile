FROM node:6.2.1
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app

CMD [ "npm", "start" ]

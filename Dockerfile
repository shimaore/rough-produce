FROM shimaore/nodejs:4.3.2
COPY . /opt/service
CMD ["npm start"]

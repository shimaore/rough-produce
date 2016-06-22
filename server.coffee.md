    Cuddly = require 'cuddly'
    PouchDB = require 'pouchdb'
    IO = require 'socket.io-client'
    assert = require 'assert'

    pkg = require './package'
    @name = "#{pkg.name}:server"
    debug = (require 'debug') @name

    assert process.env.LOGGING?, 'Missing LOGGING environment variable.'
    logging = new PouchDB process.env.LOGGING

    assert process.env.IO?, 'Missing IO environment variable.'
    io = IO process.env.IO

    for event in Cuddly.events
      do (event) ->
        io.on event, (data) ->
          data.level = event.substr 7
          data.event = [
            data.application
            data.host
            data.stamp
            data.level
            data.error
          ].join '-'
          data._id = "event:#{data.event}"
          logging.put data

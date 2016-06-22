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
    socket = IO process.env.IO

    socket.on 'connect_error', (o) ->
      debug 'connect_error', o.stack ? o.toString()
    socket.on 'connect_timeout', ->
      debug 'connect_timeout'
    socket.on 'reconnect', (n) ->
      debug 'reconnect', n
    socket.on 'reconnect_attempt', ->
      debug 'reconnect_attempt'
    socket.on 'reconnecting', (n) ->
      debug 'reconnecting', n
    socket.on 'reconnect_error', (o) ->
      debug 'reconnect_error', o.stack ? o.toString()
    socket.on 'reconnect_failed', ->
      debug 'reconnect_failed'

    socket.on 'connect', ->
      debug 'connect'
    socket.on 'error', (o) ->
      debug 'connect', o.stack ? o.toString()
    socket.on 'disconnect', ->
      debug 'disconnect'

    for event in Cuddly.events
      do (event) ->
        socket.on event, (data) ->
          data.level = event.substr 7
          data.event = [
            data.application
            data.host
            data.stamp
            data.level
            data.error
          ].join '-'
          data._id = "event:#{data.event}"
          logging
            .put data
            .catch (error) ->
              debug "put", data, error.stack ? error.toString()

    socket.emit 'configure',
      support: true

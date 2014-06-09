LindaClient = require('linda').Client
socketio    = require 'socket.io-client'
debug       = require('debug')('linda:worker')
path        = require 'path'

config  = require path.resolve 'config.json'
scripts = require path.resolve 'libs', 'scripts'

config.url = process.env.URL || config.url

console.log config

scripts.load (err, codes) ->

  socket = socketio.connect config.url
  linda = new LindaClient().connect socket
  linda.config = config

  for code in codes
    code linda

  linda.io.on 'connect', ->
    debug "socket.io connnect <#{config.url}>"

  linda.io.on 'disconnect', ->
    debug "socket.io disconnect <#{config.url}>"

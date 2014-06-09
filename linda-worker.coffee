LindaClient = require('linda').Client
socketio    = require 'socket.io-client'
debug       = require('debug')('linda:worker')
path        = require 'path'

config     = require path.resolve 'config.json'
scripts    = require path.resolve 'libs', 'scripts'
httpserver = require path.resolve 'libs', 'httpserver'

config.url = process.env.URL or config.url
debug config


## Scripts

scripts.load process.env.SCRIPT or '.+', (err, scripts) ->
  socket = socketio.connect config.url

  for script in scripts
    debug "load script \"#{script.name}\""
    linda = new LindaClient().connect socket
    linda.config = config
    linda.debug = require('debug')("linda:worker:#{script.name}")
    script.function(linda)


  linda = new LindaClient().connect socket

  linda.io.on 'connect', ->
    debug "socket.io connnect <#{config.url}>"

  linda.io.on 'disconnect', ->
    debug "socket.io disconnect <#{config.url}>"


## HTTP Server
httpserver.start process.env.PORT or 3000

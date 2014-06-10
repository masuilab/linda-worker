http  = require 'http'
debug = require('debug')('linda:worker:httpserver')

app_handler = (req, res) ->
  debug req.url
  res.writeHead 200
  res.end "linda worker"

app = http.createServer app_handler

module.exports =
  start: (port) ->
    app.listen port
    debug "start - port:#{port}"

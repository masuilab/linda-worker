debug      = require('debug')('linda:worker:httpserver')
express    = require 'express'
bodyParser = require 'body-parser'

app = express()
app.disable 'x-powered-by'
app.use bodyParser.urlencoded(extended: true)

http = require('http').Server(app)

app.get '/', (err, res) ->
  res.end 'linda-worker'

module.exports =
  start: (port) ->
    http.listen port
    debug "start - port:#{port}"

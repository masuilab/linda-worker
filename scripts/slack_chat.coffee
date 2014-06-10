## require: env variable SLACK_TOKEN

Slackbot = require 'slackbot'

module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace(config.linda.space)

  unless process.env.SLACK_TOKEN
    linda.debug 'ERROR: ENV variable "SLACK_TOKEN" missing'
    return
  slack = new Slackbot config.slack.team, process.env.SLACK_TOKEN

  send = (msg, callback = ->) ->
    slack.send config.slack.channel, msg, callback

  linda.io.on 'connect', ->
    ts.watch {type: "slack", cmd: "post"}, (err, tuple) ->
      return if tuple.data.response?
      return unless tuple.data.value?
      linda.debug tuple
      msg = "#{config.slack.header} 《Linda》 #{tuple.data.value} 《#{ts.name}》"
      send msg, (err, res, body) ->
        if err
          tuple.data.response = "fail"
          ts.write tuple.data
          return
        tuple.data.response = body
        ts.write tuple.data
  

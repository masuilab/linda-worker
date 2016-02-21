# watch {type: "rain"}
# notify difference between "observation" and "forecast"

module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace config.linda.space

  notify = (msg, where, emoji) ->
    linda.debug msg

    ts.write
      type: "hubot"
      cmd: "post"
      value: msg + " " + emoji

    ts.write
      type: "say"
      value: msg
      where: where

  linda.io.on 'connect', ->
    ts.watch
      type: 'rain'
    , (err, tuple) ->
      return if err
      linda.debug tuple
      place_name = config.places[tuple.data.where] or tuple.data.where
      if tuple.data.observation is 0
        if tuple.data.forecast > 0
          notify "#{place_name}でもうすぐ雨が#{tuple.data.forecast}降ります\n#{tuple.data.map}", tuple.data.where, ":umbrella:"
          return
      if tuple.data.observation > 0
        if tuple.data.forecast is 0
          notify "#{place_name}でもうすぐ雨が止みます\n#{tuple.data.map}", tuple.data.where, ":sunny:"
          return

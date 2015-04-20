module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace config.linda.space

  notify = (msg) ->
    ts.write
      type: "hubot"
      cmd: "post"
      value: msg

    ts.write
      type: "say"
      value: msg

  yo = (room_name) ->
    ts.write
      type: "yo"
      value: room_name

  linda.io.on 'connect', ->

    ts.watch
      type: "door"
      cmd: "open"
      response: "success"
    , (err, tuple) ->
      return if err
      linda.debug JSON.stringify tuple
      unless tuple.data.where
        return linda.debug 'parameter "where" is missing'

      place_name = config.places[tuple.data.where] or tuple.data.where
      if tuple.data.who?
        msg = "#{place_name}で、#{tuple.data.who}がドアを開きました"
      else
        msg = "#{place_name}でドアが開きました"
      linda.debug msg
      notify msg
      yo tuple.data.where

    ts.watch
      type: "door"
      cmd: "close"
      response: "success"
    , (err, tuple) ->
      return if err
      linda.debug JSON.stringify tuple
      unless tuple.data.where
        return linda.debug 'parameter "where" is missing'

      place_name = config.places[tuple.data.where] or tuple.data.where
      if tuple.data.who?
        msg = "#{place_name}で、#{tuple.data.who}がドアを閉じました"
      else
        msg = "#{place_name}でドアが閉じました"
      linda.debug msg
      notify msg

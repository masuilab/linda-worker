module.exports = (linda) ->

  config = linda.config
  tss = []
  for name, yomi of config.linda.spaces
    tss.push linda.tuplespace(name)

  notify = (msg) ->
    for ts in tss
      ts.write {type: "say", value: msg}
      ts.write {type: "skype", cmd: "post", value: msg}
      ts.write {type: "slack", cmd: "post", value: msg}

  yo = (room_name) ->
    linda.tuplespace(config.linda.space).write
      type: "yo"
      value: room_name

  linda.io.on 'connect', ->

    for ts in tss
      do (ts) ->
        ts.watch {type: "door", cmd: "open", response: "success"}, (err, tuple) ->
          return if err
          linda.debug "#{ts.name}  - #{JSON.stringify tuple}"
          if tuple.data.who?
            msg = "#{config.linda.spaces[ts.name]}で、#{tuple.data.who}がドアを開きました"
          else
            msg = "#{config.linda.spaces[ts.name]}でドアが開きました"
          linda.debug msg
          notify msg
          yo ts.name

        ts.watch {type: "door", cmd: "close", response: "success"}, (err, tuple) ->
          return if err
          linda.debug "#{ts.name}  - #{JSON.stringify tuple}"
          if tuple.data.who?
            msg = "#{config.linda.spaces[ts.name]}で、#{tuple.data.who}がドアを閉じました"
          else
            msg = "#{config.linda.spaces[ts.name]}でドアが閉じました"
          linda.debug msg
          notify msg

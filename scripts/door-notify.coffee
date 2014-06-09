module.exports = (linda) ->

  tss = []
  for name, yomi of linda.config.spaces
    tss.push linda.tuplespace(name)

  notify = (msg) ->
    for ts in tss
      ts.write {type: "say", value: msg}
      ts.write {type: "skype", cmd: "post", value: msg}
      ts.write {type: "slack", cmd: "post", value: msg}

  linda.io.on 'connect', ->

    for ts in tss
      do (ts) ->
        ts.watch {type: "door", cmd: "open", response: "success"}, (err, tuple) ->
          return if err
          linda.debug "#{ts.name}  - #{JSON.stringify tuple}"
          if tuple.data.who?
            msg = "#{linda.config.spaces[ts.name]}で、#{tuple.data.who}がドアを開きました"
          else
            msg = "#{linda.config.spaces[ts.name]}でドアが開きました"
          linda.debug msg
          notify msg

        ts.watch {type: "door", cmd: "close", response: "success"}, (err, tuple) ->
          return if err
          linda.debug "#{ts.name}  - #{JSON.stringify tuple}"
          if tuple.data.who?
            msg = "#{linda.config.spaces[ts.name]}で、#{tuple.data.who}がドアを閉じました"
          else
            msg = "#{linda.config.spaces[ts.name]}でドアが閉じました"
          linda.debug msg
          notify msg

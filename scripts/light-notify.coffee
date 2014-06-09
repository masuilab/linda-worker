module.exports = (linda) ->

  tss = []
  for name, yomi of linda.config.spaces
    tss.push linda.tuplespace(name)

  notify = (msg, value) ->
    for ts in tss
      ts.write {type: "say", value: msg}
      ts.write {type: "slack", cmd: "post", value: "#{msg} (#{value})"}
      ts.write {type: "skype", cmd: "post", value: "#{msg} (#{value})"}

  linda.io.on 'connect', ->
    console.log 'socket.io connect!!'
    for ts in tss
      last_value = null
      do (ts, last_value) ->
        console.log "watch #{ts.name}"
        ts.watch {type: "sensor", name: "light"}, (err, tuple) ->
          return if err
          return if tuple.data.value < 0 or tuple.data.value > 1023  # 異常値
          console.log "#{ts.name} -> #{tuple.data.value}, last:#{last_value}"
          if last_value != null and Date.now()
            if tuple.data.value > last_value
              if tuple.data.value / (last_value+1) > 3
                console.log msg = "#{linda.config.spaces[ts.name]} で電気がつきました"
                notify msg, tuple.data.value
            else
              if last_value / (tuple.data.value+1) > 3
                console.log msg = "#{linda.config.spaces[ts.name]} で電気が消えました"
                notify msg, tuple.data.value
          last_value = tuple.data.value


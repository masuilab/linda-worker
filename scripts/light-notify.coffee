module.exports = (linda) ->

  config = linda.config
  tss = []
  for name, yomi of config.linda.spaces
    tss.push linda.tuplespace(name)

  notify = (msg, value) ->
    ts = linda.tuplespace config.linda.space
    ts.write {type: "slack", cmd: "post", value: "#{msg} (#{value})"}
    ts.write {type: "skype", cmd: "post", value: "#{msg} (#{value})"}
    for ts in tss
      ts.write {type: "say", value: msg}

  linda.io.on 'connect', ->

    for ts in tss
      last_value = null
      do (ts, last_value) ->
        linda.debug "watch #{ts.name}"
        ts.watch {type: "sensor", name: "light"}, (err, tuple) ->
          return if err
          return if tuple.data.value < 0 or tuple.data.value > 1023  # 異常値
          linda.debug "#{ts.name} -> #{tuple.data.value}, last:#{last_value}"
          if last_value != null and Date.now()
            if tuple.data.value > last_value
              if tuple.data.value / (last_value+1) > 3
                linda.debug msg = "#{config.linda.spaces[ts.name]} で電気がつきました"
                notify msg, tuple.data.value
            else
              if last_value / (tuple.data.value+1) > 3
                linda.debug msg = "#{config.linda.spaces[ts.name]} で電気が消えました"
                notify msg, tuple.data.value
          last_value = tuple.data.value


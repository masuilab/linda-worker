module.exports = (linda) ->

  ts = linda.tuplespace('shokai')

  notify = (msg) ->
    console.log "notify #{msg}"
    ts.write {type: "say", value: msg}

  linda.io.on 'connect', ->

    last_value = null

    ts.watch {type: 'sensor', name: 'light'}, (err, tuple) ->
      if err or !tuple.data.value?
        return
      if tuple.data.value < 0 or tuple.data.value > 1023 # 異常値
        return
      console.log tuple

      if last_value != null
        if tuple.data.value > last_value
          if tuple.data.value / (last_value+1) > 3
            notify "電気ついた"
        else
          if last_value / (tuple.data.value+1) > 3
            notify "電気消えた"
      last_value = tuple.data.value

module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace config.linda.space

  notify = (msg, value, where) ->
    ts = linda.tuplespace config.linda.space

    ts.write
      type: "hubot"
      cmd: "post"
      value: "#{msg} (#{value})"

    ts.write
      type: "yo"
      value: where

    ts.write
      type: "say"
      value: msg

  linda.io.on 'connect', ->

    last_values = {}

    ts.watch {type: "sensor", name: "light"}, (err, tuple) ->
      return if err
      return unless where = tuple.data.where
      return if tuple.data.value < 0 or tuple.data.value > 1023  # 異常値

      last_value = last_values[where]
      last_values[where] = tuple.data.value
      linda.debug "#{where} -> #{tuple.data.value}, last:#{last_value}"

      place_name = config.places[where] or where
      if last_value != null and Date.now()
        if tuple.data.value > last_value
          if tuple.data.value / (last_value+1) > 3
            linda.debug msg = "#{place_name} で電気がつきました"
            notify msg, tuple.data.value, where
        else
          if last_value / (tuple.data.value+1) > 3
            linda.debug msg = "#{place_name} で電気が消えました"
            notify msg, tuple.data.value, where

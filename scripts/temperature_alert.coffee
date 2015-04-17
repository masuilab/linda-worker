module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace config.linda.space

  alert_tempe = (where) ->
    linda.debug "read tempe at \"#{where}\""
    cid = ts.read
      type: "sensor"
      name: "temperature"
      where: where
    , (err, tuple) ->
      cid = null
      return if err
      linda.debug JSON.stringify tuple.data
      tempe = Math.floor tuple.data.value

      msg = "現在の気温、 #{tempe}度。"
      if tempe < 20 or 27 < tempe
        msg += "お体に触りますよ"

      ts.write
        type: "say"
        value: msg
        where: where

    if cid
      setTimeout ->
        ts.cancel cid
        linda.debug "tuple not found at \"#{where}\""
      , 2000

  alert_all_tempe = ->
    for where, nickname of config.places
      alert_tempe where

  linda.io.once 'connect', ->

    setInterval alert_all_tempe, 1000 * config.temperature_alert.interval

    alert_all_tempe()

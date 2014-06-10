module.exports = (linda) ->

  config = linda.config
  tss = []
  for name,yomi of config.linda.spaces
    tss.push linda.tuplespace name

  alert_tempe = (ts) ->
    cid = ts.read {type: "sensor", name: "temperature"}, (err, tuple) ->
      return if err
      linda.debug "#{ts.name} - #{JSON.stringify tuple.data}"
      tempe = Math.floor tuple.data.value
  
      msg = "現在の気温、 #{tempe}度。"
      if tempe < 20 or 27 < tempe
        msg += "お体に触りますよ"
      ts.write {type: "say", value: msg}
      cid = null
  
      if cid
        setTimeout ->
          ts.cancel cid
        , 2000

  setInterval ->
    for ts in tss
      alert_tempe ts
  , 1000 * config.temperature_alert.interval

  for ts in tss
    alert_tempe ts

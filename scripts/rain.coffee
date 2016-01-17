# require ENV var "WEATHER_APPID"
# register appid https://e.developer.yahoo.co.jp/dashboard/
# write tuple - { type: 'rain', observation: 0, forecast: 0, where: 'sfc' }

{Yolp} = require 'weather-yahoo-jp'
yolp = new Yolp(process.env.WEATHER_APPID)

module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace config.linda.space

  write_rain_tuples = ->

    yolp
      .getWeather
        coordinates: config.rain.coordinates
      .then (res) ->
        for where, weather of res
          tuple =
            type: 'rain'
            observation: weather.observation.rain
            forecast: weather.forecast[0].rain
            where: where
          linda.debug tuple
          ts.write tuple, expire: config.rain.interval
      .catch (err) ->
        if err.stack
          console.error err.stack
        else
          linda.debug err

  linda.io.once 'connect', ->
    write_rain_tuples()
    setInterval write_rain_tuples, config.rain.interval * 1000

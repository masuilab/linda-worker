# require ENV var "WEATHER_APPID"
# register appid https://e.developer.yahoo.co.jp/dashboard/
# write tuple - { type: 'rain', observation: 0, forecast: 0, where: 'sfc' }

request = require 'request'
_ = require 'lodash'

module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace config.linda.space

  get_weather = (latlon) ->
    return new Promise (resolve, reject) ->
      linda.debug "getting yahoo weather API"
      request
        url: "http://weather.olp.yahooapis.jp/v1/place"
        qs:
          appid: process.env.WEATHER_APPID
          coordinates: latlon
          output: "json"
      , (err, res, body) ->
        return reject err if err
        return resolve JSON.parse body

  write_rain_tuples = ->
    for where, latlon of config.rain.coordinates
      do (where, latlon) ->
        get_weather latlon
        .then (res) ->
          for feature in res.Feature
            data = feature.Property.WeatherList.Weather
            observation = _.find data, (i) -> i.Type is 'observation' and typeof i.Rainfall is 'number'
            forecast = _.chain(data)
              .filter (i) -> i.Type is 'forecast' and typeof i.Rainfall is 'number'
              .min (i) -> i.Date
              .value()
            tuple =
              type: 'rain'
              observation: observation.Rainfall
              forecast: forecast.Rainfall
              where: where
            linda.debug tuple
            ts.write tuple, expire: config.rain.interval
        .catch (err) ->
          linda.debug err

  linda.io.once 'connect', ->
    write_rain_tuples()
    setInterval write_rain_tuples, config.rain.interval * 1000

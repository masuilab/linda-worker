module.exports = (linda) ->

  ts = linda.tuplespace('shokai')

  linda.io.on 'connect', ->
    ts.watch {type: 'sensor', name: 'light'}, (err, tuple) ->
      console.log tuple.data

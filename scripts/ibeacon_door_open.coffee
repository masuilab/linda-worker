module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace(config.linda.space)

  door_open = (where, who) ->
    linda.tuplespace(where).write {type: "door", cmd: "open", who: who}

  linda.io.on 'connect', ->

    ts.watch {type: 'region', action: 'enter'}, (err, tuple) ->
      linda.debug tuple
      return if tuple.data.where?.length < 1
      return if tuple.data.who?.length < 1
      door_open tuple.data.where, tuple.data.who

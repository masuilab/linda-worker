module.exports = (linda) ->

  config = linda.config

  linda.router.post '/littlebits/waiwai', (req, res) ->

    linda.debug 'callback received'

    res.end 'ok'

    linda.tuplespace(config.linda.space).write
      type:  'waiwai'
      query: req.query
      body:  req.body

    linda.tuplespace(config.linda.space).write
      type: 'hubot'
      cmd:  'post'
      value:'デルタ氏「わいわい」'
      room: 'news'

    for tsName,nickname of config.linda.spaces
      linda.tuplespace(tsName).write
        type: 'say'
        value: 'わいわい'

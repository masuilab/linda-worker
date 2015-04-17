module.exports = (linda) ->

  config = linda.config

  linda.router.post '/littlebits/waiwai', (req, res) ->

    linda.debug 'callback received'

    res.end 'ok'

    ts = linda.tuplespace config.linda.space

    ts.write
      type:  'waiwai'
      query: req.query
      body:  req.body

    ts.write
      type: 'hubot'
      cmd:  'post'
      value:'デルタ氏「わいわい」'
      room: 'news'

    for where, nickname of config.places
      ts.write
        type: 'say'
        value: 'わいわい'
        where: where

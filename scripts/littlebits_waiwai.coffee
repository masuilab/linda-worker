module.exports = (linda) ->

  config = linda.config

  linda.router.post '/littlebits/waiwai', (req, res) ->

    res.end 'ok'

    linda.tuplespace(config.linda.space).write
      type:  'waiwai'
      query: req.query
      body:  req.body

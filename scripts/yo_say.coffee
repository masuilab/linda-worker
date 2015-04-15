module.exports = (linda) ->

  config = linda.config

  linda.router.get '/yo/say_shookai', (req, res) ->
    linda.debug req.query
    ip = req.query.user_ip
    unless who = req.query.username
      return res.status(400).end 'invalid request'
    res.end 'ok'

    linda.tuplespace('shokai').write
      type:  'say'
      value: 'ヨー'

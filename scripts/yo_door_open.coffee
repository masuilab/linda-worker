module.exports = (linda) ->

  linda.router.get '/yo/door_open_delta', (req, res) ->
    linda.debug req.query
    from = req.query.user_ip
    unless who = req.query.username
      return res.status(400).end 'invalid request'
    res.end 'ok'

    linda.tuplespace('delta').write
      type: 'door'
      cmd:  'open'
      who:  who

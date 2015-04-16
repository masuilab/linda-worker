module.exports = (linda) ->

  config = linda.config

  linda.router.get '/yo/door_open_delta', (req, res) ->
    linda.debug req.query
    ip = req.query.user_ip
    unless who = req.query.username
      return res.status(400).end 'invalid request'
    res.end 'ok'

    linda.tuplespace(config.linda.space).write
      type:  'hubot'
      cmd:   'post'
      value: "#{who}(ip:#{ip})がYoでドアを開けようとしています"

    linda.tuplespace('delta').write
      type: 'door'
      cmd:  'open'
      who:  who

    linda.tuplespace('delta').write
      type:  'say'
      value: 'ヨー'

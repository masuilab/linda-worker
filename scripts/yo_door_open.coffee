module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace config.linda.space

  linda.router.get '/yo/door_open_delta', (req, res) ->
    linda.debug req.query
    ip = req.query.user_ip
    unless who = req.query.username
      return res.status(400).end 'invalid request'
    res.end 'ok'

    ts.write
      type:  'hubot'
      cmd:   'post'
      value: "#{who}(ip:#{ip})がYoでドアを開けようとしています"

    ts.write
      type: 'door'
      cmd:  'open'
      where:'delta'
      who:  who

    ts.write
      type:  'say'
      value: 'ヨー'
      where: 'delta'

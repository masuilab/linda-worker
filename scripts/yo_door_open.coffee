# Yoでドアを開ける
# ENV: YO_DOOR_TOKEN

process.env.YO_DOOR_TOKEN ||= 'うどん居酒屋かずどん'

module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace config.linda.space

  linda.router.get '/yo/door_open_delta', (req, res) ->
    linda.debug req.query
    ip = req.query.user_ip
    unless who = req.query.username
      return res.status(400).end 'invalid request'
    if config.yo.users.indexOf(who.toUpperCase()) < 0
      res.status(400).end "bad user: #{who}"
      ts.write
        type:  'hubot'
        cmd:   'post'
        value: "不正なユーザー #{who}(ip#{ip})がYoでドアを開けようとしています"
      return
    if req.query.token isnt process.env.YO_DOOR_TOKEN
      res.status(400).end "bad token"
      ts.write
        type:  'hubot'
        cmd:   'post'
        value: "#{who}(ip#{ip})が不正なYo token\"#{req.query.token}\"でドアを開けようとしています"
      return

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

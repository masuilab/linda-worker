module.exports = (linda) ->

  config = linda.config

  linda.router.post '/littlebits/waiwai', (req, res) ->

    linda.debug 'callback received'
    linda.debug JSON.stringify req.body

    if req.body.type isnt 'amplitude'
      linda.debug msg = 'type must be amplitude'
      return res.status(400).end msg
    if req.body.bit_id isnt config.waiwai.bit_id
      linda.debug msg = 'bit_id is wrong'
      return res.status(400).end msg

    percent = req.body.payload.percent
    if typeof percent isnt 'number'
      linda.debug msg = 'cannot get "percent" property in payload'
      return res.status(400).end msg

    res.end 'ok'

    linda.debug "percent: #{percent}"

    ts = linda.tuplespace config.linda.space

    ts.write
      type:  'waiwai'
      percent: percent
      body:  req.body

    return if percent < 80  # 静かな時は通知しない

    ts.write
      type: 'hubot'
      cmd:  'post'
      value:'デルタ氏「わいわい」'
      room: 'news'

    ts.write
      type: 'say'
      value: 'わいわい'

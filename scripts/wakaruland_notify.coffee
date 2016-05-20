module.exports = (linda) ->

  config = linda.config
  ts = linda.tuplespace config.linda.space
  wakaruland = linda.tuplespace 'wakaruland'

  image_url = (reaction) -> "http://wakaruland.herokuapp.com/images/#{reaction}.jpg"

  wakaruland.watch {type: 'reaction'}, (err, tuple) ->
    {who, reaction} = tuple.data
    ts.write
      type: "hubot"
      cmd: "post"
      value: "#{who}「#{reaction}」\n#{image_url(reaction)}"

module.exports = (linda) ->
  url = linda.config.app.url
  unless /^https?:\/\/.+/.test url
    linda.debug "ERROR: invalid keepalive URL (#{url})"
    return
  linda.debug "start (#{url})"

  setInterval ->
    linda.requestKeepalive url
  , 90000


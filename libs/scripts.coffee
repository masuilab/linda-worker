path = require 'path'
fs   = require 'fs'
_    = require 'lodash'

class Scripts
  load: (pattern, callback = ->) ->
    @files pattern, (err, files) ->
      if err
        callback err
        return

      scripts = []
      for file in files
        scripts.push
          name: file.name.match(/(.+)\.coffee$/)[1]
          fullpath: file.fullpath
          function: require file.fullpath

      callback null, scripts

  files: (pattern, callback = ->) ->
    fs.readdir path.resolve("scripts"), (err, files) ->
      if err
        callback err
        return

      files = _.chain(files)
      .filter (file) -> new RegExp("#{pattern}\.coffee$").test file
      .map (file) ->
        fullpath: path.resolve 'scripts', file
        name: file
      .value()

      callback null, files


module.exports = new Scripts

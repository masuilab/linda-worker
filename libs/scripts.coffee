path = require 'path'
fs   = require 'fs'
_    = require 'lodash'

class Scripts
  load: (callback = ->) ->
    @files (err, files) ->
      callback err, files.map (f) ->
        return require f
      
  files: (callback = ->) ->
    fs.readdir path.resolve("scripts"), (err, files) ->
      if err
        callback err
        return

      files = _.chain(files)
      .filter (file) -> /.+\.coffee$/.test file
      .map (file) -> path.resolve 'scripts', file
      .value()

      callback null, files

    
module.exports = new Scripts

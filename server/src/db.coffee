fs = require 'fs'

requireDir = (path) ->
  fs.readdirSync(path).forEach (file) ->
    require "#{path}/#{file}"

requireDir './../models'

module.exports = mongoose.connect 'mongodb://localhost/fondue'

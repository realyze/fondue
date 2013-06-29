path = require 'path'
#
# * GET home page.
# 
exports.index = (req, res) ->
  res.sendfile path.resolve '../client/_public/index.html'


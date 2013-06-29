jsdom = require 'jsdom'
request = require 'superagent'

exports.setup = (app) ->

  app.get '/api/funds/:id', (req, res) ->
    res.send("fund #{req.params.id}")

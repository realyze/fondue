

exports.setup = (app) ->
  app.get '/api/users/me', (req, res) ->
    console.log 'users/me', req.user
    res.send req.user

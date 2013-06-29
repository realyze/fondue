###
Module dependencies.
###
passport = require 'passport'
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
app = express()

require './db'

# all environments
app.set "port", process.env.PORT or 3000
app.use express.favicon()
app.use express.logger("dev")
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session secret: 'keyboard cat'

app.use passport.initialize()
app.use passport.session()

app.use app.router
app.use express.static(path.join(__dirname, "../../client/_public"))

# development only
if "development" is app.get("env")
  app.use express.errorHandler()

app.get "/", routes.index

require('./routes/funds').setup app
require('./routes/users').setup app

require('./lib/auth').setup app

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")



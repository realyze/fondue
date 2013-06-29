passport = require 'passport'
require '../models/user'
mongoose = require 'mongoose'

GoogleStrategy = require("passport-google-oauth").OAuth2Strategy

GOOGLE_CONSUMER_KEY = '181953787023.apps.googleusercontent.com'
GOOGLE_CONSUMER_SECRET = 'ICC_MwD2172FXSRmjQFunF23'

mongoose.connect 'mongodb://localhost/test'
User = mongoose.model 'User'


passport.use new GoogleStrategy(
  clientID: GOOGLE_CONSUMER_KEY
  clientSecret: GOOGLE_CONSUMER_SECRET
  callbackURL: "/auth/google/callback"
, (accessToken, refreshToken, profile, done) ->
  console.log 'find or create', profile
  User.findOrCreate profile, done
)

passport.serializeUser (user, done) ->
  done null, user.googleId

passport.deserializeUser (id, done) ->
  User.findOne googleId: id, done

exports.setup = (app) ->

  app.get "/auth/google", passport.authenticate("google",
    scope: ["https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/userinfo.email"]
  ), (req, res) -> # Nada...
  
  app.get '/auth/google/callback',
    passport.authenticate('google', { failureRedirect: '/login' }),
    (req, res) -> res.redirect '/'

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'

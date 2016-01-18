jwt = require 'jsonwebtoken'
passport = require 'passport'

tokenExpiresIn = parseInt(process.env.TOKEN_VALIDITY_IN_MINS) * 60 || 24* 60 * 60
console.log "token validity interval: #{tokenExpiresIn} secs"


_pingFrontend = (req, res) ->
  # prepares token that user uses to claim user info after successful login
  token = jwt.sign req.user, process.env.SERVER_SECRET,
    expiresIn: tokenExpiresIn || 24 * 60 * 60
  # sends it within url query
  return res.redirect "#{process.env.CLIENTAPPURL}?token=#{token}"


module.exports = (app, usermanip, getToken) ->
  # NOTE: app.use passport.initialize() should be done on app already!!

  _initUserInfoRoute = false

  if 'FBCLIENTID' of process.env
    Facebook = require('./lib/facebook')
    Facebook(app, usermanip, passport, _pingFrontend)
    _initUserInfoRoute = true

  if 'TWITTERCONSUMERKEY' of process.env
    Twitter = require('./lib/twitter')
    Twitter(app, usermanip, passport, _pingFrontend)
    _initUserInfoRoute = true

  # var GithubStrategy = require('passport-github').Strategy;

  if 'GOOGLECLIENTID' of process.env
    Google = require('./lib/google')
    Google(app, usermanip, passport, _pingFrontend)
    _initUserInfoRoute = true

  if _initUserInfoRoute
    app.get '/userinfo', (req, res) ->
      token = req.query.token
      jwt.verify token, process.env.SERVER_SECRET, (err, decoded) ->
        if err
          res.status(404).send 'TOKEN_NOT_VALID'
        else
          res.send
            user: decoded
            token: getToken(decoded)

  app.use (err, req, res, next) ->
    if err.name and err.name == 'AuthenticationError'
      return res.status(401).send('CREDENTIALS_NOT_VALID')
    next(err)

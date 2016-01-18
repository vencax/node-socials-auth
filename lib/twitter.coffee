TwitterStrategy = require('passport-twitter').Strategy

module.exports = (app, usermanip, passport, postAuthFunc) ->

  passport.use new TwitterStrategy
    consumerKey: process.env.TWITTERCONSUMERKEY
    consumerSecret: process.env.TWITTERCONSUMERSECRET
    callbackURL: process.env.AUTH_URL + '/twitter/callback'
  , (accessToken, refreshToken, profile, done) ->
    email = profile.username + '@twitter.com'
    usermanip.find [{email: email}], (err, user) ->
      if !user
        user = usermanip.build
          email: email
          name: profile.displayName
      usermanip.save user, (err, user) ->
        done null, user

  session = require('express-session')
  app.use session
    secret: process.env.SERVER_SECRET
    saveUninitialized: true
    resave: true
  app.get '/twitter', passport.authenticate('twitter')
  app.get '/twitter/callback', passport.authenticate('twitter', session: false), postAuthFunc

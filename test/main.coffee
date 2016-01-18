
should = require('should')
http = require('http')
fs = require('fs')
bodyParser = require('body-parser')
express = require('express')

process.env.SERVER_SECRET='fhdsakjhfkjal'
process.env.FBCLIENTID='fhdsakjhfkjal'
process.env.FBCLIENTSECRET='fhdsakjhfkjal'
process.env.TWITTERCONSUMERKEY='fhdsakjhfkjal'
process.env.TWITTERCONSUMERSECRET='fhdsakjhfkjal'
process.env.GOOGLECLIENTID='fhdsakjhfkjal'
process.env.GOOGLECLIENTSECRET='fhdsakjhfkjal'
# process.env.DATABASE_URL = 'sqlite://db.sqlite'
port = process.env.PORT || 3333
g =
  sentemails: []

sendMail = (mail, cb) ->
  g.sentemails.push mail
  cb()

getToken = ()->
  return 'ahoy'

# entry ...
describe "app", ->

  apiMod = require(__dirname + '/../index')

  Sequelize = require('sequelize')

  before (done) ->
    this.timeout(5000)
    # init server
    app = express()

    sequelize = new Sequelize process.env.DATABASE_URL || 'sqlite:',
      dialect: 'sqlite'  # sqlite! now!
    # register models
    mdlsMod = require(__dirname + '/models')
    mdlsMod(sequelize, Sequelize)

    sequelize.sync(logging: console.log).then () ->

      api = express()
      api.use(bodyParser.urlencoded({ extended: false }))
      api.use(bodyParser.json())

      manip = g.manip = require('./sequelize_manip')(sequelize)
      apiMod api, manip, getToken

      app.use('/', api)

      g.server = app.listen port, (err) ->
        return done(err) if err
        setTimeout () ->
          done()
        , 1500

      g.app = app

  after (done) ->
    g.server.close()
    done()

  it "should exist", (done) ->
    should.exist g.app
    done()

  # run the rest of tests
  g.baseurl = "http://localhost:#{port}"

  Register = require('./socials')
  Register(g)


should = require('should')
request = require('request')

module.exports = (g) ->

  addr = g.baseurl

  it "must at least return some error from google", (done) ->
    request.get "#{addr}/google", (err, res, body) ->
      return done(err) if err
      res.statusCode.should.eql 401
      body.indexOf('That’s all we know.').should.be.above 0
      done()

  it "must at least return some error from facebook", (done) ->
    request.get "#{addr}/facebook", (err, res, body) ->
      return done(err) if err
      res.statusCode.should.eql 200
      body.length.should.be.above 100
      done()

  # it "must at least return some error from twitter", (done) ->
  #   request.get "#{addr}/twitter", (err, res, body) ->
  #     return done(err) if err
  #     console.log body
  #     res.statusCode.should.eql 200
  #     body.length.should.be.above 100
  #     done()

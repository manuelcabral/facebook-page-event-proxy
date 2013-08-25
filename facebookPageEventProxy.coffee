request = require('request')
restify = require('restify')

module.exports = (appConfig, port) ->
  baseURL = "https://graph.facebook.com"
  tokenURL = "#{baseURL}/oauth/access_token?client_id=#{appConfig.appID}&client_secret=#{appConfig.secret}&grant_type=client_credentials"

  request tokenURL, (err, response, body) ->
    if err? then return console.error(err)
    accessToken = body.match(/access_token=(.+)/)[1]

    server = restify.createServer()
    server.get '/:pageName', (req, res) ->


      request "#{baseURL}/#{req.params.pageName}/events?access_token=#{accessToken}", (err, response, body) ->
        if err then res.send(404, err)
        else res.send(200, JSON.parse(body))

    server.listen port, ->
      console.log('%s listening at %s', server.name, server.url)
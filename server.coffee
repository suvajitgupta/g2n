express = require 'express'
assets = require 'connect-assets'
routes = require './routes'
port = process.env.PORT or 3000

module.exports = app = express.createServer()

app.set 'view engine', 'jade'
app.use assets src: "#{__dirname}/assets"
app.use express.favicon()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session secret: 'randomstuffherethatstryingtobeasecret12@@124'
app.use app.router
app.use express.static "#{__dirname}/public"

# setup defaults
app.helpers
  title: "G2N PoC"

# setup routes
app.get  '/', routes.show_buildings
app.get  '/buildings', routes.show_buildings
app.get '/building/:building_id/meters', routes.show_building_meters
app.get '/meter/:meter_id/readings', routes.show_meter_readings

# start server
app.listen port, -> console.log "Listening @ http://0.0.0.0:#{port}"

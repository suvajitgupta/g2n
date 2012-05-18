express = require 'express'
assets = require 'connect-assets'
routes = require './routes'
port = process.env.PORT or 3000
middleware =
  building: require './middleware/building'
  meter: require './middleware/meter'

app = express.createServer()
app.use assets src: "#{__dirname}/assets"
app.set 'view engine', 'jade'
app.set 'view options', { layout: false }
app.use express.favicon()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session secret: 'randomstuffherethatstryingtobeasecret12@@124'
app.use app.router
app.use express.static "#{__dirname}/public"

#middleware
app.param 'building_id', middleware.building
app.param 'meter_id', middleware.meter

# setup defaults
app.helpers
  title: "G2N PoC"

# setup routes
routes.register(app);

# start server
app.listen port, -> console.log "Listening @ http://0.0.0.0:#{port}"

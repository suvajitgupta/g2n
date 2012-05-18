meters = new (require '../../repositories/meters')()

module.exports = (app) ->
  app.get '/chart/readings/:building_id/:meter_id', (req, res, next) ->
    building = req.building
    meter = req.meter
    meter_id = req.params.meter_id

    meters.get_readings meter_id, (err, readings) ->
      reading_begin = Date.parse readings[0].createdAt      
      res.json
        reading_begin: reading_begin
        readings: readings
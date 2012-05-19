meters = new (require '../../repositories/meters')()

module.exports = (app) ->
  app.get '/chart/readings/:building_id/:meter_id', (req, res, next) ->
    building = req.building
    meter = req.meter
    meter_id = req.params.meter_id

    meters.get_readings meter_id, (err, readings) ->
      yAxis =
        title: 'Kilowatt Hours (kw)'
      
      chart_data =
        title: 'Meter Readings (kW)'
        type: 'line'
        xAxis:
          type: 'datetime'
        yAxis: [ yAxis ]
        data_name: 'Meter Reading'
        data: readings.map (reading) -> [ Date.parse(reading.createdAt), reading.kW ]
      res.json chart_data
meters = new (require '../repositories/meters')()

show_meter_details = (req, res, next)->
  building = req.building
  meter = req.meter
  meter_id = req.params.meter_id
  
  meters.get_readings meter_id, (err, readings) ->
    chart_start =
      day: readings[0].createdAt.getDay()
      month: readings[0].createdAt.getMonth()
      year: readings[0].createdAt.getYear()
      hour: readings[0].createdAt.getHours()
      min: readings[0].createdAt.getMinutes()

    timestamps = readings.map (reading) -> '\'' + reading.timestamp + '\''
    kWs = readings.map (reading) -> reading.kW
    ret =
      header: "#{building.name}.#{meter.name}: #{readings.length} Readings"
      chart_start: chart_start
      readings: readings
      timestamps: timestamps
      kWs: kWs
    res.render 'readings', ret

module.exports =
  register: (app) ->
    app.get '/building/:building_id/meter/:meter_id/readings', show_meter_details
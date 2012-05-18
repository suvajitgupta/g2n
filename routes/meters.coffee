meters = new (require '../repositories/meters')()

show_meter_details = (req, res, next)->
  building = req.building
  meter = req.meter
  meter_id = req.params.meter_id
  
  meters.get_readings meter_id, (err, readings) ->
    utc_start = Date.parse readings[0].createdAt
    
    timestamps = readings.map (reading) -> '\'' + reading.timestamp + '\''
    kWs = readings.map (reading) -> reading.kW
    ret =
      building_name: building.name
      meter_name: meter.name
      chart_start: utc_start
      readings: readings
      timestamps: timestamps
      kWs: kWs
    res.render 'readings', ret

module.exports =
  register: (app) ->
    app.get '/building/:building_id/meter/:meter_id/readings', show_meter_details
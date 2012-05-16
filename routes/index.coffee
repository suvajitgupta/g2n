mongoose        = require 'mongoose'
config          = require '../config'
db              = mongoose.connect config.db_url
mongoose.connection.on "open", -> console.log "Connected to Mongooose\n"
mongoose.connection.on "error", (err, res) -> console.log "Mongoose error occured: #{err}"

properties      = require '../models/properties'
readings        = require '../models/readings'

module.exports =
  
  index: (req, res, next) ->
    res.render 'index'
    
  show_buildings: (req, res, next) ->
    properties.Building.find {}, {}, (err, buildings) ->
      return next err if err?
      ret =
        header: "#{buildings.length} Buildings"
        buildings: buildings
      res.render 'buildings', ret

  show_building_meters: (req, res, next)->
    properties.Building.find {_id: req.params.building_id}, {}, (err, buildings) ->
      return next err if err?
      building = buildings[0]
      ret =
        header: "#{building.name}: #{building.meters.length} Meters"
        meters: building.meters
      res.render 'meters', ret

  show_meter_readings: (req, res, next)->
    properties.Building.find {'meters._id': req.params.meter_id}, {}, (err, buildings) ->
      return next err if err?
      building = buildings[0]
      meter = building.meters[0]
      readings.MeterReading.find {'meterId': req.params.meter_id}, {}, (err, readings) ->
        return next err if err?
        for reading in readings
          reading.timestamp = reading.createdAt.getHours() + ':' + reading.createdAt.getMinutes()
          
        timestamps = readings.map (reading) -> '\'' + reading.timestamp + '\''
        kWs = readings.map (reading) -> reading.kW
        ret =
          header: "#{building.name}.#{meter.name}: #{readings.length} Readings"
          readings: readings
          timestamps: timestamps
          kWs: kWs
        res.render 'readings', ret
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
    properties.Building.find {}, {}, (err, docs) ->
      return next err if err?
      ret =
        header: "#{docs.length} Buildings"
        records: docs
      res.send ret

  show_building_meters: (req, res, next)->
    properties.Building.find {_id: req.params.building_id}, {}, (err, docs) ->
      return next err if err?
      ret =
        header: "#{docs[0].name}: #{docs[0].meters.length} Meters"
        records: docs[0].meters
      res.send ret

  show_meter_readings: (req, res, next)->
    properties.Building.find {'meters._id': req.params.meter_id}, {}, (err, buildings) ->
      return next err if err?
      building = buildings[0]
      meter = building.meters[0]
      readings.MeterReading.find {'meterId': req.params.meter_id}, {}, (err, readings) ->
        return next err if err?
        ret =
          header: "#{building.name}.#{meter.name}: #{readings.length} Readings"
          readings: readings
        res.render 'readings', ret
    
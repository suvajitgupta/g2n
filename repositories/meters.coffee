Repository = require './repository'
config     = require '../config'
model      = require '../models/properties'
readings   = require '../models/readings'

module.exports = class Meters extends Repository
  constructor: () ->
    super config, model.Building
    
  findById: (id, cb) ->
    throw 'no callback specified' unless cb?
    model.Building.find {'meters._id': id}, {}, (err, meters) ->
      return cb err if err?
      return cb null, null if not meters.length
      cb null, meters[0]

  get_readings: (meter_id, cb) ->
    readings.MeterReading.find {'meterId': meter_id}, {}, (err, readings) ->
      modified_readings = readings.map (reading) ->
        reading.timestamp = reading.createdAt.getHours() + ':' + reading.createdAt.getMinutes()
      cb err, readings
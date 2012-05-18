charts = require './charts'
meter_readings = require './meter_readings'

module.exports = (app) ->
  charts: charts app
  meter_readings: meter_readings app
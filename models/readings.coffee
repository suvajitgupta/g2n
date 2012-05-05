mongoose	= require 'mongoose'
Schema    = mongoose.Schema


building_reading_schema = new Schema
  buildingId: Schema.ObjectId
  timestamp:  Date
  humidity:   Number
  occupancy:  Number

BuildingReading  = mongoose.model "building_reading", building_reading_schema


meter_reading_schema = new Schema
  meterId:    Schema.ObjectId
  timestamp:  Date
  kW:         Number

MeterReading  = mongoose.model "meter_reading", meter_reading_schema


module.exports = { BuildingReading, MeterReading }
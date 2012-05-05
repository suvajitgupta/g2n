mongoose	= require 'mongoose'
Schema    = mongoose.Schema


meter_schema = new Schema
  type:       { type: String, enum: ['Meter', 'Submeter'] }
  name:       String
  building:   String
  utility:    String
	createdAt:  Date
	updatedAt:  Date

square_feet_validator = (v)->
  return v > 0

building_schema = new Schema
  name:       String
  squareFeet: { type: Number, validate: [ square_feet_validator, 'invalid building square feet' ] }
  owner:      String
  meters:     [meter_schema]
	createdAt:  Date
	updatedAt:  Date

Building  = mongoose.model "building", building_schema

meter_reading_schema = new Schema
  meterId:    Schema.ObjectId
  timestamp:  Date
  kW:         Number

MeterReading  = mongoose.model "meter_reading", meter_reading_schema

module.exports = { Building, MeterReading }
mongoose	= require 'mongoose'
Schema    = mongoose.Schema

meter_schema = new Schema
  type:       { type: String, enum: ['Meter', 'Submeter'] }
  name:       String
  building:   String
  utility:    String
	createdAt:  Date
	updatedAt:  Date

square_footage_validator = (v)->
  return v > 0

building_schema = new Schema
  name:       String
  squareFootage: { type: Number, validate: [ square_footage_validator, 'invalid building square feet' ] }
  owner:      String
  meters:     [meter_schema]
	createdAt:  Date
	updatedAt:  Date

Building  = mongoose.model "building", building_schema

module.exports = { Building }
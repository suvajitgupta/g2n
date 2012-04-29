mongoose	= require 'mongoose'
Schema    = mongoose.Schema


type_validator = (v)->
  return v is "Meter" or v is "Submeter"

meter_schema = new Schema
  Type:       { type: String, validate: [ type_validator, 'unknown meter type' ] }
  Name:       String
  Building:   String
	CreatedAt:  Date
	UpdatedAt:  Date

Meter  = mongoose.model "meter", meter_schema


square_feet_validator = (v)->
  return v > 0

building_schema = new Schema
  Name:       String
  Utility:    String
  SquareFeet: { type: Number, validate: [ square_feet_validator, 'invalid building square feet' ] }
  Owner:      String
	CreatedAt:  Date
	UpdatedAt:  Date

Building  = mongoose.model "building", building_schema


module.exports = { Meter, Building }
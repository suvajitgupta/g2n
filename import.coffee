config          = require './config'
mongoose        = require 'mongoose'
db              = mongoose.connect config.db_url
csv             = require 'csv'
properties      = require './models/properties'
readings        = require './models/readings'

add_doc = (Model, doc, cb) ->
  m = new Model doc
  m.save (err) ->
    cb() if cb?
    if err
      console.log err
      return err
    else
      return m
      
properties.Building.find {name: "50 West"}, {name:true, meters: true}, (err, docs) ->
  building_id = docs[0]._id
  building_name = docs[0].name
  console.log "Building Name: #{building_name}"
  
  meter_id = docs[0].meters[1]._id
  meter_name = docs[0].meters[1].name
  console.log "Meter Name: #{meter_name}"
  
  csv()
  .fromPath("#{__dirname}/import.csv")
  .on 'data', (data, idx)->
    meter_reading =
      meterId: meter_id
      createdAt: new Date("#{data[0]} #{data[1]}"),
      kW: data[2]
    add_doc readings.MeterReading, meter_reading, () -> console.log meter_reading
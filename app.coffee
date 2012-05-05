config          = require './config'
mongoose        = require 'mongoose'
db              = mongoose.connect config.db_url
properties      = require './models/properties'
readings        = require './models/readings'
properties_data = require './sample_data/properties_data'
readings_data   = require './sample_data/readings_data'
counter         = 0

mongoose.connection.on "open", -> console.log "Connected to Mongooose\n"
mongoose.connection.on "error", (err, res) -> console.log "Mongoose error occured: #{err}"
shutdown = ->
  mongoose.disconnect()
  console.log "\nDisconnected from Mongoose"

add_doc = (Model, doc, cb) ->
  m = new Model doc
  console.log m
  m.save (err) ->
    console.log "Err %{err}"
    cb() if cb?
    if err
      console.log err
      return err
    else
      return m

update_cb = (docs)->
  (err, num_affected) ->
    print_docs docs if ++counter == properties_data.buildings.length
  
update_doc = (Model, doc, cb) ->
  Model.update {name: doc.name}, {updatedAt: new Date}, null, cb
  
print_doc = (doc) ->
  console.log "********************************************************************************"
  for own key, value of doc.toObject()
    console.log "#{key}: #{value}" if key isnt "_id"

print_docs = (docs) ->
  print_doc doc for doc in docs
  shutdown()

remove_doc = (Model, doc) ->
  Model.remove {name: doc.name}, (err)->
    console.log "Removed #{doc.name}" if not err
    shutdown()
  
done_cb = (array)->
  if ++counter == array.length
    shutdown()
  
seed_docs = (Model, done) ->
  for building in properties_data.buildings
    building.createdAt = building.updatedAt = new Date
    add_doc Model, building, done

# seed_docs properties.Building, done_cb(properties_data.buildings)

properties.Building.find {name: "50 West"}, {name:true, meters: true}, (err, docs) ->
  building_id = docs[0]._id
  building_name = docs[0].name
  console.log "Building Name: #{building_name}"
  for building_reading in readings_data.building_readings
    building_reading.buildingId = building_id
    building_reading.timestamp = new Date
    add_doc readings.BuildingReading, building_reading, null
  meter_id = docs[0].meters[0]._id
  meter_name = docs[0].meters[0].name
  console.log "Meter Name: #{meter_name}"
  for meter_reading in readings_data.meter_readings
    meter_reading.meterId = meter_id
    meter_reading.timestamp = new Date
    add_doc readings.MeterReading, meter_reading, done_cb(readings_data.meter_readings)

# properties.Building.find {name: "50 West"}, {name:true, meters: true}, (err, docs) ->
#   building_id = docs[0]._id
#   building_name = docs[0].name
#   console.log "Building Name: #{building_name}"
#   readings.BuildingReading.find {buildingId: building_id}, {temperature: true, timestamp: true}, (err, docs) ->
#     print_docs docs
#     meter_id = docs[0].meters[0]._id
#     meter_name = docs[0].meters[0].name
#     console.log "Meter Name: #{meter_name}"
#     readings.MeterReading.find {meterId: meter_id}, {kW: true, timestamp: true}, (err, docs) ->
#       print_docs docs
#       shutdown()
    
# update_doc properties.Building, doc, update_cb(docs) for doc in docs
# remove_doc docs[0]
# properties.Building.remove {}, (err)->shutdown()

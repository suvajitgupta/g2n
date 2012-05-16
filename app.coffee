config          = require './config'
mongoose        = require 'mongoose'
db              = mongoose.connect config.db_url
properties      = require './models/properties'
readings        = require './models/readings'
properties_data = require './sample_data/properties_data'
readings_data   = require './sample_data/readings_data'
counter         = 0

shutdown = ->
  mongoose.disconnect()
  console.log "\nDisconnected from Mongoose"

add_doc = (Model, doc, cb) ->
  m = new Model doc
  console.log m
  m.save (err) ->
    cb() if cb?
    if err
      console.log err
      return err
    else
      return m

update_cb = ->
  (err, num_affected) ->
    console.log err if err?
    shutdown()
  
update_doc = (Model, doc, cb) ->
  Model.update {name: doc.name}, {updatedAt: new Date}, null, cb
  
print_doc = (doc) ->
  console.log "********************************************************************************"
  for own key, value of doc.toObject()
    console.log "#{key}: #{value}" if key isnt "_id"

print_docs = (docs, cb) ->
  print_doc doc for doc in docs
  cb() if cb?

remove_doc = (Model, doc, cb) ->
  Model.remove {name: doc.name}, (err)->
    console.log "Removed #{doc.name}" if not err
    cb() if cb?
  
done_cb = (array)->
  ->
    if ++counter == array.length
      shutdown()
  
seed_docs = (Model, done) ->
  for building in properties_data.buildings
    building.createdAt = building.updatedAt = new Date
    add_doc Model, building, done

# seed_docs properties.Building, done_cb(properties_data.buildings)

# properties.Building.find {name: "50 West"}, {name:true, meters: true}, (err, docs) ->
#   building_id = docs[0]._id
#   building_name = docs[0].name
#   console.log "Building Name: #{building_name}"
#   done = done_cb(readings_data.building_readings)
#   date = (new Date()).getTime();
#   fifteenMinutes = 15*60*1000;
#   for building_reading, i in readings_data.building_readings
#     building_reading.buildingId = building_id
#     building_reading.createdAt = new Date(date + i*4*fifteenMinutes)
#     add_doc readings.BuildingReading, building_reading, done
#   meter_id = docs[0].meters[0]._id
#   meter_name = docs[0].meters[0].name
#   console.log "Meter Name: #{meter_name}"
#   done = done_cb(readings_data.meter_readings)
#   for meter_reading, i in readings_data.meter_readings
#     meter_reading.meterId = meter_id
#     meter_reading.createdAt = new Date(date + i*fifteenMinutes)
#     add_doc readings.MeterReading, meter_reading, done


# properties.Building.find {name: "50 West"}, {name:true, meters: true}, (err, docs) ->
#   building_id = docs[0]._id
#   building_name = docs[0].name
#   console.log "Building Name: #{building_name}"
#   meter_id = docs[0].meters[0]._id
#   meter_name = docs[0].meters[0].name
#   console.log "Meter Name: #{meter_name}"
#   readings.BuildingReading.find {buildingId: building_id}, {temperature: true, createdAt: true}, (err, docs) ->
#     print_docs docs, null
#     readings.MeterReading.find {meterId: meter_id}, {kW: true, createdAt: true}, (err, docs) ->
#       print_docs docs, shutdown
#       shutdown()

# update_doc properties.Building, doc, update_cb(docs)
# remove_doc properties.Building, docs[0], shutdown

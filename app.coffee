config      = require './config'
mongoose    = require 'mongoose'
db          = mongoose.connect config.db_url
properties  = require './models/properties'
readings    = require './models/readings'
counter     = 0

mongoose.connection.on "open", -> console.log "Connected to Mongooose\n"
mongoose.connection.on "error", (err, res) -> console.log "Mongoose error occured: #{err}"
shutdown = ->
  mongoose.disconnect()
  console.log "\nDisconnected from Mongoose"

buildings = [
  name: "50 West"
  squareFeet: 203440
  owner: "BECO Management"
  meters: [
    name: "House Load"
    building: "50 West"
    utility: "Dominion"
  ,
    name: "Tenant Load"
    building: "50 West"
    utility: "Dominion"
  ]
,
  name: "Fernwood"
  squareFeet: 235417
  owner: "Meritage Property Management"
  meters: [
    name: "Feed A"
    building: "Fernwood"
    utility: "Pepco"
  ,
    name: "Feed B"
    building: "Fernwood"
    utility: "Pepco"
  ,
    name: "Feed C"
    building: "Fernwood"
    utility: "Pepco"
  ]
,
  name: "Ten15"
  squareFeet: 99916
  owner: "Donohoe"
  meters: [
    name: "Building"
    building: "Ten15"
    utility: "Pepco-DC"
  ,
    name: "Motor Control"
    building: "Ten15"
    utility: "Pepco-DC"
  ]
,
  name: "Homer"
  squareFeet: 300000
  owner: "Akridge Property Management"
  meters: [
    name: "B"
    building: "Homer"
    utility: "Pepco-DC"
  ,
    name: "D"
    building: "Homer"
    utility: "Pepco-DC"
  ,
    name: "North C"
    building: "Homer"
    utility: "Pepco-DC"
  ,
    name: "South A"
    building: "Homer"
    utility: "Pepco-DC"
  ]
]

meter_readings = [
  kW: 207.4
,
  kW: 217.7
,
  kW: 207.4
,
  kW: 197
,
  kW: 207.4
,
  kW: 207.4
,
  kW: 217.7
,
  kW: 487.3
,
  kW: 580.6
,
  kW: 207.4
]


add_doc = (Model, doc, cb) ->
  console.log doc
  doc.createdAt = doc.updatedAt = new Date
  r = new Model doc
  r.save (err) ->
    cb()
    if err
      console.log err
      return err
    else
      return r

update_cb = (docs)->
  (err, num_affected) ->
    print_docs docs if ++counter == buildings.length
  
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
  
done_cb = ->
  if ++counter == buildings.length
    shutdown()
  
seed_docs = (Model, done) ->
  add_doc Model, building, done_cb for building in buildings

seed_docs properties.Building, done_cb

# properties.Building.find {name: "50 West"}, {meters: true}, (err, docs) ->
#   meter_id = docs[0].meters[0]._id
#   console.log "Meter ID: #{meter_id}"
#   for meter_reading in meter_readings
#     meter_reading.meterId = meter_id
#     meter_reading.timestamp = new Date
#     add_doc readings.MeterReading, meter_reading, done_cb

# properties.Building.find {name: "50 West"}, {meters: true}, (err, docs) ->
#   meter_id = docs[0].meters[0]._id
#   meter_name = docs[0].meters[0].name
#   console.log "Meter Name: #{meter_name}"
#   readings.MeterReading.find {meterId: meter_id}, {kW: true, timestamp: true}, (err, docs) ->
#     print_docs docs
#     shutdown()
    
# update_doc properties.Building, doc, update_cb(docs) for doc in docs
# remove_doc docs[0]
# properties.Building.remove {}, (err)->shutdown()

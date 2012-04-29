config   = require './config'
mongoose = require 'mongoose'
db       = mongoose.connect config.db_url
models   = require './models'
counter  = 0

mongoose.connection.on "open", -> console.log "Connected to Mongooose\n"
mongoose.connection.on "error", (err, res) -> console.log "Mongoose error occured: #{err}"
shutdown = ->
  mongoose.disconnect()
  console.log "\nDisconnected from Mongoose"

meters = [
  Name: "House Load"
  Building: "50 West"
,
  Name: "Tenant Load"
  Building: "50 West"
,
  Name: "Feed A"
  Building: "Fernwood"
,
  Name: "Feed B"
  Building: "Fernwood"
,
  Name: "Feed C"
  Building: "Fernwood"
,
  Name: "Building"
  Building: "Ten15"
,
  Name: "Motor Control"
  Building: "Ten15"
,
  Name: "B"
  Building: "Homer"
,
  Name: "D"
  Building: "Homer"
,
  Name: "North C"
  Building: "Homer"
,
  Name: "South A"
  Building: "Homer"
,
]

buildings = [
  Name: "50 West"
  Utility: "Dominion"
  SquareFeet: 203440
  Owner: "BECO Management"
,
  Name: "Fernwood"
  Utility: "Pepco"
  SquareFeet: 235417
  Owner: "Meritage Property Management"
,
  Name: "Ten15"
  Utility: "Pepco-DC"
  SquareFeet: 99916
  Owner: "Donohoe"
,
  Name: "Homer"
  Utility: "Pepco-DC"
  SquareFeet: 300000
  Owner: "Akridge Property Management"
]

add_record = (Model, record, cb) ->
  record.CreatedAt = record.UpdatedAt = new Date
  r = new Model record
  r.save (err) ->
    cb()
    if err
      console.log err
      return err
    else
      return r

update_cb = (docs)->
  (err, num_affected) ->
    print_buildings docs if ++counter == buildings.length
  
update_building = (building, cb) ->
  models.Building.update {Name: building.Name}, {UpdatedAt: new Date}, null, cb
  
print_building = (doc) ->
  console.log "********************************************************************************"
  for own key, value of doc.toObject()
    console.log "#{key}: #{value}" if key isnt "_id"

print_buildings = (docs) ->
  print_building doc for doc in docs
  shutdown()

remove_building = (building) ->
  models.Building.remove {Name: building.Name}, (err)->
    console.log "Removed #{building.Name}" if not err
    shutdown()
  
done = ->
  if ++counter == buildings.length
    shutdown()
  
seed_data = (done) ->
  add_record models.Meter, meter, done for meter in meters
  add_record models.Building, building, done for building in buildings

models.Building.find {}, (err, docs) ->
  return console.log err if err
  if docs is null || docs.length is 0
    seed_data done
  else
    update_building building, update_cb(docs) for building in docs
    # remove_building docs[0]

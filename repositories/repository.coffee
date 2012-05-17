mongoose = require 'mongoose'

module.exports = class
  constructor: (@config, @Model) ->
    throw 'no config specified' unless @config?
    throw 'no model specified' unless @Model?
    mongoose.connect config.db_url
    mongoose.connection.on "open", -> console.log "Connected to Mongooose\n"
    mongoose.connection.on "error", (err, res) -> console.log "Mongoose error occured: #{err}"

  all: (cb) =>
    throw 'no callback specified' unless cb?
    @Model.find {}, {}, (err, results) ->
      cb err, results
      
  findById: (id, cb) =>
    throw 'no callback specified' unless cb?
    @Model.find { _id: id }, {}, (err, items) ->
      return cb err if err?
      return cb null, null if not items.length
      cb null, items[0]
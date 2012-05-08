config          = require '../config'
mongoose        = require 'mongoose'
db              = mongoose.connect config.db_url
properties      = require '../models/properties'
readings        = require '../models/readings'

module.exports =
  
  index: (req, res, next) ->
    res.render 'index'
    
  show_buildings: (req, res, next) ->
    properties.Building.find {}, {}, (err, docs) ->
      return next err if err?
      ret =
        title: "#{docs.length} Buildings"
        records: docs
      res.send ret

  show_building_meters: (req, res, next)->
    properties.Building.find {_id: req.params.id}, {}, (err, docs) ->
      ret =
        title: "#{docs[0].name}: #{docs[0].meters.length} Meters"
        records: docs[0].meters
      res.send ret
    
Repository = require './repository'
config     = require '../config'
model      = require '../models/properties'

module.exports = class Buildings extends Repository
  constructor: () ->
    super config, model.Building
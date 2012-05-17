buildings = require './buildings'
meters    = require './meters'

module.exports =
  register: (app) ->
    buildings.register app
    meters.register app
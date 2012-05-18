buildings = require './buildings'
charts  = require './charts'

module.exports =
  register: (app) ->
    buildings app
    charts app
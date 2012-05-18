buildings = new (require '../repositories/buildings')()

show_all_buildings = (req, res, next) ->
  buildings.all (err, buildings) ->
    return next err if err?
    res.render 'buildings', { header: "#{buildings.length} Buildings", buildings: buildings }
    
show_building_meters = (req, res, next) ->
  building = req.building
  res.render 'meters', { building, meters: building.meters }

module.exports = (app) ->
  app.get '/', show_all_buildings
  app.get '/buildings', show_all_buildings
  app.get '/building/:building_id/meters', show_building_meters
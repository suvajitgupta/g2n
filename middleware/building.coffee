buildings = new (require '../repositories/buildings')()

module.exports = (req, res, next, id) ->
  buildings.find_by_id id, (err, building) ->
    return res.send "building not found", 404 unless err? or building?
    return res.send err, 500 if err?
    req.building = building
    next()
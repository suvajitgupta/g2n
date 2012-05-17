meters = new (require '../repositories/meters')()

module.exports = (req, res, next, id) ->
  if req.building
    req.meter = req.building.meters.filter (meter) ->
      meter._id == id
  else
    meters.findById id, (err, meter) ->
      return res.send "meter not found", 404 unless err? or meter?
      return res.send err, 500 if err?
      req.meter = meter
  next()
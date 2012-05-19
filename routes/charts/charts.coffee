chart_types = require '../../lib/chart_types'

module.exports = (app) ->
  app.get '/charts/:chart_type', (req, res, next) ->
    chart_type = req.params.chart_type
    chart = chart_types[chart_type]
    
    chart.url = chart.url.replace "{{#{param}}}", value for param, value of req.query
    res.render 'chart', { chart }
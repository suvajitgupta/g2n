chart_urls =
  meter_readings: '/chart/readings/{{buildingId}}/{{meterId}}'

module.exports = (app) ->
  app.get '/charts/:chart_type', (req, res, next) ->
    chart_type = req.params.chart_type
    chart_data_url = chart_urls[chart_type]
    
    chart_data_url = chart_data_url.replace "{{#{param}}}", value for param, value of req.query
    res.render 'chart', { chart_data_url: chart_data_url }
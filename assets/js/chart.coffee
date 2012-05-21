#= require 'lib/jquery.min.js'
#= require 'lib/highcharts/highcharts.js'
#= require 'lib/highcharts/modules/exporting.js'

$ = jQuery

create_yAxis = (axis) ->
  yAxis =
    title:
      text: axis.title

render_chart = (target, zoom_type) ->
  (response) ->
    graph_options =
      chart:
        renderTo: target.attr 'id'
        type: response.type or 'bar'
        zoomType: zoom_type or ''
      title:
        text: response.title or ''
        
    graph_options.xAxis = response.xAxis if response.xAxis?

    graph_options.yAxis = [] if response.yAxis?
    graph_options.yAxis.push create_yAxis(axis) for axis in response.yAxis

    graph_options.series = [{ data: response.data, name: response.data_name }]
    graph = new Highcharts.Chart graph_options

render_failure = (target) ->
  (response) ->
    $(target).html 'An error occurred. Your chart could not be loaded'
    
load_chart = (url, target, zoom_type) ->
  target.html 'Loading Chart...'
  $.get(url).success(render_chart target, zoom_type).fail(render_failure target)

$.fn.chart = (url, options) ->
  zoom = ''
  zoom = 'xy' if options?.zoomable
  load_chart url, @, zoom

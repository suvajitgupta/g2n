$ = jQuery
$.fn.chart = (options, data) ->
  @.each () ->
    target = $(@).attr 'id'
    
    graph_options =
      chart:
        renderTo: target
        type: options.type or 'bar'
      series: []
    graph_options.series.push { data }
    
    graph = new Highcharts.Chart graph_options
      
    
    # function(target, options, data) {
    #   var graph = new Highcharts.Chart({
    #     chart: {
    #       zoomType: 'x',
    #     },
    #     title: {
    #       text: options.title
    #     },
    #     xAxis: {
    #       type: 'datetime',
    #       maxZoom: 15 * 60 * 1000
    #     },
    #     yAxis: { 
    #       title: { 
    #         text: options.yAxis.title 
    #       } 
    #     },
    #     series: [{
    #       pointStart: Date.UTC(#{chart_start.year},#{chart_start.month},#{chart_start.day}, #{chart_start.hour}, #{chart_start.min}),
    #       pointInterval: 15 * 60 * 1000,
    #       data: data
    #     }]
    #   });
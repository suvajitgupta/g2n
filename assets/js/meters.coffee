#= require 'lib/bootstrap.min.js'
#= require 'chart'

$(document).ready () ->
  $("a[rel=popover]").click (e) ->
    chart = $ '#chart'
    url = $(@).attr 'href'
    chart.chart url
    e.preventDefault()
#= require 'lib/jquery.min.js'
#= require 'lib/bootstrap.min.js'
#= require 'lib/jquery.validate.min.js'
#= require 'lib/jquery.mustache.js'
#= require 'initialize_spinner.coffee'

hydrateTemplate = (templateID, data)->
  templ = $("##{templateID}-templ").html()
  hydrated = $.mustache templ, data
  return hydrated


$ ->
  $.get '/buildings', (data, textStatus, jqXHR)->
    report = hydrateTemplate 'buildings', data
    $('.page-header').remove()
    $('.row').remove()
    $('#content').append report
    $("a.ajax-link").click (event)->
      event.preventDefault();
      $.get $(this).attr("href"), (data, textStatus, jqXHR)->
        report = hydrateTemplate 'meters', data
        $('.page-header').remove()
        $('.row').remove()
        $('#content').append report

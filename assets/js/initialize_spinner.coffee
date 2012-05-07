#= require 'lib/spin.min.js'

window.initialize_spinner = ->

  spinner_opts =
    lines: 12
    length: 7
    width: 4
    radius: 10
    color: '#000'
    speed: 1
    trail: 60
    shadow: false
    hwaccel: false
    className: 'spinner'
    zIndex: 2e9
    top: 'auto'
    left: 'auto'
  spinner_target = document.getElementById('spinner')
  spinner = new Spinner(spinner_opts).spin(spinner_target)

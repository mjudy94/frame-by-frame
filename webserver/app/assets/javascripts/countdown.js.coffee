fetchFrame = ->
  $.get gon.currentFrameUrl, (frame) ->
    if frame.complete
      location.reload()
    else
      startCountdown frame

drawOnion = ->
  svg = Snap('#canvas')
  # Remove old onion elements
  for element in svg.selectAll ".onion"
    element.remove()
  # Set new onion elements
  for element in svg.selectAll("*")
    element.touchstart().unmouseover().attr class: "onion"

startCountdown = (frame) ->
  return unless frame?

  expiration = new Date(frame.expiration)
  countdown = $('#countdown').css('color', 'black')

  setTime = ->
    timeRemaining = numeral (expiration - Date.now()) / 1000
    if timeRemaining <= 0
      # Logic to load next frame rather than reload the page
      clearInterval interval
      fetchFrame()
      drawOnion()
    else
      countdown.text "Time remaining #{timeRemaining.format('00:00')}"
      countdown.css('color', 'red') if timeRemaining < 5

  setTime()
  interval = setInterval(setTime, 1000) if expiration > Date.now()

$(document).ready ->
  fetchFrame() unless gon.animationComplete || !Snap('#canvas')

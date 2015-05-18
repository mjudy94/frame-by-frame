fetchFrame = ->
  $.get gon.currentFrameUrl, (frame) ->
    Snap('#canvas')?.clear()
    if frame.complete
      location.reload()
    else
      startCountdown frame

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
    else
      countdown.text "Time remaining #{timeRemaining.format('00:00')}"
      countdown.css('color', 'red') if timeRemaining < 5

  setTime()
  interval = setInterval(setTime, 1000) if expiration > Date.now()

$(document).ready ->
  fetchFrame() unless gon.animationComplete

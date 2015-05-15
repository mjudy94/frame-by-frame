$(document).ready ->
  return unless gon.frameExpiration?

  expiration = new Date(gon.frameExpiration)
  countdown = $('#countdown')

  setTime = ->
    timeRemaining = numeral((expiration - Date.now()) / 1000)
    if timeRemaining <= 0
      # Logic to load next frame rather than reload the page
      # location.reload()
    else
      countdown.text "Time remaining #{timeRemaining.format('00:00')}"

  setTime()
  setInterval setTime, 1000

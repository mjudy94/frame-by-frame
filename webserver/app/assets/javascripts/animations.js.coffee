$(document).ready ->
  updateTotal()
  $("form").keyup updateTotal
  $("form").change updateTotal

getUnitFactor = ->
  if $("select[name=timer_units]").val() == "seconds" then 1 else 60

formatTime = (time) ->
  numeral(time).format '0[.]0'

getConvertedTotal = (total) ->
  if total > 86400
    amount: formatTime total / 86400
    units: 'days'
  else if total > 3600
    amount: formatTime total / 3600
    units: 'hours'
  else if total > 60
    amount: formatTime total / 60
    units: 'minutes'
  else
    amount: formatTime total
    units: 'seconds'

updateTotal = ->
  inputs = $("input[type=number]")
  total = parseInt(inputs.eq(0).val(), 10) *
    parseInt(inputs.eq(1).val(), 10) * getUnitFactor()
  converted = getConvertedTotal total

  $('#total_time').text converted.amount
  $('#total_time_units').text converted.units

  videoLength = parseInt(inputs.eq(0).val(), 10) / parseInt(inputs.eq(2).val(), 10)
  converted = getConvertedTotal videoLength

  $('#video_length').text converted.amount
  $('#video_length_units').text converted.units

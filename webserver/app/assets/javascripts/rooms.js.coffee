# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require draw

$(document).ready ->
  $('#copy_message').hide()

  $('#room_url').on 'click', (e) ->
    e.target.select()

  $('#copy_button').on 'click', ->
    $('#room_url').select().focus()
    $('#copy_message').fadeIn 'fast'
    setTimeout ->
      $('#copy_message').fadeOut 'slow'
    , 4000

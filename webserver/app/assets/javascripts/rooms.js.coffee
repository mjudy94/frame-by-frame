# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require draw

$(document).ready ->
  shareDialog = $("#share_dialog")

  shareDialog.dialog
    title: $("#share_dialog").data("title")
    autoOpen: false
    modal: true
    height: 175
    width: 400
    close: ->
      shareDialog.dialog "option", "height", 175
      shareDialog.find("span").hide()

  shareDialog.find('span').hide()

  $('#share_button').on "click", ->
    $("#share_dialog").dialog "open"

  shareDialog.find('textarea').on 'click', (e) ->
    e.target.select()

  $('#copy_button').on 'click', ->
    shareDialog.dialog "option", "height", 225
    shareDialog.find('textarea').select().focus()
    shareDialog.find('span').fadeIn 'fast'

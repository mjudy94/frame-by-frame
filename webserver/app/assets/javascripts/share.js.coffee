$(document).ready ->
  shareDialog = $("#share_dialog")
  copyMessage = shareDialog.find(".copyMessage").hide()

  shareDialog.dialog
    title: $("#share_dialog").data("title")
    autoOpen: false
    modal: true
    height: 300
    width: 500
    close: -> copyMessage.hide()

  $('#share_button').click ->
    $("#share_dialog").dialog "open"

  shareDialog.find('textarea').on 'click', (e) ->
    e.target.select()

  $('#copy_button').click ->
    shareDialog.find('.linkSection textarea').select().focus()
    copyMessage.fadeIn 'fast'

  addEmail = (e) ->
    emailInput = $('#emailInput')
    email = emailInput.val()
    if validateEmail email
      recipient = $("<div></div>").append(email)
        .append($("<input type='hidden' name='to[]'>").val(email))
      shareDialog.find('.recipients').append(recipient)
      emailInput.val("")
    else
      alert "Invalid email"

  emailNum = 0
  shareDialog.find(".addButton").click addEmail
  shareDialog.find('#emailInput').keypress (e) ->
    if e.which == 13
      addEmail(e)
      e.preventDefault()
      return false

validateEmail = (email) ->
  reg = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/
  reg.test email

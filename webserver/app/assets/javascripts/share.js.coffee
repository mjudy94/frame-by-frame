$(document).ready ->
  shareDialog = $(".shareDialog")
  copyMessage = shareDialog.find(".copyMessage").hide()

  shareDialog.dialog
    title: shareDialog.data("title")
    autoOpen: false
    modal: true
    height: 'auto'
    width: 500
    close: -> copyMessage.hide()

  $('.shareButton').click ->
    shareDialog.dialog "open"

  shareDialog.find('textarea').on 'click', (e) ->
    e.target.select()

  $('#copy_button').click ->
    shareDialog.find('.linkSection textarea').select().focus()
    copyMessage.fadeIn 'fast'

  addEmail = (e) ->
    emailInput = $('#emailInput')
    email = emailInput.val()
    if validateEmail email
      shareDialog.find('.recipients').append(createRecipent(email))
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

createRecipent = (email) ->
  $("<div></div>")
    .append $("<input type='hidden' name='to[]'>").val(email)
    .append $("<span class='close'>x</span>").click (e) ->
      $(e.target).parent().remove()
    .append(email)

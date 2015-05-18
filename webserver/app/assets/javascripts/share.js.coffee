$(document).ready ->
  shareDialog = $(".shareDialog")
  copyMessage = shareDialog.find(".copyMessage").hide()
  emailInput = $('#emailInput')
  copyClient = new ZeroClipboard $('#copy_button')

  shareDialog.dialog
    title: shareDialog.data("title")
    autoOpen: false
    modal: true
    height: 'auto'
    width: 500
    close: -> copyMessage.hide()

  $('.shareButton').click ->
    shareDialog.dialog "open"

  shareDialog.find('textarea').click (e) ->
    e.target.select()

  copyClient.on "ready", (event) ->
    copyClient.on 'copy', (event) ->
      clipboard = event.clipboardData;
      textarea = shareDialog.find '.linkSection textarea'
      clipboard.setData "text/plain", textarea.val()

    copyClient.on 'aftercopy', (event) ->
      textarea = shareDialog.find '.linkSection textarea'
      copyMessage.fadeIn 'fast'

  copyClient.on 'error', (event) ->
    ZeroClipboard.destroy();
    $('#copy_button').hide()

  addEmail = (e) ->
    email = emailInput.val()
    if validateEmail email
      shareDialog.find('.recipients').append(createRecipent(email))
      emailInput.val("")

  emailNum = 0
  shareDialog.find(".addButton").click addEmail
  emailInput.keypress (e) ->
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
    .append $("<span class='exit'>x</span>").click (e) ->
      $(e.target).parent().remove()
    .append(email)

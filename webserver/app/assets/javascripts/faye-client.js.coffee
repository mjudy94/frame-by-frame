$(document).ready ->
  unless window.faye?
    if gon.fayeUrl?
      window.faye = new Faye.Client gon.fayeUrl
      window.faye.addExtension
        outgoing : (message, callback) ->
          message['ext'] = message['ext'] ? {}
          message['ext']['room_id'] = gon.roomId
          callback message
    else
      window.faye = null

$(document).on 'page:before-unload', ->
  if window.faye?
    window.faye.disconnect()
    window.faye = null

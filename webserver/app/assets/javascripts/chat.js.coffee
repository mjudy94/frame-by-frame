$ ->
  client = new Faye.Client "http://localhost:9292/faye"

  # Incoming messages
  client.subscribe "/chat", (data) ->
    $(".chat").find("div").append "<p>#{data.msg}"

  # Outgoing messages
  $(".chat").find("form").submit ->
    input = $("input:first")
    client.publish "/chat",
      msg: input.val()
    input.val("")
    false

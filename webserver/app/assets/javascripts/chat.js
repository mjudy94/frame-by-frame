$(function() {
  var client = new Faye.Client("http://localhost:9292/faye");
  var form = $(".chat").find("form");
  var roomId = form.data('id');
  var password = form.data('password');
  var channel = "/chat/" + roomId + "p" + password;

  client.subscribe(channel, function(data) {
    var messageBox = $(".chat").find(".messages");
    messageBox.append("<p>" + data.msg);
    messageBox.animate({
      scrollTop: messageBox.prop("scrollHeight")
    }, "slow");
  });


  form.submit(function() {
    var input = $("input:first");
    client.publish(channel, {
      msg: input.val()
    });
    input.val("");
    return false;
  });
});

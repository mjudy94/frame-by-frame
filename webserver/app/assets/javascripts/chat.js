$(function() {
  var client = new Faye.Client("http://localhost:9292/faye");
  var room_id = $(".chat").find("form").data('id');
  var password = $(".chat").find("form").data('password');
  var channel = "/chat/" + room_id;

  client.subscribe(channel, function(data) {
    $(".chat").find("div").append("<p>" + data.msg);
  });

 
  $(".chat").find("form").submit(function() {
    var input = $("input:first");
    client.publish(channel, {
      password,
      msg: input.val()
    });
    input.val("");
    return false;
  });
});

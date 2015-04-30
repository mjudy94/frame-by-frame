$(function() {
  var client = new Faye.Client("http://localhost:9292/faye"),
      chatWidget = $(".chat"),
      greeting = chatWidget.find(".greeting"),
      messageForm = chatWidget.find(".messageForm"),
      messageBox = chatWidget.find(".messages"),
      nameForm = chatWidget.find('.nameForm'),
      nameInput = nameForm.find("input:first");
      roomId = messageForm.data('id'),
      password = messageForm.data('password'),
      channel = "/chat/" + roomId + "p" + password,
      username = localStorage.getItem('username') || 'Guest',
      userId = guid();

  // MESSAGE SUBSCRIBE
  client.subscribe(channel, function(data) {
    var isOwnMessage = data.userId === userId,
        className =  isOwnMessage ? 'self' : 'other',
        name = isOwnMessage ? 'Me' : data.from;
    messageBox.append("<p><strong class='" + className + "'>" + name +
        ":</strong> " + data.msg);
    messageBox.animate({
      scrollTop: messageBox.prop("scrollHeight")
    }, "slow");
  });

  // MESSAGE INPUT AND PUBLISH
  messageForm.submit(function() {
    var input = messageForm.find("input:first");
    client.publish(channel, {
      msg: input.val(),
      from: username,
      userId: userId
    });
    input.val("");
    return false;
  });

  // NAME DIALOG FORM
  nameForm.dialog({
    title: 'Change your display name',
    autoOpen: false,
    modal: true,
    width: 350,
    open: function() {
      nameInput.val(username).select();
    }
  });

  nameForm.submit(function() {
    nameForm.dialog("close");
    username = nameInput.val();
    localStorage.setItem("username", username);
    updateGreeting();
    return false;
  });

  chatWidget.find('button').click(function() {
    nameForm.dialog("open");
  });

  function updateGreeting() {
    greeting.text(username);
  };

  updateGreeting();
});

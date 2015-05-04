$(function() {
  var chatWidget = $(".chat"),
      client = new Faye.Client(chatWidget.data("faye")),
      titleBar = chatWidget.find('.titleBar'),
      hideButton = titleBar.find(".hideButton"),
      content = chatWidget.find('.content'),
      displayName = chatWidget.find(".displayName"),
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

  // HIDE CHAT
  var isHidden = false;
  hideButton.button({
    text: false,
    icons: {
      primary: "ui-icon-minus"
    }
  }).click(function() {
    if (isHidden) {
      hideButton.button({ icons: { primary: "ui-icon-minus" } });
      content.show("fast");
      isHidden = false;
    } else {
      hideButton.button({ icons: { primary: "ui-icon-plus" } });
      content.hide("fast");
      isHidden = true;
    }
  });

  // DRAG CHAT WIDGET
  chatWidget.draggable({
    axis: 'x',
    handle: titleBar,
    stop: function() {
      chatWidget.css("top", "auto");
    }
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
    updateDisplayName();
    return false;
  });

  displayName.click(function() {
    nameForm.dialog("open");
  });

  function updateDisplayName() {
    displayName.text(username);
  };

  updateDisplayName();
});

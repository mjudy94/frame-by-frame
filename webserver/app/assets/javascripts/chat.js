$(document).ready(function() {
  var chatWidget = $(".chat"),
      titleBar = chatWidget.find('.titleBar'),
      content = chatWidget.find('.content'),
      displayName = chatWidget.find(".displayName"),
      messageForm = chatWidget.find("#messageForm"),
      messageBox = chatWidget.find(".messages"),
      nameForm = chatWidget.find('.nameForm'),
      nameInput = nameForm.find("input:first");
      roomId = gon.roomId,
      password = gon.password,
      channel = "/chat/" + roomId + "p" + password,
      username = localStorage.getItem('username') || 'Guest',
      userId = guid();

  if (!faye) {
    return;
  }

  // MESSAGE SUBSCRIBE
  faye.subscribe(channel, function(data) {
    var isOwnMessage = data.userId === userId,
        className =  isOwnMessage ? 'self' : 'other',
        name = isOwnMessage ? 'Me' : data.from;
    messageBox.append("<p><strong class='" + className + "'>" + name +
      ":</strong> " + data.msg);
    messageBox.animate({
      scrollTop: messageBox.prop("scrollHeight")
    }, "slow");

    // Highlight the titlebar as a notification
    if (!isOwnMessage) {
      titleBar.effect("highlight");
    }
  });

  // MESSAGE INPUT AND PUBLISH
  messageForm.submit(function() {
    var input = messageForm.find("input:first");
    faye.publish(channel, {
      msg: input.val(),
      from: username,
      userId: userId
    });
    input.val("");
    return false;
  });

  // HIDE CHAT
  var isHidden = false;
  titleBar.click(function() {
    if (isHidden) {
      content.show("fast");
      isHidden = false;
    } else {
      content.hide("fast");
      isHidden = true;
    }
  });

  // DRAG CHAT WIDGET
  chatWidget.draggable({
    axis: 'x',
    handle: content,
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
    return false;
  });

  function updateDisplayName() {
    displayName.text(username);
  };

  updateDisplayName();
});

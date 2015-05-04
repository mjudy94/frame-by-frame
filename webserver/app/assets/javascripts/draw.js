(function() {
  var canvas, context;
  var mouseClicked = false;
  
  // Previous frame's mouse position
  var recentX;
  var recentY;
  var drawColor = "rgb(0, 0, 0)";
  var lineWidth = 5;

  var client = new Faye.Client("http://localhost:9292/faye"),
      chatWidget = $(".chat"),
      messageForm = chatWidget.find(".messageForm"),
      roomId = messageForm.data('id'),
      password = messageForm.data('password'),
      channel = "/draw/" + roomId + "p" + password,
      username = localStorage.getItem('username') || 'Guest',
      userId = guid();
      
  //need to subscribe to channel in ruby too   
  client.subscribe(channel, function(data) {
    var isOwnSketchAction = data.userId === userId,
        className = isOwnSketchAction ? 'self' : 'other',
        name = isOwnSketchAction ? 'Me' : data.fromUser;

    //Add isOwnSketchAction as param so sketch knows whether or not to ignore the following sketch request?
    if(!isOwnSketchAction) {
      if(data.action === "sketch") {
        sketch(data.guestX, data.guestY, data.guestDrawing, data.guestRecentX, data.guestRecentY, data.guestLineWidth, data.guestDrawColor, isOwnSketchAction);
      } else if(data.action === "fill") {
        fill(data.guestDrawColor, isOwnSketchAction);
      }
    }
  });

  $(function() {
      canvas = document.getElementById("canvas");
      if (!canvas) {
        // Stop execution if the canvas is not found
        return;
      }

      context = canvas.getContext("2d");

      // Hotkey binding
      $(document).bind("keydown", "e", resizeEraser);
      $(document).bind("keydown", "b", resizeBrush);
      $(document).bind("keydown", "c", clear);

      $("#pencil").click(function(){
        lineWidth = 2;
      });

      $("#eraser").click(function(){
        drawColor = "white";
        alert("Press 'e' to modify eraser size, 'c' to clear frame");

      });

      $("#brush").click(function(){
        lineWidth = 15;
        alert("Press 'b' to modify brush size");
      });

      $("#bucket").click(function(){
        fill(drawColor, true);
      });

      /*
      * Mouse input events
      */

      // Mouse pressed down on the canvas
      $("#canvas").mousedown(function(e) {
          mouseClicked = true;
          var xPos = e.pageX - $(this).offset().left;
          var yPos = e.pageY - $(this).offset().top;

        sketch(xPos, yPos, false, recentX, recentY, lineWidth, drawColor, true);
      });

      // Mouse moves on the canvas
      $("#canvas").mousemove(function(e) {
        if (mouseClicked) {
          sketch(e.pageX - $(this).offset().left, e.pageY - $(this).offset().top, true, recentX, recentY, lineWidth, drawColor, true);
        }
      });

      // Mouse un-press
      $("#canvas").mouseup(function(e) {
        mouseClicked = false;
      });

      // Mouse goes off the canvas
      $("#canvas").mouseleave(function(e) {
        mouseClicked = false;
      });


      // Color pickers
      $(".color-picker").click(function(e) {
        drawColor = $(this).css("background-color");
      });
  });

  function sketch(x, y, drawing, rX, rY, lwidth, dcolor, isOwnSketch) {
    if(drawing) {
      context.beginPath();
      context.strokeStyle = dcolor;
      context.lineWidth = lwidth;
      context.moveTo(rX, rY);
      context.lineTo(x, y);
      context.lineCap = 'round';
      context.stroke();

      //send faye message here with x, y, drawing, recentX, recentY, drawColor, lineWidth
      if(isOwnSketch) {
        client.publish(channel, {
          userId: userId,
          action: "sketch",
          guestX: x,
          guestY: y,
          guestDrawing: drawing,
          guestRecentX: rX,
          guestRecentY: rY,
          guestDrawColor: dcolor,
          guestLineWidth: lwidth
        });
      }
    }

    if (isOwnSketch) {
      recentX = x;
      recentY = y;
    }
  }

  function fill(dcolor, isOwnSketch) {
    context.fillStyle = dcolor;
    context.fillRect(0,0, context.canvas.width, context.canvas.height);
    if(isOwnSketch) {
      client.publish(channel, {
        userId: userId,
        action: "fill",
        guestDrawColor: dcolor
      });
    }
  }

  function resizeEraser() {
    lineWidth = prompt("Enter size of eraser: ");
    drawColor = "white";
  }

  function resizeBrush() {
    lineWidth = prompt("Enter size of brush: ");
  }

  function clear() {
    context.clearRect(0, 0, context.canvas.width, context.canvas.height);
  }

})();

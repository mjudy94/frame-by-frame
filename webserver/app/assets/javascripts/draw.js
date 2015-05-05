(function() {
  var canvas, context;
  var mouseClicked = false;
  
  // Previous frame's mouse position
  var recentX;
  var recentY;
  var drawColor = "rgb(0, 0, 0)";
  var lineWidth = 5;

  var channel;

  var client = new Faye.Client("http://localhost:9292/faye"),
      username = localStorage.getItem('username') || 'Guest',
      userId = guid();

  $(function() {
      channel = "/draw/" + $("#messageForm").data("id") + "p" + $("#messageForm").data("password");

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
          } else if(data.action === "clear") {
            clear(isOwnSketchAction);
          }
        }
      });
    
      canvas = document.getElementById("canvas");
      if (!canvas) {
        // Stop execution if the canvas is not found
        return;
      }

      context = canvas.getContext("2d");

      // Hotkey binding
      $(document).bind("keydown", "e", resizeEraser);
      $(document).bind("keydown", "b", resizeBrush);
      $(document).bind("keydown", "c", function() { clear(true); });

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
        $(".color-picker").not($(this)).animate({
          "border-radius": 0
        }, 200);
        $(".color-picker").not($(this)).css("border", "none");

        $(this).animate({
          "border-radius": "20px"
        }, 200);
        $(this).css("border", "2px dashed white");

        drawColor = $(this).css("background-color");
      });
  });

  function sketch(x, y, drawing, rX, rY, lwidth, dcolor, isOwnSketch) {
    if(channel) {
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
  }

  function fill(dcolor, isOwnSketch) {
    if(channel) {
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
  }

  function clear(isOwnSketch) {
    if(channel) {
      context.clearRect(0, 0, context.canvas.width, context.canvas.height);
      if(isOwnSketch) {
        client.publish(channel, {
          userId: userId,
          action: "clear"
        });
      }
    }
  }

  function resizeEraser() {
    lineWidth = prompt("Enter size of eraser: ");
    drawColor = "white";
  }

  function resizeBrush() {
    lineWidth = prompt("Enter size of brush: ");
  }

  

})();

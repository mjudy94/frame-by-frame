//= require snap-svg

(function() {
  var MIN_LINE_LENGTH = 5;

  var svg, svgElement, publishAction;
  var mouseClicked = false;

  // Previous frame's mouse position
  var recentX;
  var recentY;
  var drawColor = "rgb(0, 0, 0)";
  var lineWidth = 5;

  var channel;

  var client, username, userId;
  $(function() {
      var brushSizeChanged = function() {
        lineWidth = $("#brush-size-slider").slider("value");
        $("#brush-size").html(lineWidth);
      };
      $("#brush-size-slider").slider({
        range: "min",
        min: 1,
        max: 100,
        value: 5,
        change: brushSizeChanged
      });

      client = new Faye.Client($(".chat").data("faye"));
      username = localStorage.getItem('username') || 'Guest',
      userId = guid();

      channel = "/draw/" + $("#messageForm").data("id") + "p" + $("#messageForm").data("password");

      client.subscribe(channel, function(data) {
        var isOwnSketchAction = data.userId === userId,
            className = isOwnSketchAction ? 'self' : 'other';

        //Add isOwnSketchAction as param so sketch knows whether or not to ignore the following sketch request?
        if(!isOwnSketchAction) {
          // if(data.action === "sketch") {
          //   sketch(data.guestX, data.guestY, data.guestDrawing, data.guestRecentX, data.guestRecentY, data.guestLineWidth, data.guestDrawColor, isOwnSketchAction);
          // } else if(data.action === "fill") {
          //   fill(data.guestDrawColor, isOwnSketchAction);
          // } else if(data.action === "clear") {
          //   clear(isOwnSketchAction);
          // }
          switch (data.action) {
            case "sketch":
              svg.add(Snap.parse(data.svg));
              break;
            case "clear":
              svg.clear();
              break;
            default:
              break;
          }
        }
      });

      svg = Snap("#canvas");
      if (!svg) {
        // Stop execution if the svg canvas is not found
        return;
      }

      // Hotkey binding
      $(document).bind("keydown", "c", function() { clear(true); });

      $("#pencil").click(function(){
        lineWidth = 2;
      });

      $("#eraser").click(function(){
        drawColor = "white";
      });

      $("#brush").click(function(){
        lineWidth = 15;
      });

      $("#bucket").click(function(){
        fill(drawColor, true);
      });

      $("#clear").click(function(){
         clear(true);

      });

      $(".tool").click(function(){
        $(".tool").not($(this)).css("border", "none");
        $(this).css("border", "2px solid black");
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

      //touch began
      $("#canvas")[0].addEventListener('touchstart', function(e) {
        e.preventDefault();

        mouseClicked = true;
        var xPos = e.changedTouches[0].pageX - $(this).offset().left;
        var yPos = e.changedTouches[0].pageY - $(this).offset().top;

        sketch(xPos, yPos, false, recentX, recentY, lineWidth, drawColor, true);
      }, false);

      // Mouse moves on the canvas
      $("#canvas").mousemove(function(e) {
        if (mouseClicked) {
          sketch(e.pageX - $(this).offset().left, e.pageY - $(this).offset().top, true, recentX, recentY, lineWidth, drawColor, true);
        }
      });

      //touch move
      $("#canvas")[0].addEventListener('touchmove', function(e) {
        if (mouseClicked) {
          sketch(e.changedTouches[0].pageX - $(this).offset().left, e.changedTouches[0].pageY - $(this).offset().top, true, recentX, recentY, lineWidth, drawColor, true);
        }
      }, false);

      //triggers when user removes finger while within bounds of specified element
      $("#canvas")[0].addEventListener('touchend', commitInput);

      // Mouse un-press
      $("#canvas").mouseup(commitInput);

      //triggers when no longer touching the canvas
      $("#canvas")[0].addEventListener('touchleave', commitInput);

      // Mouse goes off the canvas
      $("#canvas").mouseleave(commitInput);


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

  function commitInput() {
    if (publishAction) {
      client.publish(channel, {
        userId: userId,
        svg:  svgElement && svgElement.toString(),
        action: publishAction
      });
    }

    mouseClicked = false;
    svgElement = null;
    publishAction = null;
  };

  function sketch(x, y, drawing, rx, ry, lwidth, dcolor, isOwnSketch) {
    if(channel) {
      if(drawing) {
        if (Math.abs(x - rx) < MIN_LINE_LENGTH  &&
              Math.abs(y - ry) < MIN_LINE_LENGTH) {
          // Do not draw anything if the change is too insignificant. This helps
          // conserve bandwidth and size of the svg image.
          return;
        }

        publishAction = "sketch";

        if (!svgElement) {
          svgElement = svg.polyline(x, y, rx, ry).attr({
            "stroke": dcolor,
            "stroke-width": lwidth,
            "stroke-linecap": "round",
            "stroke-linejoin": "round",
            "fill": "none"
          });
        } else {
          svgElement.attr("points", svgElement.attr("points").concat(rx, ry))
        }

        //send faye message here with x, y, drawing, recentX, recentY, drawColor, lineWidth
        // if(isOwnSketch) {
        //   client.publish(channel, {
        //     userId: userId,
        //     action: "sketch",
        //     guestX: x,
        //     guestY: y,
        //     guestDrawing: drawing,
        //     guestRecentX: rx,
        //     guestRecentY: ry,
        //     guestDrawColor: dcolor,
        //     guestLineWidth: lwidth
        //   });
        // }
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
      svg.clear();
      if(isOwnSketch) {
        publishAction = "clear";
        commitInput();
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

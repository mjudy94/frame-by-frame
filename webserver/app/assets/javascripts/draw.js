//= require countdown
//= require snap-svg

(function() {
  var MIN_LINE_LENGTH = 5;

  var svg, svgElement, publishAction, publishData;
  var mouseClicked = false;

  // Previous frame's mouse position
  var recentX;
  var recentY;
  var drawColor = "rgb(0, 0, 0)";
  var lineWidth = 5;

  var textDialog, textForm;

  // tool enums
  var Tool = {
    "BRUSH": 0,
    "PENCIL": 1,
    "ERASER": 2,
    "TEXT": 3
  };
  var currentTool = Tool.BRUSH;

  var channel;
  var userId = guid();

  $(document).ready(function() {
      svg = Snap("#canvas");
      if (!svg) {
        // Stop execution if the svg canvas is not found
        return;
      }

      var svgElements = svg.selectAll("*");
      for(var i = 0; i < svgElements.length; i++) {
        addSVGEvents(svgElements[i]);
      }


      textDialog = $("#text-dialog").dialog({
        autoOpen: false,
        height: 300,
        width: 350,
        modal: true,
        buttons: {
          "Insert": addText
        },
        close: function() {
          textForm[0].reset();
        }
      });
      textForm = textDialog.find("form").on("submit", function(e) {
        e.preventDefault();
        addText();
      });


      var brushSizeChanged = function() {
        lineWidth = $("#brush-size-slider").slider("value");
        $("#brush-size").html(lineWidth);
      };

      var setBrushSize = function(size) {
        lineWidth = size;
        $("#brush-size-slider").slider("option", "value", size);
      };

      $("#brush-size-slider").slider({
        range: "min",
        min: 1,
        max: 100,
        value: 5,
        change: brushSizeChanged
      });

      // Set up the Faye client
      channel = "/draw/" + gon.roomId + "p" + gon.password;
      var subscription = faye.subscribe(channel, function(data) {
        var isOwnSketchAction = data.userId === userId,
            className = isOwnSketchAction ? 'self' : 'other';

        //Add isOwnSketchAction as param so sketch knows whether or not to ignore the following sketch request?
        if(!isOwnSketchAction) {
          var incomingSVGElement;

          switch (data.action) {
            case "sketch":
              incomingSVGElement = Snap.parse(data.svg);
              break;
            case "clear":
              svg.clear();
              break;
            case "erase":
              for(var i = 0; i < data.data.ids.length; i++) {
                svg.select('[id="' + data.data.ids[i] + '"]').remove();
              }
            default:
              break;
          }

          if(incomingSVGElement) {
            addSVGEvents(incomingSVGElement.select("*"));
            svg.add(incomingSVGElement);
          }
        }
      });

      // Hotkey binding
      $(document).bind("keydown", "c", function() { clear(true); });

      $("#brush").click(function(){
        currentTool = Tool.BRUSH;
        setBrushSize(15);
      });

      $("#pencil").click(function(){
        currentTool = Tool.PENCIL;
        setBrushSize(2);
      });

      $("#eraser").click(function(){
        currentTool = Tool.ERASER;
      });

      $("#text").click(function() {
        currentTool = Tool.TEXT;
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

        if(currentTool === Tool.BRUSH || currentTool === Tool.PENCIL) {
          sketch(xPos, yPos, false, recentX, recentY, lineWidth, drawColor, true);
        } else if(currentTool === Tool.TEXT) {
          text(xPos, yPos);
        }
      });

      //touch began
      $("#canvas")[0].addEventListener('touchstart', function(e) {
        e.preventDefault();
        mouseClicked = true;

        var xPos = e.changedTouches[0].pageX - $(this).offset().left;
        var yPos = e.changedTouches[0].pageY - $(this).offset().top;

        if(currentTool === Tool.BRUSH || currentTool === Tool.PENCIL) {
          sketch(xPos, yPos, false, recentX, recentY, lineWidth, drawColor, true);
        } else if(currentTool === Tool.TEXT) {
          text(xPos, yPos);
        }
      }, false);

      // Mouse moves on the canvas
      $("#canvas").mousemove(function(e) {
        if(currentTool === Tool.BRUSH || currentTool === Tool.PENCIL) {
          if (mouseClicked) {
            sketch(e.pageX - $(this).offset().left, e.pageY - $(this).offset().top, true, recentX, recentY, lineWidth, drawColor, true);
          }
        }
      });

      //touch move
      $("#canvas")[0].addEventListener('touchmove', function(e) {
        if(currentTool === Tool.BRUSH || currentTool === Tool.PENCIL) {
          if (mouseClicked) {
            sketch(e.changedTouches[0].pageX - $(this).offset().left, e.changedTouches[0].pageY - $(this).offset().top, true, recentX, recentY, lineWidth, drawColor, true);
          }
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
      faye.publish(channel, {
        userId: userId,
        svg:  svgElement && svgElement.toString(),
        action: publishAction,
        data: publishData
      });
    }

    mouseClicked = false;
    svgElement = null;
    publishAction = null;
    publishData = null;
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
            "id": guid(),
            "stroke": dcolor,
            "stroke-width": lwidth,
            "stroke-linecap": "round",
            "stroke-linejoin": "round",
            "fill": "none"
          });
          addSVGEvents(svgElement);
        } else {
          svgElement.attr("points", svgElement.attr("points").concat(rx, ry))
        }
      }

      if (isOwnSketch) {
        recentX = x;
        recentY = y;
      }
    }
  }
  
  function text(x, y) {
    textDialog.x = x;
    textDialog.y = y;
    textDialog.dialog("open");
  }
  function addText() {
    publishAction = "sketch";
    svgElement = svg.text(textDialog.x, textDialog.y, $("#text-dialog #text").val()).attr({
      "id": guid(),
      "class": "unselectable",
      "font-size": $("#text-dialog #fontSize").val(),
      "fill": drawColor
    });
    addSVGEvents(svgElement);
    
    textDialog.dialog("close");
  }

  function erase(svgId) {
    svg.select('[id="' + svgId + '"]').remove();

    publishAction = "erase";
    if(!publishData) {
      publishData = { "ids": [] };
    }
    publishData.ids.push(svgId);
  }


  // Add event listeners to SVG elements
  function addSVGEvents(svgElem) {
    svgElem.mouseover(svgElementMouseOver);
    svgElem.touchstart(svgElementTouchStart);
  }

  // SVG Element events
  function svgElementMouseOver() {
    if(mouseClicked && currentTool === Tool.ERASER) {
      erase(this.attr("id"));
    }
  }
  function svgElementTouchStart() {
    if(mouseClicked && currentTool === Tool.ERASER) {
      erase(this.attr("id"));
    }
  }
})();

(function() {
  $("textBox").hide();
  var canvas, context;
  var mouseClicked = false;
  

  // Previous frame's mouse position
  var recentX;
  var recentY;

  var drawColor = "rgb(0, 0, 0)";

  var lineWidth = 5;

  var zoom= 0;
  var textBox = false;

  $(function() {
      canvas = document.getElementById("frameCanvas");
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

      $("#text").click(function(){
        textBox = !textBox;
        var textarea = $(document).getElementById("#textBox");
        $("#frameCanvas").append(textarea);
        alert("You can now give a title to your frame");

        if (textBox == false)
          $("#textBox").hide();
      });

      $("#brush").click(function(){
          lineWidth = 15;
          alert("Press 'b' to modify brush size");
      });

      $("#bucket").click(function(){
          context.fillStyle = drawColor;
          context.fillRect(0,0,780,540);
      });

      /*
      * Mouse input events
      */

      // Mouse pressed down on the canvas
      $("#frameCanvas").mousedown(function(e) {
          mouseClicked = true;
          var xPos = e.pageX - $(this).offset().left;
          var yPos = e.pageY - $(this).offset().top;

          sketch(xPos, yPos, false);
      });

      // Mouse moves on the canvas
      $("#frameCanvas").mousemove(function(e) {
          if (mouseClicked) {
              sketch(e.pageX - $(this).offset().left, e.pageY - $(this).offset().top, true);
          }
      });

      // Mouse un-press
      $("#frameCanvas").mouseup(function(e) {
          mouseClicked = false;
      });

      // Mouse goes off the canvas
      $("#frameCanvas").mouseleave(function(e) {
          mouseClicked = false;
      });


      // Color pickers
      $(".color-picker").click(function(e) {
          drawColor = $(this).css("background-color");
      });
  });

  function sketch(x, y, drawing) {
      if(drawing) {
          context.beginPath();
          context.strokeStyle = drawColor;
          context.lineWidth = lineWidth;
          context.moveTo(recentX, recentY);
          context.lineTo(x, y);
          context.closePath();
          context.stroke();
      }
      recentX = x;
      recentY = y;
  }

  function resizeEraser() {
    lineWidth = prompt("Enter size of eraser: ");
    drawColor = "white";
  }

  function resizeBrush() {
    lineWidth = prompt("Enter size of brush: ");
  }

  function clear() {
    context.clearRect(0, 0, 780, 540);
  }

})();
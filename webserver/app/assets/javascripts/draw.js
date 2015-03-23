/*
* Enables the user to draw on the canvas
* 3/12/15
* Multiple colors and tools have not been implemented
* Basic groundwork for the UI is laid- will refine it a good deal
* Will incorporate a 'clear canvas' function very soon
*/

var context;


var mouseClicked = false;

// Previous frame's mouse position
var recentX;
var recentY;


function initialize() {
    context = document.getElementById("frameCanvas").getContext("2d");

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
}

function sketch(x, y, drawing) {
    if(drawing) {
        context.beginPath();
        context.strokeStyle = "#00CCFF";
        context.lineWidth = 5;
        context.moveTo(recentX, recentY);
        context.lineTo(x, y);
        context.closePath();
        context.stroke();
    }
    recentX = x;
    recentY = y;
}
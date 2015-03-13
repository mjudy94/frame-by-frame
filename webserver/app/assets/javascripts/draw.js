/*
* Enables the user to draw on the canvas
*3/12/15
* Multiple colors and tools have not been implemented
* Basic groundwork for the UI is laid- will refine it a good deal
* Will incorporate a 'clear canvas' function very soon
*/



var mouseClicked = false;
var recentX;
var recentY;
var context;

function initialize() {
    context = document.getElementById("frameCanvas").getContext("2d");

    /*
    * 4 vital mouse events that allow the user to interact with the canvas
    */


     /*
    * 3rd parameter set to 0 as user has not yet dragged the mouse to begin sketching
    */

    $("#frameCanvas").mousedown(function (down) {
        mouseClicked = true;
        var xPos = down.pageX - $(this).offset().left;
        var yPos = down.pageY - $(this).offset().top;

        sketch(xPos, yPos, 0);
    });

    /*
    * 3rd parameter set to 1 to reflect the fact that the mouse is clicked and moving around
    */
    $("#frameCanvas").mousemove(function (move) {
        if (mouseClicked) {
            sketch(move.pageX - $(this).offset().left, move.pageY - $(this).offset().top, 1);
        }
    });

    $("#frameCanvas").mouseup(function (up) {
        mouseClicked = false;
    });
	    $("#frameCanvas").mouseleave(function (leave) {
        mouseClicked = false;
    });
}

function sketch(x, y, condition) {
    if (condition == 1) {
        context.beginPath();
        context.strokeStyle = "#00CCFF";
        context.lineWidth = 5;
        context.moveTo(recentX, recentY);
        context.lineTo(x, y);
        context.closePath();
        context.stroke();
    }
    recentX = x; recentY = y;
}
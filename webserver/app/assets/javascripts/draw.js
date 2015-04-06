window.addEventListener("keydown", checkifE, false);
window.addEventListener("keydown", checkifB, false);
window.addEventListener("keydown", checkifC, false)
var context;
var mouseClicked = false;

// Previous frame's mouse position
var recentX;
var recentY;

var drawColor = "rgb(0, 0, 0)";

var lineWidth = 5;

$(function() {
    context = document.getElementById("frameCanvas").getContext("2d");

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

    $("#textBox").click(function(){

        // Mouse pressed, create text area on mouse click of arbitrary (small) size
        // User can expand text area anyways

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

function checkifE(e) {
    if (e.keyCode == "69") {
        lineWidth = prompt("Enter size of eraser: ");
        drawColor = "white";
    }
}

function checkifB(e) {
    if (e.keyCode == "66"){
        lineWidth = prompt("Enter size of brush: ");
    }
}

function checkifC(e) {

    if (e.keyCode == "67"){
        context.clearRect(0, 0, 780, 540);
    }
}

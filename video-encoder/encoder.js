var gm = require('gm');
var ffmpeg = require('fluent-ffmpeg');
var CombinedStream = require('combined-stream');

var IMG_FORMAT = 'png';

/**
 * Converts a list of images into a video of a desired framerate.
 * @param img {Array} List of paths or URLs to the images that are to be
 *            encoded into a video. The order of the list matters.
 * @param fps {Number} The desired framerate of the video
 * @param width {Number}  The maximum width of the rendered video
 * @param height {Number} The maximum height of the rendered video
 * @param out {WriteableStream} A stream that the video is written to.
 */
function encode(imgs, fps, width, height, out) {
  var combinedStream = CombinedStream.create();

  // Convert all SVGs into PNG streams
  imgs.forEach(function(img) {
    combinedStream.append(gm(img).resize(width, height).stream(IMG_FORMAT));
  });

  // Run the command and stream to out
  ffmpeg()
    .input(combinedStream)
    .inputFormat('image2pipe')
    .withVideoCodec('libvpx')
    .inputFps(fps)
    .outputFormat('webm')
    .stream(out);
}

module.exports.encode = encode;

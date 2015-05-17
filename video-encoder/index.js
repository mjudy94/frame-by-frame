/**
 * AWS Lambda function that converts SVG frames into a video. The Lambda event
 * should have the following items:
 *
 * animationId -> Rails ActiveRecord ID,
 * galleryId -> Rails ActiveRecord ID,
 * videoId -> Rails ActiveRecord ID,
 * fps -> The FPS of the rendered video,
 * width -> The width of the rendered video,
 * height -> The height of the rendered video
 *
 * @author Kenneth Ruddick
 */
process.env['PATH'] = process.env['PATH'] + ':' + process.env['LAMBDA_TASK_ROOT']

var gm = require('gm').subClass({ imageMagick: true }),
    ffmpeg = require('fluent-ffmpeg'),
    CombinedStream = require('combined-stream'),
    AWS = require('aws-sdk'),
    creds = require('./creds.json')
    s3 = new AWS.S3(creds),
    s3Stream = require('s3-upload-stream')(s3);

var BUCKET = 'frame-by-frame',
    MAX_PART_SIZE = 20971520, // 20 MB
    lambdaContext;

// Completed
process.on('exit', function() {
  lambdaContext.done();
});

// There was an error
process.on('uncaughtException', function(e) {
  lambdaContext.fail(e);
});

exports.handler = function(event, context) {
  lambdaContext = context;
  getFrames(event.animationId, function(frames) {
    var video = encode(frames, event.fps, event.width, event.height);
    storeVideo(event.galleryId, event.videoId, video);
  });
};

function getFrames(animationId, callback) {
  var params = {
    Bucket: BUCKET,
    EncodingType: 'url',
    Prefix: 'frames/' + animationId + '/'
  };

  s3.listObjects(params, function(err, data) {
    var frames;
    if (err) {
      lambdaContext.fail(err);
    } else {
      // Get streams for all objects
      frames = filterAndSort(data.Contents).map(function(object) {
        return s3.getObject({
          Bucket: BUCKET,
          Key: object.Key
        }).createReadStream();
      });
      callback(frames);
    }
  });
}

function filterAndSort(frames) {
  return frames.filter(function(f) {
    return f.Size > 0;
  }).sort(function(a, b) {
    return parseInt(a.Key.match(/\/(\d+)/)[1]) - parseInt(b.Key.match(/\/(\d+)/)[1]);
  });
}

function storeVideo(galleryId, videoId, stream) {
  var upload = s3Stream.upload({
    Bucket: BUCKET,
    Key: 'galleries/' + galleryId + '/' + videoId,
  });

  // Optional configuration
  upload.maxPartSize(MAX_PART_SIZE);
  upload.concurrentParts(5);

  upload.on('error', function (error) {
    lambdaContext.fail(error)
  });

  upload.on('part', function (details) {
    console.log(details);
  });

  upload.on('uploaded', function (details) {
    lambdaContext.succeed(details);
  });

  stream.pipe(upload);
}

/**
 * Converts a list of images into a video of a desired framerate.
 * @param img {Array} List of paths or URLs to the images that are to be
 *            encoded into a video. The order of the list matters.
 * @param fps {Number} The desired framerate of the video
 * @param width {Number}  The maximum width of the rendered video
 * @param height {Number} The maximum height of the rendered video
 * @return {WriteableStream} A stream that contains the encoded video
 */
function encode(imgs, fps, width, height) {
  var combinedStream = CombinedStream.create();

  // Convert all SVGs into PNG streams
  imgs.forEach(function(img) {
    combinedStream.append(gm(img, 'img.svg').resize(width, height).stream('png'));
  });

  // Run the command and stream to out
  return ffmpeg()
    .input(combinedStream)
    .inputFormat('image2pipe')
    .withVideoCodec('libvpx')
    .inputFps(fps)
    .outputFormat('webm')
    .stream();
}

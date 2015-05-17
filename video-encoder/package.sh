#!/bin/bash
# Packages up all the components of the Lambda function into a zip file for upload

if [ ! -f ./ffmpeg ]
then
  echo "Downloading FFMPEG static build"
  curl "http://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz" | tar -xJf - --strip-components 1 */ffmpeg
fi

echo "Zipping all components into video-encoder.zip"
zip -r video-encoder.zip ffmpeg creds.json node_modules index.js

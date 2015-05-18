require 'json'

module Lambduh
  @@client = Aws::Lambda::Client.new(
    region: 'us-east-1',
    access_key_id: Rails.configuration.lambduh['access_key_id'],
    secret_access_key: Rails.configuration.lambduh['secret_access_key']
  )

  def self.render animation
    galleryId = animation.room.gallery.id
    video = animation.room.gallery.videos.create
    video.video_url = "galleries/#{galleryId}/#{video.id}"
    video.name = video.id
    if video.save
      @@client.invoke(
        function_name: 'renderAnimation',
        payload: {
          animationId: animation.id,
          galleryId: galleryId,
          videoId: video.id,
          fps: animation.video_framerate,
          width: 960,
          height: 540
        }.to_json
      )
    end
  end
end

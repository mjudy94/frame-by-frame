module Lambduh
  @@client = Aws::Lambda::Client.new(
    region: 'us-east-1',
    credentials: Rails.configuration.lambduh
  )

  def render animation
    galleryId = animation.room.gallery.id
    video = animation.room.gallery.videos.create
    video.video_url = "galleries/#{galleryId}/#{video.id}"
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
        }
      )
    end
  end
end

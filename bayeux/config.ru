require "faye"
require "./canvas"

Faye::WebSocket.load_adapter("thin")
bayeux = Faye::RackAdapter.new(:mount => "/faye", :timeout => 25)
bayeux.add_extension(Canvas.new)
run bayeux

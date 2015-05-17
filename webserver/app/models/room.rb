class Room < ActiveRecord::Base
	has_one :animation
	has_one :gallery
end

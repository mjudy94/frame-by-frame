class Gallery < ActiveRecord::Base
	belongs_to :room
	has_many :videos
end

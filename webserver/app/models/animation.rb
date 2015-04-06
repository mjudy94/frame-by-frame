class Animation < ActiveRecord::Base
	belongs_to :room
	has_many :frames
end

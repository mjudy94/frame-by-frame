class CreateAnimations < ActiveRecord::Migration
  def change
    create_table :animations do |t|
      t.belongs_to :rooms, index: true
      t.integer :number_of_frames
      t.integer :timer_per_frame
      t.integer :video_framerate
      t.timestamps
    end
  end
end

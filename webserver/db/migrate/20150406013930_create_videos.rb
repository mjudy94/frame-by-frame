class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.belongs_to :galleries, index: true
      t.string :video_url
      t.timestamps
    end
  end
end

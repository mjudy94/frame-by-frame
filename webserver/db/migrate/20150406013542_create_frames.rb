class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.belongs_to :animations, index: true
      t.string :image_url
      t.timestamps
    end
  end
end

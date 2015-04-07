class FixReferencePluralizations < ActiveRecord::Migration
  def change
    # Fix animation references
    remove_belongs_to :animations, :rooms, index: true
    add_belongs_to :animations, :room, index: true

    # Fix frame references
    remove_belongs_to :frames, :animations, index: true
    add_belongs_to :frames, :animation, index: true

    # Fix gallery references
    remove_belongs_to :galleries, :rooms, index: true
    add_belongs_to :galleries, :room, index: true

    # Fix video references
    remove_belongs_to :videos, :galleries, index: true
    add_belongs_to :videos, :gallery, index: true
  end
end

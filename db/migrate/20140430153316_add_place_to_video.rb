class AddPlaceToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :place, :string
    add_column :videos, :tags, :string
  end
end
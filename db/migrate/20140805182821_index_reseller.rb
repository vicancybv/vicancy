class IndexReseller < ActiveRecord::Migration
  def change
    add_index :resellers, :slug, :unique => true
    add_index :resellers, :token, :unique => true
  end
end

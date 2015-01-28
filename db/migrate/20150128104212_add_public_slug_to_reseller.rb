class AddPublicSlugToReseller < ActiveRecord::Migration
  def change
    add_column :resellers, :public_slug, :string
    add_index :resellers, :public_slug, :unique => true
  end
end

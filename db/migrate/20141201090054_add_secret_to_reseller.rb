class AddSecretToReseller < ActiveRecord::Migration
  def change
    add_column :resellers, :secret, :string
  end
end

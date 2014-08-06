class AddResellerToClient < ActiveRecord::Migration
  def change
    remove_index :clients, [:user_id, :external_id]
    add_column :clients, :reseller_id, :integer, references: :resellers
    add_index :clients, :reseller_id
    add_index :clients, [:reseller_id, :external_id], :unique => true
  end
end

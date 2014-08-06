class AddClientFieldToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :client_id, :integer, references: :clients
    add_index :videos, :client_id
  end
end

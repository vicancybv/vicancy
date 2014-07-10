class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :user_id
      t.string :external_id
      t.string :name
      t.string :email
      t.string :language
      t.string :slug
      t.string :token
      t.timestamps
    end

    add_index :clients, :user_id
    add_index :clients, [:user_id, :external_id], :unique => true
    add_index :clients, :slug, :unique => true
    add_index :clients, :token, :unique => true
  end
end

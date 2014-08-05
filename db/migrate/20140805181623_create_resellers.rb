class CreateResellers < ActiveRecord::Migration
  def change
    create_table :resellers do |t|
      t.string :name
      t.string :slug
      t.string :language
      t.string :token

      t.timestamps
    end
  end
end

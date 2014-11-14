class CreateSimpleOrders < ActiveRecord::Migration
  def change
    create_table :simple_orders do |t|
      t.text :params

      t.timestamps
    end
  end
end

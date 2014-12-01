class AddProductToSimpleOrder < ActiveRecord::Migration
  def change
    add_column :simple_orders, :product, :string
  end
end

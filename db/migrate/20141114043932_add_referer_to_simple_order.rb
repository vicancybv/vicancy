class AddRefererToSimpleOrder < ActiveRecord::Migration
  def change
    add_column :simple_orders, :referer, :string
    add_column :simple_orders, :email, :string
    add_column :simple_orders, :name, :string
    add_column :simple_orders, :url, :string
  end
end

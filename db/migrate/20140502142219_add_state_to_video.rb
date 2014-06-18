class AddStateToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :aasm_state, :string
  end
end

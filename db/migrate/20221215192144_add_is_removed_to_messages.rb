class AddIsRemovedToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :is_removed, :boolean, default: false
  end
end

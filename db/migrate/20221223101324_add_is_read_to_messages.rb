class AddIsReadToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :is_read, :boolean, default: false, index: true
  end
end

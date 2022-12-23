class AddIndexToMessages < ActiveRecord::Migration[7.0]
  def change
    add_index :messages, :is_read
  end
end

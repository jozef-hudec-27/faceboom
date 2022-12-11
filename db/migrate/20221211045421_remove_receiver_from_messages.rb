class RemoveReceiverFromMessages < ActiveRecord::Migration[7.0]
  def change
    remove_reference :messages, :receiver, null: false, foreign_key: { to_table: :users }
  end
end

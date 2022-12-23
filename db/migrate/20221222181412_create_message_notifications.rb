class CreateMessageNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :message_notifications do |t|
      t.references :message, null: false, foreign_key: true
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.boolean :seen, default: false, index: true

      t.timestamps
    end
  end
end

class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.string :key, index: { unique: true }
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end

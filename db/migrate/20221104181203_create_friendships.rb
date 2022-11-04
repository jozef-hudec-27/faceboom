class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships, id: false do |t|
      t.bigint :user_id, null: false
      t.bigint :friend_user_id, null: false

      t.timestamps
    end
  end
end

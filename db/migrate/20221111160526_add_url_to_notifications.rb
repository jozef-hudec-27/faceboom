class AddUrlToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :url, :string, default: ''
  end
end

class AllowNotifiableToBeNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:notifications, :notifiable_id, true)
    change_column_null(:notifications, :notifiable_type, true)
  end
end

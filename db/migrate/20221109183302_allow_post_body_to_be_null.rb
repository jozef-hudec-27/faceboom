class AllowPostBodyToBeNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:posts, :body, true)
  end
end

class AddPersonalInfoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :bio, :text, default: ""
    add_column :users, :username, :string, default: ""
  end
end

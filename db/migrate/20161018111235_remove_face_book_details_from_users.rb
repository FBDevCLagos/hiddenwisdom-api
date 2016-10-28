class RemoveFaceBookDetailsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :username, :string
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :fb_id, :integer
  end
end

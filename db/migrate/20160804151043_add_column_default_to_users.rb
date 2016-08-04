class AddColumnDefaultToUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :user_type, 0
  end
end

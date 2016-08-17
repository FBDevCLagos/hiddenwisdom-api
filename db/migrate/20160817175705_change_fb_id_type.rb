class ChangeFbIdType < ActiveRecord::Migration
  def change
    change_column :users, :fb_id, :string
  end
end

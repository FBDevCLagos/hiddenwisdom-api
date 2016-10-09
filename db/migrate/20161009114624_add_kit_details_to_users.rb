class AddKitDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kit_id, :string
    add_column :users, :phone_number, :string
  end
end

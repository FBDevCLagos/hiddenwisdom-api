class RemoveColumnRootIdFromProverbTable < ActiveRecord::Migration
  def change
    remove_column :proverbs, :root_id
  end
end

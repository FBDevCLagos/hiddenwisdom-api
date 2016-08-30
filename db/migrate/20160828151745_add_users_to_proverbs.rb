class AddUsersToProverbs < ActiveRecord::Migration
  def change
    add_reference :proverbs, :user, foreign_key: true
  end
end

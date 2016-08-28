class CreateProverbs < ActiveRecord::Migration
  def change
    create_table :proverbs do |t|
      t.string :body
      t.string :language
      t.string :status, default: "unapproved"

      t.timestamps null: false
    end
  end
end

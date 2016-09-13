class CreateProverbs < ActiveRecord::Migration
  def change
    create_table :proverbs do |t|
      t.string :body
      t.string :language
      t.string :status, default: "unapproved"
      t.references :root, index: true, default: 0

      t.timestamps null: false
    end
  end
end

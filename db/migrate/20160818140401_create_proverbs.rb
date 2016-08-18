class CreateProverbs < ActiveRecord::Migration
  def change
    create_table :proverbs do |t|
      t.string :body
      t.string :lang
      t.references :root, index: true, foreign_key: true, default: 0

      t.timestamps null: false
    end
  end
end

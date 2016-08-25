class CreateExpiredTokens < ActiveRecord::Migration
  def change
    create_table :expired_tokens do |t|
      t.string :token

      t.timestamps null: false
    end
  end
end

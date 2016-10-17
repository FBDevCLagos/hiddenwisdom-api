class CreateProverbTranslations < ActiveRecord::Migration
  def up
    Proverb.create_translation_table!({
      body: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Proverb.drop_translation_table! migrate_data: true
  end
end

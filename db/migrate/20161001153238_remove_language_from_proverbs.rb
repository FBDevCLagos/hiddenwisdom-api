class RemoveLanguageFromProverbs < ActiveRecord::Migration
  def change
    remove_column :proverbs, :language
  end
end

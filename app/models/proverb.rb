class Proverb < ActiveRecord::Base
  belongs_to :root, class_name: "Proverb", foreign_key: "root_id"
  validates :lang, :body, presence: true

  def translations
    Proverb.where("root_id = #{id} OR id = #{root_id}").where.not(id: id)
  end
end

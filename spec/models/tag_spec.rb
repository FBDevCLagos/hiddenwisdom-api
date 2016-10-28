require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "instance methods" do
    it { is_expected.to respond_to :name }
  end

  describe "associations" do
    it { is_expected.to have_many :taggings }
    it { is_expected.to have_many :proverbs }
  end
end

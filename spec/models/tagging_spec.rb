require "rails_helper"

RSpec.describe Tagging, type: :model do
  describe "instance methods" do
    it { is_expected.to respond_to :tag_id }
    it { is_expected.to respond_to :proverb_id }
  end

  describe "associations" do
    it { is_expected.to belong_to :proverb }
    it { is_expected.to belong_to :tag }
  end
end

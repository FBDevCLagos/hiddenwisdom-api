require "rails_helper"

RSpec.describe Proverb, type: :model do
  describe "validation" do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:language) }
    it { should validate_presence_of :user }
  end

  describe "associations" do
    it { is_expected.to have_many :taggings }
    it { is_expected.to have_many :tags }
  end

  let(:proverb) { create(:proverb) }
  let(:translation) { create(:proverb, root: proverb) }

  it { is_expected.to respond_to(:root) }
  it { is_expected.to respond_to(:translations) }

  it "should return a translation for proverb" do
    expect(proverb.translations).to eq [translation]
  end

  it "should return a translation for translation" do
    expect(translation.translations).to eq [proverb]
  end

  it "should return a root for translation" do
    expect(translation.root).to eq proverb
  end
end

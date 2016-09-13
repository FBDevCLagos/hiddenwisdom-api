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

  describe ".search" do
    before(:all) do
      tags = ["wisdom", "love", "life", "opportunity"]
      languages = ["english", "yoruba", "igbo", "hausa"]
      10.times do
        proverb = create(:proverb, language: languages[rand(languages.length)])
        tag = create(:tag, name: tags[rand(tags.length)])
        create(:tagging, proverb: proverb, tag: tag)
      end
    end

    context "when full query params is passed" do
      it "returns proverbs that all query params" do
        search_result = Proverb.search({
            tag: "wisdom",
            language: "english",
            random: true,
            direction: "desc"
          })
        search_result.map do |proverb|
          expect(proverb.language).to eq "english"
          expect(proverb.tags.map(&:name)).to include "wisdom"
        end
      end
    end

    context "when only tag is passed" do
      it "returns proverbs with matching tags" do
        search_result = Proverb.search({tag: "life"})
        search_result.each do |proverb|
          expect(proverb.tags.map(&:name)).to include "life"
        end
      end
    end

    context "when only langauge is passed" do
      it "returns proverbs with matching language" do
        search_result = Proverb.search({language: "yoruba"})
        search_result.each do |proverb|
          expect(proverb.language).to eq "yoruba"
        end
      end
    end

    context "when direction is passed" do
      it "returns proverbs in the specified order" do
        search_result = Proverb.search({direction: "asc"})
        expect(search_result[0].created_at).to be < search_result[1].created_at
      end
    end
  end
end

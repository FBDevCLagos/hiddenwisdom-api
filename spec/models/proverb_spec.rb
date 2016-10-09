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

  describe "search filters" do
    before(:each) do
      @proverb1 = create(:proverb, body: 'hello')
      @proverb2 = create(:proverb, body: 'world')
    end

    describe ".filter_language" do
      context "when present" do
        it 'returns proverbs with the language' do
          @proverb2.update(language: 'igbo')
          result = Proverb.filter_language({language: 'igbo'}).all
          expect(result.count).to be 1
          expect(result.first).to eql @proverb2
        end
      end

      context "when not present" do
        it 'returns all proverbs' do
          result = Proverb.all
          expect(result.count).to be 2
          expect(result.first).to eql @proverb1
        end
      end
    end

    describe ".filter_tag" do
      context "when present" do
        it "returns proverbs that match the tag" do
          tag = create(:tag, name: 'joy')
          create(:tagging, tag: tag, proverb: @proverb2)
          result = Proverb.joins(:tags).filter_tag({tag: 'joy'}).all
          expect(result.count).to be 1
          expect(result.first).to eql @proverb2
        end
      end

      context "when not present" do
        it "returns all proverbs" do
          result = Proverb.joins(:tags).all
          expect(result).to be_empty
        end
      end
    end

    describe ".filter_order" do
      context "when present" do
        it 'returns proverbs with the given order' do
          @proverb2.update({language: 'igbo'})
          result = Proverb.filter_order({language: 'igbo'}).all
          expect(result.size).to be 2
          expect(result.first).to eql @proverb2
          expect(result.second).to eql @proverb1
        end
      end
      context "when not present" do
        it 'returns proverbs order by id in desc' do
          result = Proverb.all
          expect(result.size).to be 2
          expect(result.first).to eql @proverb1
          expect(result.second).to eql @proverb2
        end
      end
    end

    describe ".filter_limit" do
      context "when present" do
        it "returns the number of proverbs required" do
          result = Proverb.filter_limit({limit: 1})
          expect(result.size).to be 1
          expect(result.first).to eql(@proverb1)
        end
      end
    end

    describe ".filter_offset" do
      context "when present" do
        it "returns the default" do
          result = Proverb.all
          expect(result.size).to be 2
          expect(result.first).to eql(@proverb1)
          expect(result.second).to eql(@proverb2)
        end
      end
    end
  end

  describe ".paginate" do
    before(:each) do
      @proverb1 = create(:proverb, body: 'hello')
      @proverb2 = create(:proverb, body: 'world')
    end

    context "when pagination is random" do
      it "returns randomize results" do
        result = Proverb.paginate({direction: 'random'})
        expect(result.size).to be 2
      end
    end
  end
end

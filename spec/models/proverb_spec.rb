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
          @proverb1.update({language: 'igbo'})
          result = Proverb.filter_order({order: 'language'}).all
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

  describe ".sanitize_search_params" do
    describe "limit" do
      context "when valid" do
        it "updates field to nil" do
          params = {limit: '10'}
          expect(Proverb.sanitize_search_params(params)[:limit]).to eql "10"
        end
      end
      context "when invalid" do
        it "updates field to nil" do
          params = {limit: 'something'}
          expect(Proverb.sanitize_search_params(params)[:limit]).to be_nil
        end
      end
    end
    describe "offset" do
      context "when valid" do
        it "updates field to nil" do
          params = {offset: '10'}
          expect(Proverb.sanitize_search_params(params)[:offset]).to eql "10"
        end
      end
      context "when invalid" do
        it "updates field to nil" do
          params = {offset: 'something'}
          expect(Proverb.sanitize_search_params(params)[:offset]).to be_nil
        end
      end
    end

    context "tag" do
      it "changes value to lower case and appends wildcard matchers" do
        params = {tag: 'JOY'}
        expect(Proverb.sanitize_search_params(params)[:tag]).to eql("%joy%")
      end
    end

    context "language" do
      it "changes value to lower case and appends wildcard matchers" do
        params = {language: 'IGBO'}
        expect(Proverb.sanitize_search_params(params)[:language]).to eql("%igbo%")
      end
    end
  end

  describe ".sanitize_order_by" do
    context "when order by is valid" do
      it "appends proverbs. to it" do
        params = {order: 'language', direction: 'asc'}
        expect(Proverb.sanitize_order_by(params)).to eql({order: 'proverbs.language', direction: 'asc'})
      end
    end

    context "when order by is invalid" do
      it "updates it with default and append proverbs" do
        params = {order: 'something', direction: 'asc'}
        expect(Proverb.sanitize_order_by(params)).to eql({order: 'proverbs.id', direction: 'asc'})
      end
    end
  end

  describe ".sanitize_direction" do
    context "when direction is random" do
      it "updates the params and removes the order field" do
        params = {direction: 'random', order: 'id' }
        expect(Proverb.sanitize_direction(params)).to eql({direction: 'RANDOM()', order: ''})
      end
    end

    context "when direction is not valid" do
      it "updates the params with the default direction" do
        params = {direction: 'something'}
        expect(Proverb.sanitize_direction(params)).to eql({direction: 'desc'})
      end
    end

    context "when direction is valid" do
      it "doesn't modify the args" do
        params = {direction: 'asc'}
        expect(Proverb.sanitize_direction(params)).to eql(params)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Proverb, type: :model do

  describe "validation" do
    it { should validate_presence_of :body }
    it { should validate_presence_of :language }
    it { should validate_presence_of :user_id }
  end
end

require "rails_helper"

RSpec.describe User, type: :model do
  describe ".find_or_create_user" do
    let(:user_attributes) { HashWithIndifferentAccess.new(user.attributes) }
    let(:user) { build(:user) }

    context "when a new user is being created" do
      it "increases user record by 1" do
        expect do
          User.create(user_attributes)
        end.to change(User, :count).by 1
      end

      it "returns the newly created user" do
        expect(User.find_or_create_user(user_attributes)).to be_a User
      end
    end

    context "when an existing user attributes is supplied" do
      before(:each) do
        user.save
      end

      it "doesn't change the count of the User records" do
        expect do
          User.find_or_create_user(user_attributes)
        end.to change(User, :count).by 0
      end

      it "returns the existing user" do
        returned_user = User.find_or_create_user(user_attributes)
        expect(returned_user.email).to eq user.email
      end
    end
  end
end

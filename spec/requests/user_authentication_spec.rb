require "rails_helper"

RSpec.describe "User Authentication", type: :request do

  context "when trying to create a user" do
    before(:all) do
      post "/api/v1/auth/login", attributes_for(:user)
    end

    it "returns an auth token" do
      expect(json["token"]).to be_truthy
    end

  end

  context "when logging out " do
    let(:user) { create(:user) }

    let(:token) { token_generator(user) }

    let(:header) do
      { "Content-Type" => "application/json",
        "AUTHORIZATION" => token
       }
    end

    let!(:req) { get "/api/v1/auth/logout", {}, header }

    it "renders the logout message" do
      expect(json["Status"]).to eq "Logged out"
    end

    it "inserts the token into expired token table" do
      expect(ExpiredToken.all.map(&:token)).to include token
    end
  end

end

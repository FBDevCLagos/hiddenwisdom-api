require "rails_helper"
require "support/shared_examples/account_kit_authentication"

RSpec.describe "User Authentication", type: :request do
  context "using account_kit" do
    let(:valid_code) { "35df78934565" }
    let(:invalid_code) { "54324ty5633" }

    context "when access_code is valid" do
      context "and authentication_type is phone" do
        it_behaves_like "a valid account_kit_authentication_with", :phone
      end

      context "and authentication_type is email" do
        it_behaves_like "a valid account_kit_authentication_with", :email
      end
    end

    context "when access_code is invalid" do
      it "responds with a 400 http status code" do
        post api_v1_auth_login_path, access_token: invalid_code
        expect(response).to have_http_status(400)
      end
    end
  end

  context "when logging out " do
    let(:user) { create(:user) }

    let(:token) { token_generator(user) }

    let(:header) do
      { "Content-Type" => "application/json",
        "AUTHORIZATION" => token }
    end

    let!(:req) { get "/api/v1/auth/logout", {}, header }

    it "renders the logout message" do
      expect(json["Status"]).to eq "Logged out"
    end

    it "inserts the token into expired token table" do
      expect(ExpiredToken.find_by(token: token)).not_to be nil
    end
  end
end

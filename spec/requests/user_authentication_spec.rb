require "rails_helper"

RSpec.describe "User Authentication", type: :request do

  context "when trying to create a user" do
    it "returns an auth token" do
      VCR.use_cassette("synopsis") do
        token = "EAAH6msXVZCB0BAHqwjgc829cZAZAg6Ymua77S9rkmkLDvr701mavIxjZBsGnihhJ5roGcY2vTCWb8nmi78LNk4NmNkgAuSK660oHmWkKNdXRAIIPy7qDEugpt78VvGvzzpFeOxc2t9xsZBN4viopXh2utRfIZB1WEZD"
        post "/api/v1/auth/login", access_token: token
        expect(json["token"]).to be_truthy
        returned_user = json["user"]
        user = User.find_by id: returned_user["id"]
        expect(json["user"]).to be_truthy
        expect(user.first_name).to eql returned_user["first_name"]
      end
    end
  end

  context "when token is invalid" do
    it "returns an 401 error" do
      VCR.use_cassette("token_invalid") do
        token = "giberrish"
        post "/api/v1/auth/login", access_token: token
        expect(response).to have_http_status(401)
        expect(json["token"]).to be_nil
        expect(json["error"]).to eql("Invalid OAuth access token.")

      end
    end
  end

  context "when token can't be decrypted" do
    it "returns an auth token" do
      VCR.use_cassette("token_undecryptable") do
        token = "EAAH6msXVZCB0BAHqwjgc829cZAZAgw6Ymua77S9rkmkLDvr701mavIxjZBsGnihhJ5roGcY2vTCWb8nmi78LNk4NmNkgAuSK660oHmWkKNdXRAIIPy7qDEugpt78VvGvzzpFeOxc2t9xsZBN4viopXh2utRfIZB1WEZD"
        post "/api/v1/auth/login", access_token: token
        expect(response).to have_http_status(401)
        expect(json["token"]).to be_nil
        expect(json["error"]).to eql("The access token could not be decrypted")
      end
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

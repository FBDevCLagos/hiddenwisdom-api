shared_examples_for "a valid account_kit_authentication_with" do |type|
  before { mock_account_kit_info(type) }

  context "when user is already created" do
    before do
      create(:user, kit_id: "175649852839525")
    end

    it "does not create user" do
      expect { post api_v1_auth_login_path, access_token: valid_code }.
        to_not change(User, :count)
    end

    it "responds with a 200 http status code" do
      post api_v1_auth_login_path, access_token: valid_code
      expect(response).to have_http_status(200)
    end
  end

  context "when user is not created" do
    it "responds with a 200 http_status code" do
      post api_v1_auth_login_path, access_token: valid_code
      expect(response).to have_http_status(200)
    end

    it "creates the user" do
      expect { post api_v1_auth_login_path, access_token: valid_code }.
        to change(User, :count).by(1)
    end
  end
end

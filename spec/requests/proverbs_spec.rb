require "rails_helper"

RSpec.describe Api::V1::ProverbsController, type: :request do
  let(:user) { create(:user) }
  let!(:valid_session) { login(user) }

  let(:valid_attributes) { build(:proverb).attributes }
  let(:invalid_attributes) { build(:proverb, :invalid).attributes }

  describe "GET #index" do
    # it "assigns all proverbs as @proverbs" do
    #   proverb = create(:proverb)
    #   translation = create(:proverb, root_id: proverb.id)
    #
    #   get "/api/v1/proverbs", {}, valid_session
    #   result = proverb.attributes
    #   expect(JSON.parse(response.body)["proverbs"][0]["body"]).to eq(result["body"])
    #   expect(JSON.parse(response.body)["proverbs"][0]["language"]).to eq(result["language"])
    #   expect(JSON.parse(response.body)["proverbs"][0]["translations"][0]["body"]).to eq(translation.body)
    #   expect(JSON.parse(response.body)["proverbs"][0]["translations"][0]["language"]).to eq(translation.language)
    #   expect(response).to have_http_status(200)
    # end

    describe "search" do
      before(:all) do
        user = create(:user)
        3.times do |index|
          Proverb.create({body: "test proverb #{index}", language: "english", all_tags: ["wisdom"], user_id: user.id})
          Proverb.create({body: "test proverb #{index}", language: "igbo", all_tags: ["life", "opportunity"], user_id: user.id})
          Proverb.create({body: "test proverb #{index}", language: "yoruba", all_tags: ["love"], user_id: user.id})
        end
      end

      context "when searching with complete params" do
        it "returns proverbs that all query params" do
          get(
            "/api/v1/proverbs?tag=wisdom&language=english&direction=desc&random=true",
            {},
            valid_session
          )
          expect(JSON.parse(response.body)["proverbs"].count).to eq 6
        end
      end

      context "when searching with only tag and language" do

      end
    end
  end

  describe "GET #show" do
    it "assigns the requested proverb as @proverb" do
      proverb = create(:proverb)
      translation = create(:proverb, root_id: proverb.id)

      get "/api/v1/proverbs/#{proverb.id}", {}, valid_session
      expect(assigns(:proverb)).to eq(proverb)

      expect(JSON.parse(response.body)["proverb"]["translations"][0]["body"]).to eq(translation.body)
      expect(JSON.parse(response.body)["proverb"]["translations"][0]["language"]).to eq(translation.language)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET with bad id" do
    it "returns not found error for ids that do not exits" do
      get "/api/v1/proverbs/100", {}, valid_session

      expect(json).to eq("Error" => "Resource not found")
      expect(response).to have_http_status(404)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Proverb" do
        expect do
          post(
            "/api/v1/proverbs/",
            { proverb: valid_attributes.merge!(all_tags: ["wisdom", "life"]) },
            valid_session
          )
        end.to change(Proverb, :count).by(1)
        expect(response).to have_http_status(201)
      end

      it "assigns a newly created proverb as @proverb" do
        post(
          "/api/v1/proverbs/",
          { proverb: valid_attributes.merge!(all_tags: ["wisdom", "life"]) },
          valid_session
        )
        expect(assigns(:proverb)).to be_a(Proverb)
        expect(assigns(:proverb)).to be_persisted
        expect(assigns(:proverb).tags[0].name).to eq "wisdom"
        expect(response).to have_http_status(201)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved proverb as @proverb" do
        post "/api/v1/proverbs/", { proverb: invalid_attributes }, valid_session
        expect(assigns(:proverb)).to be_a_new(Proverb)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { "body" => "This is a new proverb body", "language" => "en" } }

      it "updates the requested proverb" do
        proverb = create(:proverb)
        put "/api/v1/proverbs/#{proverb.id}", { proverb: new_attributes }, valid_session
        proverb.reload
        expect(assigns(:proverb).body).to eq("This is a new proverb body")
        expect(response).to have_http_status(200)
      end

      it "assigns the requested proverb as @proverb" do
        proverb = create(:proverb)
        put "/api/v1/proverbs/#{proverb.id}", { proverb: valid_attributes }, valid_session
        expect(assigns(:proverb)).to eq(proverb)
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid params" do
      it "assigns the proverb as @proverb" do
        proverb = create(:proverb)
        put "/api/v1/proverbs/#{proverb.id}", { proverb: invalid_attributes }, valid_session
        expect(assigns(:proverb)).to eq(proverb)
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested proverb" do
      proverb = create(:proverb)
      expect do
        delete "/api/v1/proverbs/#{proverb.id}", {}, valid_session
      end.to change(Proverb, :count).by(-1)
      expect(response).to have_http_status(204)
    end

    it "redirects to the proverbs list" do
      proverb = create(:proverb)
      delete "/api/v1/proverbs/#{proverb.id}", {}, valid_session
      expect(response).to have_http_status(204)
    end
  end
end

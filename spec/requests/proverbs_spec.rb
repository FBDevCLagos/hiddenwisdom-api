require 'rails_helper'

RSpec.describe Api::V1::ProverbsController, type: :request do


  let(:user) { create(:user) }
  let(:valid_attributes) { build(:proverb).attributes }
  let(:invalid_attributes) { build(:proverb, :invalid).attributes }
  let!(:valid_session) { login(user) }

  describe "GET #index" do
    it "assigns all proverbs as @proverbs" do
      proverb = Proverb.create! valid_attributes
      get "/api/v1/proverbs", {}, valid_session
      result = proverb.attributes
      expect(JSON.parse(response.body)[0]["body"]).to eq(result["body"])
      expect(JSON.parse(response.body)[0]["language"]).to eq(result["language"])
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "assigns the requested proverb as @proverb" do
      proverb = Proverb.create! valid_attributes
      get "/api/v1/proverbs/#{proverb.id}", {}, valid_session
      expect(assigns(:proverb)).to eq(proverb)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET with bad id" do
    it "returns not found error for ids that do not exits" do
      get "/api/v1/proverbs/100", {}, valid_session
      expect(json).to eq({'Error'=> 'Resource not found'})
      expect(response).to have_http_status(404)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Proverb" do
        expect {
          post "/api/v1/proverbs/", {:proverb => valid_attributes}, valid_session
        }.to change(Proverb, :count).by(1)
        expect(response).to have_http_status(201)
      end

      it "assigns a newly created proverb as @proverb" do
        post "/api/v1/proverbs/", {:proverb => valid_attributes}, valid_session
        expect(assigns(:proverb)).to be_a(Proverb)
        expect(assigns(:proverb)).to be_persisted
        expect(response).to have_http_status(201)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved proverb as @proverb" do
        post "/api/v1/proverbs/", {:proverb => invalid_attributes}, valid_session
        expect(assigns(:proverb)).to be_a_new(Proverb)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { "body" => "This is a new proverb body", "language" => "en" }}

      it "updates the requested proverb" do
        proverb = Proverb.create! valid_attributes
        put "/api/v1/proverbs/#{proverb.id}", {:proverb => new_attributes}, valid_session
        proverb.reload
        expect(assigns(:proverb).body).to eq("This is a new proverb body")
        expect(response).to have_http_status(200)
      end

      it "assigns the requested proverb as @proverb" do
        proverb = Proverb.create! valid_attributes
        put "/api/v1/proverbs/#{proverb.id}", {:proverb => valid_attributes}, valid_session
        expect(assigns(:proverb)).to eq(proverb)
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid params" do
      it "assigns the proverb as @proverb" do
        proverb = Proverb.create! valid_attributes
        put "/api/v1/proverbs/#{proverb.id}", {:proverb => invalid_attributes}, valid_session
        expect(assigns(:proverb)).to eq(proverb)
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested proverb" do
      proverb = Proverb.create! valid_attributes
      expect {
        delete "/api/v1/proverbs/#{proverb.id}", {}, valid_session
      }.to change(Proverb, :count).by(-1)
      expect(response).to have_http_status(204)
    end

    it "redirects to the proverbs list" do
      proverb = Proverb.create! valid_attributes
      delete "/api/v1/proverbs/#{proverb.id}", {}, valid_session
      expect(response).to have_http_status(204)
    end
  end
end

require "rails_helper"

RSpec.describe Api::V1::ProverbsController, type: :request do
  let(:user) { create(:user) }
  let!(:valid_session) { login(user) }

  let(:valid_attributes) { attributes_for(:proverb) }
  let(:invalid_attributes) { attributes_for(:proverb, :invalid) }

  describe "GET #index" do
    it "assigns all proverbs as @proverbs" do
      proverb = create(:proverb)
      tag = create(:tag, name: "wisdom")
      create(:tagging, proverb: proverb, tag: tag)
      result = create(:proverb, root_id: proverb.id)

      get "/api/v1/en/proverbs", {}, valid_session
      result = proverb.attributes
      expect(JSON.parse(response.body)["proverbs"][0]["body"]).to eq(result["body"])
      expect(response).to have_http_status(200)
    end

    describe "search" do
      before(:each) do
        tags = ["wisdom", "love", "life", "opportunity"]
        10.times do
          proverb = create(:proverb)
          tag = create(:tag, name: tags[rand(tags.length)])
          create(:tagging, proverb: proverb, tag: tag)
        end
      end

      context "when searching with complete params" do
        it "returns proverbs that match all query params" do
          get(
            "/api/v1/en/proverbs?tag=wisdom&direction=desc&random=true",
            {},
            valid_session
          )
          JSON.parse(response.body)["proverbs"].each do |prov|
            expect(prov["tags"]).to include "wisdom"
          end
        end
      end

      context "when searching with only tag" do
        it "returns proverbs matching the tag" do
          get(
            "/api/v1/en/proverbs?tag=life",
            {},
            valid_session
          )
          JSON.parse(response.body)["proverbs"].each do |prov|
            expect(prov["tags"]).to include "life"
          end
        end
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested proverb as @proverb" do
      proverb = create(:proverb)

      get "/api/v1/en/proverbs/#{proverb.id}", {}, valid_session
      expect(assigns(:proverb)).to eq(proverb)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET with bad id" do
    it "returns not found error for ids that do not exits" do
      get "/api/v1/en/proverbs/100", {}, valid_session

      expect(json).to eq("Error" => "Resource not found")
      expect(response).to have_http_status(404)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Proverb" do
        expect do
          post(
            "/api/v1/en/proverbs/",
            proverbs_with_translations_params,
            valid_session
          )
        end.to change(Proverb, :count).by(1)
        expect(response).to have_http_status(201)
      end

      it "assigns a newly created proverb as @proverb" do
        post(
          "/api/v1/en/proverbs/",
          proverbs_with_translations_params,
          valid_session
        )
        expect(assigns(:proverb)).to be_a(Proverb)
        expect(assigns(:proverb)).to be_persisted
        expect(assigns(:proverb).tags[0].name).to eq "peace"
        expect(response).to have_http_status(201)
      end
    end


    context "when proverbs does not have a translations attribute" do
      it "creates translations in translations array" do
        post(
          "/api/v1/en/proverbs/", proverbs_with_translations_params,
          valid_session
        )
        expect(assigns(:proverb)).to be_persisted
        expect(assigns(:proverb).translations.size).to eq 1
        expect(response).to have_http_status(201)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved proverb as @proverb" do
        post "/api/v1/en/proverbs/", { proverb: invalid_attributes.merge!(all_tags: ["life"]) }, valid_session
        expect(assigns(:proverb)).to be_a_new(Proverb)
      end
    end

    context "with invalid tags format" do
      it "returns 'tags must be an array' error message" do
        post(
          "/api/v1/en/proverbs/",
          { proverb: valid_attributes.merge!(all_tags: "wisdom, life") },
          valid_session
        )
        expect(JSON.parse(response.body)["tag_error"]).to eq "tags must be in an array"
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { "body" => "This is a new proverb body", "all_tags" => [] } }

      it "updates the requested proverb" do
        proverb = create(:proverb)
        put "/api/v1/en/proverbs/#{proverb.id}", { proverb: new_attributes }, valid_session
        proverb.reload
        expect(assigns(:proverb).body).to eq("This is a new proverb body")
        expect(response).to have_http_status(200)
      end

      it "assigns the requested proverb as @proverb" do
        proverb = create(:proverb)
        put "/api/v1/en/proverbs/#{proverb.id}", { proverb: valid_attributes }, valid_session
        expect(assigns(:proverb)).to eq(proverb)
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid params" do
      it "assigns the proverb as @proverb" do
        proverb = create(:proverb)
        put "/api/v1/en/proverbs/#{proverb.id}", { proverb: invalid_attributes }, valid_session
        expect(assigns(:proverb)).to eq(proverb)
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested proverb" do
      proverb = create(:proverb)
      expect do
        delete "/api/v1/en/proverbs/#{proverb.id}", {}, valid_session
      end.to change(Proverb, :count).by(-1)
      expect(response).to have_http_status(204)
    end

    it "redirects to the proverbs list" do
      proverb = create(:proverb)
      delete "/api/v1/en/proverbs/#{proverb.id}", {}, valid_session
      expect(response).to have_http_status(204)
    end
  end
end

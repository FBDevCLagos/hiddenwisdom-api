require "rails_helper"

RSpec.describe Api::V1::ProverbsController, type: :request do
  before(:each) { I18n.locale = :en }
  let(:user) { create(:user, user_type: 1) }
  let(:valid_session) { login(user) }

  let(:valid_attributes) { attributes_for(:proverb) }
  let(:invalid_attributes) { attributes_for(:proverb, :invalid) }

  describe "GET #index" do

    it "returns all proverbs" do
      create_list(:proverb, 2)
      get "/api/v1/en/proverbs"

      result = JSON.parse(response.body)
      expect(result.size).to eq 2
      expect(result.last["body"]).to eq(Proverb.first.body)
      expect(response).to have_http_status(200)
    end

    describe "search" do
      let!(:proverb1){ create(:proverb, status: "approved") }
      let!(:proverb2){ create(:proverb) }

      context "when searching with complete params" do
        it "returns proverbs that match the given tag" do
          proverb_a = create(:proverb, status: "approved")
          proverb_b = create(:proverb, status: "approved")
          tag = create(:tag, name: "love")
          create(:tagging, proverb: proverb_a, tag: tag)
          create(:tagging, proverb: proverb_b, tag: tag)

          get "/api/v1/en/proverbs?tag=love&direction=asc&limit=1&status=approved&offset=1"

          result = JSON.parse(response.body)
          expect(result.size).to eq 1
          expect(result.first["body"]).to eq proverb_b.body
        end
      end

      context "when searching with tags" do
        it 'returns proverbs that match the given tag' do
          tag = create(:tag, name: "love")
          create(:tagging, proverb: proverb2, tag: tag)

          get "/api/v1/en/proverbs?tag=love"

          result = JSON.parse(response.body)
          expect(result.size).to eq 1
          expect(result.first["body"]).to eq proverb2.body
        end
      end

      context "when searching with locale" do
        it "returns proverbs for the given locale" do
          I18n.with_locale(:ib){create(:proverb)}
          get "/api/v1/ib/proverbs"

          result = JSON.parse(response.body)
          expect(result.size).to eq 1
          expect(result.first["body"]).to eq Proverb.last.body
        end
      end

      context "when searching with status" do
        it "returns proverbs that match the given status" do
          get "/api/v1/en/proverbs?status=approved"

          result = JSON.parse(response.body)
          expect(result.size).to eq 1
          expect(result.first["body"]).to eq proverb1.body
        end
      end

      describe "limit" do
        context "when present" do
          it "returns result within the given limit" do
            get "/api/v1/en/proverbs?limit=1"

            result = JSON.parse(response.body)
            expect(result.size).to eq 1
            expect(result.first["body"]).to eq proverb2.body
          end
        end
        context "when invalid" do
          it "returns result within the default limit" do
            get "/api/v1/en/proverbs?limit=asc"

            result = JSON.parse(response.body)
            expect(result.size).to eq 2
            expect(result.first["body"]).to eq proverb2.body
            expect(result.last["body"]).to eq proverb1.body
          end
        end
        context "when not present" do
          it "returns result within the default limit" do
            get "/api/v1/en/proverbs"

            result = JSON.parse(response.body)
            expect(result.size).to eq 2
            expect(result.first["body"]).to eq proverb2.body
            expect(result.last["body"]).to eq proverb1.body
          end
        end
      end

      describe "direction" do
        context "when present" do
          it "returns result with id ordered by the given direction" do
            get "/api/v1/en/proverbs?direction=asc"

            result = JSON.parse(response.body)
            expect(result.size).to eq 2
            expect(result.first["body"]).to eq proverb1.body
            expect(result.last["body"]).to eq proverb2.body
          end
        end
        context "when invalid" do
          it "returns result ordered by the default, desc" do
            get "/api/v1/en/proverbs?direction=ainvalidsc"

            result = JSON.parse(response.body)
            expect(result.size).to eq 2
            expect(result.first["body"]).to eq proverb2.body
            expect(result.last["body"]).to eq proverb1.body
          end
        end
        context "when not present" do
          it "returns result ordered by the default, desc" do
            get "/api/v1/en/proverbs?"

            result = JSON.parse(response.body)
            expect(result.size).to eq 2
            expect(result.first["body"]).to eq proverb2.body
            expect(result.last["body"]).to eq proverb1.body
          end
        end
      end

      describe "offset" do
        context "when present" do
          it "skips the given offset" do
            get "/api/v1/en/proverbs?offset=1"

            result = JSON.parse(response.body)
            expect(result.size).to eq 1
            expect(result.first["body"]).to eq proverb1.body
          end
        end
        context "when invalid" do
          it "defaults to zero" do
            get "/api/v1/en/proverbs?offset=invalid"

            result = JSON.parse(response.body)
            expect(result.size).to eq 2
            expect(result.first["body"]).to eq proverb2.body
            expect(result.last["body"]).to eq proverb1.body
          end
        end
        context "when not present"
          it "defaults to zero" do
            get "/api/v1/en/proverbs"

            result = JSON.parse(response.body)
            expect(result.size).to eq 2
            expect(result.first["body"]).to eq proverb2.body
            expect(result.last["body"]).to eq proverb1.body
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

  describe "approve" do
    let!(:proverb) { create(:proverb) }
    context "when user is a moderator" do
      it " updates the status of the proverb" do
        get "/api/v1/en/proverbs/#{proverb.id}/approve", {}, valid_session
        expect(JSON.parse(response.body)["status"]).to eq "approved"
      end
    end

    context "when user is an admin" do
      let(:user_admin) { create(:user, user_type: 2)}
      let(:valid_admin_session) { login(user_admin) }
      it " updates the status of the proverb" do
        get "/api/v1/en/proverbs/#{proverb.id}/approve", {}, valid_admin_session
        expect(JSON.parse(response.body)["status"]).to eq "approved"
      end
    end

    context "when user is a regular user" do
      let(:user_regular) { create(:user)}
      let(:valid_regular_session) { login(user_regular) }
      it " updates the status of the proverb" do
        get "/api/v1/en/proverbs/#{proverb.id}/approve", {}, valid_regular_session
        expect(response).to have_http_status(403)
      end
    end

  end
end

require "rails_helper"

RSpec.describe Api::V1::ProverbsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "api/v1/proverbs").to route_to({"default" => {"format" => :json}, "controller" => "api/v1/proverbs", "action" => "index"})
    end

    it "routes to #show" do
      expect(:get => "api/v1/proverbs/1").to route_to({"default" => {"format" => :json}, "controller" => "api/v1/proverbs", "action" => "show", "id" => "1"})
    end

    it "routes to #create" do
      expect(:post => "api/v1/proverbs").to route_to({"default" => {"format" => :json}, "controller" => "api/v1/proverbs", "action" => "create"})
    end

    it "routes to #update via PUT" do
      expect(:put => "api/v1/proverbs/1").to route_to({"default" => {"format" => :json}, "controller" => "api/v1/proverbs", "action" => "update", "id" => "1"})
    end

    it "routes to #update via PATCH" do
      expect(:patch => "api/v1/proverbs/1").to route_to({"default" => {"format" => :json}, "controller" => "api/v1/proverbs", "action" => "update", "id" => "1"})
    end

    it "routes to #destroy" do
      expect(:delete => "api/v1/proverbs/1").to route_to({"default" => {"format" => :json}, "controller" => "api/v1/proverbs", "action" => "destroy", "id" => "1"})
    end

  end
end

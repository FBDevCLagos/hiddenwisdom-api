require "facebook/account_kit"

Facebook::AccountKit.config do |c|
  c.account_kit_version = "v1.0"
  c.account_kit_app_secret = ENV["kit_app_secret"]
  c.facebook_app_id = ENV["kit_app_id"]
end

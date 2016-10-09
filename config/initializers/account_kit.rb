require "facebook/account_kit"

Facebook::AccountKit.config do |c|
  c.account_kit_version = "v1.0"
  c.account_kit_app_secret = "your account kit secret"
  c.facebook_app_id = "your facebook app id"
end

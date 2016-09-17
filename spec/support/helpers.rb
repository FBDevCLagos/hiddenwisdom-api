module Helpers
  def json
    JSON.parse(response.body)
  end

  def token_generator(user)
    user_info = { fb_id: user.fb_id, email: user.email }
    exp = Time.zone.now.to_i + 1 * 3600
    Api::V1::Authenticate.create_token(user_info, exp)
  end

  def login(user)
    token = token_generator(user)
    { "format" => :json,
      "AUTHORIZATION" => token }
  end

  def proverbs_with_translations_params
    { proverb: {
        body: "A dead person shall have all the sleep necessary.",
        language: "english",
        all_tags: ["peace", "love", "sleeep"],
        translations: [
          { body: "Some translations in igbo", language: "igbo" },
          { body: "Some translations in yoruba", language: "yoruba" },
          { body: "Some translations in hausa", language: "hausa" }
        ]
      }}
  end

  def proverbs_with_empty_translations_params
    { proverb: {
        body: "A dead person shall have all the sleep necessary.",
        language: "english",
        all_tags: ["peace", "love", "sleeep"],
        translations: [""]
      }}
  end

  def proverbs_without_translations_params
    { proverb: {
        body: "A dead person shall have all the sleep necessary.",
        language: "english",
        all_tags: ["peace", "love", "sleeep"],
      }}
  end
end

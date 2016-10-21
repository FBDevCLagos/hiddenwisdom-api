module Mocks
  module AccountKit
    def phone
      {
        id: "175649852839525",
        phone: {
          number: "+234736847989",
          country_prefix: "234",
          national_number: "736847989"
        }
      }
    end

    def email
      {
        id: "175649852839525",
        email: {
          address: "email@email.com"
        }
      }
    end

    def mock_account_kit_info(type)
      allow_any_instance_of(Facebook::AccountKit::UserAccount).
        to receive(:fetch_user_info).and_return(send(type))
    end
  end
end

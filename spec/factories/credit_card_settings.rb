FactoryBot.define do
  factory :credit_card_setting do
    company_code { "MyString" }
    company { nil }
    payment_method { nil }
  end
end

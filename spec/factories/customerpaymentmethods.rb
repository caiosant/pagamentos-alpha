FactoryBot.define do
  factory :customerpaymentmethod do
    payment_method { "MyString" }
    payment_method { nil }
    credit_card_name { "MyString" }
    credit_card_number { "MyString" }
    credit_card_expiration_date { "2021-11-25" }
    credit_card_security_code { "MyString" }
    company { nil }
    customer { nil }
    customer_payment_token { "MyString" }
  end
end

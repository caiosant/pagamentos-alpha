FactoryBot.define do
  factory :pix_setting do
    pix_key { "MyString" }
    bank_code { 1 }
    company { nil }
    payment_method { nil }
  end
end

FactoryBot.define do
  factory :boleto_setting do
    agency_number { 1 }
    account_number { 1 }
    bank_code { 1 }
    company { nil }
    payment_method { nil }
  end
end

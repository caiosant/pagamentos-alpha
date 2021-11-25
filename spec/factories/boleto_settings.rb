FactoryBot.define do
  factory :boleto_setting do
    sequence(:agency_number) { |n| "agencia#{n}" }
    sequence(:account_number) { |n| "conta#{n}" }
    bank_code { '001' }
    company
    payment_method { create :payment_method, :boleto }
  end
end

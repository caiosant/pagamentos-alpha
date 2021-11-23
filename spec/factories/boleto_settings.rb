FactoryBot.define do
  factory :boleto_setting do
    agency_number { '1' }
    account_number { '1' }
    bank_code { '001' }
    company
    payment_method { create :payment_method, :boleto }
  end
end

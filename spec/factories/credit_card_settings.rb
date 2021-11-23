FactoryBot.define do
  factory :credit_card_setting do
    company_code { '1231313' }
    company
    payment_method { create :payment_method, :credit_card }
  end
end

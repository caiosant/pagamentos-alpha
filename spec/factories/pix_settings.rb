FactoryBot.define do
  factory :pix_setting do
    sequence(:pix_key) { |n| "chave_pix#{n}" }
    bank_code { '001' }
    company
    payment_method { create :payment_method, :pix }
  end
end

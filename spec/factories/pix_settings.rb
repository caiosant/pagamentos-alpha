FactoryBot.define do
  factory :pix_setting do
    pix_key { 'chave_pix2131' }
    bank_code { '001' }
    company
    payment_method
  end
end

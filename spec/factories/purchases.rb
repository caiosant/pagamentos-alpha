FactoryBot.define do
  factory :purchase do
    customer_payment_method { nil }
    type_of { 'pix' }
    pix_setting
    boleto_setting { nil }
    credit_card_setting { nil }
    product { nil }
    cost { "9.99" }
    receipt { nil }
    paid_date { "2021-11-29" }
    expiration_date { "2021-11-29" }
  end
end

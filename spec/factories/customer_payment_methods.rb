FactoryBot.define do
  factory :customer_payment_method do
    company { create(:company, status: :accepted) }
    customer { create(:customer, company: company) }

    trait :pix do
      payment_method { create(:payment_method, :pix) }
    end

    trait :boleto do
      payment_method { create(:payment_method, :boleto) }
    end

    trait :credit_card do
      payment_method { create(:payment_method, :credit_card) }
      credit_card_name { 'Credit Card 1' }
      credit_card_number { '4929513324664053' }
      credit_card_expiration_date { 3.months.from_now }
      credit_card_security_code { '123' }
    end
  end
end

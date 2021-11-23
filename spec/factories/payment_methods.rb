FactoryBot.define do
  factory :payment_method do
    name { 'Cartão de Crédito Visa' }
    fee { '5' }
    type_of { 'credit_card' }
    maximum_fee { '50' }
    icon { Rack::Test::UploadedFile.new('app/assets/images/icone_visa.jpg', 'image/jpg') }

    trait :credit_card do
      sequence(:name) { |n| "pagamento teste #{n}: Cartão de Crédito" }
      type_of { 'credit_card' }
    end

    trait :pix do
      sequence(:name) { |n| "pagamento teste #{n}: PIX" }
      type_of { 'pix' }
    end

    trait :boleto do
      sequence(:name) { |n| "pagamento teste #{n}: boleto" }
      type_of { 'boleto' }
    end
  end
end

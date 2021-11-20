FactoryBot.define do
  factory :payment_method do
    name { 'Cartão de Crédito Visa' }
    fee { '5' }
    maximum_fee { '50' }
    icon { Rack::Test::UploadedFile.new('app/assets/images/icone_visa.jpg', 'image/jpg') }
  end

  factory :payment_methods, parent: :payment_method do
    sequence(:name) { |n| "Payment #{n}" }
  end
end

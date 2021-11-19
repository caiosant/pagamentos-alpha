FactoryBot.define do
  factory :payment_method do
    name { 'Cartão de Crédito Visa' }
    fee { '5' }
    maximum_fee { '50' }
    icon { Rack::Test::UploadedFile.new('app/assets/images/icone_visa.jpg', 'image/jpg') }
  end
end

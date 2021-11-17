FactoryBot.define do
  factory :payment_method do
    name { 'MyString' }
    fee { '9.99' }
    maximum_fee { '9.99' }
  end
end

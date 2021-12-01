FactoryBot.define do
  factory :customer_subscription do
    token { 'MyString' }
    status { 1 }
    cost { '9.99' }
    renovation_date { '2021-11-30' }
    product { nil }
    customer_payment_method { nil }
  end
end

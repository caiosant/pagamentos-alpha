FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@pagapaga.com.br" }
    password { '123456789' }
  end
end

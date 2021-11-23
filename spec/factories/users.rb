FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@companymail#{n}.com" }
    password { '123456789' }

    trait :complete_company_owner do
      company
      owner { true }
    end
  end
end

FactoryBot.define do
  factory :rejected_company do
    company { nil }
    reason { 'MyText' }
  end
end

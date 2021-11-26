FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "produto teste #{n}" }
    company
  end
end

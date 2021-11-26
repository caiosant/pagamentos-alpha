FactoryBot.define do
  factory :subscription do
    sequence(:name) { |n| "assinatura teste #{n}" }
    company
  end
end

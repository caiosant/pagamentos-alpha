FactoryBot.define do
  factory :company do
    sequence(:cnpj) { |n| "#{n}#{n}.#{n}#{n}#{n}.#{n}#{n}#{n}/#{n}#{n}#{n}#{n}-#{n}#{n}" }
    sequence(:legal_name) { |n| "Empresa n#{n}" }
    sequence(:billing_email) { |n| "test#{n}@companymail.com" }
    sequence(:billing_address) { |n| "endereco numero da empresa numero #{n}" }
  end
end

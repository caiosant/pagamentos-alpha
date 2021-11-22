def cnpj_sequence(sequence_number)
  number_string = format('%014d', sequence_number)
  "#{number_string.slice(0, 2)}."\
    "#{number_string.slice(1, 3)}."\
    "#{number_string.slice(4, 3)}/"\
    "#{number_string.slice(8, 4)}-"\
    "#{number_string.slice(12, 2)}"
end

FactoryBot.define do
  factory :company do
    sequence(:cnpj) do |n|
      cnpj_sequence n
    end
    sequence(:legal_name) { |n| "Empresa n#{n}" }
    sequence(:billing_email) { |n| "test#{n}@companymail.com" }
    sequence(:billing_address) { |n| "endereco numero da empresa numero #{n}" }
  end
end

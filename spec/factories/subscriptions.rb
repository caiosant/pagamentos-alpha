FactoryBot.define do
  factory :subscription do
    token { 'MyString' }
    name { 'MyText' }
    status { 5 }
    company
  end
end

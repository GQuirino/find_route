FactoryBot.define do
  factory :distance do
    association :map
    origin { 'A' }
    destiny { 'B' }
    distance { 10 }
  end
end

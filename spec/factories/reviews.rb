FactoryBot.define do
  factory :review do
    property { nil }
    user { nil }
    rating { 1 }
    comment { "MyText" }
  end
end

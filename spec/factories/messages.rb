FactoryBot.define do
  factory :message do
    content { "MyText" }
    sender { nil }
    receiver { nil }
    property { nil }
    read { false }
  end
end

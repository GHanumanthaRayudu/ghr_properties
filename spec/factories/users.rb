FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { :customer }

    trait :developer do
      role { :developer }
    end

    trait :agent do
      role { :agent }
    end

    trait :customer do
      role { :customer }
    end

    factory :developer, traits: [:developer]
    factory :agent, traits: [:agent]
    factory :customer, traits: [:customer]
  end
end

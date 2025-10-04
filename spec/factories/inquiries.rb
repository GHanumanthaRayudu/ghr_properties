FactoryBot.define do
  factory :inquiry do
    association :customer, factory: :user, role: :customer
    association :property
    message { "I am interested in this property and would like to know more details." }
    status { :pending }
  end
end



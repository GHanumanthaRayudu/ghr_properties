FactoryBot.define do
  factory :property do
    association :user, factory: :developer
    title { "Beautiful 3BHK Apartment" }
    description { "A wonderful property with modern amenities and great location" }
    price { 5000000 }
    property_type { :apartment }
    status { :available }
    address { "123 Main Street" }
    city { "Mumbai" }
    state { "Maharashtra" }
    zip_code { "400001" }
    latitude { 19.0760 }
    longitude { 72.8777 }
    bedrooms { 3 }
    bathrooms { 2 }
    area { 1200 }
    furnished { false }
    parking { true }
  end
end

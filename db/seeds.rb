# Clear existing data
puts "🗑️  Cleaning database..."
Inquiry.destroy_all
Review.destroy_all
Message.destroy_all
Transaction.destroy_all
Favorite.destroy_all
Property.destroy_all
User.destroy_all

# Create users with specific roles
puts "👤 Creating users with roles..."

developer = User.create!(
  email: "developer@example.com",
  password: "password123",
  password_confirmation: "password123",
  role: :developer
  # Developers don't need phone verification
)

agent = User.create!(
  email: "agent@example.com",
  password: "password123",
  password_confirmation: "password123",
  role: :agent,
  phone_number: "9876543210",
  phone_verified_at: Time.current # Pre-verified for testing
)

customer = User.create!(
  email: "customer@example.com",
  password: "password123",
  password_confirmation: "password123",
  role: :customer,
  phone_number: "9876543211",
  phone_verified_at: Time.current # Pre-verified for testing
)

# Create additional users
additional_developers = 2.times.map do |i|
  User.create!(
    email: "developer#{i + 2}@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: :developer
  )
end

additional_agents = 2.times.map do |i|
  User.create!(
    email: "agent#{i + 2}@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: :agent,
    phone_number: "987654321#{i + 2}",
    phone_verified_at: Time.current
  )
end

additional_customers = 3.times.map do |i|
  User.create!(
    email: "customer#{i + 2}@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: :customer,
    phone_number: "987654321#{i + 4}",
    phone_verified_at: Time.current
  )
end

developers = [developer] + additional_developers
agents = [agent] + additional_agents
customers = [customer] + additional_customers
all_users = developers + agents + customers

puts "✅ Created #{User.count} users (#{developers.count} developers, #{agents.count} agents, #{customers.count} customers)"

# Create properties
puts "🏠 Creating properties..."
properties = []

cities = [
  { name: "Mumbai", state: "Maharashtra", pincode: "400001" },
  { name: "Delhi", state: "Delhi", pincode: "110001" },
  { name: "Bangalore", state: "Karnataka", pincode: "560001" },
  { name: "Hyderabad", state: "Telangana", pincode: "500001" },
  { name: "Chennai", state: "Tamil Nadu", pincode: "600001" },
  { name: "Pune", state: "Maharashtra", pincode: "411001" },
  { name: "Kolkata", state: "West Bengal", pincode: "700001" },
  { name: "Ahmedabad", state: "Gujarat", pincode: "380001" }
]

property_types = [:house, :apartment, :condo, :land, :commercial]
property_statuses = [:available, :sold, :ongoing, :rented]
property_owners = developers + agents

20.times do |i|
  city = cities.sample
  property_type = property_types.sample
  status = property_statuses.sample
  bedrooms = [1, 2, 3, 4, 5].sample
  
  base_price = rand(50000..10000000)
  
  properties << Property.create!(
    user: property_owners.sample,
    title: "#{['Spacious', 'Luxurious', 'Modern', 'Beautiful', 'Cozy'].sample} #{bedrooms}BHK #{property_type.to_s.titleize} in #{city[:name]}",
    description: "This is a wonderful #{property_type} located in the heart of #{city[:name]}. " \
                "Perfect for families and professionals looking for a comfortable living space. " \
                "The property features #{bedrooms} bedrooms, modern amenities, and is located in a prime area " \
                "with easy access to schools, hospitals, shopping centers, and public transportation. " \
                "The neighborhood is safe and peaceful, ideal for comfortable living.",
    property_type: property_type,
    status: status,
    price: base_price,
    bedrooms: bedrooms,
    bathrooms: [1, 2, 3].sample,
    area: rand(500..3000),
    address: "#{rand(1..999)} #{['MG Road', 'Park Street', 'Main Road', 'Church Street', 'Brigade Road'].sample}",
    city: city[:name],
    state: city[:state],
    zip_code: city[:pincode],
    furnished: [true, false].sample,
    parking: [true, false].sample
  )
end

puts "✅ Created #{properties.count} properties"

# Create reviews
puts "⭐ Creating reviews..."
reviews = []

properties.sample(10).each do |property|
  # Get a unique set of users for this property
  reviewers = all_users.shuffle.take(rand(1..3))
  reviewers.each do |reviewer|
    next if reviewer == property.user  # Skip property owner
    reviews << Review.create!(
      property: property,
      user: reviewer,
      rating: rand(3..5),
      comment: [
        "Great property! Highly recommended. The location is perfect and the owner is very cooperative.",
        "Nice place, well maintained. Good amenities and peaceful neighborhood.",
        "Perfect for families. Spacious rooms and good ventilation.",
        "Excellent property with all modern amenities. Worth the price!",
        "Good value for money. Clean and well-maintained property.",
        "Loved the location and the property condition. Very satisfied!",
        "Amazing property! Exactly as described. Great experience."
      ].sample
    )
  end
end

puts "✅ Created #{reviews.count} reviews"

# Create messages
puts "💬 Creating messages..."
messages = []

10.times do
  sender = all_users.sample
  receiver = all_users.sample
  property = properties.sample
  
  next if sender == receiver
  
  messages << Message.create!(
    sender: sender,
    receiver: receiver,
    property: property,
    subject: "Inquiry about #{property.title}",
    content: [
      "Hi, I'm interested in this property. Is it still available?",
      "Can I schedule a visit to see the property this weekend?",
      "What is the security deposit amount?",
      "Are pets allowed in this property?",
      "Is the property negotiable on price?",
      "When can I move in if I finalize today?",
      "Does the property have 24/7 water and electricity backup?"
    ].sample,
    read: [true, false].sample
  )
end

puts "✅ Created #{messages.count} messages"

# Create inquiries
puts "📋 Creating inquiries..."
inquiries = []

properties.sample(8).each do |property|
  rand(1..3).times do
    inquiries << Inquiry.create!(
      property: property,
      customer: customers.sample,
      message: [
        "I am very interested in this property. Could you please provide more details about the location and amenities?",
        "Is this property still available? I would like to schedule a viewing at your earliest convenience.",
        "What are the payment terms for this property? Is there any flexibility on the price?",
        "I am looking for a property in this area. Can you tell me more about the neighborhood and nearby facilities?",
        "This looks like exactly what I need. When would be the earliest move-in date?",
        "Could you provide more information about the maintenance costs and any additional fees?",
        "I'm interested in purchasing this property. What is the next step in the process?",
        "Is there any room for negotiation on the asking price? I am a serious buyer."
      ].sample,
      status: [:pending, :responded, :closed].sample
    )
  end
end

puts "✅ Created #{inquiries.count} inquiries"

puts "\n🎉 Database seeded successfully!"
puts "\n📊 Summary:"
puts "   Users: #{User.count}"
puts "     - Developers: #{User.developer.count}"
puts "     - Agents: #{User.agent.count}"
puts "     - Customers: #{User.customer.count}"
puts "   Properties: #{Property.count}"
puts "   Reviews: #{Review.count}"
puts "   Messages: #{Message.count}"
puts "   Inquiries: #{Inquiry.count}"
puts "\n👤 Test Accounts:"
puts "   Developer: developer@example.com / password123"
puts "   Agent: agent@example.com / password123"
puts "   Customer: customer@example.com / password123"
puts "\n📝 Role Capabilities:"
puts "   ✓ Developers & Agents can post and manage properties"
puts "   ✓ Customers can browse properties and send inquiries"
puts "   ✓ Property owners can view and respond to inquiries"
puts "\n🚀 Visit http://localhost:3000 to see your application!"

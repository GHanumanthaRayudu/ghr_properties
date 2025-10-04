# 🚀 GHR Properties - Setup & Run Guide

## Complete Property Management System with Role-Based Access

---

## 📋 Quick Setup

### 1. **Run Migrations**

```bash
cd /Users/hanumantharayudu/Workspace/ghr_properties

# Run all migrations
bin/rails db:migrate
```

This will:
- Add `role` column to users (developer/agent/customer)
- Create `inquiries` table
- Convert property status and type to enums

### 2. **Seed the Database**

```bash
bin/rails db:seed
```

This creates:
- **3 Main Users:**
  - Developer: `developer@example.com` / `password123`
  - Agent: `agent@example.com` / `password123`
  - Customer: `customer@example.com` / `password123`
- **Additional Users:** 2 more developers, 2 agents, 3 customers
- **20 Properties** (posted by developers & agents)
- **Sample Reviews**
- **Sample Messages**
- **Sample Inquiries**

### 3. **Start the Server**

```bash
# Option 1: Using bin/dev (includes Tailwind CSS watcher)
bin/dev

# Option 2: Just Rails server
bin/rails server -p 3000
```

### 4. **Visit the Application**

Open your browser and go to: **http://localhost:3000**

---

## 👥 User Roles & Capabilities

### 🏗️ **Developers**
- ✅ Can post properties
- ✅ Can edit/delete their properties
- ✅ Can view and manage inquiries for their properties
- ✅ Can browse all properties
- ❌ Cannot submit inquiries

### 🏢 **Agents**
- ✅ Can post properties
- ✅ Can edit/delete their properties
- ✅ Can view and manage inquiries for their properties
- ✅ Can browse all properties
- ❌ Cannot submit inquiries

### 👤 **Customers**
- ✅ Can browse all properties
- ✅ Can submit inquiries to properties
- ✅ Can add properties to favorites
- ✅ Can compare properties
- ✅ Can write reviews
- ❌ Cannot post properties

---

## 🎯 Key Features Implemented

### 1. **Role-Based Authorization**
```ruby
# Only developers & agents can post properties
user.can_post_property?

# Only customers can submit inquiries
user.customer?

# Property owners can manage inquiries
user.can_manage_inquiries?
```

### 2. **Advanced Property Filtering**
- Filter by **Status** (Available, Sold, Ongoing, Rented)
- Filter by **Property Type** (House, Apartment, Condo, Land, Commercial)
- Filter by **Location** (City or State)
- Filter by **Price Range** (Min & Max)

### 3. **Inquiry System**
- Customers can send inquiries to property owners
- Property owners receive and view all inquiries
- Status tracking: Pending → Responded → Closed
- Beautiful UI with Tailwind CSS

### 4. **Property Management**
- CRUD operations for developers & agents
- Property status management
- Reviews and ratings
- Favorites system
- Comparison feature

---

## 📁 New Files Created

### **Migrations:**
```
db/migrate/20251003205000_add_role_to_users.rb
db/migrate/20251003205100_create_inquiries.rb
db/migrate/20251003205200_update_property_status_and_type_to_integer.rb
```

### **Models:**
```
app/models/inquiry.rb (NEW)
app/models/user.rb (UPDATED - added roles)
app/models/property.rb (UPDATED - added enums & scopes)
```

### **Controllers:**
```
app/controllers/inquiries_controller.rb (NEW)
app/controllers/properties_controller.rb (UPDATED - added filters & authorization)
```

### **Views:**
```
app/views/inquiries/_form.html.erb (NEW)
app/views/inquiries/index.html.erb (NEW)
app/views/inquiries/show.html.erb (NEW)
app/views/properties/show.html.erb (UPDATED - added inquiry section)
app/views/properties/index.html.erb (UPDATED - enhanced filters)
```

### **Tests:**
```
spec/models/user_updated_spec.rb
spec/models/property_updated_spec.rb
spec/models/inquiry_spec.rb
spec/requests/properties_spec.rb
spec/requests/inquiries_spec.rb
spec/factories/users.rb (UPDATED)
spec/factories/properties.rb (UPDATED)
spec/factories/inquiries.rb (NEW)
```

---

## 🧪 Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/
bundle exec rspec spec/requests/

# Run with documentation format
bundle exec rspec --format documentation
```

---

## 🎨 UI Features

### **Beautiful Tailwind CSS Design:**
- ✨ Modern gradient backgrounds
- 📊 Status badges with color coding
- 🎯 Clean card layouts
- 📱 Fully responsive design
- 🔄 Smooth transitions and hover effects
- 📈 Statistics dashboards
- 🏷️ Active filter tags
- 💬 Message and inquiry cards

### **Inquiry System UI:**
- 📝 Customer inquiry form with validation
- 📊 Property owner inquiry dashboard
- 📋 Inquiry detail view with timeline
- 🎨 Status-based color coding
- ⚡ Quick status update forms

### **Enhanced Filters:**
- 🔍 Multi-field search
- 🏷️ Active filter display with remove options
- 📊 Real-time results count
- 🎯 Icons for each filter field

---

## 🗺️ Routes Overview

### **Properties:**
```ruby
GET    /properties              # List all properties (with filters)
GET    /properties/:id          # Show property details
GET    /properties/new          # New property form (developers/agents only)
POST   /properties              # Create property (developers/agents only)
GET    /properties/:id/edit     # Edit property form (owner only)
PATCH  /properties/:id          # Update property (owner only)
DELETE /properties/:id          # Delete property (owner only)
```

### **Inquiries:**
```ruby
GET    /properties/:id/inquiries       # List inquiries (property owner)
POST   /properties/:id/inquiries       # Create inquiry (customers only)
GET    /inquiries/:id                  # Show inquiry details
PATCH  /inquiries/:id                  # Update inquiry status (owner)
```

---

## 📊 Database Schema

### **Users Table:**
```ruby
- email (string)
- encrypted_password (string)
- role (integer) # 0: developer, 1: agent, 2: customer
- created_at, updated_at
```

### **Properties Table:**
```ruby
- title, description
- price (decimal)
- status (integer) # 0: available, 1: sold, 2: ongoing, 3: rented
- property_type (integer) # 0: house, 1: apartment, 2: condo, 3: land, 4: commercial
- bedrooms, bathrooms (integer)
- area (decimal)
- city, state, address, zip_code
- furnished, parking (boolean)
- user_id (references users)
- created_at, updated_at
```

### **Inquiries Table:**
```ruby
- customer_id (references users)
- property_id (references properties)
- message (text)
- status (integer) # 0: pending, 1: responded, 2: closed
- created_at, updated_at
```

---

## 🔐 Test Accounts

### Sign in with these accounts:

| Role      | Email                    | Password    | Capabilities                          |
|-----------|--------------------------|-------------|---------------------------------------|
| Developer | developer@example.com    | password123 | Post properties, manage inquiries     |
| Agent     | agent@example.com        | password123 | Post properties, manage inquiries     |
| Customer  | customer@example.com     | password123 | Browse, inquire, review, favorite     |

---

## 🎯 How to Use

### **As a Developer/Agent:**
1. Sign in with developer or agent account
2. Click "Post Property" in the navigation
3. Fill in property details and submit
4. View inquiries on your property pages
5. Update inquiry status (Pending → Responded → Closed)

### **As a Customer:**
1. Sign in with customer account
2. Browse properties with filters
3. Click on a property to view details
4. Fill out the "Send an Inquiry" form
5. View your inquiry status

---

## 🐛 Troubleshooting

### **If migrations fail:**
```bash
# Check migration status
bin/rails db:migrate:status

# Rollback if needed
bin/rails db:rollback

# Run again
bin/rails db:migrate
```

### **If seed fails:**
```bash
# Reset database
bin/rails db:reset

# This will drop, create, migrate, and seed
```

### **If Tailwind CSS isn't working:**
```bash
# Build Tailwind CSS
bin/rails tailwindcss:build

# Or use bin/dev to watch for changes
bin/dev
```

---

## 📚 Additional Resources

- **Implementation Summary:** See `IMPLEMENTATION_SUMMARY.md` for detailed technical documentation
- **Tests:** Run `bundle exec rspec --format documentation` to see all test scenarios
- **Models:** Check `app/models/` for business logic
- **Controllers:** Check `app/controllers/` for request handling

---

## ✅ Completed Features

- [x] User roles (Developer, Agent, Customer)
- [x] Role-based property posting authorization
- [x] Property CRUD with validations
- [x] Inquiry system (create, view, update status)
- [x] Advanced filtering (status, type, location, price)
- [x] Beautiful Tailwind CSS UI
- [x] Complete test coverage (models & controllers)
- [x] Seed data with sample users, properties, inquiries
- [x] Property enums (status & type)
- [x] Inquiry status tracking
- [x] Authorization at all levels

---

## 🎉 You're All Set!

Your property management system is now fully functional with:
- ✅ 3 distinct user roles
- ✅ Role-based authorization
- ✅ Inquiry system
- ✅ Advanced filtering
- ✅ Beautiful UI
- ✅ Complete test coverage

**Happy coding! 🚀**



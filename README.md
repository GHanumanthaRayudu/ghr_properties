# 🏠 GHR Properties

A modern property rental and real estate platform built with Ruby on Rails, featuring zero brokerage property listings, direct owner communication, and a beautiful UI.

![Rails](https://img.shields.io/badge/Rails-8.0-red)
![Ruby](https://img.shields.io/badge/Ruby-3.x-red)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue)
![TailwindCSS](https://img.shields.io/badge/TailwindCSS-Styling-38B2AC)

## ✨ Features

### 🎨 Beautiful Modern UI
- **Tailwind CSS** powered responsive design
- Mobile-first approach
- Smooth animations and transitions
- Intuitive user experience

### 🏘️ Property Management
- Post properties for rent or sale
- Advanced search and filtering
- Detailed property pages with images
- Property owner dashboard
- Edit and delete your listings

### 🔐 User Authentication
- Secure sign-up and sign-in with **Devise**
- JWT token support for API authentication
- Password recovery
- Session management

### 💬 Communication
- Direct messaging between users
- Property-specific inquiries
- Message tracking and notifications

### ⭐ Reviews & Ratings
- Review properties
- Rating system (1-5 stars)
- Read reviews from other users

### 🔍 Advanced Search
- Filter by property type (Apartment, House, Villa, Commercial)
- Filter by listing type (Rent, Sale)
- Price range filtering
- Location-based search
- Pagination for large result sets

### 📊 User Dashboard
- View all your properties
- Track messages
- Manage reviews
- Quick stats overview

## 🚀 Getting Started

### Prerequisites

- Ruby 3.x
- Rails 8.0.3
- PostgreSQL
- Node.js (for asset compilation)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd ghr_properties
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup the database**
   ```bash
   # Create databases
   bin/rails db:create
   
   # Run migrations
   bin/rails db:migrate
   
   # (Optional) Seed sample data
   bin/rails db:seed
   ```

4. **Install Tailwind CSS**
   ```bash
   bundle exec rails tailwindcss:install
   ```

5. **Start the development server**
   ```bash
   # Option 1: Using bin/dev (starts Rails + Tailwind watcher)
   bin/dev
   
   # Option 2: Separate terminals
   # Terminal 1:
   bin/rails server
   
   # Terminal 2:
   bin/rails tailwindcss:watch
   ```

6. **Visit the application**
   ```
   http://localhost:3000
   ```

## 📁 Project Structure

```
ghr_properties/
├── app/
│   ├── assets/           # Stylesheets and static assets
│   ├── controllers/      # Application controllers
│   ├── models/          # ActiveRecord models
│   ├── views/           # ERB templates
│   │   ├── layouts/     # Application layouts
│   │   ├── home/        # Home page
│   │   ├── properties/  # Property views
│   │   ├── dashboards/  # User dashboard
│   │   └── devise/      # Authentication views
│   └── javascript/      # JavaScript files
├── config/
│   ├── routes.rb        # Application routes
│   ├── database.yml     # Database configuration
│   └── tailwind.config.js # Tailwind configuration
├── db/
│   ├── migrate/         # Database migrations
│   └── schema.rb        # Current database schema
├── spec/               # RSpec tests
├── Gemfile             # Ruby dependencies
└── README.md           # This file
```

## 🗄️ Database Schema

### Users
- Email & encrypted password (Devise)
- Associations: properties, messages, reviews, transactions

### Properties
- Title, description, price
- Property type (apartment, house, villa, commercial)
- Listing type (rent, sale)
- Bedrooms, bathrooms, area
- Location (address, city, state, zip code)
- Geocoding support (latitude, longitude)
- Owner (belongs to User)

### Messages
- Content
- Sender and receiver (Users)
- Related property
- Read status

### Reviews
- Property and user associations
- Rating (1-5)
- Comment

### Transactions
- Property, buyer, and seller
- Transaction type and status
- Amount, start date, end date

## 🛠️ Technologies

### Backend
- **Ruby on Rails 8.0** - Web framework
- **PostgreSQL** - Database
- **Devise** - Authentication
- **Devise-JWT** - API authentication
- **Kaminari** - Pagination

### Frontend
- **Tailwind CSS** - Styling
- **Turbo & Stimulus** - Hotwire for modern interactions
- **ERB** - Templating

### Additional Features
- **Geocoder** - Location services
- **Ransack** - Advanced search
- **CarrierWave** - File uploads
- **Sidekiq** - Background jobs
- **ActiveModel Serializers** - API responses

## 📝 Key Routes

```ruby
# Authentication
GET  /users/sign_in          # Sign in page
POST /users/sign_in          # Create session
GET  /users/sign_up          # Sign up page
POST /users              # Create user
DELETE /users/sign_out       # Sign out

# Properties
GET  /properties             # List all properties
GET  /properties/:id         # Property details
GET  /properties/new         # New property form
POST /properties             # Create property
GET  /properties/:id/edit    # Edit property form
PATCH /properties/:id        # Update property
DELETE /properties/:id       # Delete property

# Dashboard
GET  /dashboard              # User dashboard

# Home
GET  /                       # Landing page
```

## 🎨 Customization

### Changing the Color Scheme

Edit `config/tailwind.config.js`:

```javascript
theme: {
  extend: {
    colors: {
      primary: {
        50: '#your-color',
        // ... other shades
      }
    }
  }
}
```

### Adding Custom Styles

Edit `app/assets/stylesheets/application.tailwind.css`:

```css
@layer components {
  .custom-class {
    @apply bg-blue-500 text-white p-4;
  }
}
```

## 🧪 Testing

Run the test suite:

```bash
bundle exec rspec
```

## 📦 Deployment

This application is configured for deployment with:
- **Kamal** - Docker-based deployment
- **Thruster** - HTTP/2 proxy

See `SETUP.md` for detailed setup instructions.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the MIT License.

## 👥 Authors

Built as a learning project for Ruby on Rails and modern web development.

## 🙏 Acknowledgments

- Inspired by zero-brokerage property platforms
- Built with Ruby on Rails
- Styled with Tailwind CSS
- Icons: Emoji (for demo purposes)

---

**Need help?** Check out `SETUP.md` for detailed setup instructions and troubleshooting.

Happy coding! 🚀

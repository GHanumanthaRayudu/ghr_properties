# 🚀 Quick Installation Guide

Follow these steps to get your GHR Properties application up and running!

## Step 1: Install Dependencies

```bash
bundle install
```

## Step 2: Install Tailwind CSS

```bash
bundle exec rails tailwindcss:install
```

## Step 3: Setup Database

```bash
# Create the database
bin/rails db:create

# Run migrations
bin/rails db:migrate

# Seed with sample data (optional but recommended)
bin/rails db:seed
```

## Step 4: Start the Application

### Option A: Using bin/dev (Recommended)

```bash
bin/dev
```

This will start both the Rails server and Tailwind CSS watcher in one command.

### Option B: Manual Start (Two Terminals)

**Terminal 1 - Rails Server:**
```bash
bin/rails server
```

**Terminal 2 - Tailwind CSS Watcher:**
```bash
bin/rails tailwindcss:watch
```

## Step 5: Open in Browser

Visit: **http://localhost:3000**

## 🎉 You're Done!

### Test Accounts (after seeding)

- **Email:** user1@example.com
- **Password:** password123

You can also use user2, user3, user4, or user5 with the same password.

## 📖 What You'll See

1. **Beautiful Home Page** with property search
2. **Property Listings** with filters
3. **Detailed Property Pages** with reviews
4. **User Dashboard** with stats and properties
5. **Styled Authentication** pages

## ❓ Troubleshooting

### Styles not loading?
Make sure Tailwind is running:
```bash
bin/rails tailwindcss:build
```

### Database errors?
Reset the database:
```bash
bin/rails db:reset
```

### Port already in use?
Use a different port:
```bash
bin/rails server -p 3001
```

## 🎨 Next Steps

- Browse properties at `/properties`
- Sign in with test account
- Post a new property at `/properties/new`
- View your dashboard at `/dashboard`

Enjoy your beautiful GHR Properties platform! 🏠


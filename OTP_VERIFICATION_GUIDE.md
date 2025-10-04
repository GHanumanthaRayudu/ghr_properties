# 📱 OTP Verification System - Implementation Guide

## Overview
This guide explains the OTP (One-Time Password) verification system implemented for Agents and Customers during registration.

---

## ✅ Features Implemented

### 1. **Role-Based Phone Verification**
- ✅ **Developers**: No phone verification required
- ✅ **Agents**: Mandatory phone verification with OTP
- ✅ **Customers**: Mandatory phone verification with OTP

### 2. **Security Features**
- ✅ 6-digit OTP generation
- ✅ OTP expires in 10 minutes
- ✅ Maximum 3 attempts to enter correct OTP
- ✅ Resend OTP with 1-minute cooldown
- ✅ Phone number uniqueness validation
- ✅ 10-digit Indian mobile number format (+91)

### 3. **User Flow**
1. User selects role (Developer/Agent/Customer)
2. For Agents & Customers: Phone number field appears
3. User completes registration
4. OTP sent to phone number (logged in console for development)
5. User enters OTP on verification page
6. Upon successful verification, user can access the application

---

## 📁 Files Created/Modified

### **New Migrations:**
```
db/migrate/20251003210000_add_phone_and_otp_to_users.rb
```
- Adds `phone_number`, `otp_code`, `otp_sent_at`, `phone_verified_at`, `otp_attempts`
- Adds unique index on `phone_number`

### **New Controllers:**
```
app/controllers/users/registrations_controller.rb
app/controllers/otp_verifications_controller.rb
```

### **New Service:**
```
app/services/sms_service.rb
```
- Mock SMS service for development
- Logs OTP to console (for production: integrate Twilio/AWS SNS)

### **New Views:**
```
app/views/otp_verifications/new.html.erb
```
- Beautiful OTP verification page with Tailwind CSS

### **Modified Files:**
- `app/models/user.rb` - Added OTP methods and validations
- `app/views/devise/registrations/new.html.erb` - Added phone number field
- `config/routes.rb` - Added OTP routes
- `db/seeds.rb` - Added phone numbers for seeded users
- `config/locales/devise.custom.en.yml` - Custom Devise messages

---

## 🚀 How to Run

### **1. Run Migration:**
```bash
cd /Users/hanumantharayudu/Workspace/ghr_properties
bash -c "bin/rails db:migrate"
```

### **2. Reset and Seed Database (Optional):**
```bash
bash -c "bin/rails db:reset"
```

### **3. Start Server:**
```bash
bash -c "bin/rails server -p 3000"
```

---

## 🧪 Testing the Feature

### **Test as Agent/Customer (with OTP verification):**

1. **Sign Up:**
   - Go to http://localhost:3000/users/sign_up
   - Select "Agent" or "Customer" as role
   - Fill in email: `test@example.com`
   - Fill in phone: `9123456789` (any 10-digit number)
   - Fill in password and confirmation
   - Click "Sign up"

2. **Check Console for OTP:**
   - Look at your Rails server console
   - You'll see something like:
   ```
   ================================================================================
   📱 OTP SENT (Development Mode)
   Phone: 9123456789
   OTP Code: 123456
   Expires: 10 minutes
   ================================================================================
   ```

3. **Enter OTP:**
   - Copy the 6-digit OTP from console
   - Enter it on the verification page
   - Click "Verify OTP"

4. **Success:**
   - You'll be redirected to the home page
   - Your phone is now verified!

### **Test as Developer (no OTP required):**
1. Go to sign up page
2. Select "Developer" as role
3. Phone number field will hide automatically
4. Complete registration
5. You're logged in immediately (no OTP needed)

---

## 🔐 User Model Methods

### **OTP Generation:**
```ruby
user.generate_otp
# Generates 6-digit OTP, sets timestamp, resets attempts
```

### **OTP Verification:**
```ruby
user.verify_otp("123456")
# Returns true if OTP is correct and not expired
# Increments attempt counter on failure
```

### **Check if OTP Expired:**
```ruby
user.otp_expired?
# Returns true if OTP is older than 10 minutes
```

### **Check if Can Resend:**
```ruby
user.can_resend_otp?
# Returns true if last OTP was sent >1 minute ago
```

### **Check if Phone Verified:**
```ruby
user.phone_verified?
# Returns true if phone_verified_at is set
```

---

## 📊 Database Schema

### **Users Table (Additional Columns):**
```ruby
phone_number       :string    (indexed, unique)
otp_code          :string
otp_sent_at       :datetime
phone_verified_at :datetime
otp_attempts      :integer   (default: 0)
```

---

## 🎨 UI Features

### **Registration Page:**
- ✨ Role selector dropdown
- ✨ Conditional phone number field (shows/hides based on role)
- ✨ +91 country code prefix
- ✨ 10-digit validation
- ✨ Clear helper text

### **OTP Verification Page:**
- ✨ Large, centered OTP input field
- ✨ Shows phone number being verified
- ✨ Remaining attempts counter
- ✨ Resend OTP button (with cooldown)
- ✨ Countdown timer display
- ✨ Helpful tips section
- ✨ Sign out option for wrong number

---

## 🔄 OTP Flow Diagram

```
┌─────────────────┐
│   Sign Up Form  │
│  (with phone)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Generate OTP    │
│ Send via SMS    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  OTP Verify     │
│  Page           │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
  Valid    Invalid
    │         │
    │         ▼
    │   ┌─────────┐
    │   │ Retry   │
    │   │ (max 3) │
    │   └─────────┘
    │
    ▼
┌─────────────────┐
│ Phone Verified  │
│ Access Granted  │
└─────────────────┘
```

---

## 🛠️ Production Integration

### **For SMS Gateway Integration:**

Replace the mock service in `app/services/sms_service.rb`:

#### **Option 1: Twilio**
```ruby
# Add to Gemfile
gem 'twilio-ruby'

# In sms_service.rb
def self.send_otp(phone_number, otp_code)
  client = Twilio::REST::Client.new(
    ENV['TWILIO_ACCOUNT_SID'],
    ENV['TWILIO_AUTH_TOKEN']
  )
  
  client.messages.create(
    from: ENV['TWILIO_PHONE_NUMBER'],
    to: "+91#{phone_number}",
    body: "Your OTP for GHR Properties is: #{otp_code}. Valid for 10 minutes."
  )
end
```

#### **Option 2: AWS SNS**
```ruby
# Add to Gemfile
gem 'aws-sdk-sns'

# In sms_service.rb
def self.send_otp(phone_number, otp_code)
  sns = Aws::SNS::Client.new(
    region: ENV['AWS_REGION'],
    credentials: Aws::Credentials.new(
      ENV['AWS_ACCESS_KEY_ID'],
      ENV['AWS_SECRET_ACCESS_KEY']
    )
  )
  
  sns.publish(
    phone_number: "+91#{phone_number}",
    message: "Your OTP for GHR Properties is: #{otp_code}. Valid for 10 minutes."
  )
end
```

---

## 🧪 Test Scenarios

### **Happy Path:**
1. ✅ Sign up as Agent with valid phone
2. ✅ Receive OTP
3. ✅ Enter correct OTP
4. ✅ Phone verified, access granted

### **Error Scenarios:**
1. ❌ **Expired OTP**: Wait >10 minutes, enter OTP → Error message
2. ❌ **Wrong OTP**: Enter incorrect code → Attempts counter decreases
3. ❌ **Max Attempts**: Enter wrong OTP 3 times → Must request new OTP
4. ❌ **Resend Too Soon**: Try to resend <1 minute → Error message
5. ❌ **Duplicate Phone**: Try to register with existing phone → Validation error

---

## 📝 Environment Variables (Production)

Add these to your `.env` file:

```bash
# For Twilio
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=your_twilio_number

# For AWS SNS
AWS_REGION=ap-south-1
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
```

---

## 🎯 Key Security Features

1. ✅ **Time-Based Expiration**: OTP expires in 10 minutes
2. ✅ **Attempt Limiting**: Maximum 3 attempts per OTP
3. ✅ **Cooldown Period**: 1 minute between OTP resends
4. ✅ **Unique Phone Numbers**: Each phone can only be registered once
5. ✅ **Session Management**: Prevents access until phone verified
6. ✅ **Secure Storage**: OTP is cleared after successful verification

---

## 🐛 Troubleshooting

### **"Phone number is required" error:**
- Make sure you selected "Agent" or "Customer" role
- Phone field only appears for these roles

### **OTP not showing in console:**
- Check Rails server logs
- Look for lines with "📱 OTP SENT"
- OTP is printed in console output

### **Can't sign in after registration:**
- Check if phone is verified: `User.last.phone_verified?`
- Verify in console: `User.last.update(phone_verified_at: Time.current)`

### **"Too many attempts" error:**
- User exceeded 3 attempts
- Click "Resend OTP" to get a new code

---

## ✅ Completed Features

- [x] Add phone number field to User model
- [x] OTP generation and validation logic
- [x] SMS service (mock for development)
- [x] Custom Devise registration controller
- [x] OTP verification controller
- [x] Beautiful OTP verification page
- [x] Role-based phone requirement
- [x] Attempt limiting
- [x] Resend functionality
- [x] Auto-hide phone field for developers
- [x] Seed data with phone numbers
- [x] Custom Devise messages

---

## 🚀 Next Steps (Optional Enhancements)

1. **Add SMS Templates**: Customize SMS messages per role
2. **Rate Limiting**: Add Redis-based rate limiting for OTP requests
3. **Phone Number History**: Track phone number changes
4. **2FA for Existing Users**: Allow existing users to enable 2FA
5. **WhatsApp Integration**: Send OTP via WhatsApp as alternative
6. **Email Fallback**: Send OTP via email if SMS fails

---

## 📞 Support

If you encounter any issues:
1. Check the Rails server console for error messages
2. Verify migrations are up to date: `bin/rails db:migrate:status`
3. Check user's phone verification status in Rails console
4. Review logs for SMS service errors

---

**🎉 OTP Verification System is now fully functional!**

Agents and Customers must verify their phone numbers before accessing the application, while Developers can register without phone verification.



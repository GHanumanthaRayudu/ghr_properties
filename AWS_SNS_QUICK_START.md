# AWS SNS Quick Start Guide

## 🚀 Getting Started (5 Minutes)

### Option 1: Test in Development (No AWS Setup Needed)
**Current Status**: ✅ Already working!

1. Go to: http://localhost:3000/users/sign_up
2. Select "Agent" or "Customer"
3. Enter phone: `9876543210`
4. Click "📱 Send OTP"
5. **See OTP in browser console** (F12)
6. Use that OTP to verify

**Note**: In development, OTP is shown in browser - no real SMS sent!

---

### Option 2: Send Real SMS (AWS Setup Required)

#### Step 1: Get AWS Credentials (15 minutes)

1. **Create AWS Account**: https://aws.amazon.com
2. **Go to IAM Console**: https://console.aws.amazon.com/iam/
3. **Create User**:
   - Name: `ghr-properties-sms`
   - Access: Programmatic access
   - Permissions: `AmazonSNSFullAccess`
4. **Save Credentials**:
   ```
   Access Key ID: AKIAIOSFODNN7EXAMPLE
   Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
   ```

#### Step 2: Configure SNS (5 minutes)

1. **Go to SNS Console**: https://console.aws.amazon.com/sns/
2. **Select Region**: Asia Pacific (Mumbai) - `ap-south-1`
3. **Click "Text messaging (SMS)"** → **"Edit"**
4. **Set**:
   - Default message type: **Transactional**
   - Default sender ID: **GHRProp**
5. **Save changes**

#### Step 3: Request Production Access (24-48 hours)

**For new AWS accounts**:
1. Go to: https://console.aws.amazon.com/support/home
2. Create case → "Service limit increase"
3. Limit type: **SNS Text Messaging**
4. New limit: **$10.00**
5. Use case: "OTP verification for property app"
6. Wait for approval

**OR Use Sandbox Mode**:
- Verify your phone number in SNS Console
- Only verified numbers will receive SMS

#### Step 4: Set Environment Variables

Create `.env` file in project root:

```bash
AWS_ACCESS_KEY_ID=your_actual_access_key
AWS_SECRET_ACCESS_KEY=your_actual_secret_key
AWS_REGION=ap-south-1
```

#### Step 5: Install dotenv gem

Add to `Gemfile`:
```ruby
group :development, :test do
  gem 'dotenv-rails'
end
```

Run:
```bash
bundle install
```

#### Step 6: Test!

1. **Restart Rails server**:
   ```bash
   bin/rails server
   ```

2. **Go to signup**: http://localhost:3000/users/sign_up

3. **Fill form**:
   - Role: Agent or Customer
   - Email: test@example.com
   - Phone: Your actual phone number (e.g., 9876543210)
   - Password: password123

4. **Click "📱 Send OTP"**

5. **Check your phone** - You should receive SMS! 📱

---

## 💰 Cost Estimate

**India (AWS SNS Pricing)**:
- Per SMS: ₹0.06 (~$0.008)
- 100 OTPs/month: ₹6 (~$0.77)
- 1,000 OTPs/month: ₹60 (~$7.70)

**Free Tier**: 100 free SMS/month (first 12 months)

---

## 🔧 Testing in Rails Console

```bash
bin/rails console
```

```ruby
# Send test OTP
SmsService.send_otp('+919876543210', '123456')

# Check if it works
# => You should receive SMS on your phone!
```

---

## 🐛 Common Issues

### "SMS not received"
- ✅ Check if you're in **Sandbox mode** → Verify your phone number
- ✅ Check spending limit approved
- ✅ Verify phone number format: `+919876543210`

### "Access Denied"
- ✅ Check AWS credentials in `.env`
- ✅ Verify IAM user has SNS permissions

### "InvalidParameter"
- ✅ Phone number must include country code: `+91`

---

## 📚 Full Documentation

See `AWS_SNS_SETUP.md` for complete setup guide.

---

## ⚙️ Current Implementation

### Development Mode (Default):
- ✅ OTP shown in browser console
- ✅ OTP shown in browser alert
- ✅ No real SMS sent
- ✅ Free to test

### Production Mode (with AWS):
- ✅ Real SMS sent to phone
- ✅ Uses AWS SNS
- ✅ Costs ~₹0.06 per SMS
- ✅ Requires AWS credentials

---

## 🎯 Next Steps

**For Development** (Now):
1. Use browser console OTP ✅
2. Test the flow
3. Verify it works

**For Production** (Later):
1. Create AWS account
2. Get SNS credentials
3. Set environment variables
4. Request production access
5. Deploy and test with real SMS

---

**Questions?** Check `AWS_SNS_SETUP.md` for detailed guide!



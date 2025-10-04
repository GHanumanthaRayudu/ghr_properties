# AWS SNS Setup Guide for SMS Verification

This guide will help you configure AWS SNS to send real SMS messages for OTP verification.

## 📋 Prerequisites

- AWS Account (create at: https://aws.amazon.com)
- Credit card for AWS billing
- Basic understanding of AWS IAM

---

## 🚀 Step 1: Create AWS Account & Enable SNS

### 1.1 Sign up for AWS
1. Go to https://aws.amazon.com
2. Click "Create an AWS Account"
3. Follow the registration process
4. **Important**: You may need to request SMS spending limit increase

### 1.2 Request SMS Spending Limit Increase
1. Go to AWS Support Center: https://console.aws.amazon.com/support/home
2. Click "Create case"
3. Select "Service limit increase"
4. **Limit type**: SNS Text Messaging
5. **Region**: Asia Pacific (Mumbai) - `ap-south-1` (for India)
6. **Limit**: Account spending limit
7. **New limit value**: $10.00 (or higher based on your needs)
8. Provide use case: "OTP verification for property listing application"
9. Wait for approval (usually 24-48 hours)

---

## 🔑 Step 2: Create IAM User with SNS Permissions

### 2.1 Create IAM User
1. Go to IAM Console: https://console.aws.amazon.com/iam/
2. Click "Users" → "Add users"
3. **User name**: `ghr-properties-sns-user`
4. **Access type**: ✅ Programmatic access
5. Click "Next: Permissions"

### 2.2 Attach SNS Policy
1. Select "Attach existing policies directly"
2. Search for `AmazonSNSFullAccess`
3. Check the box next to it
4. Click "Next: Tags" → "Next: Review" → "Create user"

### 2.3 Save Credentials
⚠️ **IMPORTANT**: Save these credentials immediately (you won't see them again!)

```
AWS_ACCESS_KEY_ID: AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_REGION: ap-south-1
```

---

## 🔧 Step 3: Configure SMS Settings in AWS SNS

### 3.1 Set Default SMS Type
1. Go to SNS Console: https://console.aws.amazon.com/sns/
2. Select region: **Asia Pacific (Mumbai)** - `ap-south-1`
3. Click "Text messaging (SMS)" in left sidebar
4. Click "Edit" in "Text messaging preferences"
5. Set the following:
   - **Default message type**: Transactional
   - **Account spending limit**: $10.00 (or as approved)
   - **Default sender ID**: `GHRProp` (max 6 chars for India)
6. Click "Save changes"

### 3.2 Verify Sandbox Mode (for new accounts)
- New AWS accounts start in **SNS Sandbox mode**
- In sandbox, you can only send to **verified phone numbers**
- To exit sandbox: Request production access via AWS Support

#### To Verify a Phone Number (Sandbox Mode):
1. In SNS Console → "Text messaging (SMS)"
2. Click "Sandbox destination phone numbers"
3. Click "Add phone number"
4. Enter phone number with country code: `+919876543210`
5. Click "Add phone number"
6. You'll receive a verification code via SMS
7. Enter the code and verify

---

## ⚙️ Step 4: Configure Your Rails Application

### 4.1 Install AWS SDK Gem
```bash
cd /Users/hanumantharayudu/Workspace/ghr_properties
bundle install
```

### 4.2 Set Environment Variables

#### For Development (use `.env` file):

Create `.env` file in project root:
```bash
# AWS SNS Configuration
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
AWS_REGION=ap-south-1
```

**Install dotenv gem** (if not already):
```ruby
# Add to Gemfile
group :development, :test do
  gem 'dotenv-rails'
end
```

Then run:
```bash
bundle install
```

#### For Production (use Rails credentials):
```bash
EDITOR="code --wait" rails credentials:edit
```

Add to credentials:
```yaml
aws:
  access_key_id: your_access_key_here
  secret_access_key: your_secret_key_here
  region: ap-south-1
```

Update `app/services/sms_service.rb` to use credentials in production:
```ruby
access_key_id: Rails.application.credentials.dig(:aws, :access_key_id) || ENV['AWS_ACCESS_KEY_ID']
secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key) || ENV['AWS_SECRET_ACCESS_KEY']
```

---

## 🧪 Step 5: Test SMS Sending

### 5.1 Test in Rails Console

```bash
bin/rails console
```

```ruby
# Test sending OTP
SmsService.send_otp('+919876543210', '123456')

# You should see:
# ✅ OTP sent via AWS SNS to +919876543210
# Message ID: 12345678-1234-1234-1234-123456789012
```

### 5.2 Test in Browser
1. Go to: http://localhost:3000/users/sign_up
2. Select "Agent" or "Customer"
3. Enter your phone number: `9876543210`
4. Enter email and password
5. Click "📱 Send OTP"
6. **You should receive SMS on your actual phone!** 📱

---

## 💰 Step 6: Understand Pricing

### AWS SNS SMS Pricing (India - as of 2024)
- **Transactional SMS**: ₹0.0643 per SMS (~$0.00772 USD)
- **Promotional SMS**: ₹0.0591 per SMS (~$0.00710 USD)

**Example costs:**
- 100 OTPs/month = ₹6.43 (~$0.77)
- 1,000 OTPs/month = ₹64.30 (~$7.72)
- 10,000 OTPs/month = ₹643 (~$77.20)

### Free Tier:
- AWS Free Tier includes **100 free SMS** per month (for the first 12 months)

---

## 🛡️ Step 7: Security Best Practices

### 7.1 Never Commit Credentials
Add to `.gitignore`:
```
.env
.env.local
/config/credentials/production.key
```

### 7.2 Rotate Credentials Regularly
- Rotate AWS access keys every 90 days
- Use AWS IAM to monitor access

### 7.3 Set Spending Alerts
1. Go to AWS Billing Console
2. Set up billing alerts for SNS spending
3. Get notified if spending exceeds threshold

---

## 📊 Step 8: Monitor SMS Delivery

### 8.1 Enable CloudWatch Logs
```ruby
# In app/services/sms_service.rb, add logging:
Rails.logger.info "SMS Delivery Status: #{response.message_id}"
```

### 8.2 Check SNS Dashboard
1. Go to SNS Console → "Text messaging (SMS)"
2. View "Text messages sent" metrics
3. Monitor delivery success rate

---

## 🐛 Troubleshooting

### Issue: "SMS not received"
**Solution:**
- Check if you're in Sandbox mode → Verify destination number
- Check spending limit → Request increase
- Verify AWS credentials are correct
- Check CloudWatch logs for errors

### Issue: "InvalidParameter: Invalid phone number"
**Solution:**
- Ensure phone number is in E.164 format: `+919876543210`
- Verify country code is correct

### Issue: "Access Denied"
**Solution:**
- Check IAM user has `AmazonSNSFullAccess` policy
- Verify `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are correct

### Issue: "Throttling Exception"
**Solution:**
- AWS SNS has rate limits: 20 SMS/second
- Implement exponential backoff in your code

---

## 🌍 Supported Countries

AWS SNS supports SMS in **200+ countries**. Popular regions:
- 🇮🇳 India: `+91`
- 🇺🇸 USA: `+1`
- 🇬🇧 UK: `+44`
- 🇦🇺 Australia: `+61`
- 🇸🇬 Singapore: `+65`

---

## 📚 Additional Resources

- AWS SNS Documentation: https://docs.aws.amazon.com/sns/
- AWS SNS Pricing: https://aws.amazon.com/sns/pricing/
- SMS Best Practices: https://docs.aws.amazon.com/sns/latest/dg/sms_best_practices.html
- IAM Best Practices: https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html

---

## ✅ Checklist

Before going to production:

- [ ] AWS account created
- [ ] SMS spending limit approved
- [ ] IAM user created with SNS permissions
- [ ] AWS credentials saved securely
- [ ] SMS preferences configured in SNS Console
- [ ] Sandbox mode exited (or destination numbers verified)
- [ ] Environment variables set
- [ ] Tested SMS sending in development
- [ ] Billing alerts configured
- [ ] `.env` added to `.gitignore`
- [ ] Credentials encrypted in production

---

## 🎉 You're All Set!

Your application is now configured to send **real SMS messages** using AWS SNS!

For support, contact: support@ghrproperties.com



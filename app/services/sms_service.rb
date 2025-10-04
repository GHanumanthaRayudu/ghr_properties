require 'aws-sdk-sns'

class SmsService
  def self.send_otp(phone_number, otp_code)
    # Format phone number to E.164 format (+91XXXXXXXXXX)
    formatted_number = format_phone_number(phone_number)
    message = "Your GHR Properties verification code is: #{otp_code}. It expires in 10 minutes."
    
    if Rails.env.production?
      # Send via AWS SNS in production
      send_via_aws_sns(formatted_number, message, otp_code)
    else
      # Development/Test mode - just log
      log_otp_development(formatted_number, otp_code)
    end
  rescue => e
    Rails.logger.error "Failed to send OTP: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    # Still log for development even if AWS fails
    log_otp_development(formatted_number, otp_code) if Rails.env.development?
    raise unless Rails.env.development?
  end
  
  def self.send_welcome_message(phone_number, user_name)
    if Rails.env.development?
      Rails.logger.info "📱 Welcome SMS to #{phone_number}: Welcome #{user_name} to GHR Properties!"
    end
    true
  end
  
  private
  
  def self.send_via_aws_sns(phone_number, message, otp_code)
    sns_client = Aws::SNS::Client.new(
      region: ENV['AWS_REGION'] || 'ap-south-1',
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    
    response = sns_client.publish(
      phone_number: phone_number,
      message: message,
      message_attributes: {
        'AWS.SNS.SMS.SenderID' => {
          data_type: 'String',
          string_value: 'GHRProp' # Max 6 chars for India
        },
        'AWS.SNS.SMS.SMSType' => {
          data_type: 'String',
          string_value: 'Transactional' # Ensures high priority delivery
        }
      }
    )
    
    Rails.logger.info "✅ OTP sent via AWS SNS to #{phone_number}"
    Rails.logger.info "Message ID: #{response.message_id}"
    true
  rescue Aws::SNS::Errors::ServiceError => e
    Rails.logger.error "AWS SNS Error: #{e.message}"
    raise
  end
  
  def self.log_otp_development(phone_number, otp_code)
    Rails.logger.info "=" * 80
    Rails.logger.info "📱 OTP GENERATED (Development Mode)"
    Rails.logger.info "Phone: #{phone_number}"
    Rails.logger.info "OTP Code: #{otp_code}"
    Rails.logger.info "Expires: 10 minutes"
    Rails.logger.info "Note: In production, this will be sent via AWS SNS"
    Rails.logger.info "=" * 80
    
    # Also output to console for easy access during development
    puts "\n" + "=" * 80
    puts "📱 OTP SENT (Development Mode)"
    puts "Phone: #{phone_number}"
    puts "OTP Code: #{otp_code}"
    puts "Expires: 10 minutes"
    puts "Note: In production, this will be sent via AWS SNS"
    puts "=" * 80 + "\n"
    
    true
  end
  
  def self.format_phone_number(phone_number)
    # Remove any non-digit characters
    clean_number = phone_number.to_s.gsub(/\D/, '')
    
    # Add +91 if not present (assuming India)
    if clean_number.length == 10
      "+91#{clean_number}"
    elsif clean_number.start_with?('91') && clean_number.length == 12
      "+#{clean_number}"
    else
      "+#{clean_number}"
    end
  end
end

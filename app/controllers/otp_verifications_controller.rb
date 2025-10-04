class OtpVerificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :check_already_verified, only: [:new, :create]

  def new
    # Show OTP verification form
  end

  def create
    otp_code = params[:otp_code]
    
    if @user.verify_otp(otp_code)
      SmsService.send_welcome_message(@user.phone_number, @user.name)
      sign_in(@user, bypass: true) # Refresh the session
      redirect_to root_path, notice: "Phone number verified successfully! Welcome to GHR Properties."
    else
      if @user.otp_expired?
        flash.now[:alert] = "OTP has expired. Please request a new one."
      elsif @user.otp_attempts >= 3
        flash.now[:alert] = "Too many failed attempts. Please request a new OTP."
      else
        remaining_attempts = 3 - @user.otp_attempts
        flash.now[:alert] = "Invalid OTP. #{remaining_attempts} attempts remaining."
      end
      render :new
    end
  end

  def resend
    if @user.can_resend_otp?
      @user.generate_otp
      if SmsService.send_otp(@user.phone_number, @user.otp_code)
        redirect_to new_otp_verification_path, notice: "OTP has been resent to your phone number."
      else
        redirect_to new_otp_verification_path, alert: "Failed to send OTP. Please try again."
      end
    else
      redirect_to new_otp_verification_path, alert: "Please wait before requesting a new OTP."
    end
  end

  private

  def set_user
    @user = current_user
  end

  def check_already_verified
    if @user.phone_verified?
      redirect_to root_path, notice: "Your phone number is already verified."
    end
  end
end



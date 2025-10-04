class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enums
  enum :role, { developer: 0, agent: 1, customer: 2 }

  # Associations
  has_many :properties, dependent: :destroy
  has_many :inquiries, foreign_key: 'customer_id', dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy
  has_many :buyer_transactions, class_name: 'Transaction', foreign_key: 'buyer_id', dependent: :destroy
  has_many :seller_transactions, class_name: 'Transaction', foreign_key: 'seller_id', dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_properties, through: :favorites, source: :property

  # Validations
  validates :role, presence: true
  validates :phone_number, presence: true, if: :requires_phone_verification?
  validates :phone_number, format: { with: /\A[0-9]{10}\z/, message: "must be 10 digits" }, allow_blank: true
  validates :phone_number, uniqueness: true, allow_blank: true

  # Scopes
  scope :developers, -> { where(role: :developer) }
  scope :agents, -> { where(role: :agent) }
  scope :customers, -> { where(role: :customer) }
  scope :can_post_properties, -> { where(role: [:developer, :agent]) }

  # Instance methods
  def name
    email.split('@').first.titleize
  end

  def can_post_property?
    developer? || agent?
  end

  def can_manage_inquiries?
    developer? || agent?
  end

  # OTP related methods
  def requires_phone_verification?
    agent? || customer?
  end

  def phone_verified?
    phone_verified_at.present?
  end

  def generate_otp
    self.otp_code = rand(100000..999999).to_s
    self.otp_sent_at = Time.current
    self.otp_attempts = 0
    save(validate: false)
  end

  def verify_otp(code)
    return false if otp_code.blank? || otp_sent_at.blank?
    return false if Time.current > otp_sent_at + 10.minutes # OTP expires in 10 minutes
    return false if otp_attempts >= 3 # Max 3 attempts
    
    if otp_code == code
      self.phone_verified_at = Time.current
      self.otp_code = nil
      self.otp_sent_at = nil
      self.otp_attempts = 0
      save(validate: false)
      true
    else
      increment!(:otp_attempts)
      false
    end
  end

  def otp_expired?
    return true if otp_sent_at.blank?
    Time.current > otp_sent_at + 10.minutes
  end

  def can_resend_otp?
    return true if otp_sent_at.blank?
    Time.current > otp_sent_at + 1.minute # Can resend after 1 minute
  end

  # Override active_for_authentication? to check phone verification
  def active_for_authentication?
    super && (!requires_phone_verification? || phone_verified?)
  end

  # Custom message for inactive users
  def inactive_message
    !phone_verified? && requires_phone_verification? ? :phone_not_verified : super
  end
end

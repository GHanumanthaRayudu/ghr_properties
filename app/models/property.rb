class Property < ApplicationRecord
  # Enums
  enum :status, { available: 0, sold: 1, ongoing: 2, rented: 3 }
  enum :property_type, { house: 0, apartment: 1, condo: 2, land: 3, commercial: 4 }, prefix: true

  # Associations
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :inquiries, dependent: :destroy

  # Validations
  validates :title, :description, :price, :bedrooms, :bathrooms, :area, presence: true
  validates :city, :state, :status, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :bedrooms, :bathrooms, numericality: { greater_than: 0, only_integer: true }
  validates :area, numericality: { greater_than: 0 }
  validate :user_can_post_property

  # Scopes
  scope :available_properties, -> { where(status: :available) }
  scope :by_location, ->(location) { where('city ILIKE ? OR state ILIKE ?', "%#{location}%", "%#{location}%") if location.present? }
  scope :by_price_range, ->(min, max) { where(price: min..max) if min.present? && max.present? }
  scope :by_property_type, ->(type) { where(property_type: type) if type.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :recent, -> { order(created_at: :desc) }

  # Instance methods
  def average_rating
    return 0 if reviews.empty?
    (reviews.average(:rating) || 0).round(1)
  end

  def reviews_count
    reviews.count
  end

  def location
    "#{city}, #{state}"
  end

  def posted_by
    user
  end

  private

  def user_can_post_property
    unless user&.can_post_property?
      errors.add(:user, 'must be a developer or agent to post properties')
    end
  end
end

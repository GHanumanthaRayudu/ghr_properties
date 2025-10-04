class Inquiry < ApplicationRecord
  # Enums
  enum :status, { pending: 0, responded: 1, closed: 2 }

  # Associations
  belongs_to :customer, class_name: 'User'
  belongs_to :property

  # Validations
  validates :message, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :status, presence: true
  validates :customer_id, presence: true
  validates :property_id, presence: true
  validate :customer_must_be_customer_role

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :for_property, ->(property_id) { where(property_id: property_id) }
  scope :for_customer, ->(customer_id) { where(customer_id: customer_id) }

  private

  def customer_must_be_customer_role
    if customer && !customer.customer?
      errors.add(:customer, 'must have customer role to create inquiries')
    end
  end
end


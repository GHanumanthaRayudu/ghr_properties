class Review < ApplicationRecord
  belongs_to :property
  belongs_to :user

  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5, only_integer: true }
  validates :comment, presence: true, length: { minimum: 10, maximum: 500 }
  validates :user_id, uniqueness: { scope: :property_id, message: "has already reviewed this property" }

  scope :recent, -> { order(created_at: :desc) }
end

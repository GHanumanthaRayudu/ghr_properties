class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @my_properties = current_user.properties.order(created_at: :desc).limit(5)
    @received_messages = current_user.received_messages.includes(:sender).order(created_at: :desc).limit(5)
    @my_reviews = current_user.reviews.includes(:property).order(created_at: :desc).limit(5)
  end
end


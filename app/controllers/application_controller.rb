class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern if Rails.env.production?

  helper_method :comparison_count, :in_comparison?, :favorited?, :favorite_for

  def comparison_count
    (session[:comparison_properties] || []).length
  end

  def in_comparison?(property)
    comparison_properties = session[:comparison_properties] || []
    comparison_properties.include?(property.id)
  end

  def favorited?(property)
    return false unless user_signed_in?
    current_user.favorites.exists?(property: property)
  end

  def favorite_for(property)
    return nil unless user_signed_in?
    current_user.favorites.find_by(property: property)
  end
end

module FavoritesHelper
  def favorited?(property)
    return false unless user_signed_in?
    current_user.favorites.exists?(property: property)
  end

  def favorite_for(property)
    return nil unless user_signed_in?
    current_user.favorites.find_by(property: property)
  end
end


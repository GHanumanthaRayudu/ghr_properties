class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorite_properties = current_user.favorite_properties.includes(:user, :reviews).order('favorites.created_at DESC')
  end

  def create
    @property = Property.find(params[:property_id])
    @favorite = current_user.favorites.build(property: @property)

    if @favorite.save
      respond_to do |format|
        format.html { redirect_to @property, notice: "Property added to favorites." }
        format.turbo_stream
      end
    else
      redirect_to @property, alert: "Unable to add to favorites."
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @property = @favorite.property
    @favorite.destroy

    respond_to do |format|
      format.html { redirect_to request.referer || properties_path, notice: "Property removed from favorites." }
      format.turbo_stream
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end
end



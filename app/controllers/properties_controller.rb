class PropertiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @properties = Property.includes(:user).order(created_at: :desc).page(params[:page]).per(12)
    
    if params[:property_type].present?
      @properties = @properties.where(property_type: params[:property_type])
    end
    
    if params[:listing_type].present?
      @properties = @properties.where(listing_type: params[:listing_type])
    end
    
    if params[:min_price].present?
      @properties = @properties.where("price >= ?", params[:min_price])
    end
    
    if params[:max_price].present?
      @properties = @properties.where("price <= ?", params[:max_price])
    end
  end

  def show
    @reviews = @property.reviews.includes(:user).order(created_at: :desc)
  end

  def new
    @property = Property.new
  end

  def create
    @property = current_user.properties.build(property_params)
    
    if @property.save
      redirect_to @property, notice: "Property was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @property.update(property_params)
      redirect_to @property, notice: "Property was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    redirect_to properties_url, notice: "Property was successfully deleted."
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def authorize_owner!
    unless @property.user == current_user
      redirect_to properties_path, alert: "You are not authorized to perform this action."
    end
  end

  def property_params
    params.require(:property).permit(
      :title, :description, :property_type, :listing_type,
      :price, :bedrooms, :bathrooms, :area, :address,
      :city, :state, :pincode, :amenities, :available_from
    )
  end
end


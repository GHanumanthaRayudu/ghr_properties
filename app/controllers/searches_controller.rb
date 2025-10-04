class SearchesController < ApplicationController
  def index
    @properties = Property.includes(:user, :reviews).order(created_at: :desc)

    # Property type filter
    if params[:property_type].present?
      @properties = @properties.where(property_type: params[:property_type])
    end

    # Listing type filter (rent/sale)
    if params[:listing_type].present?
      @properties = @properties.where(listing_type: params[:listing_type])
    end

    # Price range
    if params[:min_price].present?
      @properties = @properties.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      @properties = @properties.where("price <= ?", params[:max_price])
    end

    # Bedrooms
    if params[:bedrooms].present?
      @properties = @properties.where("bedrooms >= ?", params[:bedrooms])
    end

    # Bathrooms
    if params[:bathrooms].present?
      @properties = @properties.where("bathrooms >= ?", params[:bathrooms])
    end

    # Location search
    if params[:city].present?
      @properties = @properties.where("city ILIKE ?", "%#{params[:city]}%")
    end

    if params[:state].present?
      @properties = @properties.where("state ILIKE ?", "%#{params[:state]}%")
    end

    # Area/Size
    if params[:min_area].present?
      @properties = @properties.where("area >= ?", params[:min_area])
    end

    if params[:max_area].present?
      @properties = @properties.where("area <= ?", params[:max_area])
    end

    # Keyword search (title, description, address)
    if params[:query].present?
      query = "%#{params[:query]}%"
      @properties = @properties.where(
        "title ILIKE ? OR description ILIKE ? OR address ILIKE ? OR amenities ILIKE ?",
        query, query, query, query
      )
    end

    # Amenities search
    if params[:amenities].present?
      @properties = @properties.where("amenities ILIKE ?", "%#{params[:amenities]}%")
    end

    @properties = @properties.page(params[:page]).per(12)
  end
end


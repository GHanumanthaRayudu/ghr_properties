class ComparisonsController < ApplicationController
  def index
    property_ids = (session[:comparison_properties] || []).take(4)
    @properties = Property.includes(:user, :reviews).where(id: property_ids)
  end

  def create
    property_id = params[:property_id].to_i
    session[:comparison_properties] ||= []
    
    unless session[:comparison_properties].include?(property_id)
      if session[:comparison_properties].length >= 4
        redirect_to property_path(property_id), alert: "You can compare maximum 4 properties at a time."
      else
        session[:comparison_properties] << property_id
        redirect_to property_path(property_id), notice: "Property added to comparison."
      end
    else
      redirect_to property_path(property_id), alert: "Property already in comparison list."
    end
  end

  def destroy
    property_id = params[:id].to_i
    session[:comparison_properties] ||= []
    session[:comparison_properties].delete(property_id)
    
    redirect_to request.referer || comparisons_path, notice: "Property removed from comparison."
  end

  def clear
    session[:comparison_properties] = []
    redirect_to properties_path, notice: "Comparison list cleared."
  end
end


